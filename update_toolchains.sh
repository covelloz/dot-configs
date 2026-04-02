#!/usr/bin/env bash

# node (global packages)
echo "Updating node packages..."
npm -g update

# Rust/cargo (toolchain)
echo "=========================="
echo "Updating Rust and cargo..."
echo
rustup update

# cargo (installed packages)
echo "=========================="
echo "Updating cargo packages..."
echo
cargo_packages=$(cargo install --list | grep ':' | cut -d' ' -f 1)
for package in $cargo_packages; do
  [[ "$package" == "helix-term" ]] && continue
  cargo binstall $package
done
