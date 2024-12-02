class SporeFire extends tk_ProjectileFire;

function DrawMuzzleFlash(Canvas Canvas)
{
    if (FlashEmitter != None)
        FlashEmitter.SetRotation(Weapon.Rotation);
    Super.DrawMuzzleFlash(Canvas);
}

function float MaxRange()
{
	return 2500;
}

defaultproperties
{
     ProjSpawnOffset=(X=20.000000,Y=9.000000,Z=-6.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     TransientSoundVolume=1.000000
     FireEndAnim=
     FireSound=SoundGroup'WeaponSounds.BioRifle.BioRifleFire'
     FireForce="BioRifleFire"
     FireRate=1.350000
     AmmoClass=Class'tk_FHIWeapons.SporeAmmo'
     AmmoPerFire=10
     ShakeRotMag=(X=70.000000)
     ShakeRotRate=(X=1000.000000)
     ShakeRotTime=1.800000
     ShakeOffsetMag=(Z=-2.000000)
     ShakeOffsetRate=(Z=1000.000000)
     ShakeOffsetTime=1.800000
     ProjectileClass=Class'tk_FHIWeapons.Spore'
     BotRefireRate=0.800000
     FlashEmitterClass=Class'XEffects.BioMuzFlash1st'
     Spread=3000.000000
     SpreadStyle=SS_Random
}
