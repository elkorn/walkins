This README is currently out-of-date. Furthermore, the present version of the project suffers from notification bugs. This will change in the next few days.

Also, the installation process has been revamped- The `howto` does no longer apply.

walkins
=======

A small Bash utility to watch Jenkins build statuses.

Requires [jq](http://stedolan.github.io/jq/) to be configured as a command to run properly. `jq` is available on apt, yum and the AUR. (let me know if you found it in another popular repository so I can specify it here!)

Run it in a console window to have an overview of the build statuses and what's currently being built.
Run it in the background to have notifications only.

The project is super-duper alpha.
Currently it's dependent on libnotify and it'll poll Jenkins every 30 seconds.
These things are not configurable yet.
It also **will not** handle disabled (gray) builds.

Howto
-------

There are two things you need to have **placed within the main app directory** for walkins to walk:
* a `.credentials` file containing your Jenkins credentials. The contents of the file must be just `username:password` in that exact format.
* a `.walkinsrc` file, containing the URL to the Jenkins view you want to track. This will most likely take a form similar to this: http://server.address/jenkins/view/the-name-of-your-view
  * please do not leave a trailing slash... I wanna go to sleep :) it'll be fixed, promise!

Todo
-------

See the [issues](https://github.com/elkorn/walkins/issues?state=open).

