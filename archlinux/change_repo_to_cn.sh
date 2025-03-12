#!/bin/bash

echo -e "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 

yay --aururl "https://mirrors.ustc.edu.cn/archlinuxcn" --save
