class DroidWeaponFire extends tk_ProjectileFire
     config(TKWeaponsClient);

defaultproperties
{
     ProjSpawnOffset=(X=27.000000,Y=10.000000,Z=-3.000000)
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireSound=Sound'tk_StarWars.Droideka.DroidFireNew'
     FireForce="redeemer_shoot"
     FireRate=0.200000
     AmmoClass=Class'tk_StarWars.DroidWeaponAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'tk_StarWars.DroidProj'
     BotRefireRate=0.500000
}