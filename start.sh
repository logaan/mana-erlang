#!/bin/sh
cd `dirname $0`

echo Starting Nitrogen.
erl \
	-name nitrogen@localhost \
        -pa ../nitrogen/ebin \
	-pa ./ebin -pa ./include \
	-s make all \
	-eval "application:start(mnesia)" \
	-eval "application:start(mana_erlang)"
