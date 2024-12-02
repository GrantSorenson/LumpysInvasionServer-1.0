class SpeedModifier extends LinearUpgradeWeaponModifier;

var bool bActive;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role < ROLE_Authority)
		ActivateSpeed, DeactivateSpeed, AdjustSpeedModifier;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
///	<param name="Owner">
///	</param>
///	<param name="Weapon">
///	</param>
simulated function Apply() {
	super.Apply();

	ActivateSpeed();
}

function SetLevel(
	int iNewLevel
) {
	DeactivateSpeed();

	super.SetLevel(iNewLevel);

	ActivateSpeed();
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
simulated function Upgrade() {
	AdjustSpeedModifier(1);

	super.Upgrade();
}

////////////////////////////////////////////////////////////////////////////////

simulated function Remove() {
	DeactivateSpeed();
}

function Destroyed() {
	DeactivateSpeed();

	super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

function HolderDeathPrevented() {
	DeactivateSpeed();
}

function bool OnGhost() {
	ActivateSpeed();

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

function AdjustSpeedModifier(
	int iAdjustment
) {
	local WopStatsInv StatsInv;

	if (
		(GetWeapon().Owner       != None) &&
		(Pawn(GetWeapon().Owner) != None)
	) {
		StatsInv = WopStatsInv(Pawn(GetWeapon().Owner).FindInventoryType(class'WopStatsInv'));

		if (StatsInv != None) {
			StatsInv.AdjustPlayerSpeed(iAdjustment);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function ActivateSpeed() {
	// Insure we don't accidentally activate this twice.
	if (bActive == false) {
		bActive = true;
		AdjustSpeedModifier(CurrentLevel);
	}
}

////////////////////////////////////////////////////////////////////////////////

function DeactivateSpeed() {
	// Insure we don't accidentally deactivate this twice.
	if (bActive == true) {
		bActive = false;
		AdjustSpeedModifier(-CurrentLevel);
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	ActivateSpeed();
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool PutDown() {
	DeactivateSpeed();

	return super.PutDown();
}

////////////////////////////////////////////////////////////////////////////////

function DropFrom(
	vector     OriginalStartLocation,
	out vector StartLocation
) {
	DeactivateSpeed();

	super.DropFrom(
		OriginalStartLocation,
		StartLocation
	);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.BRShaders.BombIconBS'
    ModifierColor=(R=225,G=128,B=255,A=0),
    configuration=Class'SpeedModifierConfiguration'
    Artifact=Class'SpeedModifierArtifact'
}
