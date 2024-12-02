class FireModeWeaponModifier extends LinearUpgradeWeaponModifier;

struct FireModeEntry {
	var class<Weapon>         WeaponType;
	var class<WeaponFireMode> FireMode;
	var int                   ModeNum;
};

var Array<FireModeEntry> FireModeEntries;

var float fLastPress;

var WeaponFireMode FireMode;

var FireModeEntry NullEntry;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		FireMode;
}

////////////////////////////////////////////////////////////////////////////////

static function FireModeEntry FindFireModeEntry(
	class<Weapon> WeaponType
) {
	local int i;

	for (i = 0; i < default.FireModeEntries.length; ++i) {
		if (default.FireModeEntries[i].WeaponType == WeaponType) {
			return default.FireModeEntries[i];
		}
	}

	return default.NullEntry;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied for the specified player
///		and the specified weapon.
///	</summary>
///	<param name="Owner">
///		The player that owns the weapon.
///	</param>
///	<param name="Weapon">
///		The weapon to apply the modifier to.
///	</param>
///	<returns>
///		Returns true if this weapon modifier can be applied to the specified
///		player and weapon.
///	</returns>
static function bool CanApply(
	Actor         Owner,
	WeaponOfPower Weapon
) {
	local FireModeEntry entry;

	entry = FindFireModeEntry(Weapon.ModifiedWeapon.Class);

	if (entry.WeaponType == None) {
		Weapon.NotifyOwner(default.Class, 1);
		return false;
	}

	if (super.CanApply(Owner, Weapon) == false) {
		return false;
	}

	return true;
}

///	<summary>
///	</summary>
simulated function Apply() {
	local WeaponOfPower Weapon;
	local FireModeEntry entry;

	super.Apply();

	Weapon = GetWeapon();

	entry = FindFireModeEntry(Weapon.ModifiedWeapon.Class);

	if (entry.WeaponType == None) {
		return;
	}

	FireMode = Weapon.CreateFireMode(entry.FireMode, entry.ModeNum);

	if (FireMode != None) {
		Weapon.AddFireMode(FireMode);
	}
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
simulated function Upgrade() {
	super.Upgrade();

	if (FireMode != None) {
		FireMode.SetLevel(CurrentLevel);
	}
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Manuals changes the level of this modifier to the specified level.
///		Children can override this to do additional taste. This is called whenever
///		weapons are copied so it's important to implement this.
///	</summary>
function SetLevel(
	int iNewLevel
) {
	super.SetLevel(iNewLevel);

	if (FireMode != None) {
		FireMode.SetLevel(iNewLevel);
	}
}

////////////////////////////////////////////////////////////////////////////////

event Destroyed() {
	Remove();
	super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

simulated function Remove() {
	DestroyFireMode();

	super.Remove();
}

////////////////////////////////////////////////////////////////////////////////

simulated function DestroyFireMode() {
	local WeaponOfPower Weapon;

	Weapon = GetWeapon();

	if (FireMode != None) {
		weapon.RemoveFireMode(FireMode);
		FireMode = None;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool ClientStartFire(
	int iMode
) {
	if (GetWeapon() == None || GetWeapon().GetFireMode(0) == None) {
		return super.ClientStartFire(iMode);
	}

	if (
		(iMode == 1) &&
		(GetWeapon().GetFireMode(0).bIsFiring == true)
	) {
		if (Level.TimeSeconds - fLastPress > 0.5) {
			GetWeapon().NextPrimaryFireMode();
			fLastPress = Level.TimeSeconds;
		}

		return false;
	}

	return super.ClientStartFire(iMode);
}

////////////////////////////////////////////////////////////////////////////////

function DropFrom(
	vector     OriginalStartLocation,
	out vector StartLocation
) {
	// This is VITAL! When and RPG weapon is thrown, it's modified weapon is
	// destroyed, thus this means that the normal weapon fire mode in the
	// Weapon Of Power will be destroyed yet the weapon will still reference it.
	// The way to avoid crashing is for all firing modes to clean themselves up
	// when a weapon is thrown. (The modes will get recreated by the new weapon
	// generated).
	DestroyFireMode();
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return default.Configuration.default.ModifierName $ " cannot be upgraded!";

		case 1:
			return default.Configuration.default.ModifierName $ " cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
