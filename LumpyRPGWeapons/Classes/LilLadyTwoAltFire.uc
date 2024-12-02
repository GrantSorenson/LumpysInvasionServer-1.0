class LilLadyTwoAltFire extends ProjectileFire;

function InitEffects()
{
	Super.InitEffects();
	if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local LilLadyTwo LilLadyTwo;

	LilLadyTwo = LilLadyTwo(Weapon);

	LilLadyTwo.Heat += 0.005;
	return Spawn(ProjectileClass,,, Start, Dir);
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Z=0.000000)
     FireAnim="AltFire"
     FireAnimRate=1.500000
     FireSound=Sound'RBSoundsINV.LilLady.AltBang'
     FireForce="ShockRifleAltFire"
     FireRate=0.140000
     AmmoClass=Class'LumpyRPGWeapons.LilLadyTwoAmmo'
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'LumpyRPGWeapons.LilLadyTwoAltProj'
     BotRefireRate=0.500000
     FlashEmitterClass=Class'LumpyRPGWeapons.LilLadyTwoMuzFlash'
}
