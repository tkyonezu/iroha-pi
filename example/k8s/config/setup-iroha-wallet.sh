#!/bin/bash
# 
# Copyright (c) 2018,2019 , Takeshi Yonezu. All Rights Reserved.
#

KEY_PATH=/opt/iroha/key

IROHA_IP=0.0.0.0
IROHA_PORT=50051

function tx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name admin@test \
    --key_path ${KEY_PATH} \
    <<EOF | grep -E '(^\[20|^Congratulation|^Its)' | sed 's/^>.*: //' | tee /tmp/hash
tx
$2
$3
$4
$5
$6
$7
$8
send
${IROHA_IP}
${IROHA_PORT}
EOF

  hash=$(cat /tmp/hash| grep hash | cut -d' ' -f4)
  st $hash >/tmp/st
  while ! cat /tmp/st | grep -q "successfully committed"; do
    if cat /tmp/st | grep -q "error"; then
      echo
      cat /tmp/st | grep "error" | sed 's/^>.*: //'
      break
    fi
    sleep 1
    echo -n "."
    st $hash >/tmp/st
  done
}

function rx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name admin@test \
    --key_path ${KEY_PATH} \
    <<EOF | grep -E '(^\[20|^Congratulation|^Its)' | sed 's/^>.*: //'
qry
$2
$3
$4
$5
$6
$7
$8
send
${IROHA_IP}
${IROHA_PORT}
EOF
}

function st {
  iroha-cli \
    --account_name admin@test \
    --key_path ${KEY_PATH} \
    <<EOF
st
get_tx_info
$1
send
${IROHA_IP}
${IROHA_PORT}
EOF
}

tx CreateAccount crt_acc alice test $(cat ${KEY_PATH}/alice@test.pub)
rx GetAccountInformation get_acc alice@test

tx CreateAccount crt_acc bob test $(cat ${KEY_PATH}/bob@test.pub)
rx GetAccountInformation get_acc bob@test

tx CreateAsset crt_ast coolcoin test 2
rx GetAssetInformation get_ast_info 'coolcoin#test'

tx CreateAsset crt_ast hotcoin test 5
rx GetAssetInformation get_ast_info 'hotcoin#test'

tx AddAssetQuantity add_ast_qty 'coolcoin#test' 1000 0
rx GetAccountAsset get_acc_ast admin@test 'coolcoin#test'

tx AddAssetQuantity add_ast_qty 'hotcoin#test' 1000 0
rx GetAccountAsset get_acc_ast admin@test 'hotcoin#test'

tx TransferAsset tran_ast admin@test alice@test 'coolcoin#test' 500.00
rx GetAccountAsset get_acc_ast alice@test 'coolcoin#test'

tx TransferAsset tran_ast admin@test alice@test 'hotcoin#test' 500.00000
rx GetAccountAsset get_acc_ast alice@test 'hotcoin#test'

tx TransferAsset tran_ast admin@test bob@test 'coolcoin#test' 500.00
rx GetAccountAsset get_acc_ast bob@test 'coolcoin#test'

tx TransferAsset tran_ast admin@test bob@test 'hotcoin#test' 500.00000
rx GetAccountAsset get_acc_ast bob@test 'hotcoin#test'

exit 0
