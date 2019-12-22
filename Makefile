#!/usr/bin/make -f
# Makefile for Aoede Linux
# automates builds for optional AUR and third-party packages with makepkg (or AUR helper if installed)
#
# Authored by atrusofthefuture
#

all: AUR GIT EXTRA

AUR: jack-keyboard

jack-keyboard:
	git clone https://aur.archlinux.org/jack-keyboard.git && makepkg -s
