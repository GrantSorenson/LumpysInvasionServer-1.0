class HowitzerFire extends tk_ProjectileFire;

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)
     TransientSoundVolume=1.000000
     FireEndAnim=
     FireAnimRate=0.650000
     FireSound=Sound'tk_FHIWeapons.FHISnd.Howitzer_Fire'
     FireForce="FlakCannonFire"
     FireRate=1.250000
     AmmoClass=Class'tk_FHIWeapons.HowitzerAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.HowitzerShell'
     BotRefireRate=0.700000
     FlashEmitterClass=Class'tk_FHIWeapons.HowitzerMuzFlash1st'
}