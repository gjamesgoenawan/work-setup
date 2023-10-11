#!/bin/bash

# Message to display
# reset screen and limit scrolling
numlines=$(tput lines)
echo -eq "\ec\e7\e[0;0H*****************************************"
echo -e "\e[2;0H          Work Setup Script 1.0"
echo -e "\e[3;0H*****************************************"
echo -e "\e[4;0HInstalling Dependencies 🏗️\n\n\n\n\n"
echo -e "\e[6;$((numlines))r\e[5;0H"
# go to first line and output a header
for x in $(seq 10); do
    # save position, go to last line, write status and restore position

    sudo apt update
    sleep 0.5
    
done 