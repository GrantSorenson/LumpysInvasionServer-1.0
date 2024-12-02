class GrenadeSecondaryFire extends tk_ProjectileFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=10.000000,Z=-7.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     TransientSoundVolume=1.000000
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_AltFire'
     ReloadSound=Sound'WeaponSounds.BaseGunTech.BReload9'
     FireForce="AssaultRifleAltFire"
     FireRate=3.500000
     AmmoClass=Class'tk_FHIWeapons.GrenadeAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.GrenadePPG'
     BotRefireRate=0.500000
     Spread=1200.000000
     SpreadStyle=SS_Random
}