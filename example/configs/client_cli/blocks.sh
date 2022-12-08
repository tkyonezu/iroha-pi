#!/bin/bash

function cli ()
{
  ../../../docker/release/iroha_client_cli $*
}

cli blocks 0

exit 0
