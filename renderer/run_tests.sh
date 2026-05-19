#!/bin/bash
# Run the renderer test suite.
# Usage: bash run_tests.sh  (from anywhere inside the repo)

cd "$(dirname "$0")"
printf 'use "loadrender.sml";\n' | sml
