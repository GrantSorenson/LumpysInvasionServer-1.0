class SpreadLinkAltFire extends LinkAltFire;

var int SpreadLevel;

////////////////////////////////////////////////////////////////////////////////

function SetLevel(
	int iNewLevel
) {
	SpreadLevel = iNewLevel;
}

////////////////////////////////////////////////////////////////////////////////

function StartSpread() {
	Load        = 1 + SpreadLevel * class'SpreadModifierConfiguration'.default.SpreadLinkAmmoCost;
	AmmoPerFire = 1 + SpreadLevel * class'SpreadModifierConfiguration'.default.SpreadLinkAmmoCost;
}

////////////////////////////////////////////////////////////////////////////////

function DoFireEffect() {
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator R, Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();
	StartProj  = StartTrace + X*ProjSpawnOffset.X;

	if (!Weapon.WeaponCentered()) {
		StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
	}

	// check if projectile would spawn through a wall and adjust start location accordingly
	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

	if (Other != None) {
		StartProj = HitLocation;
	}

	Aim = AdjustAim(StartProj, AimError);

	X = Vector(Aim);

	SpawnProjectile(StartProj, Rotator(X));

	R.Yaw = 4000;
	SpawnProjectile(StartProj, Rotator(X >> R));

	R.Yaw = -4000;
	SpawnProjectile(StartProj, Rotator(X >> R));

	if (SpreadLevel > 1) {
		R.Yaw = 2000;
		SpawnProjectile(StartProj, Rotator(X >> R));

		R.Yaw = -2000;
		SpawnProjectile(StartProj, Rotator(X >> R));
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SpreadLevel=1
    AmmoPerFire=4
}
