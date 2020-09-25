#!/usr/bin/env bash

tag=${1}
if [ -z "${1}" ]
then
      echo "release tag is not provided"
      exit 1
fi

echo $tag

cat > dockerfile-configs/gardenctl-components.yaml << EOF
# Copyright 2019 Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, v. 2 except as noted otherwise in the LICENSE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

- bash:
  - name: make-gardenctl-dir
    command: mkdir -p /opt/gardenctl/bin
    info: ~

- curl:
  - name: gardenctl
    version: "$tag"
    from: https://github.com/gardener/gardenctl/releases/download/{version}/gardenctl-linux-amd64
    to: /opt/gardenctl/bin/gardenctl
    command: |
      chmod 755 /opt/gardenctl/bin/gardenctl && \
      ln -s /opt/gardenctl/bin/gardenctl /usr/local/bin/gardenctl && \
      mkdir $HOME/.garden && \
      echo "source <(gardenctl completion bash | grep -v 'Please provide a gardenctl configuration before usage')" >> /root/.bashrc
    info: command-line client for administrative purposes for Gardener

EOF