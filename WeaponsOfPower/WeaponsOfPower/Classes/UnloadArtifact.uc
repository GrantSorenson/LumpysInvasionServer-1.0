class UnloadArtifact extends WeaponOfPowerArtifact;

////////////////////////////////////////////////////////////////////////////////

function bool Apply() {
	local WeaponOfPower Weapon;

	if (Instigator == None) {
		return false;
	}

	Weapon = WeaponOfPower(Instigator.Weapon);

	// Insure we have a weapon of power.
	if (Weapon == None) {
		Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',0,,,class);
		return false;
	}

	// Check if any power ups have been applied.
	if (Weapon.FirstModifier == None) {
		Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',1,,,class);
		return false;
	}

	Weapon.UnloadModifiers();

	return true;
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "The unload artifact only works on Weapons Of Power.";

		case 1:
			return "The current Weapon of Power has no power ups applied.";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Description="Utility that will allow you to unload the power ups from a Weapon of Power and return them to your inventory."
    PickupClass=Class'UnloadPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.UnloadPickupIcon'
    ItemName="Weapon Unload Artifact"
}
