# GitHub Issue Stats (GHIS)

GHIS is a command line tool that calculates and plots stats about a GitHub project's issues:

* The number of open and closed issues/pull requests over time
* Average lead time (time from open to closed) over time  
* A simplified [Cumulative Flow Diagram](https://en.wikipedia.org/wiki/Cumulative_flow_diagram)

## Usage

Authenticate with GitHub:

    # Username/password
    export GITHUB_AUTH='-u username:password'
    # Or, if you prefer, token
    export GITHUB_AUTH='-H "Authorization: token TOKEN"'

Fetch a copy of GitHub issues to disk:

    scripts/fetch-issues cucumber/cucumber-jvm

Generate the stats as a [tsv](https://en.wikipedia.org/wiki/Tab-separated_values):

    # Pipe to pbcopy if you want to paste straight into a Google sheet
    ruby -Ilib bin/ghis repos/cucumber/cucumber-jvm/issues.json
