#!/bin/bash

# Wait for a few seconds before checking
sleep 10

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)

if [ "$STATUS" -ne 200 ]; then
  echo "Health check failed with status $STATUS"
  exit 1
else
  echo "Health check passed with status $STATUS"
fi
