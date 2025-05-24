# Testnet CC3RYJTKDJATUI6FUOFGHGEJ4SWINTURHG7K7O6NUMZHCDSSOTZTA3XL
# Mainnet CDZJQYC75AZHRC645ZCXICIFNII7NH65RJOWBSKXAF3DO63D4F74X6C5

default: build

all: test

test: build
	cargo test

build:
	stellar contract build
	@ls -l target/wasm32-unknown-unknown/release/*.wasm

optimize:
	stellar contract build
	stellar contract optimize --wasm target/wasm32-unknown-unknown/release/chat_demo.wasm

deploy:
	stellar contract deploy --wasm target/wasm32-unknown-unknown/release/chat_demo.optimized.wasm --network testnet --source default

bindings:
	stellar contract bindings typescript --wasm target/wasm32-unknown-unknown/release/chat_demo.wasm --output-dir ../chat-demo-sdk --overwrite 

fmt:
	cargo fmt --all

clean:
	cargo clean
