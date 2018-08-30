#!/bin/bash
# 
# Copyright (c) 2018, Takeshi Yonezu. All Rights Reserved.
#

cat kubenode0.pub | xxd -r -p | base64
cat kubenode1.pub | xxd -r -p | base64
cat kubenode2.pub | xxd -r -p | base64
cat kubenode3.pub | xxd -r -p | base64

exit 0
