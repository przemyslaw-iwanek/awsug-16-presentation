#!/bin/bash

###############################################
# Hex SSE Customer Key
SSE_C_KEY="0123456789abcdef0123456789abcdef"
###############################################

for file in /root/backups/*; do
    aws s3 cp --sse-c --sse-c-key "${SSE_C_KEY}" ${file} s3://test-stefan-bucket-747/
    if [ $? -eq 0 ]; then
        rm -f ${file}
    fi
done