class FlareFire extends tk_ProjectileFire;

function PlayFireEnd()
{}

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function PlayFiring()
{
	Super.PlayFiring();
	FlareLauncher(Weapon).PlayFiring(true);
}

defaultproperties
{
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     TweenTime=0.000000
     FireSound=Sound'tk_FHIWeapons.FHISnd.FlareLauncher_Fire'
     FireForce="RocketLauncherFire"
     FireRate=0.370000
     AmmoClass=Class'tk_FHIWeapons.FlareAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.FlareProj'
     BotRefireRate=0.550000
     WarnTargetPct=0.900000
}