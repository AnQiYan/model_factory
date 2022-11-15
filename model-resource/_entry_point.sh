#!/usr/bin/env bash

CUR_DIR=$(readlink -e $(dirname "$0"))
export CUR_DIR

/usr/local/bin/_entrypoint.sh python3 "$CUR_DIR"/code/yjy_week_dyn_eval.py
/usr/local/bin/_entrypoint.sh python3 "$CUR_DIR"/code/yjy_year_dyn_eval.py

