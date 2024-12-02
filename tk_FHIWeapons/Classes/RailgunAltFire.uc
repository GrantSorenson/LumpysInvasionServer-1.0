class RailgunAltFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

/*
function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter == None )
		FlashEmitter = Weapon.FireMode[0].FlashEmitter;
}
*/

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=9.000000,Z=-12.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireAnim="AltFire"
     FireEndAnim=
     FireSound=Sound'tk_FHIWeapons.FHISnd.Railgun_AltFire'
     FireForce="FlakCannonAltFire"
     FireRate=0.750000
     AmmoClass=Class'tk_FHIWeapons.RailgunAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.RailBomb'
     BotRefireRate=0.700000
     WarnTargetPct=0.900000
}
