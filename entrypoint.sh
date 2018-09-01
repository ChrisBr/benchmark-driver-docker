#!/bin/bash
#source ~/.bash_profile 

for filename in results/*.yml; do
  echo "$filename"
  benchmark-driver.ruby2.4 "$filename" -o markdown > "$filename".md
  benchmark-driver.ruby2.4 "$filename" > "$filename".txt
  benchmark-driver.ruby2.4 "$filename" -o gruff
  mv graph.png "$filename"-graph.png
done

