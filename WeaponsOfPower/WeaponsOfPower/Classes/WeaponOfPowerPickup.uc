class WeaponOfPowerPickup extends RPGWeaponPickup;

function inventory SpawnCopy(
	Pawn Other
) {
	local inventory        Copy;
	local RPGWeapon        OldWeapon;
	local class<RPGWeapon> NewWeaponClass;
	local int              i;
	local bool             bCopyModifiers;
	local RPGStatsInv      StatsInv;
	local bool             bRemoveReference;

	if (Inventory != None) {
		Inventory.Destroy();
	}

	bCopyModifiers = False;

	//if already have a RPGWeapon, use it
	if (DroppedWeapon != None) {
		OldWeapon      = DroppedWeapon;
		NewWeaponClass = OldWeapon.Class;
		bCopyModifiers = True;
	} else if (bWeaponStay) {
		// If player previously had a weapon of class InventoryType, force modifier to be the same
		StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

		if (StatsInv != None) {
			for (i = 0; i < StatsInv.OldRPGWeapons.length; ++i) {
				if (StatsInv.OldRPGWeapons[i].ModifiedClass == InventoryType) {
					OldWeapon = StatsInv.OldRPGWeapons[i].Weapon;

					if (OldWeapon == None) {
						StatsInv.OldRPGWeapons.Remove(i, 1);
						--i;
					} else {
						NewWeaponClass = OldWeapon.Class;
						StatsInv.OldRPGWeapons.Remove(i, 1);
						bRemoveReference = true;

						break;
					}
				}
			}
		}
	}

	if (NewWeaponClass == None) {
		NewWeaponClass = RPGMut.GetRandomWeaponModifier(class<Weapon>(InventoryType), Other);
	}

	Copy = spawn(NewWeaponClass, Other, , , rot(0,0,0));

	if (Copy == None) {
		return None;
	}

	if (RPGWeapon(Copy) != None) {
		RPGWeapon(Copy).Generate(OldWeapon);
		RPGWeapon(Copy).SetModifiedWeapon(
			Weapon(
				spawn(
					InventoryType,Other,,,rot(0,0,0)
				)
			),
			false
		);

		Copy.GiveTo(Other, self);

		if (
			(WeaponOfPower(Copy) != None) &&
			(WeaponOfPower(OldWeapon) != None)
		) {
			WeaponOfPower(Copy).CopyStatsFrom(WeaponOfPower(OldWeapon));

			if (bCopyModifiers == True) {
				if (class'WeaponModifierArtifactManager'.default.DroppedWeaponsLoseModifiers == false) {
					WeaponOfPower(Copy).CopyModifiersFrom(WeaponOfPower(OldWeapon));
				}
			}
		}

		if (bRemoveReference) {
			OldWeapon.RemoveReference();
		}
	}

	return Copy;
}

defaultproperties
{
}
