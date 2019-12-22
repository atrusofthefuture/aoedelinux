#!/usr/bin/env bash
# deps.sh
# 
# Use this script to automagically fetch and build specified AUR packages.
# Specify an AUR helper application with the -H flag (currently only aurutils, yay, and pakku supported)
# By default the packages stored in the "packages" variable are build, and this may be superceded by passing a flag argument when executing the script.
# Ex. usage: $ deps.sh -o <list of packages to "o"verride>
#	     $ deps.sh -a <list of packages to "a"ppend>
# Alternately modify the packages variable with desired packages and run the script with no argument.

# global variables
custom-db="$HOME/custom.db.tar.gz"
packages=( jack-keyboard bitwig etc )

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

case "${helper}" in
	aur) helper_fn="build-aur" ;;
	yay) helper_fn="build-yay" ;;
	pakku) helper_fn="build-pakku" ;;
esac

for i in ${DEPS};
do
	${helper_fn} "$i"
done

#how do i pass the package (represented in the temporary $i variable) as the argument to the helper function in $helper_fn

# repo-add [options] <path-to-db> <package> [<package> ...]
repo-add custom.db jack-keyboard.pkg.tar.xz

# enable custom repo in pacman.conf
# uncomment lines 104..106
for i in 104 105 106; do sed -i "${i}s/^#//" pacman.conf; done

while getopts 'somelettersthatflagopts' arg; do
	case "${arg}" in


options:
  --helper <aurhelper> (ex. aurutils, yaourt)

######## actual code follows

_usage() {
	echo "usage $(basename 0) [options]"
	echo "Options:"
	echo "	-a, --append [package-list]
	Append packages to default list."
	echo "  -o, --override [package-list]
	Override default packages."
	echo "  -H, --helper [aur-helper]
	Select a preferred AUR helper."
	echo "  -h, --help
	Show this help message."
	exit ${1}
}

if [[ ${EUID} -ne 0 ]]; then
	echo "This script must be run as root."
	_usage 1
fi

build() {
for pkg in "${packages}"
do
	if [[ -z $(which makepkg) ]]; then
		exit 1;
	fi
	
	if [[ -n $(which aur) ]]; then
		aur sync ${pkg}; 
	elif [[ -n $(which yay) ]]; then
		yay -S ${pkg}; 
	elif [[ -n $(which pakku) ]]; then 
		pakku -Sn ${pkg};
	else
		git clone "https://aur.archlinux.org/packages/${pkg}.git"
		cd ${pkg}
		makepkg
		repo-add ${custom-db} jack-keyboard.pkg.tar.xz;
	fi
}

## refactor so that there's less redundancy
# check if ${helper} is set; if so, use it
# PROBLEM: syntax for helpers is different so can't just drop-in to same line
# check if helper variable from getopts set
	# if so, run relevant function
	# if not, run main (build?) function, which checks to find a helper and defaults to makepkg if none found

case ${helper} in
	aur) build-aur ;;
	yay) build-yay ;;
	other) build-other ;;
	*)
		echo "invalid argument ${helper}" ;;
esac

build-aur(pkg) {
	aur sync ${pkg}; 
}

build-yay(pkg) {
	yay -S ${pkg};
}

build-pakku(pkg) {
	pakku -Sn ${pkg};
}

while getopts 'H:o:a:h' arg; do # add verbose if needed
	case "${arg}" in
		H) helper="${OPTARG}" ;;
		o) override="${OPTARG}" ;;
		a) append="${OPTARG}" ;;
	#	v) verbose= ;;
		h) _usage 0 ;;
		*) echo "Invalid argument ${arg}"
			_usage 1
			;;
	esac
done


####
program flow:









finally
  if none of the branching conditions are met, run build()
