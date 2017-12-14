#!/bin/bash

GO=`which go`
PATH_TO_SCRIPT=`readlink -f ${0}`
PATH_TO_FOLDER=`dirname "$PATH_TO_SCRIPT"`

if [ "x$GO" == "x" ]; then
    echo "go missing, please install go 1.5 or newer"
    exit 1
fi

VERSION=`go version`

cd "${PATH_TO_FOLDER}/.."
rm -rf _build/
mkdir -p _build/src/github.com/watts-kit/
mkdir -p _build/bin

GOPATH=`cd _build && pwd -P`
echo " "
echo "running the build with '$VERSION', please include in issue reports"
echo " using GOPATH=${GOPATH} "
export "GOPATH=${GOPATH}"
cd _build/src/github.com/watts-kit/
git clone https://github.com/watts-kit/watts_plugin_info.git
cd watts_plugin_info
go get -v -u
go build -o watts_plugin_info main.go
cd "${PATH_TO_FOLDER}/.."
cp _build/bin/watts_plugin_info .
echo "done"
