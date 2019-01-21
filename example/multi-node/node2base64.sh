#!/bin/bash
# 
# Copyright (c) 2018, Takeshi Yonezu. All Rights Reserved.
#

cat iroha1.pub | xxd -r -p | base64
cat iroha2.pub | xxd -r -p | base64
cat iroha3.pub | xxd -r -p | base64
cat iroha4.pub | xxd -r -p | base64
cat iroha5.pub | xxd -r -p | base64

exit 0
