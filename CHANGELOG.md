# Changes

## Java

* 2018-12-11 - v5.1 - Created - Removed Gradle (CMD now uses gradlew), added tini entrypoint, added OpenJDK 11 variant (tag 5.1-11)
* 2018-12-07 - v5 - Created - Upgraded and unpinned OpenJDK, updated CentOS to 7.5, added Gradle cache directory as a volume
* 2017-10-03 - v4 - Created - Upgraded and pinned OpenJDK to build 144, Gradle updated to 4.2.1, Updated CentOS to 7.4, removed LOG_LEVEL environment variable
* 2017-04-07 - v3 - Created - Differences to v1: Locale explicitly set to en_GB, Gradle updated to 3.4.1
* Earlier - v2 - Created - Difference to v1: Changed CMD to build jar then run it in a separate process (more memory efficient)

## Python

* 2018-12-07 - v5 - Created - Updated CentOS to 7.5, added Python 3.6 variant (tag 5-3.6)
* 2017-10-03 - v4 - Created - Updated CentOS to 7.4, removed LOG_LEVEL environment variable
* 2017-04-07 - v3 - Created - Difference to v2: Locale explicitly set to en_GB
* Earlier - v2 - Created - Difference to v1: Removed setting of non-existent en_US locale

## Flask

* 2018-12-07 - v5 - Created - Extends Python v5, added Python 3.6 variant, removed gunicorn and eventlet preinstalls, changed CMD to use sync worker
* 2017-10-03 - v4 - Created - Extends Python v4, removed TEMPLATES\_AUTO\_RELOAD environment variable
* 2017-04-07 - v3 - Created - Differences to v2: Locale explicitly set to en_GB, gunicorn and eventlet updated, extends python v3.
* Earlier - v2 - Created - Differences to v1: Removed FLASK_LOG_LEVEL env var, extends python v2.

## Ruby

* 2018-12-07 - v4 - Created - Updated CentOS to 7.5, ruby to 2.5, and bundler to 1.17; replace PhantomJS with headless Chrome
* 2017-10-03 - v3 - Created - Updated CentOS to 7.4, updated ruby and bundler to 2.4.2 and 1.15.4 respectively
* 2017-04-07 - v2 - Created - Difference to v1: Locale explicitly set to en_GB
* 2017-04-07 - v1 - Updated - added installation of extra fonts
