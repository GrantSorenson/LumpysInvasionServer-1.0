class GhostArtifact extends WeaponOfPowerArtifact;

////////////////////////////////////////////////////////////////////////////////

function bool Apply() {
	if (Instigator == None) {
		return false;
	}

	Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',0,,,class);

	return false;
}

////////////////////////////////////////////////////////////////////////////////

function bool PreventDeath(
	Pawn              Killed,
	Controller        Killer,
	class<DamageType> damageType,
	vector HitLocation
) {
	local Inventory Inv;

	if (Killed == None) {
		return false;
	}

	// Bad monsters! No ghosting!
	if (Monster(Killed) != None) {
		return false;
	}

	RemoveOne();

	// Ability won't work if pawn is still attached to the vehicle.
	if (Killed.DrivenVehicle != None) {
		// So vehicle will properly kick pawn out.
		Killed.Health = 1;
		Killed.DrivenVehicle.KDriverLeave(true);
	}

	Inv = Killed.spawn(class'GhostArtifactInv', Killed,,, rot(0,0,0));
	Inv.GiveTo(Killed);

	return true;
}

////////////////////////////////////////////////////////////////////////////////

function bool PreventSever(
	Pawn              Killed,
	name              boneName,
	int               Damage,
	class<DamageType> DamageType
) {
	// Never sever limbs as long as the player has this artifact.
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
			return "The Ghost Artifact will automatically apply itself when you die.";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Description="This artifact will automatically activate when you die and give you a second chance. You will ghost to another part of the level and respawn."
    PickupClass=Class'GhostPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.GhostPickupIcon'
    ItemName="Ghost Artifact"
}
