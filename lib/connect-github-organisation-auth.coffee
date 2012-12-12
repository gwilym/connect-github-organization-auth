util = require "util"

async	= require "async"
request	= require "request"

__is_user_organisation_member = (token, username, organisation, callback) ->
	github_api = request.defaults
		headers:
			"Authorization": "token #{token}"
			"Accept": "application/json"
			"Content-Type": "application/json"
		encoding: "utf8"
		timeout: 10000
		strictSSL: true
		json: true

	util.debug "checking #{organisation} membership for #{username}"

	github_api.get "https://api.github.com/orgs/#{organisation}/members/#{username}", (err, res) ->
		return callback err if err
		return callback null, res.statusCode is 204

is_user_organisation_member = async.memoize __is_user_organisation_member, (token, username, organisation) ->
	[token, username, organisation].join "\t"

module.exports = (options) ->
	(req, res, next) ->
		is_user_organisation_member req.github.user.token, req.github.user.login, options.organisation, (err, is_member) ->
			return next err if err
			return next null if is_member
			
			error = new Error "Forbidden"
			error.status = 403
			next error
