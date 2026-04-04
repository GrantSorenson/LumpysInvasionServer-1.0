#!/bin/bash
# Rebuild and restart the UT2004 dedicated server.
# Usage: ./rebuild_server.sh
# Requires SSH key auth to be set up (see README or ask Claude).

SERVER="root@172.232.9.14"
export PATH="/c/Program Files/Git/usr/bin:$PATH"
SSH="ssh"
SCP="scp"
REMOTE_DIR="/root/dedicatedserver3369.3-bonuspack"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Pushing latest System files..."
${SCP} "${SCRIPT_DIR}/System/LumpysInvasion.u" ${SERVER}:${REMOTE_DIR}/System/LumpysInvasion.u
${SCP} "${SCRIPT_DIR}/System/LumpysRPG.u"  ${SERVER}:${REMOTE_DIR}/System/LumpysRPG.u

echo "==> Rebuilding and restarting container..."
${SSH} ${SERVER} "
  cd ${REMOTE_DIR} &&
  docker build -t ut2004 . &&
  docker rm -f ut2004 &&
  docker run -d --name ut2004 \
    -p 7777:7777/udp \
    -p 7778:7778/udp \
    -v ${REMOTE_DIR}/Textures:/ut2004/Textures \
    -v ${REMOTE_DIR}/StaticMeshes:/ut2004/StaticMeshes \
    -v ${REMOTE_DIR}/Sounds:/ut2004/Sounds \
    -v ${REMOTE_DIR}/Animations:/ut2004/Animations \
    -v ${REMOTE_DIR}/Maps:/ut2004/Maps \
    -v ${REMOTE_DIR}/LumpysRPG:/ut2004/LumpysRPG \
    -v ${REMOTE_DIR}/LumpysInvasion:/ut2004/LumpysInvasion \
    ut2004
"

echo "==> Verifying md5..."
LOCAL_MD5=\$(md5sum "${SCRIPT_DIR}/System/LumpysInvasion.u" | awk '{print \$1}')
REMOTE_MD5=\$(${SSH} ${SERVER} "md5sum ${REMOTE_DIR}/System/LumpysInvasion.u | awk '{print \$1}'")
echo "  Local:  \${LOCAL_MD5}"
echo "  Remote: \${REMOTE_MD5}"
if [ "\${LOCAL_MD5}" = "\${REMOTE_MD5}" ]; then
  echo "  MD5 OK"
else
  echo "  WARNING: MD5 MISMATCH"
fi

echo "==> Done. Server starting up..."
echo "    Monitor logs: ssh ut2004 'docker exec ut2004 tail -f /root/.ut2004/System/ucc.log'"
