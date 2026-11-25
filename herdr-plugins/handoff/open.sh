#!/usr/bin/env bash
# keybinding は action しか呼べないので、action から popup pane を開く
exec "${HERDR_BIN_PATH:-herdr}" plugin pane open --plugin "$HERDR_PLUGIN_ID" --entrypoint ask
