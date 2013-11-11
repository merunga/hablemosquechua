#!/bin/bash
app=${1%'/'}
cd $1
source "envvars-$app.sh"
cd "app/.demeteorized"
pwd=`pwd`
forever -a -l "$pwd/../../logs/$app-main.log" -o "$pwd/../../logs/$app-out.log" -e "$pwd/../../logs/$app-err.log" start "$pwd/main.js"
