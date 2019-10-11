#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

package-cleanup --leaves | tail -n+2 | xargs --no-run-if-empty rpm -e
