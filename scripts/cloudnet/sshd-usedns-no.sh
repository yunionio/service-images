#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

f=/etc/ssh/sshd_config

if grep -q '^#UseDNS yes$' "$f"; then
	sed -i -e 's/^#UseDNS yes$/UseDNS no/' "$f"
else
	echo "UseDNS yes" >>"$f"
fi
