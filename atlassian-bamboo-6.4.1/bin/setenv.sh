#!/bin/sh
#
# One way to set the Bamboo HOME path is here via this variable.  Simply uncomment it and set a valid path like /bamboo/home.  You can of course set it outside in the command terminal.  That will also work.
#
#BAMBOO_HOME=""

#
#  Occasionally Atlassian Support may recommend that you set some specific JVM arguments.  You can use this variable below to do that.
#
: ${JVM_SUPPORT_RECOMMENDED_ARGS:=""}

#
# Byteman agent
#JVM_SUPPORT_RECOMMENDED_ARGS="$JVM_SUPPORT_RECOMMENDED_ARGS -javaagent:../tools/byteman/lib/byteman.jar=listener:true"
#

#
# The following 2 settings control the minimum and maximum given to the Bamboo Java virtual machine.  In larger Bamboo instances, the maximum amount will need to be increased.
#
: ${JVM_MINIMUM_MEMORY:=512m}
: ${JVM_MAXIMUM_MEMORY:=1024m}

#
# The following are the required arguments need for Bamboo standalone.
#
: ${JVM_REQUIRED_ARGS:=""}

#-----------------------------------------------------------------------------------
#
# In general don't make changes below here
#
#-----------------------------------------------------------------------------------

PRGDIR=`dirname "$0"`
cat "${PRGDIR}"/bamboobanner.txt

BAMBOO_HOME_MINUSD=""
if [ "$BAMBOO_HOME" != "" ]; then
    echo $BAMBOO_HOME | grep -q " "
    if [ $? -eq 0 ]; then
	    echo ""
	    echo "----------------------------------------------------------------------------------------------------------------------"
		echo "   WARNING : You cannot have a BAMBOO_HOME environment variable set with spaces in it.  This variable is being ignored"
	    echo "----------------------------------------------------------------------------------------------------------------------"
   else
		BAMBOO_HOME_MINUSD=-Dbamboo.home=$BAMBOO_HOME
   fi
fi

JAVA_OPTS="-Xms${JVM_MINIMUM_MEMORY} -Xmx${JVM_MAXIMUM_MEMORY} ${JAVA_OPTS} ${JVM_REQUIRED_ARGS} ${JVM_SUPPORT_RECOMMENDED_ARGS} ${BAMBOO_HOME_MINUSD}"

JAVA_OPTS=$(echo "$JAVA_OPTS" | sed -e 's/\s*$//' -e 's/^\s*//')
export JAVA_OPTS

echo ""
echo "If you encounter issues starting or stopping Bamboo Server, please see the Troubleshooting guide at https://confluence.atlassian.com/display/BAMBOO/Installing+and+upgrading+Bamboo"
echo ""
if [ "$BAMBOO_HOME_MINUSD" != "" ]; then
    echo "Using BAMBOO_HOME:       $BAMBOO_HOME"
fi
