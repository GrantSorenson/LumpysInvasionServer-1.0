$SERVER = "root@172.232.9.14"
$REMOTE = "/root/dedicatedserver3369.3-bonuspack"
$LOCAL  = $PSScriptRoot

Write-Host "==> Compiling..."
Push-Location "$LOCAL\System"
.\ucc-bin.exe make ini=ucc_comp.ini
Pop-Location

Write-Host "==> Pushing .u files..."
scp "$LOCAL/System/LumpysInvasion.u" "${SERVER}:${REMOTE}/System/LumpysInvasion.u"
scp "$LOCAL/System/LumpysRPG.u"      "${SERVER}:${REMOTE}/System/LumpysRPG.u"

Write-Host "==> Rebuilding and restarting container..."
$CMD = @"
cd $REMOTE && docker build -t ut2004 . && docker rm -f ut2004 && docker run -d --name ut2004 -p 7777:7777/udp -p 7778:7778/udp -v $REMOTE/Textures:/ut2004/Textures -v $REMOTE/StaticMeshes:/ut2004/StaticMeshes -v $REMOTE/Sounds:/ut2004/Sounds -v $REMOTE/Animations:/ut2004/Animations -v $REMOTE/Maps:/ut2004/Maps -v $REMOTE/LumpysRPG:/ut2004/LumpysRPG -v $REMOTE/LumpysInvasion:/ut2004/LumpysInvasion ut2004
"@
ssh $SERVER $CMD

Write-Host "==> Done. Monitor logs with:"
Write-Host "    ssh $SERVER 'docker exec ut2004 tail -f /root/.ut2004/System/ucc.log'"
