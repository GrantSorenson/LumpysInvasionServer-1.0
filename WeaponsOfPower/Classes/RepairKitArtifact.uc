class RepairKitArtifact extends WeaponOfPowerArtifact;

var config bool OnlyApplyToWops;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role == ROLE_Authority)
		ClientUpdateWeapon;
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientUpdateWeapon(
	int iNewModifier
) {
	local RPGWeapon Weapon;
	local HudBase   Hud;

	if (Instigator == None) {
		return;
	}

	Weapon = RPGWeapon(Instigator.Weapon);

	if (Weapon != None) {
		Weapon.Modifier = iNewModifier;
		Weapon.ConstructItemName();
	}

	// Reannounce the weapon to the player now that it has been upgraded.
	if (
		(Instigator != None) &&
		(Level.GetLocalPlayerController() == Instigator.Controller)
	) {
		Hud = HudBase(Level.GetLocalPlayerController().myHUD);

		if (Hud != None) {
			Hud.LastWeaponName  = Weapon.GetHumanReadableName();
			Hud.WeaponDrawTimer = Level.TimeSeconds + 1.5;
			Hud.WeaponDrawColor = Weapon.HudColor;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool Apply() {
	local RPGWeapon   Weapon;
	local WopStatsInv StatsInv;

	if (Instigator == None) {
		return false;
	}

	Weapon = RPGWeapon(Instigator.Weapon);

	// Check if this can only be applied to Weapons of Power.
	if (class'RepairKitArtifact'.default.OnlyApplyToWops == true) {
		if (WeaponOfPower(Weapon) == None) {
			Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',0,,,class);
			return false;
		}
	}

	// Check to make sure the weapon we're applying to is at least an RPGWeapon.
	if (Weapon == None) {
		Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',1,,,class);
		return false;
	}

	// Insure that the modifier on the weapon is less than 0.
	if (Weapon.Modifier >= 0) {
		Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',2,,,class);
		return false;
	}

	// Increase the modifier to make it less bad. Only up to 0. We do not upgrade
	// weapons with this artifact.
	Weapon.Modifier = Weapon.Modifier + 1;

	// Insure that we don't end up with a zero modifier on a weapon that does
	// not allow zero modifiers.
	if (
		(Weapon.bCanHaveZeroModifier == false) &&
		(Weapon.Modifier             == 0)
	) {
		Weapon.Modifier = Weapon.Modifier + 1;
	}

	Weapon.ConstructItemName();

	ClientUpdateWeapon(Weapon.Modifier);

	// For weapons of power, we need to notify about the change in the weapoon.
	if (WeaponOfPower(Weapon) != None) {
		StatsInv = WopStatsInv(Instigator.FindInventoryType(class'WopStatsInv'));

		if (StatsInv != None) {
			StatsInv.WeaponUpgraded();
		}
	}

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
			return "The repair kit can only be used to repair Weapons Of Power.";

		case 1:
			return "The repair kit can only be used to repair RPG Weapons.";

		case 2:
			return "The repair kit not be used to upgrade weapons.";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Description="Utility that will repair negative weapons one unit at a time.||This can be applied multiple times to turn a negative weapon into a positive weapon but cannot be used to upgrade a weapon."
    PickupClass=Class'RepairKitPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.RepairKitIcon'
    ItemName="Weapon Repair Kit"
}