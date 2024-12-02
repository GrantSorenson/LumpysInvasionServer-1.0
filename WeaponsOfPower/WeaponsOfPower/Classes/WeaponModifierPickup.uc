class WeaponModifierPickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

var float BounceSpeedLoss;

var sound BounceSound;

var vector InitialLocation;

var bool bReactToPhysics;

////////////////////////////////////////////////////////////////////////////////

simulated function PostBeginPlay() {
	InitialLocation = Location;
	super.PostBeginPlay();
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetRespondToPhysics() {
	bReactToPhysics = true;
}

////////////////////////////////////////////////////////////////////////////////

simulated final function RandSpin(float spinRate) {
	DesiredRotation    = RotRand();
	RotationRate.Yaw   = spinRate * 2 * FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 * FRand() - spinRate;
	RotationRate.Roll  = spinRate * 2 * FRand() - spinRate;
}

////////////////////////////////////////////////////////////////////////////////

function HitWall(
	vector HitNormal,
	Actor Wall
) {
	if (bReactToPhysics == false) {
		return;
	}

	Velocity = BounceSpeedLoss * ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);

	if (bHidden == false) {
		PlaySound(BounceSound, SLOT_Misc);
	}

	//RandSpin(100000);

	if (VSize(Velocity) < 10) {
		Velocity = vect(0,0,0);
		SetRotation(rotator(vect(0,0,0)));
		SetPhysics(PHYS_None);
		AddToNavigation();
	}
}

////////////////////////////////////////////////////////////////////////////////

function Landed(
	vector hitNormal
) {
	if (bReactToPhysics == true) {
		HitWall(HitNormal, None);
	}
}

////////////////////////////////////////////////////////////////////////////////

function TakeDamage(
	int    Damage,
	Pawn   EventInstigator,
	vector HitLocation,
	vector Momentum,
	class<DamageType> DamageType
) {
	if (bReactToPhysics == true && bHidden == false) {
		RemoveFromNavigation();
		SetPhysics(PHYS_Falling);
		Velocity += Momentum / Mass;
		//RandSpin(100000);
	}
}

////////////////////////////////////////////////////////////////////////////////

State Sleeping {
	function BeginState() {
		if (bReactToPhysics == false) {
			super.BeginState();
		} else {
			SetCollisionSize(0,0);
			bHidden = true;
		}
	}

	function EndState() {
		if (bReactToPhysics == false) {
			super.EndState();
		} else {
			SetCollisionSize(default.CollisionRadius,default.CollisionHeight);
			bHidden = false;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated event FellOutOfWorld(
	eKillZType KillType
) {
	Velocity = vect(0,0,0);
	spawn(class'PlayerSpawnEffect');

	Destroy();
}

////////////////////////////////////////////////////////////////////////////////

simulated event PhysicsVolumeChange(
	PhysicsVolume NewVolume
) {
	if (bReactToPhysics == true && NewVolume.bPainCausing == true) {
		spawn(class'PlayerSpawnEffect');

		Destroy();
	}

	Super.PhysicsVolumeChange(NewVolume);
}

////////////////////////////////////////////////////////////////////////////////

function bool CanPickupArtifact(
	Pawn Other
) {
	local Inventory currentItem;

	if (super.CanPickupArtifact(Other) == false) {
		return false;
	}

	// Finish off checking if a WoP weapon is required.
	if (class'WeaponModifierArtifactManager'.default.RequireWopForPickup == false) {
		return true;
	}

	currentItem = Other.Inventory;

	while (currentItem != None) {
		if (WeaponOfPower(currentItem) != None) {
			return true;
		}

		currentItem = currentItem.Inventory;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

function Inventory SpawnCopy(
	Pawn Other
) {
	local Inventory                     Copy;
	local WeaponModifierArtifactManager Manager;

	Copy = super.SpawnCopy(Other);

	if (Copy != None) {
		if (WeaponOfPowerArtifact(Copy) != None) {
			WeaponOfPowerArtifact(Copy).RemainingUses = GetIntialUses();

			if (WeaponModifierArtifact(Copy) != None) {
				// Don't count artifacts that have been picked up by players against
				// the maximum number of artifacts that should be in play.
				foreach DynamicActors(class'WeaponModifierArtifactManager', Manager) {
					Manager.RemovePlayerPickup(WeaponModifierArtifact(Copy));
					break;
				}
			}
		}
	}

	return Copy;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    BounceSpeedLoss=0.60
    BounceSound=Sound'WeaponSounds.Misc.ball_bounce_v3a'
    NetUpdateFrequency=100.00
    bShouldBaseAtStartup=False
    bProjTarget=True
    bBounce=True
    Mass=50.00
}
