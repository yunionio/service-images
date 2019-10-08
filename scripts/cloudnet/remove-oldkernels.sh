#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

package-cleanup --oldkernels --count 1
