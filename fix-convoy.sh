#!/bin/bash

GT_DIR="${1:-$(pwd)}"
BEADS_DB="$GT_DIR/.beads/beads.db"
CONFIG_YAML="$GT_DIR/.beads/config.yaml"

if [ ! -f "$BEADS_DB" ]; then
  echo "Error: no beads.db found at $BEADS_DB"
  echo "Usage: fix-convoy.sh <path-to-gt-hq-directory>"
  exit 1
fi

PREFIX=$(grep '^issue-prefix:' "$CONFIG_YAML" 2>/dev/null | sed 's/issue-prefix: *"//' | sed 's/"//' | tr -d ' ')
if [ -z "$PREFIX" ]; then
  PREFIX="hq"
fi

sqlite3 "$BEADS_DB" "INSERT OR REPLACE INTO config (key, value) VALUES ('types.custom', 'convoy,agent,rig,polecat,patrol,wisp,formula,molecule,gate,hook,event');"
sqlite3 "$BEADS_DB" "INSERT OR REPLACE INTO config (key, value) VALUES ('issue_prefix', '$PREFIX');"

RESULT=$(sqlite3 "$BEADS_DB" "SELECT value FROM config WHERE key='types.custom';")
echo "types.custom = $RESULT"
echo "issue_prefix = $PREFIX"
echo "Done. Run convoy create with: BEADS_DIR=$GT_DIR/.beads BD_NO_DB=false gt convoy create ..."
