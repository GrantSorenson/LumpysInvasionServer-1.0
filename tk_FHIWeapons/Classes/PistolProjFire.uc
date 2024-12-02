class PistolProjFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-3.000000)
     bSplashDamage=True
     TransientSoundVolume=1.000000
     FireAnimRate=0.500000
     FireSound=Sound'WeaponSounds.BaseFiringSounds.BMiniGunAltFire'
     FireForce="ShockRifleAltFire"
     FireRate=0.850000
     AmmoClass=Class'tk_FHIWeapons.PistolAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.PistolProj'
     BotRefireRate=0.850000
     FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
}
