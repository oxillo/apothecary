#!/usr/bin/env /bash
#
# A Massively Spiffy Yet Delicately Unobtrusive Compression Library
# http://zlib.net/

# define the version
VER=1.2.8

# tools for git use
GIT_URL=https://github.com/madler/zlib.git
GIT_TAG=v$VER

FORMULA_TYPES=( "vs" )

# download the source code and unpack it into LIB_NAME
function download() {
	wget -nv --no-check-certificate https://github.com/madler/zlib/archive/v$VER.tar.gz -O zlib-$VER.tar.gz
	tar -xf zlib-$VER.tar.gz
	mv zlib-$VER zlib
	rm zlib-$VER.tar.gz
}

# prepare the build environment, executed inside the lib src dir
function prepare() {
	: #noop
}

# executed inside the lib src dir
function build() {
	if [ "$TYPE" == "vs" ] ; then
		unset TMP
		unset TEMP
		# Cmake uses CMAKE_GENERATOR and CMAKE_GENERATOR_PLATFORM env variables set from apothecary
		cmake . 
		# vs-build defaults to "Release|Win32" or "Release|x64" besed on $ARCH
		vs-build "zlib.sln" Build
	fi
}

# executed inside the lib src dir, first arg $1 is the dest libs dir root
function copy() {
	if [ "$TYPE" == "osx" ] ; then
		return
	elif [ "$TYPE" == "vs" ] ; then
		if [ $ARCH == 32 ] ; then
			PLATFORM="Win32"
		else
			PLATFORM="x64"
		fi
		mkdir -p $1/../cairo/lib/$TYPE/$PLATFORM/
		cp -v Release/zlibstatic.lib $1/../cairo/lib/$TYPE/$PLATFORM/zlib.lib
	else
		make install
	fi
}

# executed inside the lib src dir
function clean() {
	if [ "$TYPE" == "vs" ] ; then
		vs-clean "zlib.sln"
	else
		make uninstall
		make clean
	fi
}
