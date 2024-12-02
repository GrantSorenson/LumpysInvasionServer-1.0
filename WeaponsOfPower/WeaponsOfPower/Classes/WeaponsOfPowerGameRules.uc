class WeaponsOfPowerGameRules extends GameRules;

////////////////////////////////////////////////////////////////////////////////

var WeaponsOfPower WopMutator;

////////////////////////////////////////////////////////////////////////////////

function bool PreventDeath(
	Pawn              Killed,
	Controller        Killer,
	class<DamageType> damageType,
	vector HitLocation
) {
	local bool             bAlreadyPrevented;
	local Inventory        Inv;
	local array<Inventory> InvToNotify;
	local int              i;
	local OldWeaponHolder  OldWeaponHolder;

	Inv = Killed.Inventory;

	while (Inv != None) {
		if (
			(WeaponOfPower(Inv) != None) ||
			(WeaponOfPowerArtifact(Inv) != None)
		) {
			InvToNotify.insert(0, 1);
			InvToNotify[0] = Inv;
		}

		Inv = Inv.Inventory;
	}

	foreach Killed.DynamicActors(class'OldWeaponHolder', OldWeaponHolder) {
		if (WeaponOfPower(OldWeaponHolder.Weapon) != None) {
			InvToNotify.insert(0, 1);
			InvToNotify[0] = Inv;
		}
	}

	bAlreadyPrevented = Super.PreventDeath(Killed, Killer, damageType, HitLocation);

	// Allow artifacts the chance to prevent death.
	if (bAlreadyPrevented == false) {
		for (i = 0; i < InvToNotify.Length; ++i) {
			if (WeaponOfPowerArtifact(InvToNotify[i]) != None) {
				bAlreadyPrevented = WeaponOfPowerArtifact(InvToNotify[i]).PreventDeath(Killed, Killer, damageType, HitLocation);

				if (bAlreadyPrevented == true) {
					break;
				}
			}
		}
	}

	if (bAlreadyPrevented == false) {
		for (i = 0; i < InvToNotify.Length; ++i) {
			if (WeaponOfPower(InvToNotify[i]) != None) {
				WeaponOfPower(InvToNotify[i]).HolderDied();
			} else if (WeaponOfPowerArtifact(InvToNotify[i]) != None) {
				WeaponOfPowerArtifact(InvToNotify[i]).HolderDied();
			}
		}
	} else {
		for (i = 0; i < InvToNotify.Length; ++i) {
			if (WeaponOfPower(InvToNotify[i]) != None) {
				WeaponOfPower(InvToNotify[i]).HolderDeathPrevented();
			} else if (WeaponOfPowerArtifact(InvToNotify[i]) != None) {
				WeaponOfPowerArtifact(InvToNotify[i]).HolderDeathPrevented();
			}
		}
	}

	return bAlreadyPrevented;
}

////////////////////////////////////////////////////////////////////////////////

function bool PreventSever(
	Pawn              Killed,
	name              boneName,
	int               Damage,
	class<DamageType> DamageType
) {
	local Inventory Inv;

	Inv = Killed.Inventory;

	while (Inv != None) {
		if (WeaponOfPowerArtifact(Inv) != None) {
			if (WeaponOfPowerArtifact(Inv).PreventSever(Killed, boneName, Damage, DamageType) == True) {
				return True;
			}
		}

		Inv = Inv.Inventory;
	}

	return super.PreventSever(Killed, boneName, Damage, DamageType);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
