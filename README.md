A Jekyll powered blog. Mostly this content is for my own records, just
in case I need to come back to it in the future. Others might find
some posts useful as they record the results of my research and
experimetnation in software.

It's more likely that someone would want to pick up my Jekyll and
Bootstrap confguration. This was kick started by [Jekyll
Bootstrap](http://jekyllbootstrap.com/) but since that is unmaintained
and I don't want to spend all my time generalizing the design it
quickly moved away to a custom config for my own site.

# Running Locally in Dev Mode

When writing posts it is useful to be able to make edits and see them immedietely in the browser. It's also useful to have the _drafts folder rendered so that you can check those contents too. To do this run

    ./script/dev.sh

You will have a server listening on port 80.

# Testing with Docker

There is a Dockerfile included that makes it easy to test that there
are no syntax errors in the site that will prevent it from being
built. Simply run:

    ./script/test.sh

# Contributions and Reuse Welcome

I welcome contributions to both content and configuration, though in
reality I dont's expect to see any.

All content is under the MIT license. Please link back to me if you
use anything from here and please contribute back if you improve
things.
