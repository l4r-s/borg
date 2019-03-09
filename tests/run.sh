#!/bin/bash

image=$1
docker run -it --rm -p 2222:2222 -e KEYS="$(cat /home/lars/.ssh/*.pub)" $image