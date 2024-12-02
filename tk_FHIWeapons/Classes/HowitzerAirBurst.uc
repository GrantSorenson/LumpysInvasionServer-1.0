class HowitzerAirBurst extends tk_ProjectileFire;

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter == None)
		FlashEmitter = Weapon.GetFireMode(0).FlashEmitter;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=9.000000,Z=-12.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     TransientSoundVolume=1.000000
     FireEndAnim=
     FireAnimRate=0.600000
     FireSound=Sound'tk_FHIWeapons.FHISnd.Howitzer_Fire'
     FireForce="FlakCannonAltFire"
     FireRate=1.500000
     AmmoClass=Class'tk_FHIWeapons.HowitzerAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.HowitzerAirBurstShell'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
}