.PHONY: clean

# Import and export env for edamame_core and edamame_foundation
-include ../secrets/lambda-signature.env
-include ../secrets/foundation.env
-include ../secrets/sentry.env
export

macos: macos_release

macos_release:
	cargo build --release

macos_debug:
	cargo build
	bash -c "export RUST_BACKTRACE=1; export EDAMAME_LOG_LEVEL=info; rust-lldb ./target/debug/edamame_posture"

macos_publish: macos_release
	# Sign + hardened runtime
	./macos/sign.sh ./target/release/edamame_posture
	./macos/notarize.sh ./target/release/edamame_posture

windows: windows_release

windows_debug:
	cargo build

windows_release:
	cargo build --release

windows_publish: windows_release

linux: linux_release

linux_debug:
	cargo build

linux_release:
	cargo build --release

linux_publish: linux_release

upgrade:
	rustup update
	cargo install -f cargo-upgrades
	cargo upgrades
	cargo update

unused_dependencies:
	cargo +nightly udeps

format:
	cargo fmt

clean:
	cargo clean
	rm -rf ./build/
	rm -rf ./target/

test:
	cargo test

debug:
	cargo build -vv
