#!/bin/bash

PREFIX=/opt/ams-servers/8.0

# add cmake from modules if they exist
if type module &> /dev/null; then
    module add cmake
fi

# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
fi

# ------------------------------------------------------------------------------
# update revision number
_PWD=$PWD
cd src/projects/ams/8.0
./UpdateGitVersion activate
cd $_PWD

echo ""
echo ">>> Number of CPUs for building: $N"
echo ""

# ------------------------------------------------------------------------------

cmake -DCMAKE_INSTALL_PREFIX="$PREFIX" . 2>&1 | tee configure.log || exit 1
make -j "$N" 2>&1 | tee make.log || exit 1
make install 2>&1 | tee install.log || exit 1

echo ""
