class AwarenessModifier extends LinearUpgradeWeaponModifier config(WeaponsOfPower);

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
///	<param name="Owner">
///	</param>
///	<param name="Weapon">
///	</param>
simulated function Apply() {
	super.Apply();

	UpdateAwareness();
}

////////////////////////////////////////////////////////////////////////////////

function bool CanUpgrade() {
	// Max level is 2 outside invasion because the radar is free.
	if (Invasion(Level.Game) == None) {
		if (CurrentLevel >= 2) {
			GetWeapon().NotifyOwner(class, 0);
			return false;
		}
	}

	// Checks the cost requirements.
	if (super.CanUpgrade() == false) {
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Upgrade() {
	super.Upgrade();

	UpdateAwareness();
}

////////////////////////////////////////////////////////////////////////////////

function HolderDied() {
	UpdateAwareness();
}

////////////////////////////////////////////////////////////////////////////////

function bool OnDrop() {
	UpdateAwareness();

	return super.OnDrop();
}

////////////////////////////////////////////////////////////////////////////////

function GiveFromDenial(
	Pawn            Other,
	optional Pickup Pickup
) {
	UpdateAwareness();
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	UpdateAwareness();
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool PutDown() {
	UpdateAwareness();

	return super.PutDown();
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdateAwareness() {
	local WopStatsInv StatsInv;

	StatsInv = WopStatsInv(PlayerOwner.FindInventoryType(class'WopStatsInv'));

	if (StatsInv != None) {
		StatsInv.UpdateAwarenessLevel();
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.AwarenessWeaponShader'
    ModifierColor=(R=255,G=0,B=255,A=0),
    configuration=Class'AwarenessModifierConfiguration'
    Artifact=Class'AwarenessModifierArtifact'
}
