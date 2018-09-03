#!/bin/bash

cd results
for filename in *.yml; do
  echo "$filename"
  benchmark-driver.ruby2.4 "$filename" -o markdown > ../output/"$filename".md
  benchmark-driver.ruby2.4 "$filename" > ../output/"$filename".txt
  benchmark-driver.ruby2.4 "$filename" -o gruff
  mv graph.png ../output/"$filename"-graph.png
done

