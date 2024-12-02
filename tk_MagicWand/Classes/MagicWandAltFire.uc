class MagicWandAltFire extends tK_ProjectileFire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;

	p = Super.SpawnProjectile(Start, Dir);
	if (p == None)
		p = Super.SpawnProjectile(Instigator.Location, Dir);

	if (p == None)
	{
	 	Weapon.Spawn(class'SmallRedeemerExplosion');
		Weapon.HurtRadius(500, 400, class'DamTypeRedeemer', 100000, Instigator.Location);
	}

	return p;
}

function float MaxRange()
{
	return 20000;
}

defaultproperties
{
     ProjSpawnOffset=(X=27.000000,Y=10.000000,Z=-3.000000)
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser23'
     FireForce="redeemer_shoot"
     FireRate=0.200000
     AmmoClass=Class'tk_MagicWand.MagicWandAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'tk_MagicWand.MagicWandProj'
     BotRefireRate=0.500000
}