@echo off

set DEFAULT_SVNKIT_HOME=%~dp0

if "%SVNKIT_HOME%"=="" set SVNKIT_HOME=%DEFAULT_SVNKIT_HOME%

set SVNKIT_CLASSPATH=%SVNKIT_HOME%lib\*;%SVNKIT_HOME%..\atlassian-bamboo\WEB-INF\lib\*
set SVNKIT_MAINCLASS=org.tmatesoft.svn.cli.SVN
set SVNKIT_OPTIONS=-Djava.util.logging.config.file="%SVNKIT_HOME%/logging.properties"

java -version
java %SVNKIT_OPTIONS% -cp "%SVNKIT_CLASSPATH%" %SVNKIT_MAINCLASS% %
