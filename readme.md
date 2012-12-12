connect-github-organization-auth
================================

Connect middleware which enforces GitHub organisation membership for applications.

Flat-out responds with `HTTP 403` if the authenticated user is not in the specified organisation.

Works for me :)

Requirements
------------

* node.js (written under v0.8.x, may work with older)
* a Connect (or Express, et. al.) application
* GitHub OAuth middleware in place before this (such as `connect_auth_github`)

OAuth Note
----------

So yes *this* module does *not* do the actual wiring up of OAuth authentication. This is more of an *authorization* add-on for your existing authentication.

If you do not want to use `connect_auth_github` for some reason, this module is simply expecting that the `req` object (via Connect) is decorated with a `github` object containing at least `login` and `token` properties.

Dig into the `/lib` code for more details if you want to use another module for OAuth itself.

Usage
-----

Isolated example:

    var github_organization_auth = require("connect-github-organization-auth");

    ...
    
    application.use(github_organization_auth({
        organization: "my-organization"
    }));

Example with `connect_auth_github`:

    var github_auth = require("connect_auth_github");
    var github_organisation_auth = require("connect-github-organisation-auth");
    
    ...

	app.use(github_auth({
		appId: process.env.GITHUB_APP_ID,
		appSecret: process.env.GITHUB_APP_SECRET,
		callback: process.env.GITHUB_CALLBACK
	});

	app.use(github_organisation_auth({
		organisation: "bigcommerce"
	});

Tests
-----

LOL

:(

Issues
------

Feel free to open an issue on GitHub if you find a bug. Better yet, fork it and fix it.