walkins
=======

A small Bash utility to watch Jenkins build statuses.

Requires http://stedolan.github.io/jq/ to be configured as a command to run properly. (It's available on apt and yum)

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

For now there are quite a few things:
* fix the goddamn slash!
* handle disabled builds
* loosen the path dependencies
* make notification system pluggable
* bundle `jq` with the project
* make the `.walkinsrc` config better
* decide on the config format
* level up in bash and refactor the code so it's less horrible
* ... something will crop up. :)

