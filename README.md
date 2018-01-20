# Iroha-pi

iroha-pi is an environment for building and running [hyperledger/iroha](https://github.com/hyperledger/iroha.git) more simple and easy way.

## build hyperledger/iroha

By executing make, execute the following contents. Also, the target environment is Linux/amd64, Linux/Darwin (MacOS) and Linux/armv7l (Raspberry Pi).

1. If hyperledger/iroha is not yet cloned, it should cloned in the same parent directory as iroha-pi. And you can checkout any branch or tags.
1. Create an iroha-dev container that is used to build iroha binaries.
1. Run the iroha-dev container and build the iroha binaries in the cloned hyperledger/iroha directory.
1. Extract the necessary commands and libraries from the build directory of hyperledger/iroha and copy them to the release directory
1. In the release directory, create a hyperledger / iroha container for execution.

## License

Copyright (c) 2017, 2018 Takeshi Yonezu
All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

