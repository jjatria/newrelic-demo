# Test server for NewRelic integration

To run locally:

1.  Create a file named `env` on the root of the repository with your New Relic
    license key like so:

        NEWRELIC_LICENSE_KEY=...

2.  Run `make` to start the server. You can view the logs with `make logs`

3.  The website will soon be visible at http://localhost:5000

4.  When you are done, you can stop the server with `make stop`
