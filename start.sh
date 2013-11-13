#!/bin/bash
app=${1%'/'}
cd $1
source "envvars-$app.sh"
cd "app/.demeteorized"
pwd=`pwd`
forever -a -l "$pwd/../../logs/main.log" -o "$pwd/../../logs/out.log" -e "$pwd/../../logs/err.log" start "$pwd/main.js"
