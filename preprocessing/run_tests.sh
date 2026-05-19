#!/bin/bash
cd "$(dirname "$0")"
printf '
use "/usr/local/smlnj/smlnj-lib/Util/json.sml";
use "preprocess.sml";
use "tests_preprocess.sml";
' | sml
