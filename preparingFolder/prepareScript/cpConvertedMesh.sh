#!bin/bash

curdir=$(pwd)

for f in $curdir/*
do 
       cd "$f" &&

       echo Entering into $f &&

       cp -rf ../../preparingFolder/preparingCases/oriCaseFolder/constant ./
done;
