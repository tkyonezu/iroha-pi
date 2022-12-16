#!/bin/bash

function cli ()
{
  ../../../docker/release/iroha_client_cli $*
}

cli blocks 1

exit 0
