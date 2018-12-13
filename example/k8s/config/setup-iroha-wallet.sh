#!/bin/bash
# 
# Copyright (c) 2018, Takeshi Yonezu. All Rights Reserved.
#

KEY_PATH=/opt/iroha/key

IROHA_IP=0.0.0.0
IROHA_PORT=50051

WAIT_TIME=5

function tx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name admin@test \
    --key_path ${KEY_PATH} \
    <<EOF | grep -E '(2018|^Congratulation|^Its)' | sed 's/^>.*: //'
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
}

function rx {
  echo -e "\n>>> $1 ($3 $4 $5 $6 $7 $8) <<<" | sed 's/ *)/)/'

  iroha-cli \
    --account_name admin@test \
    --key_path ${KEY_PATH} \
    <<EOF | grep -E '(2018|^Congratulation|^Its)' | sed 's/^>.*: //'
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

tx CreateAccount crt_acc alice test $(cat ${KEY_PATH}/alice@test.pub)
sleep ${WAIT_TIME}
rx GetAccountInformation get_acc alice@test

tx CreateAccount crt_acc bob test $(cat ${KEY_PATH}/bob@test.pub)
sleep ${WAIT_TIME}
rx GetAccountInformation get_acc bob@test

tx CreateAsset crt_ast coolcoin test 2
sleep ${WAIT_TIME}
rx GetAssetInformation get_ast_info 'coolcoin#test'

tx CreateAsset crt_ast hotcoin test 5
sleep ${WAIT_TIME}
rx GetAssetInformation get_ast_info 'hotcoin#test'

tx AddAssetQuantity add_ast_qty 'coolcoin#test' 1000 0
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast admin@test 'coolcoin#test'

tx AddAssetQuantity add_ast_qty 'hotcoin#test' 1000 0
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast admin@test 'hotcoin#test'

tx TransferAsset tran_ast admin@test alice@test 'coolcoin#test' 500.00
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast alice@test 'coolcoin#test'

tx TransferAsset tran_ast admin@test alice@test 'hotcoin#test' 500.00000
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast alice@test 'hotcoin#test'

tx TransferAsset tran_ast admin@test bob@test 'coolcoin#test' 500.00
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast bob@test 'coolcoin#test'

tx TransferAsset tran_ast admin@test bob@test 'hotcoin#test' 500.00000
sleep ${WAIT_TIME}
rx GetAccountAsset get_acc_ast bob@test 'hotcoin#test'

exit 0
