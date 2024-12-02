class MiniRocketFire extends tk_ProjectileFire;

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'flash');
}

function PlayFiring()
{
	Super.PlayFiring();
	MiniRocketLauncher(Weapon).PlayFiring(true);
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;
	
	p = MiniRocketLauncher(Weapon).SpawnProjectile(Start, Dir);
	if (p != None)
		p.Damage *= DamageAtten;

	return p;
}

defaultproperties
{
     ProjSpawnOffset=(X=100.000000,Y=18.000000,Z=-16.000000)
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireAnim="FireEnd"
     FireAnimRate=2.000000
     TweenTime=0.000000
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=0.270000
     AmmoClass=Class'tk_FHIWeapons.MiniRocketAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.MiniRocketProj'
     BotRefireRate=0.790000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'XEffects.RocketMuzFlash1st'
}