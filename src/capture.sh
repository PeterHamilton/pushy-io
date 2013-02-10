#!/bin/bash

I=0

while true;
do
echo $I
phantomjs rasterize.js http://localhost:3000/ "test$I.png"
I=`expr $I + 1`
sleep 10
done