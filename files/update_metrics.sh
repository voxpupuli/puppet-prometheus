#!/bin/bash

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue
  key="${line%%=*}"
  value="${line#*=}"
  output=$(eval "$value" 2>/dev/null)
  printf "%s %s\n" "$key" "$output" >> "$2/active.prom.$$"
done < $1

if [ -f "$2/active.prom.$$" ]; then
  mv "$2/active.prom.$$" "$2/active.prom"
else
  rm -f "$2/active.prom"
fi