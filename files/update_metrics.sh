#!/bin/bash

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue
  key="${line%%=*}"
  value="${line#*=}"
  printf "$key $($value)\n" >> "$2/active.prom.$$"
done < $1

if [ -f "$2/active.prom.$$" ]; then
  mv "$2/active.prom.$$" "$2/active.prom"
else
  rm -f "$2/active.prom"
fi