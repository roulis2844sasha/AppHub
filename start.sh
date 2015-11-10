#!/bin/bash
busybox httpd -p 8080 -f -v -h $(cd $(dirname $0) && pwd)"/"
