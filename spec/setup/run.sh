
#!/bin/bash
# Run arango under my archlinux machine

PID=$(echo $PPID)
TMP_DIR="/tmp/arangodb.$PID"
PID_FILE="/tmp/arangodb.$PID.pid"
ARANGODB_DIR="/usr/share/arangodb"

# create database directory
mkdir ${TMP_DIR}

arangod \
    --database.directory ${TMP_DIR}  \
    --configuration none  \
    --server.endpoint tcp://127.0.0.1:8529 \
    --javascript.startup-directory ${ARANGODB_DIR}/js \
    --javascript.modules-path ${ARANGODB_DIR}/js/server/modules:${ARANGODB_DIR}/js/common/modules \
    --javascript.action-directory ${ARANGODB_DIR}/js/actions/system  \
    --database.maximal-journal-size 1048576  \
    --server.disable-admin-interface true \
    --server.disable-authentication true \
    --javascript.gc-interval 1
