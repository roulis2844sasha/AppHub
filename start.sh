#!/bin/bash
dir=`pwd`
busybox httpd -p 8080 -f -v -h "$dir/"
