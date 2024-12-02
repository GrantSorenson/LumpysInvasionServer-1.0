class LilLadyTwoProjFire extends ProjectileFire;

function InitEffects()
{
	Super.InitEffects();
	if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local LilLadyTwoProj Rocket;
	local LilLadyTwo LilLadyTwo;

	LilLadyTwo = LilLadyTwo(Weapon);

	LilLadyTwo.Heat += 0.005;
	Rocket = Spawn(class'LilLadyTwoProj',,, Start, Dir);

	return Rocket;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Z=0.000000)
     bSplashDamage=True
     FireAnim="AltFire"
     FireSound=Sound'RBSoundsINV.LilLady.bang1'
     FireForce="ShockRifleAltFire"
     FireRate=0.140000
     AmmoClass=Class'LumpyRPGWeapons.LilLadyTwoAmmo'
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'LumpyRPGWeapons.LilLadyTwoProj'
     BotRefireRate=0.500000
     FlashEmitterClass=Class'LumpyRPGWeapons.LilLadyTwoMuzFlash'
}
