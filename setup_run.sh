#!/bin/bash

echo "[+] Decoding setup..."
base64 -d setup.enc > .setup_tmp.sh

chmod +x .setup_tmp.sh

echo "[+] Running setup..."
./.setup_tmp.sh

echo "[+] Cleaning..."
rm -f .setup_tmp.sh
