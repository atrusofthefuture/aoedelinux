#!/usr/bin/env bash

custom-db=$HOME/custom.db.tar

# =| $HOME/custom.db.tar
# how do i check to see if the var is set and if not set it?
if [[ -z `echo $custom-db` ]]; then
	repo-create $HOME/ custom; ## check syntax for creating local repo
fi

# ex.
# jack-keyboard https://aur.archlinux.org/jack-keyboard.git
# 1. if "helper" optarg set, execute
#	otherwise use makepkg -s
#	will have to be interactive (requires root to install deps)
#	** how to recursively build AUR deps?

# script specifies locations for all relevant audio packages since no guarantee of having a helper to search
# git clone <repo>
# cd jack-keyboard
# makepkg -s

# lets say i wasn't concerned with helping an end user build these packages, but i just wanted to do it procedurally myself
# i'd use aurutils
# ex. (something like; i forget; this is debian) 
## "aurutils build <pkg>"
# if the deps aren't installed
use some awk magic to sort them straight

DEPS=$(grep ^depends PKGBUILD | cut -d '(' -f 2 | sed -e "s/'//g" -e 's/)$//')

for i in ${DEPS};
do
	aurutils build "$i"
done

# repo-add [options] <path-to-db> <package> [<package> ...]
repo-add custom.db jack-keyboard.pkg.tar.xz

# enable custom repo in pacman.conf
# uncomment lines 104..106
for i in 104 105 106; do sed -i "${i}s/^#//" pacman.conf; done

while getopts 'somelettersthatflagopts' arg; do
	case "${arg}" in


options:
  --helper <aurhelper> (ex. aurutils, yaourt)

for pkg in jack-keyboard bitwig etc;
do

	if [[ -z `which makepkg` ]]; then
		exit 1;
	fi
	
	if [[ -n `which aur` ]]; then
		aur sync ${pkg}; 
	elif [[ -n `which yay` ]]; then
		yay; ${pkg} ## check command syntax and update
	elif [[ -n `which ` ]]; then ## placeholder for third aur helper
		command ${pkg};
	else
		git clone "https://aur.archlinux.org/packages/${pkg}.git"
		cd ${pkg}
		makepkg
		repo-add ${custom-db} jack-keyboard.pkg.tar.xz;
	fi
