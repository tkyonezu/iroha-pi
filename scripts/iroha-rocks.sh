#!/bin/bash

cd example/node4/iroha1

echo "To start python-rocksdb"
echo
echo "# python3"
echo ">>> import rocksdb"
echo ">>> db = rocksdb.DB(\"/tmp/wsv\", rocksdb.Options(create_if_missing=True))"
echo ">>> print(db.get(b\"wv\"))"
echo

docker run -it -v $(pwd)/wsv:/tmp/wsv irohar

exit 0
