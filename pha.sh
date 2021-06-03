#!/bin/sh

#### Downscale the image
convert $1 -resize 8x8! /tmp/new.png

#### Grayscale
convert /tmp/new.png -colorspace gray /tmp/new_gray.png

#### Get the average value
AVG=$(convert /tmp/new_gray.png -resize 1x1 txt:- | awk '(NR>1)' | awk -F"[()]" '{print $2}')

#### Get the values of each pixel
convert /tmp/new_gray.png txt:- > /tmp/pixels.txt
tail -n +2 /tmp/pixels.txt > /tmp/pixels.stdout
awk -F"[()]" '{print $2}' /tmp/pixels.stdout > /tmp/pixel_values.stdout

#### Generate a 64-bit string (below mean is 0, above is 1)
BITSTR=""
for i in `cat /tmp/pixel_values.stdout`
do
        BIT=$(echo "$AVG < $i" | bc -l )
        BITSTR="$BITSTR$BIT"
done

echo $BITSTR
