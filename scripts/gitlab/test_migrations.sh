#!/bin/sh
set -e

BIN="./target/release/polkadot"
WASM="./target/release/wbuild/polkadot-runtime/polkadot_runtime.compact.wasm"
export HTTP_RPC_ENDPOINT="$MIGRATION_HTTP_RPC_ENDPOINT"

# TODO: We should change this to something better - either build a Dockerfile
# for fork-off-substrate or get it into npm

if [ ! -d "./fork-off-substrate" ]; then
  git clone https://github.com/maxsam4/fork-off-substrate
fi
if [ ! -d "./fork-off-substrate/data" ]; then
  mkdir fork-off-substrate/data
fi
cp "$BIN" ./fork-off-substrate/data/binary
cp "$WASM" ./fork-off-substrate/data/runtime.wasm

cd fork-off-substrate || exit 1
npm i
echo "[+] Connecting to $HTTP_RPC_ENDPOINT and running fork-off-substrate"
npm start
echo "[+] Chain successfully forked. Launching Polkadot with forked chain"
./data/binary --chain ./data/fork.json --alice
