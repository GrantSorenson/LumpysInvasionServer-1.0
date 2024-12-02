class SturdyModifier extends LinearUpgradeWeaponModifier;

var bool bActive;

var int OldMass;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role < ROLE_Authority)
		ActivateSturdy, DeactivateSturdy;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Apply() {
	super.Apply();
}

simulated function Upgrade() {
	super.Upgrade();

	ActivateSturdy();
}

simulated function Remove() {
	DeactivateSturdy();
}

////////////////////////////////////////////////////////////////////////////////

function Destroyed() {
	DeactivateSturdy();

	super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

function HolderDeathPrevented() {
	DeactivateSturdy();
}

function bool OnGhost() {
	ActivateSturdy();

	return super.OnGhost();
}

////////////////////////////////////////////////////////////////////////////////

function GiveFromDenial(
	Pawn            Other,
	optional Pickup Pickup
) {
	bActive = false;
}

function GiveTo(
	Pawn            Other,
	optional Pickup Pickup
) {
	bActive = false;
}

////////////////////////////////////////////////////////////////////////////////

function AdjustPlayerDamage(
	int               OriginalDamage,
	out int           Damage,
	Pawn              InstigatedBy,
	vector            HitLocation,
	vector            OriginalMomentum,
	out Vector        Momentum,
	class<DamageType> DamageType
) {
	Momentum = vect(0, 0, 0);
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	ActivateSturdy();
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool PutDown() {
	// Level three an above will always be active.
	if (CurrentLevel < 3) {
		DeactivateSturdy();
	}

	return super.PutDown();
}

////////////////////////////////////////////////////////////////////////////////

simulated function HolderDied() {
	DeactivateSturdy();
}

////////////////////////////////////////////////////////////////////////////////

function DropFrom(
	vector     OriginalStartLocation,
	out vector StartLocation
) {
	DeactivateSturdy();

	super.DropFrom(
		OriginalStartLocation,
		StartLocation
	);
}

////////////////////////////////////////////////////////////////////////////////

function ActivateSturdy() {
	if (CurrentLevel < 2) {
		return;
	}

	if (bActive == true) {
		return;
	}

	if (PlayerOwner != None) {
		OldMass = PlayerOwner.Mass;

		PlayerOwner.Mass = 1000000;
	}

	bActive = true;
}

////////////////////////////////////////////////////////////////////////////////

function DeactivateSturdy() {
	if (CurrentLevel < 2) {
		return;
	}

	if (bActive == false) {
		return;
	}

	if (
		(PlayerOwner != None) &&
		(OldMass     != 0)
	) {
		PlayerOwner.Mass = OldMass;
	}

	OldMass = 0;

	bActive = false;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierColor=(R=255,G=224,B=128,A=0),
    configuration=Class'SturdyModifierConfiguration'
    Artifact=Class'SturdyModifierArtifact'
}
