# <img alt="PhantomBot" src="https://phantombot.tv/img/new-logo-dark-v2.png" width="600px"/>

# nightly-build
This repository contains a nightly build of PhantomBot from the latest master branch.  The nightly-build release is built on the following server configuration:

    CentOS Linux 7 (7.4.1708)
    Oracle Java 1.8.0_131
    OpenJDK 1.8.0_144
    
Two build files are present.  One of which is built with Oracle Java and the other with OpenJDK.  Review the name of the nightly-build file to determine which is built with OpenJDK.

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
https://community.phantombot.tv/c/nightly-builds

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
