class TurboLaserProjFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

// used for bot combos
function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile tlp;

	tlp = Super.SpawnProjectile(Start,Dir);
		if ( ( TurboLaser(Instigator.Weapon) != None) && (tlp != None) )
			TurboLaser(Instigator.Weapon).SetTLComboTarget(TurboLaserProjectile(tlp));
	return tlp;
}

defaultproperties
{
     ProjSpawnOffset=(X=24.000000,Y=8.000000,Z=-12.000000)
     bSplashDamage=True
     TransientSoundVolume=1.000000
     FireAnim="AltFire"
     FireAnimRate=1.500000
     FireSound=Sound'tk_FHIWeapons.FHISnd.TurboLaser_AltFire'
     FireForce="ShockRifleAltFire"
     FireRate=0.350000
     AmmoClass=Class'tk_FHIWeapons.TurboLaserAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.TurboLaserProjectile'
     BotRefireRate=0.550000
     FlashEmitterClass=Class'tk_FHIWeapons.TurboLaserMuzFlash1st'
}
