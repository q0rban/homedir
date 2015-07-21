#!/bin/bash
set -e

for file in `git status`; do
  file=`echo $file | sed -e "s/\\?\\?//"`;
  if [[ -f $file ]] || [[ -d $file ]]; then
    read -p "Would you like to delete $file? (y for yes): " RESPONSE
    if [[ $RESPONSE == "y" ]]; then
      echo -e "+ rm -r \"$file\"\n"
      rm -r "$file"
    fi
  fi
done