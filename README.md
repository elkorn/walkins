walkins
=======

A small Bash utility to watch Jenkins build statuses.

Requires [jq](http://stedolan.github.io/jq/) to be configured as a command to run properly. `jq` is available on apt, yum and the AUR. (let me know if you found it in another popular repository so I can specify it here!)

Awesome icon come from [Manto](http://findicons.com/pack/1039/manto).

Howto
-------

Do a checkout of the master branch and run `./configure.sh` from within the project directory. The configuration procedure will guide through the mandatory steps. (everything can be changed by editing the `~/.walkins/.walkinsrc` config file afterwards)

If you don't have `~/local/bin` added to `PATH`, run `sudo ./configure.sh` instead of just `./configure.sh`.

Run walkins in a console window to have an overview of the build statuses and what's currently being built. Successful jobs are green, unstable- yellow and failures- red.
Also, aborted jobs are displayed as white and jobs that have not been built are preceded with an `[N] `.

Run walkins in the background to have notifications only.


Extending
-------

It is possible to write your own notification providers.
What you need to do is create a script which implements the following functions:

* `notify_build_status_changed`
* `notify_job_progress_changed`
* `notify_app_started`
* `notify_error`
* `notify_connection_error`
* `notify_credentials_error`

And then specify an **absolute** path to it as the `notifier_path` property in `~/.walkins/.walkinsrc` config file.

An example implementation is the default notifier, `libnotify.sh`. (DUH)

Contributing
-------

If you happen to use the tool and want to improve something, feel free to create pull requests. If you have an improvement idea (or spotted a bug) and care to share, create an issue and I'll look into it.


Todo
-------

See the [issues](https://github.com/elkorn/walkins/issues?state=open).


