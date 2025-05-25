# ros_from_src

Following these instructions is recommended for Ubuntu 22.04: [ubuntu_2204/README.md](ubuntu_2204/README.md)

Otherwise to build ros entirely from source without using a PPA (or even the debian ros packages):

    git clone git@github.com:lucasw/ros_from_src.git
    mkdir build
    cd build
    # if Ubuntu 20.04
    # ROSCONSOLE=https://github.com/ros/rosconsole ../ros_from_src/git_clone.sh
    # if Ubuntu 22.04 or later
    ../ros_from_src/git_clone.sh
    # (take look at this script before running as sudo)
    sudo ../ros_from_src/dependencies.sh
    ../ros_from_src/build.sh

    # to install to /opt/ros/noetic (requires permissions, or chown /opt/ros/noetic)
    ../ros_from_src/install.sh

The above should be similar to what is in the github action: .github/workflows/ubuntu_20_04.yaml

    export ROS_BUILD_DIR=$HOME/own/build/ros_from_src  # or whatever
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$ROS_BUILD_DIR/ros/lib/cmake
    # make this python3.8 if python --version shows that to be your version
    export PYTHONPATH=$PYTHONPATH:$ROS_BUILD_DIR/ros/lib/python3.9/site-packages/
    # source $ROS_BUILD_DIR/ros/setup.bash
    source $ROS_BUILD_DIR/catkin_ws/devel/setup.bash

To build with docker and another ubuntu version:

    docker build --build-arg IMAGE=ubuntu:21.10 --build-arg ROSCONSOLE=https://github.com/ros/rosconsole --build-arg PYTHON_MINOR_VERSION=9 . -t ros2110

Build with default Ubuntu 22.04 version:

    docker build . -t ros2204


If you have problems compiling packages that use pcl: build processes complaining they depend on `usb-1.0` but can't find it, apply this patch to one of pcl's included cmake files:

```
--- old/Findlibusb.cmake        2025-05-25 14:55:58.089547900 +0300
+++ /usr/lib/x86_64-linux-gnu/cmake/pcl/Modules/Findlibusb.cmake        2025-05-25 14:50:09.888244937 +0300
@@ -69,5 +69,5 @@
 if(libusb_FOUND)
   add_library(libusb::libusb UNKNOWN IMPORTED)
   set_target_properties(libusb::libusb PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${libusb_INCLUDE_DIR}")
-  set_target_properties(libusb::libusb PROPERTIES IMPORTED_LOCATION "${libusb_LIBRARIES}")
+  set_target_properties(libusb::libusb PROPERTIES IMPORTED_LOCATION "${PC_libusb_LINK_LIBRARIES}")
 endif()
```
