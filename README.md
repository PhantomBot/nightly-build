# <img alt="PhantomBot" src="https://phantombot.tv/img/new-logo-dark-v2.png" width="600px"/>

# nightly-build
This repository contains a nightly build of PhantomBot from the latest master branch.  The nightly-build release is built on the latest available Ubuntu environment for GitHub Actions. You can find information about the environment [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners#supported-runners-and-hardware-resources).
    
Four build files are present.
* _PhantomBot-nightly-lin.zip_ - Contains the entire bot, but only the Java environment for Linux 64-bit (x86_64).
* _PhantomBot-nightly-win.zip_ - Contains the entire bot, but only the Java environment for Windows 64-bit (x86_64).
* _PhantomBot-nightly-mac.zip_ - Contains the entire bot, but only the Java environment for macOS 64-bit (x86_64).
* _PhantomBot-nightly-arm-bsd-other.zip_ - Contains the entire bot, but no Java environment. Use this for Raspberry Pi, Linux 32-bit (x86) with OpenJDK 11, or BSD. The launch.sh script will provide instructions if you attempt to run it without the proper JDK.

### Docker
PhantomBot publishes official builds to Docker Hub and GitHub Container Registry
* [DockerHub](https://hub.docker.com/r/gmt2001/phantombot-nightly)
* [GHCR](https://github.com/PhantomBot/nightly-build/pkgs/container/nightly-build)
* [Docker Compose File](https://github.com/PhantomBot/PhantomBot/blob/master/docker-compose.yml) (Edit to target nightly)

# Notice
When running this from Linux with the included Java environment, you must `chmod u+x launch.sh && chmod u+x java-runtime-linux/bin/java`

When running this from macOS with the included Java environment, you must `chmod u+x launch.sh && chmod u+x java-runtime-macos/bin/java`

When running this from BSD, you must `chmod u+x launch-bsd.sh`

Windows does not support 32-bit (x86) due to Oracle dropping support for it.

The historical build is a copy of the _PhantomBot-nightly-arm-bsd-other.zip_ package. If you are using 64-bit (x86_64) Windows, Linux, or macOS, you may need to download the latest copy for your platform and then copy the appropriate _launch_ scripts and _java-runtime_ folders into the historical package.

# Notice
Use this nightly build at your own risk!  The master branch is not always fully tested.  The nightly build may not even launch.  There may be new features added which may cause problems with your PhantomBot environment.  Do not take parts of the nightly build and install into an earlier version of PhantomBot unless told to by a developer.  The PhantomBot core, scripts and web modules are all tightly related.

# Support
**No support will be provided for the nightly build.**  Please report bugs, but, we will not answer questions regarding how to setup, install, or configure new features.  Typically instructions for new features will be included on the Nightly Build page for items that we would like folks to test when they are ready to be tested.

# Reporting Bugs
Please report any bugs to the Community page URL provided at the end of this section. Do ensure that your bug report includes everything we ask for on in the Bug Report template:

* Nightly Build version - include the PhantomBot Version and Build Revision from startup.
* OS and Java version.  Take this from the startup of PhantomBot.
* Browser version, if using the Control Panel.
* Steps to reproduce the bug.
* Any relevant log information.  This may be from the console, logs/core-error, logs/error, or stacktrace file.
* Screenshots as appropriate, for example, reporting a UI issue in the Control Panel.
* Any changes that you may have made in your environment.  This would include any changes to the scripts, for example.

PhantomBot Community Nightly Build Bug Reports:       
https://community.phantom.bot/c/nightly-builds

# Getting Java, OS and PhantomBot Versions from PhantomBot at Startup
The Java and OS versions are presented when PhantomBot starts up in the Console, some examples:
```
[05-16-2017 @ 16:42:26.423 GMT] Detected Java 1.8.0_102 running on Linux 4.8.13-100.fc23.x86_64 (amd64)

[05-16-2017 @ 16:47:10.158 GMT] Detected Java 1.8.0_131 running on Windows 10 10.0 (amd64)

[05-16-2017 @ 16:48:48.719 GMT] Detected Java 1.8.0_102 running on Mac OS X 10.12.4 (x86_64)
```

The version of PhantomBot as well as the Build Revision is also present at startup:
```
% ./launch.sh 
[06-30-2017 @ 04:54:18.503 GMT] The working directory is: /usr/local/opt/iobot2
[06-30-2017 @ 04:54:18.507 GMT] Detected Java 1.8.0_102 running on Linux 4.8.13-100.fc23.x86_64 (amd64)
[06-30-2017 @ 04:54:18.512 GMT] 
[06-30-2017 @ 04:54:18.512 GMT] PhantomBot Version: 2.3.7.1-NB-20170629
[06-30-2017 @ 04:54:18.512 GMT] Build Revision: 5f8f2c4
```

# Comparing Versions
A link is provided which will show the differences between the current nightly build and the previous nightly build.  This helps to quickly determine what changes were made.  Note that there are times where no changes are indicated.  This is normal, and simply means that no new commits were merged into the master branch.
