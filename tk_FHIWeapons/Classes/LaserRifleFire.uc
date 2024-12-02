class LaserRifleFire extends tk_SniperFire;

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     HitEmitterClass=Class'tk_FHIWeapons.LaserRifleBolt'
     SecHitEmitterClass=Class'tk_FHIWeapons.LaserRifleSparks'
     NumArcs=4
     DamageTypeHeadShot=Class'tk_FHIWeapons.DamTypeLaserHeadShot'
     DamageType=Class'tk_FHIWeapons.DamTypeLaserShot'
     DamageMin=105
     DamageMax=105
     TraceRange=36000.000000
     TransientSoundVolume=1.000000
     FireAnimRate=1.110000
     FireSound=Sound'tk_FHIWeapons.FHISnd.LaserRifle_Fire'
     FireRate=0.900000
     AmmoClass=Class'tk_FHIWeapons.LaserRifleAmmo'
     BotRefireRate=0.700000
     FlashEmitterClass=Class'tk_FHIWeapons.LaserRifleMuzFlash'
     aimerror=450.000000
}