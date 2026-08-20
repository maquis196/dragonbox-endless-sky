#!/bin/bash
pwd=`dirname $(readlink -f "$0")`

cd "$pwd"

echo "--------------------------------------------------------------"
echo "Setting PATH to $pwd:$PATH"
export PATH=$pwd:$PATH

echo "--------------------------------------------------------------"
echo "Setting HOME to $pwd"
export HOME=$pwd
export XDG_HOME_DIRS=$pwd
export XDG_CONFIG_HOME=$pwd

./games/endless-sky -r share/games/endless-sky"$@"
