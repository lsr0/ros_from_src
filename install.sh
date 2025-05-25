#!/bin/bash
WS_ROOT=`pwd`/catkin_ws/
DEST=`pwd`/ros

set -ex

. $DEST/setup.bash
cd $WS_ROOT
catkin build --make-args install
