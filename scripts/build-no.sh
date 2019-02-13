#!/bin/bash
#
# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

BUILDNO_FILE=.buildno

N=$(cat ${BUILDNO_FILE})

N=$((N+=1))

echo $N >${BUILDNO_FILE}
