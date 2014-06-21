#!/bin/bash

echo Compiling...
make

echo Starting execution...

for i in {0..13}
do
	echo $i
	
	./main ../../FacialHairReleasePack/data/cam9/take_001.jpg
done
