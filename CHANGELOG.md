# Changes

## Java

* 2018-12-11 - v5.1 - Created - Removed Gradle (CMD now uses gradlew), added tini entrypoint, added OpenJDK 11 variant (tag 5.1-11)
* 2018-12-07 - v5 - Created - Upgraded and unpinned OpenJDK, updated CentOS to 7.5, added Gradle cache directory as a volume
* 2017-10-03 - v4 - Created - Upgraded and pinned OpenJDK to build 144, Gradle updated to 4.2.1, Updated CentOS to 7.4, removed LOG_LEVEL environment variable
* 2017-04-07 - v3 - Created - Differences to v1: Locale explicitly set to en_GB, Gradle updated to 3.4.1
* Earlier - v2 - Created - Difference to v1: Changed CMD to build jar then run it in a separate process (more memory efficient)

## Python

* 2019-10-17 - v5 - Republished - Fixed IUS yum repository, updated CentOS to latest v7 base, changed base language to en_US and updated Python to 3.4.10 and 3.6.8
* 2018-12-07 - v5 - Created - Updated CentOS to 7.5, added Python 3.6 variant (tag 5-3.6)
* 2017-10-03 - v4 - Created - Updated CentOS to 7.4, removed LOG_LEVEL environment variable
* 2017-04-07 - v3 - Created - Difference to v2: Locale explicitly set to en_GB
* Earlier - v2 - Created - Difference to v1: Removed setting of non-existent en_US locale

## Flask

* 2019-10-17 - v5 - Republished - Extends republished Python v5, reduced gunicorn worker and thread count to 2/2 from 4/16
* 2018-12-07 - v5 - Created - Extends Python v5, added Python 3.6 variant, removed gunicorn and eventlet preinstalls, changed CMD to use sync worker
* 2017-10-03 - v4 - Created - Extends Python v4, removed TEMPLATES\_AUTO\_RELOAD environment variable
* 2017-04-07 - v3 - Created - Differences to v2: Locale explicitly set to en_GB, gunicorn and eventlet updated, extends python v3.
* Earlier - v2 - Created - Differences to v1: Removed FLASK_LOG_LEVEL env var, extends python v2.

## Ruby

* 2019-10-03 - v4.1 - Created - Updated ChromeDriver to 77.0.3865.40, Ruby to 2.6.5, rubygems to 3.0.6 and  bundler to 2.0.2
* 2019-10-03 - v4 - Republished - Updated CentOS to latest v7 base, changed base language to en_US, updated Chrome to 77.0.3865.40
* 2018-12-07 - v4 - Created - Updated CentOS to 7.5, ruby to 2.5, and bundler to 1.17; replace PhantomJS with headless Chrome
* 2017-10-03 - v3 - Created - Updated CentOS to 7.4, updated ruby and bundler to 2.4.2 and 1.15.4 respectively
* 2017-04-07 - v2 - Created - Difference to v1: Locale explicitly set to en_GB
* 2017-04-07 - v1 - Updated - added installation of extra fonts

## Squid

* 2020-06-17 - v4 - Created - Updated squid to 4.12 and changed to generic tag
* 2019-11-15 - v4.9 - Created - Updated squid to 4.9
* 2019-10-24 - v4.8 - Created - Updated squid to 4.8 and base image to ubuntu
* 2019-02-08 - v4.5 - Created

## NodeJS

* 2020-07-24 - v1 - Republished - Updated Node to 10.19.0
* 2019-10-09 - v1 - Republished - Updated CentOS to latest v7 base and Node to 10.10, changed base language to en_US
* 2019-06-14 - v1 - Created
