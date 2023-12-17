#!/bin/bash

Xvfb :1 -screen 0 1080x1080x16 &

python3 shadertoy-to-video/shadertoy-render.py \
    $BUILD_ARGUMENTS \
    $BUILD_TARGET
