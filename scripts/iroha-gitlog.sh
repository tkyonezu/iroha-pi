#!/bin/bash

if [ $# -eq 0 ]; then
  BUILD_HOME=$(pwd)/../iroha
else
  BUILD_HOME=$1
fi

cd $BUILD_HOME

GIT_LOG=$(git log | sed -n 1,/^$/p | grep -v Author | sed -e 's/commit */Commit: /' -e 's/Date: */Date: /')

GIT_BRANCH=$(git branch | grep '^\*' | sed 's/^\* /Branch: /')

echo $GIT_BRANCH $GIT_LOG

exit 0
