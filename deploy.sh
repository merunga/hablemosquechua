#!/bin/sh
cd $1/app
if [ -d .demeteorized ]; then
  mv .demeteorized ".demeteorized_$(date +%Y-%m-%d-%H-%M-%S)"
fi
demeteorizer
cd .demeteorized
npm install
