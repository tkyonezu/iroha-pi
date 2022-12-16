#!/bin/bash

function cli ()
{
  ../../../docker/release/iroha_client_cli $*
}

cli events data

exit 0
