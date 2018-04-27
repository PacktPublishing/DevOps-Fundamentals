#/bin/bash

BYTEMAN_HOME=`dirname "$0"`

$BYTEMAN_HOME/bin/bmsubmit.sh -u "$@"
