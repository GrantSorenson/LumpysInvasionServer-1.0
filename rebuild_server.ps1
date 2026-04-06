$SERVER = ""
$REMOTE = ""
$LOCAL  = $PSScriptRoot

# ─────────────────────────────────────────────
# STEP 1: Delete old .u files to force recompile
# ─────────────────────────────────────────────
Write-Host "==> Deleting old .u files..."
Remove-Item -ErrorAction SilentlyContinue "$LOCAL\System\LumpysInvasion.u"
Remove-Item -ErrorAction SilentlyContinue "$LOCAL\System\LumpysRPG.u"

# ─────────────────────────────────────────────
# STEP 2: Compile
# ─────────────────────────────────────────────
Write-Host "==> Compiling..."
Push-Location "$LOCAL\System"
.\ucc-win64.exe make ini=ucc_comp.ini
Pop-Location

# Abort if compile failed (files won't exist)
if (-not (Test-Path "$LOCAL\System\LumpysInvasion.u")) {
    Write-Error "Compile failed — LumpysInvasion.u not found. Aborting."
    exit 1
}

# ─────────────────────────────────────────────
# STEP 3: Push files to server
# ─────────────────────────────────────────────
Write-Host "==> Pushing files..."
scp "$LOCAL/System/LumpysInvasion.u"        "${SERVER}:${REMOTE}/System/LumpysInvasion.u"
scp "$LOCAL/System/LumpysRPG.u"             "${SERVER}:${REMOTE}/System/LumpysRPG.u"
scp "$LOCAL/System/IPSettings.ini"          "${SERVER}:${REMOTE}/System/IPSettings.ini"
scp "$LOCAL/Textures/LumpysMonsterTextures.utx" "${SERVER}:${REMOTE}/Textures/LumpysMonsterTextures.utx"

# ─────────────────────────────────────────────
# STEP 4: Rebuild Docker image and restart
# ─────────────────────────────────────────────
Write-Host "==> Rebuilding and restarting container..."
$CMD = @"
cd $REMOTE && docker build -t ut2004 . && docker rm -f ut2004 && docker run -d --name ut2004 -p 7777:7777/udp -p 7778:7778/udp -v $REMOTE/Textures:/ut2004/Textures -v $REMOTE/StaticMeshes:/ut2004/StaticMeshes -v $REMOTE/Sounds:/ut2004/Sounds -v $REMOTE/Animations:/ut2004/Animations -v $REMOTE/Maps:/ut2004/Maps -v $REMOTE/LumpysRPG:/ut2004/LumpysRPG -v $REMOTE/LumpysInvasion:/ut2004/LumpysInvasion ut2004
"@
ssh $SERVER $CMD

Write-Host "==> Done."
Write-Host "    Monitor logs: ssh $SERVER 'docker logs -f ut2004'"
