util = require "util"

async	= require "async"
request	= require "request"

__is_user_organization_member = (token, organization, callback) ->
	github_api = request.defaults
		headers:
			"Authorization": "token #{token}"
			"Accept": "application/json"
			"Content-Type": "application/json"
		encoding: "utf8"
		timeout: 10000
		strictSSL: true
		json: true

	if module.exports.debug
		util.debug "checking #{organization} membership for #{token}"

	github_api.get "https://api.github.com/orgs/#{organization}", (err, res, organization) ->
		if module.exports.debug
			util.debug "#{organization}:#{token}? err:#{err} status:#{if err then '' else res.statusCode}"

		return callback err if err
		return callback res.statusCode unless res.statusCode is 200

		callback null, organization.plan? and organization.plan.private_repos?

is_user_organization_member = async.memoize __is_user_organization_member, (token, organization) ->
	[token, organization].join "\t"

middleware = (options) ->
	(req, res, next) ->
		is_user_organization_member req.github.user.token, options.organization, (err, is_member) ->
			return next err if err
			return next null if is_member

			error = new Error "Forbidden"
			error.status = 403
			next error

middleware.debug = false

module.exports = middleware
