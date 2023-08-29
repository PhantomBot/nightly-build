# <img alt="PhantomBot" src="https://phantombot.tv/img/new-logo-dark-v2.png" width="600px"/>

# nightly-build
This repository contains a nightly build of PhantomBot from the latest master branch.  The nightly-build release is built on the latest available Ubuntu environment for GitHub Actions. You can find information about the environment [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners#supported-runners-and-hardware-resources).
    
Five build files are present.
* _PhantomBot-nightly-lin-runtime.zip_ - Contains the Java environment and launch scripts for Linux 64-bit (x86_64, amd64).
* _PhantomBot-nightly-win-runtime.zip_ - Contains the Java environment and launch scripts for Windows 64-bit (x86_64, amd64).
* _PhantomBot-nightly-mac-runtime.zip_ - Contains the Java environment and launch scripts for macOS 64-bit (Intel processors, x86_64, amd64).
* _PhantomBot-nightly-arm64-runtime.zip_ - Contains the Java environment and launch scripts for ARM 64-bit processors (Raspberry Pi Zero 2+, Raspberry Pi 3+, Apple Silicon M1/M2, arm64, aarch64).
* _PhantomBot-nightly-arm32-runtime.zip_ - Contains the Java environment and launch scripts for ARM 32-bit processors (Raspberry Pi 2+, Raspberry Pi 3 with 32-bit OS, armhf, arm/v7).
* _PhantomBot-nightly-bot.zip_ - Contains the bot files.

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

The historical build is a copy of the _PhantomBot-nightly-bot.zip_ package. If you are using 64-bit (x86_64) Windows, Linux, macOS, or an arm64/aarch64-based platform, you may need to download the latest copy of the runtime for your platform and then copy the appropriate _launch_ scripts and _java-runtime_ folders into the historical package.

# Notice
Use this nightly build at your own risk!  The master branch is not always fully tested.  The nightly build may not even launch.  There may be new features added which may cause problems with your PhantomBot environment.  Do not take parts of the nightly build and install into an earlier version of PhantomBot unless told to by a developer.  The PhantomBot core, scripts, and web modules are all tightly related.

# Reporting Bugs
Please report any bugs to our Discord at https://discord.gg/YKvMd78. Do ensure that your bug report includes everything we ask for on in the Bug Report template:

* Nightly Build version - include the PhantomBot Version and Build Revision from startup.
* OS and Java version.  Take this from the startup of PhantomBot.
* Browser version, if using the Control Panel.
* Steps to reproduce the bug.
* Any relevant log information.  This may be from the console, logs/core-error, logs/js-error, or stacktrace file.
* Screenshots as appropriate, for example, reporting a UI issue in the Control Panel.
* Any changes that you may have made in your environment.  This would include any changes to the scripts, for example.

# Getting Java, OS and PhantomBot Versions from PhantomBot at Startup
The Java and OS versions are presented when PhantomBot starts up in the Console:
```
[08-18-2023 @ 15:25:28.964 GMT] Detected Java 17.0.8 running on Windows 11 10.0 (amd64)
```

The version of PhantomBot as well as the Build Revision is also present at startup:
```
C:\Users\someuser\OneDrive\Documents\PhantomBot-NB-08182023> ./launch.bat
[08-18-2023 @ 15:25:28.886 GMT] The working directory is: C:\Users\someuser\OneDrive\Documents\PhantomBot-NB-08182023
[08-18-2023 @ 15:25:28.964 GMT] Detected Java 17.0.8 running on Windows 11 10.0 (amd64)
[08-18-2023 @ 15:25:29.048 GMT] 
[08-18-2023 @ 15:25:29.059 GMT] PhantomBot Version: NB-08182023 (nightly_build)
[08-18-2023 @ 15:25:29.060 GMT] Build Revision: 636f8fb
```

# Comparing Versions
A link is provided which will show the differences between the current nightly build and the previous nightly build.  This helps to quickly determine what changes were made.  Note that there are times where no changes are indicated.  This is normal, and simply means that no new commits were merged into the master branch.
