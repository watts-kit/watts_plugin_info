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
mkdir -p _build/src
mkdir -p _build/bin

GOPATH=`cd _build && pwd -P`
echo " "
echo "running the build with '$VERSION', please include in issue reports"
echo " "
export "GOPATH=${GOPATH}"
go get -v
go build -o watts_plugin_info ${GOPATH}/../main.go
echo "done"
