# nightly-build
This repository contains a nightly build of PhantomBot from the latest master branch.  The nightly-build release is built on the following server configuration:

    CentOS Linux 7 (7.2.1511)
    Oracle Java 1.8.0_102
    OpenJDK 1.8.0_101
    
Two build files are present.  One of which is built with Oracle Java and the other with OpenJDK.  Review the name of the nightly-build file to determine which is built with OpenJDK.

# Notice
Use this nightly build at your own risk!  The master branch is not always fully tested.  There may be new features added which may cause problems with your PhantomBot environment.  It is not wise to just copy off scripts without the new core and possibly the library directories.  

# Support
No support will be provided for the nightly build.  Please report bugs, but, we will not answer questions regarding how to setup, install, or configure new features.  Typically instructions for new features will be included on the Nightly Build page for items that we would like folks to test when they are ready to be tested.

# Reporting Bugs
Please report any bugs to the Community page URL provided at the end of this section. Do ensure that your bug report includes:

* Date and/or Build ID of the Nightly Build being used; Example: 18 Jul 2016 (Git Repo: 9d29388)
* OS and Java version.  Some example formats you could provide:    
    Windows 10.0.10586 - Java(TM) SE Runtime Environment (build 1.8.0_92-b14)    
    CentOS Linux release 7.2.1511 - OpenJDK Runtime Environment (build 1.8.0_91-b14)
* Steps to reproduce the bug.
* Any relevant log information.  This may be from the console, logs/core-error, logs/error, or stacktrace file.
* Screenshots as appropriate, for example, reporting a UI issue in the Control Panel.
* Any changes that you may have made in your environment.  This would include any changes to the scripts, for example.

PhantomBot Community Nightly Build Bug Reports:       
https://community.phantombot.net/category/23/bug-reports

# Getting Versions from the OS and Java
Linux: View the contents of ```/etc/system-release```.  This typically contains the distribution and version.    
Windows: From the command prompt run the ```ver``` command.    
Java: From the command prompt run ```java -version```

# Where to Find the PhantomBot Version and Build ID
When you download PhantomBot, the build date and the Git Repo are located on the description line of the download.  If you have not previously captured this, you may, at a minimum, provide the build revision, which is provided when PhantomBot first boots up:    
```
% ./launch.sh 
[07-18-2016 @ 17:05:48.675 GMT] The working directory is: /usr/local/opt/iobot2

[07-18-2016 @ 17:05:48.694 GMT] PhantomBot Version 2.1.0.1
[07-18-2016 @ 17:05:48.694 GMT] Build revision db1a26f
```
