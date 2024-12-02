class ShotgunFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjPerFire=10
     ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)
     bInstantHit=True
     TransientSoundVolume=1.000000
     FireEndAnim=
     FireSound=Sound'tk_FHIWeapons.FHISnd.Shotgun_Fire'
     FireForce="FlakCannonFire"
     FireRate=0.950000
     AmmoClass=Class'tk_FHIWeapons.ShotgunAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.ShotgunPellet'
     BotRefireRate=0.990000
     FlashEmitterClass=Class'tk_FHIWeapons.ShotgunMuzFlash1st'
     Spread=600.000000
     SpreadStyle=SS_Random
}
