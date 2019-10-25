#!/usr/bin/env bash
set -e
# capture failing exits in commands obscured behind a pipe
set -o pipefail

PACKAGE=openFrameworksLibs
if [ ! -z ${APPVEYOR+x} ]; then
    PACKAGE=${PACKAGE}_${APPVEYOR_REPO_BRANCH}
else
    PACKAGE=${PACKAGE}_${TRAVIS_BRANCH}
fi

PACKAGE=${PACKAGE}_${TARGET}

# Compress the libs into package
if [ "$TARGET" == "vs" ] || [ "$TARGET" == "msys2" ]; then
    PACKAGE=${PACKAGE}${VS_NAME}_${ARCH}_${BUNDLE}
    TARBALL=${PACKAGE}.zip
else
    PACKAGE=${PACKAGE}${OPT}${ARCH}${BUNDLE}
    TARBALL=${PACKAGE}.tar.bz2
fi

if [ "$TARGET" == "vs" ] || [ "$TARGET" == "msys2" ]; then
    pushd out
    7z a ${TARBALL} *
    popd
elif [ "$TARGET" == "emscripten" ]
    run "cd out && tar cjf $TARBALL * && cd .."
    docker cp emscripten:out/${TARBALL} .
else
    pushd out
    tar cjf $TARBALL *
    popd
fi

# Compute MD5 sum
MD5=${PACKAGE}.md5
md5sum ${TARBALL} > ${MD5}