#!/bin/bash
cd "$1/app/.demeteorized"
pwd=`pwd`
forever stop "$pwd/main.js"
