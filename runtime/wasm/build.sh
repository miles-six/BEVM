#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if cargo --version | grep -q "nightly"; then
	CARGO_CMD="cargo"
else
	CARGO_CMD="cargo +nightly"
fi

CARGO_INCREMENTAL=0 RUSTFLAGS="-C link-arg=--export-table" $CARGO_CMD build --target=wasm32-unknown-unknown --release
for i in chainx_runtime
do
	wasm-gc target/wasm32-unknown-unknown/release/$i.wasm target/wasm32-unknown-unknown/release/$i.compact.wasm
done
