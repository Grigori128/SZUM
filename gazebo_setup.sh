#!/bin/bash

echo "Konfiguracja środowiska"

sudo apt update
sudo apt install git
sudo apt install ros-melodic-effort-controllers
sudo apt install ros-melodic-hector-gazebo-plugins
sudo apt install ros-melodic-hector-gazebo
sudo apt install xdotool

mkdir catkin_ws
cd catkin_ws
mkdir src
cd src

git clone https://github.com/HumaRobotics/darwin_description.git
git clone https://github.com/HumaRobotics/darwin_control.git
git clone https://github.com/HumaRobotics/darwin_gazebo.git

cd ..
cd catkin_ws

catkin_make
source devel/setup.bash

cd ..
sudo chmod a+x matlabbash.sh

echo "Uruchamianie gazebo"
roslaunch darwin_gazebo darwin_gazebo.launch
