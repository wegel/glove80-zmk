#!/usr/bin/env bash
set -eu

PWD=$(pwd)
TIMESTAMP="${TIMESTAMP:-$(date -u +"%Y%m%d%H%M")}"
COMMIT="${COMMIT:-$(echo xxxxxx)}"

# West Build (left)
west build -s zmk/app -d build/left -b glove80_lh -- -DZMK_CONFIG="${PWD}/config"
# Adv360 Left Kconfig file
grep -vE '(^#|^$)' build/left/zephyr/.config
# Rename zmk.uf2
cp build/left/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2"

# Build right side if selected
if [ -n "${BUILD_RIGHT:-}" ]; then
    # West Build (right)
    west build -s zmk/app -d build/right -b glove80_rh -- -DZMK_CONFIG="${PWD}/config"
    # Adv360 Right Kconfig file
    grep -vE '(^#|^$)' build/right/zephyr/.config
    # Rename zmk.uf2
    cp build/right/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2"

    cat "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2" "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2" > "./firmware/combined-${TIMESTAMP}-${COMMIT}.uf2"
fi
