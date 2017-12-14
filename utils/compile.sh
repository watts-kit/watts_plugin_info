#!/bin/bash

GO=`which go`
PATH_TO_SCRIPT=`readlink -f ${0}`
PATH_TO_FOLDER=`dirname "$PATH_TO_SCRIPT"`
SOURCE_FOLDER="_build/src/github.com/watts-kit/"

if [ "x$GO" == "x" ]; then
    echo "go missing, please install go 1.5 or newer"
    exit 1
fi

VERSION=`go version`

cd "${PATH_TO_FOLDER}/.."
rm -f watts_plugin_info
rm -rf _build/
mkdir -p $SOURCE_FOLDER
mkdir -p _build/bin

GOPATH=`cd _build && pwd -P`
echo " "
echo "running the build with '$VERSION', please include in issue reports"
echo " "
export "GOPATH=${GOPATH}"
cd $SOURCE_FOLDER
git clone https://github.com/watts-kit/watts_plugin_info.git
cd "${PATH_TO_FOLDER}/.."
echo "updating with local version"
cp *.go "$SOURCE_FOLDER/watts_plugin_info"
cd "$SOURCE_FOLDER/watts_plugin_info"
go get -v -u
go build -o watts_plugin_info main.go
cd "${PATH_TO_FOLDER}/.."
cp _build/bin/watts_plugin_info .
echo "done"
