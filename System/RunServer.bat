@echo off
:10
ucc server DM-Flux2?game=InvasionProv1_7.InvasionPro?mutator=UT2004RPG.MutUT2004RPG,WeaponsOfPower.WeaponsOfPower,MonsterArtifactDropv2.MutMonsterDrop,AdminPlus_v14.MutAdminPlus,LumpyRPGWeapons.MutLumpyRPGWeapons, ini=UT2004.ini log=server.log
copy server.log servercrash.log
goto 10
