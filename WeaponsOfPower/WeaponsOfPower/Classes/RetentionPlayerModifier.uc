class RetentionPlayerModifier extends WeaponsOfPowerPlayerModifier;

var WeaponOfPower Weapon;

var int AmmoAmounts[2];

////////////////////////////////////////////////////////////////////////////////

function Destroyed() {
	if (Weapon != None) {
		Weapon.Destroy();
	}

	Super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

function ModifyPlayer(
	Pawn Other
) {
	if (Other.Role != ROLE_Authority) {
		return;
	}

	if (Weapon == None) {
		return;
	}

	Weapon.DenialGiveTo(Other, None);

	if (Weapon == None) {
		return;
	}

	Weapon.AddAmmo(AmmoAmounts[0] - Weapon.AmmoAmount(0), 0);
	Weapon.AddAmmo(AmmoAmounts[1] - Weapon.AmmoAmount(1), 1);
	Weapon = None;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    RemoteRole=0
}
