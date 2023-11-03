#!/usr/bin/env bash
set -e

sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen 
locale-gen
