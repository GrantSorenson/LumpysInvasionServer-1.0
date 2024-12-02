class WeaponSummonPlayerModifier extends WeaponsOfPowerPlayerModifier;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role == ROLE_Authority)
		ClientNotifySummon;
}

////////////////////////////////////////////////////////////////////////////////

var int CurrentLevel;

var int iCurrentSpawn;

var config int RequiredSpawns;

////////////////////////////////////////////////////////////////////////////////

function ModifyPlayer(
	Pawn Other
) {
	local bool   bAllowSupers;
	local bool   bMaxOutAmmo;
	local Weapon weapon;

	++iCurrentSpawn;

	if (iCurrentSpawn < RequiredSpawns) {
		return;
	}

	if (CurrentLevel >= 2) {
		bAllowSupers = true;
		bMaxOutAmmo  = true;
	} else {
		bAllowSupers = false;
		bMaxOutAmmo  = false;
	}

	weapon = GiveRandomWeapon(Other, bAllowSupers, bMaxOutAmmo);

	if (
		(weapon != None) &&
		(PlayerController(Other.Controller) != None)
	) {
		ClientNotifySummon(
			PlayerController(Other.Controller),
			weapon.ItemName
		);
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientNotifySummon(
	PlayerController who,
	String           weaponName
) {
	// Announce the new weapon to the person who summoned it.
	class'WeaponSummonMessage'.default.WeaponName = weaponName;
	who.ReceiveLocalizedMessage(class'WeaponSummonMessage', 0);
}

////////////////////////////////////////////////////////////////////////////////

function bool ShouldRemove() {
	return (iCurrentSpawn >= RequiredSpawns);
}

////////////////////////////////////////////////////////////////////////////////

static function Weapon GiveRandomWeapon(
	Pawn Other,
	bool bAllowSupers,
	bool bMaxOutAmmo
) {
	local class<Weapon>    WeaponClass;
	local class<RPGWeapon> RPGWeaponClass;
	local RPGWeapon        MagicWeapon;
	local int              iSanity;

	if (Other == None) {
		return None;
	}

	WeaponClass    = class'WeaponsOfPower'.default.SelfMutator.GetRandomWeaponClass(bAllowSupers);
	RPGWeaponClass = class'WeaponsOfPower'.default.SelfMutator.GetRandomWeaponModifier(WeaponClass, Other);

	MagicWeapon = Other.spawn(RPGWeaponClass, Other,,, rot(0,0,0));

	if (MagicWeapon == None) {
		return None;
	}

	do {
		MagicWeapon.Generate(None);
		++iSanity;
	} until (
		(iSanity > 100) ||
		(MagicWeapon.Modifier >= 0)
	);

	MagicWeapon.SetModifiedWeapon(Other.spawn(WeaponClass, Other,,, rot(0,0,0)), true);

	if (MagicWeapon == None) {
		return None;
	}

	MagicWeapon.GiveTo(Other);
	MagicWeapon.PickupFunction(Other);

	if (bMaxOutAmmo == true) {
		MagicWeapon.MaxOutAmmo();
	}

	return MagicWeapon;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    RequiredSpawns=1
}
