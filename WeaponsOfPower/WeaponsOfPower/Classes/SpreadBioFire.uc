class SpreadBioFire extends BioFire;

var int SpreadLevel;

////////////////////////////////////////////////////////////////////////////////

function SetLevel(
	int iNewLevel
) {
	SpreadLevel = iNewLevel;
}

////////////////////////////////////////////////////////////////////////////////

function StartSpread() {
	Load        = 1 + SpreadLevel * class'SpreadModifierConfiguration'.default.SpreadBioAmmoCost;
	AmmoPerFire = 1 + SpreadLevel * class'SpreadModifierConfiguration'.default.SpreadBioAmmoCost;
}

////////////////////////////////////////////////////////////////////////////////

function DoFireEffect() {
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local Int   i;

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

		if (SpreadLevel == 1) {
			for (i = 0; i < 3; ++i) {
				R.Yaw   = -2000 + (i * 2000) + (rand(1500) - 750);
				R.Pitch = (rand(2000) - 100);
		    SpawnProjectile(StartProj, Rotator(X >> R));
			}
		} else {
			for (i = 0; i < 5; ++i) {
				R.Yaw   = -2000 + (i * 1000) + (rand(1500) - 750);
				R.Pitch = (rand(2000) - 100);
		    SpawnProjectile(StartProj, Rotator(X >> R));
			}
		}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SpreadLevel=1
    AmmoPerFire=4
}
