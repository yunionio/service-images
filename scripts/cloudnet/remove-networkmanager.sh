#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

rpm -qa | grep NetworkManager- | xargs --no-run-if-empty rpm -e
# cleanup leaves
