#!/bin/bash

# Declare variables
# Get timestamp
timestamp=$(date +%Y%m%d-%H%M%S)

# Set number of pics to take
piccount=500

# Set number of seconds for interval between pics
pictimer=15


# Change to fswebcam directory
cd /home/pi/photos/fswebcam

# Create new directory for timelapse from timestamp
mkdir $timestamp

# While loop to take photos with autofswebcam.conf
i=0

while [[ $i -lt $piccount ]]; do
   fswebcam -c autofswebcam.conf --save $timestamp/campic-%Y-%m-%d%H:%M:%S.jpg
   sleep $pictimer
   let i=$i+1
done

# Create Timelapse video using mencoder
# navigate to directory
cd $timestamp

# create frames.txt file for mencoder to read from
ls -1tr > frames.txt

# run mencoder 
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=320:240 -mf type=jpeg:fps=20 mf://@frames.txt -o time-lapse-$timestamp.avi

# remove all jpg and txt files
rm *.jpg *.txt
