class WeaponOfPower extends RPGWeapon HideDropDown CacheExempt config(WeaponsOfPower);

var WeaponModifier FirstModifier;

var WeaponModifier LastModifier;

var WeaponFireMode PrimaryFireModes;

var WeaponFireMode LastPrimaryFireMode;

var WeaponFireMode CurrentPrimaryFireMode;

var WeaponFireMode AlternateFireModes;

var WeaponFireMode LastAlternateFireMode;

var WeaponFireMode CurrentAlternateFireMode;

var int BaseSlotCount;

// This is the number of used power slots of this weapon.
var int UsedSlots;

var config bool Debug;

var color WhiteColor;

var color DamagedColor;

var bool bJustGenerated;

var bool bDenial;

var WeaponOfPower CopiedWeapon;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		FirstModifier, PrimaryFireModes, AlternateFireModes, BaseSlotCount,
		CurrentPrimaryFireMode, CurrentAlternateFireMode;

	reliable if (Role == ROLE_Authority)
		ClientSetFireMode;

	reliable if (Role < ROLE_Authority)
		NextPrimaryFireMode, NextAlternateFireMode, RemoveModifiers, UnloadModifiers, ClientUnloadModifiers;
}

////////////////////////////////////////////////////////////////////////////////

static function bool AllowedFor(
	class<Weapon> Weapon,
	Pawn          Other
) {
	// Can't have these weapons without the mutator.
	if (class'WeaponsOfPower'.default.SelfMutator == None) {
		return false;
	}

	return class'WeaponsOfPower'.default.EnableWeaponPickups;
}

////////////////////////////////////////////////////////////////////////////////

function Generate(
	RPGWeapon ForcedWeapon
) {
	local int Count;
	local int iMin;
	local int iMax;

	if (ForcedWeapon != None) {
		Modifier = ForcedWeapon.Modifier;

		bJustGenerated = True;
		CopiedWeapon   = WeaponOfPower(ForcedWeapon);
	} else {
		// Check the configuration because this can change at any time and become
		// invalid due to a dumb admin.
		class'WeaponOfPowerConfiguration'.static.CheckConfig();

		iMin = class'WeaponOfPowerConfiguration'.default.WopMinModifier;
		iMax = class'WeaponOfPowerConfiguration'.default.WopMaxModifier;

		class'WeaponOfPower'.default.MinModifier = iMin;
		class'WeaponOfPower'.default.MaxModifier = class'WeaponOfPowerConfiguration'.default.WopMaxUpgradeModifier;

		do {
			Modifier = Rand(iMax + 1 - iMin) + iMin;
			++Count;
		} until (Modifier != 0 || bCanHaveZeroModifier || Count > 1000)

		BaseSlotCount = class'WeaponOfPowerConfiguration'.default.BaseSlotCount;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function Destroyed() {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;

	ResetFireModes();

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;
		CurrentModifier.Remove();
		CurrentModifier.Destroy();
		CurrentModifier = NextModifier;
	}

	Super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

function Color GetEmitterColor() {
	if (Modifier < 0) {
		return DamagedColor;
	} else {
		return WhiteColor;
	}
}

////////////////////////////////////////////////////////////////////////////////

function CopyStatsFrom(
	WeaponOfPower weapon
) {
	BaseSlotCount = weapon.BaseSlotCount;
}

////////////////////////////////////////////////////////////////////////////////

function CopyModifiersFrom(
	WeaponOfPower weapon
) {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NewModifier;

	CurrentModifier = weapon.FirstModifier;

	while (CurrentModifier != None) {
		NewModifier = AddModifier(CurrentModifier.class);
		NewModifier.Apply();

		if (NewModifier != None) {
			NewModifier.SetLevel(CurrentModifier.CurrentLevel);
		} else {
			LogDebug("Did not create new modifier: " $ CurrentModifier.class.name);
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	RecalculateUsedSlots();
	UpdateWeaponEffect();
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Returns the current number of used slot on this weapon.
///	</summary>
///	<returns>
///		The number of used slots of this weapon.
///	</returns>
simulated function int GetUsedSlots() {
	return UsedSlots;
}

///	<summary>
///		Gets the max UsedSlots available for each weapon.
///	</summary>
///	<returns>
///		The maximum UsedSlots a weapon can have.
///	</returns>
simulated function int GetMaxSlots() {
	return BaseSlotCount + Modifier;
}

////////////////////////////////////////////////////////////////////////////////

simulated function ConstructItemName() {
	if (ModifiedWeapon == None) {
		return;
	}

	if (Modifier < 0) {
		ItemName = PrefixNeg $ ModifiedWeapon.ItemName $ PostfixNeg @ Modifier;
	} else if (Modifier == 0) {
		ItemName = PrefixPos $ ModifiedWeapon.ItemName $ PostfixPos;
	} else {
		ItemName = PrefixPos $ ModifiedWeapon.ItemName $ PostfixPos @ "+" $ Modifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function color GetModifierColor(
	int iIndex
) {
	local int iCurrent, iInc;
	local Color ReturnColor;
	local WeaponModifier CurrentModifier;

	iCurrent = 0;

	CurrentModifier = FirstModifier;

	ReturnColor.A = 1;

	while (CurrentModifier != None) {
		iInc = CurrentModifier.GetSlotsUsed();

		if (iIndex >= iCurrent && iIndex < iCurrent + iInc) {
			ReturnColor = CurrentModifier.GetColor();
			ReturnColor.A = 255;
			break;
		}

		iCurrent += iInc;

		CurrentModifier = CurrentModifier.NextModifier;
	}

	return ReturnColor;
}

////////////////////////////////////////////////////////////////////////////////

function WeaponModifier FindModifier(
	class<WeaponModifier> modifierClass
) {
	local WeaponModifier CurrentModifier;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		if (CurrentModifier.Class == modifierClass) {
			return CurrentModifier;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	return None;
}

////////////////////////////////////////////////////////////////////////////////

function RecalculateUsedSlots() {
	local WeaponModifier CurrentModifier;

	UsedSlots = 0;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		UsedSlots += CurrentModifier.GetSlotsUsed();

		CurrentModifier = CurrentModifier.NextModifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

function UpdateWeaponEffect() {
	local int iMaxLevel;

	local WeaponModifier CurrentModifier;

	iMaxLevel       = 0;
	ModifierOverlay = None;
	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		if (iMaxLevel < CurrentModifier.GetCurrentLevel()) {
			iMaxLevel       = CurrentModifier.GetCurrentLevel();
			ModifierOverlay = CurrentModifier.GetEffect();
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	SetOverlayMaterial(ModifierOverlay, -1, true);
}

////////////////////////////////////////////////////////////////////////////////

function bool CanApplyModifier(
	class<WeaponModifier> modifier
) {
	local WeaponModifier foundModifier;

	foundModifier = FindModifier(modifier);

	// If this modifier has not yet been applied to this weapon, do an initial
	// check to see if this modifier can be applied at all for this player and
	// weapon.
	if (foundModifier == None) {
		return modifier.static.CanApply(
			Owner,
			self
		);
	}

	// If the modifier was found, then we're actually checking to see if we
	// can upgrade the weapon.
	return foundModifier.CanUpgrade();
}

////////////////////////////////////////////////////////////////////////////////

function bool ApplyModifier(
	class<WeaponModifier> modifier
) {
	local WeaponModifier foundModifier;

	LogDebug("Applying modifier: " $ modifier.name);

	if (CanApplyModifier(modifier) == false) {
		LogDebug("Can't apply.");
		return false;
	}

	foundModifier = FindModifier(modifier);

	if (foundModifier == None) {
		LogDebug("Apply first use.");
		foundModifier = AddModifier(modifier);

		if (foundModifier == None) {
			return false;
		}

		foundModifier.Apply();
	} else {
		LogDebug("Apply upgrade.");
		foundModifier.Upgrade();
	}

	RecalculateUsedSlots();
	UpdateWeaponEffect();

	return true;
}

////////////////////////////////////////////////////////////////////////////////

function WeaponModifier AddModifier(
	class<WeaponModifier> Modifier
) {
	local WeaponModifier newModifier;

	if (Modifier == None) {
		LogDebug("AddModifier: Called with None argument.");
		return None;
	}

	LogDebug("Adding weapon modifier " $ Modifier.name);

	newModifier = spawn(Modifier, self);

	if (newModifier == None) {
		LogDebug("Failed to create modifier.");
		return None;
	}

	newModifier.SetOwnerInformation(Owner, self);

	if (LastModifier != None) {
		LastModifier.NextModifier = newModifier;
		LastModifier              = newModifier;
		newModifier.NextModifier  = None;
	} else {
		FirstModifier = newModifier;
		LastModifier  = newModifier;
	}

	return newModifier;
}

////////////////////////////////////////////////////////////////////////////////

simulated function RemoveModifier(
	WeaponModifier Modifier
) {
	local WeaponModifier CurrentModifier;
	local bool           bRemoved;

	if (FirstModifier == Modifier) {
		FirstModifier = FirstModifier.NextModifier;
		bRemoved      = true;

		if (FirstModifier == None) {
			LastModifier = None;
		}
	} else {
		CurrentModifier = FirstModifier;

		while (CurrentModifier.NextModifier != None) {
			if (CurrentModifier.NextModifier == Modifier) {
				CurrentModifier.NextModifier = CurrentModifier.NextModifier.NextModifier;

				if (CurrentModifier.NextModifier == None) {
					LastModifier = CurrentModifier;
				}

				bRemoved = true;
				break;
			}

			CurrentModifier = CurrentModifier.NextModifier;
		}
	}

	if (bRemoved == true) {
		Modifier.Remove();
		Modifier.Destroy();

		RecalculateUsedSlots();
		UpdateWeaponEffect();
	}
}

////////////////////////////////////////////////////////////////////////////////

function RemoveModifiers() {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		if (CurrentModifier.CanRemove() == True) {
			CurrentModifier.Remove();
			CurrentModifier.Destroy();
		}

		CurrentModifier = NextModifier;
	}

	RecalculateUsedSlots();
	UpdateWeaponEffect();
}

////////////////////////////////////////////////////////////////////////////////

function UnloadModifiers() {
	local WeaponModifier         CurrentModifier;
	local WeaponModifier         NextModifier;
	local WeaponModifierArtifact ModifierArtifact;
	local Pawn                   OwnerPawn;

	OwnerPawn = Pawn(Owner);

	if (OwnerPawn == None) {
		LogDebug("Cannot unload weapons when there is no pawn owner.");
		return;
	}

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		if (CurrentModifier.OnUnload() == True) {
			if (CurrentModifier.Artifact != None) {
				ModifierArtifact = WeaponModifierArtifact(
					class'WeaponOfPowerArtifactPickup'.static.FindExistingArtifact(OwnerPawn, CurrentModifier.Artifact)
				);

				if (ModifierArtifact == None) {
					ModifierArtifact = spawn(CurrentModifier.Artifact, Owner);
					ModifierArtifact.GiveTo(OwnerPawn);
					ModifierArtifact.RemainingUses = CurrentModifier.CurrentLevel;
				} else {
					ModifierArtifact.RemainingUses += CurrentModifier.CurrentLevel;
				}
			}

			RemoveModifier(CurrentModifier);
		}

		CurrentModifier = NextModifier;
	}

	if (OwnerPawn.SelectedItem == None) {
		OwnerPawn.NextItem();
	}

	RecalculateUsedSlots();
	UpdateWeaponEffect();
}

////////////////////////////////////////////////////////////////////////////////

function ClientUnloadModifiers() {
	if (class'WeaponOfPowerConfiguration'.default.AllowUnload == True) {
		UnloadModifiers();
	} else {
		NotifyOwner(class'WeaponOfPower', 1);
	}
}

////////////////////////////////////////////////////////////////////////////////

function WeaponFireMode CreateFireMode(
	class<WeaponFireMode> FireModeClass,
	int                   ModeNum
) {
	local WeaponFireMode NewFireMode;

	NewFireMode = Spawn(FireModeClass, Owner);
	NewFireMode.Weapon     = self;
	NewFireMode.ModeNum    = ModeNum;
	NewFireMode.Instigator = Instigator;

	NewFireMode.Initialize();

	return NewFireMode;
}

////////////////////////////////////////////////////////////////////////////////

function AddFireMode(
	WeaponFireMode NewFireMode
) {
	// When adding a new weapon mode, spawn a normal fire mode for the original
	// firing mode and put that as the first in the list.
	if (NewFireMode.ModeNum == 0) {
		if (PrimaryFireModes == None) {
			PrimaryFireModes       = CreateFireMode(class'NormalFireMode', 0);
			LastPrimaryFireMode    = PrimaryFireModes;
			CurrentPrimaryFireMode = PrimaryFireModes;
		}

		LastPrimaryFireMode.NextFireMode = NewFireMode;
		LastPrimaryFireMode              = NewFireMode;

		if (CurrentPrimaryFireMode == None) {
			NextPrimaryFireMode();
		}
	} else if (NewFireMode.ModeNum == 1) {
		if (AlternateFireModes == None) {
			AlternateFireModes       = CreateFireMode(class'NormalFireMode', 1);
			LastAlternateFireMode    = AlternateFireModes;
			CurrentAlternateFireMode = AlternateFireModes;
		}

		LastAlternateFireMode.NextFireMode = NewFireMode;
		LastAlternateFireMode              = NewFireMode;

		if (CurrentAlternateFireMode == None) {
			NextAlternateFireMode();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function RemoveFireMode(
	WeaponFireMode FireMode
) {
	local WeaponFireMode Current;
	local bool           bRemoved;
	local int            ModeNum;

	// Nothing to be removed...
	if (FireMode == None) {
		return;
	}

	// We need this temp because we may destroy FireMode during this method, but
	// we'll still need to know it's mode number after that point. (IE, don't
	// remove this trying to reduce variables.)
	ModeNum = FireMode.ModeNum;

	// Determine which list of firing modes we're editing.
	if (ModeNum == 0) {
		Current = PrimaryFireModes;
	} else if (ModeNum == 1) {
		Current = AlternateFireModes;
	} else {
		return;
	}

	// If there are no firing modes, then obviously we can't remove a firing mode
	// that says its in that list from that empty list...
	if (Current == None) {
		return;
	}

	// If there are firing modes, the first one is always the weapon's normal
	// firing mode. This can never be removed. It can however be disabled. Set
	// Enabled to false to make it unavailable.
	if (Current == FireMode) {
		return;
	}

	bRemoved = false;

	while (Current.NextFireMode != None) {
		if (Current.NextFireMode == FireMode) {
			Current.NextFireMode  = Current.NextFireMode.NextFireMode;
			FireMode.NextFireMode = None;
			bRemoved = true;
			// No break here for a reason. We need to reach the end of the list
			// because we'll update the last of the respective list by finding the
			// last one.
		} else {
			Current = Current.NextFireMode;
		}
	}

	if (FireMode.ModeNum == 0) {
		LastPrimaryFireMode = Current;
	} else {
		LastAlternateFireMode = Current;
	}

	if (bRemoved == true) {
		// If the current firing mode is firing, trigger it to stop firing before
		// we remove it.
		if (FireMode.FireMode.bIsFiring == true) {
			StopFire(ModeNum);

			if (FireMode.FireMode.bFireOnRelease) {
				FireMode.FireMode.ModeDoFire();
			}
		}

		// If this is the last fire mode for the list of fire modes and it is a
		// normal fire mode, empty the list. Destroying normal fire modes will
		// restore the weapon firemodes to their original state.
		//
		// Otherwise, if this firemode was the current one, force the next firing
		// mode to be selected.
		if (ModeNum == 0) {
			if (PrimaryFireModes.NextFireMode == None) {
				PrimaryFireModes.Deinitialize();
				PrimaryFireModes.Destroy();

				PrimaryFireModes       = None;
				LastPrimaryFireMode    = None;
				CurrentPrimaryFireMode = None;
			} else if (FireMode == CurrentPrimaryFireMode) {
				NextPrimaryFireMode();
			}
		} else {
			if (AlternateFireModes.NextFireMode == None) {
				AlternateFireModes.Deinitialize();
				AlternateFireModes.Destroy();

				AlternateFireModes       = None;
				LastAlternateFireMode    = None;
				CurrentAlternateFireMode = None;
			} else if (FireMode == CurrentAlternateFireMode) {
				NextAlternateFireMode();
			}
		}

		FireMode.Deinitialize();
		FireMode.Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetFireModeHelper(
	WeaponFireMode NewFireMode
) {
	local RPGStatsInv stats;
	local bool        bRestartFiring;

	bRestartFiring = false;

	if (
		(Owner                != None) &&
		(NewFireMode          != None) &&
		(NewFireMode.FireMode != None) &&
		(ModifiedWeapon       != None)
	) {
		if (GetFireMode(NewFireMode.ModeNum).bIsFiring == true) {
			StopFire(NewFireMode.ModeNum);
			bRestartFiring = true;
		}

		NewFireMode.FireMode.Instigator = Instigator;
		NewFireMode.FireMode.Level      = Level;

		FireMode[NewFireMode.ModeNum]                = NewFireMode.FireMode;
		ModifiedWeapon.FireMode[NewFireMode.ModeNum] = NewFireMode.FireMode;

		if (Pawn(Owner) != None) {
			stats = RPGStatsInv(Pawn(Owner).FindInventoryType(class'RPGStatsInv'));

			if (stats != None) {
				stats.AdjustFireRate(ModifiedWeapon);
			}

			BringUp(None);

			if (bRestartFiring == true) {
				StartFire(NewFireMode.ModeNum);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientSetFireMode(
	WeaponFireMode NewFireMode
) {
	SetFireModeHelper(NewFireMode);
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetFireMode(
	WeaponFireMode NewFireMode
) {
	SetFireModeHelper(NewFireMode);
	ClientSetFireMode(NewFireMode);
}

////////////////////////////////////////////////////////////////////////////////

function ResetFireModes() {
	if (PrimaryFireModes != None) {
		SetFireMode(PrimaryFireModes);
	}

	if (AlternateFireModes != None) {
		SetFireMode(AlternateFireModes);
	}
}

////////////////////////////////////////////////////////////////////////////////

function NextPrimaryFireMode() {
	local WeaponFireMode NextFireMode;

	if (PrimaryFireModes == None) {
		return;
	}

	if (CurrentPrimaryFireMode == None) {
		NextFireMode = PrimaryFireModes;
	} else {
		NextFireMode = CurrentPrimaryFireMode.NextFireMode;

		if (NextFireMode == None) {
			NextFireMode = PrimaryFireModes;
		}
	}

	// We need to find the next enabled firing mode.
	while (NextFireMode.Enabled == false) {
		NextFireMode = NextFireMode.NextFireMode;

		if (NextFireMode == None) {
			NextFireMode = PrimaryFireModes;
		}

		// If this triggers, we've looped without finding any firing mode to use...
		if (NextFireMode == CurrentPrimaryFireMode) {
			NextFireMode = None;
			break;
		}
	}

	if (NextFireMode != CurrentPrimaryFireMode) {
		if (CurrentPrimaryFireMode != None) {
			CurrentPrimaryFireMode.Deactivate();
		}

		CurrentPrimaryFireMode = NextFireMode;

		if (NextFireMode != None) {
			NextFireMode.Activate();
			SetFireMode(NextFireMode);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function NextAlternateFireMode() {
	local WeaponFireMode NextFireMode;

	if (AlternateFireModes == None) {
		return;
	}

	if (CurrentAlternateFireMode == None) {
		NextFireMode = AlternateFireModes;
	} else {
		NextFireMode = CurrentAlternateFireMode.NextFireMode;

		if (NextFireMode == None) {
			NextFireMode = AlternateFireModes;
		}
	}

	// We need to find the next enabled firing mode.
	while (NextFireMode.Enabled == false) {
		NextFireMode = NextFireMode.NextFireMode;

		if (NextFireMode == None) {
			NextFireMode = AlternateFireModes;
		}

		// If this triggers, we've looped without finding any firing mode to use...
		if (NextFireMode == CurrentAlternateFireMode) {
			NextFireMode = None;
			break;
		}
	}

	if (NextFireMode != CurrentAlternateFireMode) {
		if (CurrentAlternateFireMode != None) {
			CurrentAlternateFireMode.Deactivate();
		}

		CurrentAlternateFireMode = NextFireMode;

		if (NextFireMode != None) {
			NextFireMode.Activate();
			SetFireMode(NextFireMode);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function AdjustTargetDamage(
	out int           Damage,
	Actor             Victim,
	vector            HitLocation,
	out vector        Momentum,
	class<DamageType> DamageType
) {
	local int OriginalDamage;

	OriginalDamage = Damage;

	NewAdjustTargetDamage(
		Damage,
		OriginalDamage,
		Victim,
		HitLocation,
		Momentum,
		DamageType
	);
}

////////////////////////////////////////////////////////////////////////////////

function NewAdjustTargetDamage(
	out int           Damage,
	int               OriginalDamage,
	Actor             Victim,
	vector            HitLocation,
	out vector        Momentum,
	class<DamageType> DamageType
) {
	local vector         vecOriginalMomentum;
	local WeaponModifier CurrentModifier;

	vecOriginalMomentum = Momentum;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		CurrentModifier.AdjustTargetDamage(
			OriginalDamage,
			Damage,
			Victim,
			HitLocation,
			vecOriginalMomentum,
			Momentum,
			DamageType
		);

		CurrentModifier = CurrentModifier.NextModifier;
	}

	// Purposely don't call this anymore because we needed to redirect the
	// original to this method.
	//	super.NewAdjustTargetDamage(
	//		Damage,
	//		OriginalDamage,
	//		Victim,
	//		HitLocation,
	//		Momentum,
	//		DamageType
	//	);
}

////////////////////////////////////////////////////////////////////////////////

function AdjustPlayerDamage(
	out int           Damage,
	Pawn              InstigatedBy,
	vector            HitLocation,
	out vector        Momentum,
	class<DamageType> DamageType
) {
	local int    iOriginalDamage;
	local vector vecOriginalMomentum;

	local WeaponModifier CurrentModifier;

	iOriginalDamage     = Damage;
	vecOriginalMomentum = Momentum;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		CurrentModifier.AdjustPlayerDamage(
			iOriginalDamage,
			Damage,
			InstigatedBy,
			HitLocation,
			vecOriginalMomentum,
			Momentum,
			DamageType
		);

		CurrentModifier = CurrentModifier.NextModifier;
	}

	super.AdjustPlayerDamage(
		Damage,
		InstigatedBy,
		HitLocation,
		Momentum,
		DamageType
	);
}

////////////////////////////////////////////////////////////////////////////////

simulated event WeaponTick(
	float deltaTime
) {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;

	// If this every happens we're killing ourselves.
	if (ModifiedWeapon == None) {
		Destroy();
		return;
	}

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		CurrentModifier.WeaponTick(
			deltaTime
		);

		CurrentModifier = NextModifier;
	}

	if (CurrentPrimaryFireMode != None) {
		CurrentPrimaryFireMode.ModeTick(deltaTime);
	}

	if (CurrentAlternateFireMode != None) {
		CurrentAlternateFireMode.ModeTick(deltaTime);
	}

	super.WeaponTick(deltaTime);
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;

	super.BringUp(PrevWeapon);

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		CurrentModifier.BringUp(
			PrevWeapon
		);

		CurrentModifier = NextModifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool PutDown() {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;
	local bool           bResult;

	bResult = true;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		if (CurrentModifier.PutDown() == false) {
			bResult = false;
		}

		CurrentModifier = NextModifier;
	}

	if (super.PutDown() == false) {
		bResult = false;
	}

	return bResult;
}

////////////////////////////////////////////////////////////////////////////////

simulated event ClientStartFire(
	int iMode
) {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;
	local bool           bAbortStart;

	bAbortStart = false;

	CurrentModifier = FirstModifier;

	// If this weapon currently supports multiple fire modes, check that it has
	// a current one set. If none are set, this weapon can't fire so return.
	if (iMode == 0) {
		if (
			(PrimaryFireModes != None) &&
			(CurrentPrimaryFireMode == None)
		) {
			return;
		}
	} else if (iMode == 1) {
		if (
			(AlternateFireModes != None) &&
			(CurrentAlternateFireMode == None)
		) {
			return;
		}
	} else {
		return;
	}

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		if (CurrentModifier.ClientStartFire(iMode) == false) {
			bAbortStart = true;
		}

		CurrentModifier = NextModifier;
	}

	if (bAbortStart == false) {
		super.ClientStartFire(iMode);
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated event ClientStopFire(
	int iMode
) {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;
	local bool           bAbortStop;

	bAbortStop = false;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;

		if (CurrentModifier.ClientStopFire(iMode) == false) {
			bAbortStop = true;
		}

		CurrentModifier = NextModifier;
	}

	if (bAbortStop == false) {
		super.ClientStopFire(iMode);
	}
}

////////////////////////////////////////////////////////////////////////////////

function HolderDied() {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;
	local GhostInv       GhostInv;

	GhostInv = GhostInv(Instigator.FindInventoryType(class'GhostInv'));

	// When these conditions trigger it means that ghost is taking effect at
	// this moment. In this case don't trigger the holder died on the power ups
	// because they're really not dying...
	if (
		(GhostInv != None) &&
		(GhostInv.OwnerController == None)
	) {
		super.HolderDied();
		return;
	}

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;
		CurrentModifier.HolderDied();
		CurrentModifier = NextModifier;
	}

	super.HolderDied();
}

////////////////////////////////////////////////////////////////////////////////

function HolderDeathPrevented() {
	local WeaponModifier CurrentModifier;
	local WeaponModifier NextModifier;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		NextModifier = CurrentModifier.NextModifier;
		CurrentModifier.HolderDeathPrevented();
		CurrentModifier = NextModifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

function OnDenial() {
	local WeaponModifier        CurrentModifier;
	local array<WeaponModifier> ModifiersToRemove;
	local int                   i;

	if (class'WeaponModifierArtifactManager'.default.DenialSavesModifiers == false) {
		RemoveModifiers();
		return;
	}

	// Check if the modifier allows itself to be retained on denial.
	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		if (CurrentModifier.OnDenial() == false) {
			ModifiersToRemove.Insert(0, 1);
			ModifiersToRemove[0] = CurrentModifier;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	for (i = 0; i < ModifiersToRemove.Length; ++i) {
		RemoveModifier(ModifiersToRemove[i]);
	}
}

////////////////////////////////////////////////////////////////////////////////

function OnGhost() {
	local WeaponModifier        CurrentModifier;
	local array<WeaponModifier> ModifiersToRemove;
	local int                   i;

	// Check if the modifier allows itself to be retained on denial.
	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		if (CurrentModifier.OnGhost() == false) {
			ModifiersToRemove.Insert(0, 1);
			ModifiersToRemove[0] = CurrentModifier;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	for (i = 0; i < ModifiersToRemove.Length; ++i) {
		RemoveModifier(ModifiersToRemove[i]);
	}
}

////////////////////////////////////////////////////////////////////////////////

function DenialGiveTo(
	Pawn            Other,
	optional Pickup Pickup
) {
	bDenial = True;

	GiveTo(Other, Pickup);
}

////////////////////////////////////////////////////////////////////////////////

function GiveTo(
	Pawn            Other,
	optional Pickup Pickup
) {
	local OldWeaponHolder OldWeaponHolder;
	local WeaponModifier  CurrentModifier;
	local WeaponFireMode  CurrentFireMode;
	local GhostInv        GhostInv;

	if (bJustGenerated == true) {
		bJustGenerated = false;

		if (CopiedWeapon != None) {
			CopyStatsFrom(CopiedWeapon);
		}
	}

	GhostInv = GhostInv(Other.FindInventoryType(class'GhostInv'));

	// Denial can take affect before ghost, so make sure we don't concider it
	// a denial if they were just ghosting.
	if (GhostInv == None) {
		foreach Other.DynamicActors(class'OldWeaponHolder', OldWeaponHolder) {
			if (OldWeaponHolder.Owner == Other.Controller) {
				if (
					(OldWeaponHolder.Weapon == self) &&
					(WeaponOfPower(OldWeaponHolder.Weapon) != None)
				) {
					bDenial = true;
					break;
				}
			}
		}
	}

	// Perform the on denial check which will remove any power ups that want
	// to be destroyed when denial occurs.
	if (bDenial == true) {
		OnDenial();
	}

	if (class'WeaponOfPowerConfiguration'.default.AllowDuplicateWops == true) {
		NewRpgGiveTo(Other, Pickup);
	} else {
		super.GiveTo(Other, Pickup);
	}

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		CurrentModifier.SetOwnerInformation(Other, self);

		if (bDenial == true) {
			CurrentModifier.GiveFromDenial(Other, Pickup);
		} else {
			CurrentModifier.GiveTo(Other, Pickup);
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	CurrentFireMode = PrimaryFireModes;

	while (CurrentFireMode != None) {
		if (CurrentFireMode.FireMode != None) {
			CurrentFireMode.Instigator          = Other;
			CurrentFireMode.FireMode.Instigator = Other;
			CurrentFireMode.SetOwner(Other);
		}

		CurrentFireMode = CurrentFireMode.NextFireMode;
	}

	CurrentFireMode = AlternateFireModes;

	while (CurrentFireMode != None) {
		if (CurrentFireMode.FireMode != None) {
			CurrentFireMode.Instigator          = Other;
			CurrentFireMode.FireMode.Instigator = Other;
			CurrentFireMode.SetOwner(Other);
		}

		CurrentFireMode = CurrentFireMode.NextFireMode;
	}

	bDenial = false;

	ConstructItemName();
}

////////////////////////////////////////////////////////////////////////////////

function NewRpgGiveTo(Pawn Other, optional Pickup Pickup)
{
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;
    local Inventory Inv;

    Instigator = Other;
    ModifiedWeapon.Instigator = Other;
    for (Inv = Instigator.Inventory; true; Inv = Inv.Inventory)
    {
    	if (Inv.Class == ModifiedWeapon.Class || (RPGWeapon(Inv) != None && WeaponOfPower(Inv) == None && !RPGWeapon(Inv).AllowRPGWeapon(Self)))
    	{
		W = Weapon(Inv);
		break;
    	}
    	m++;
    	if (m > 1000)
    		break;
    	if (Inv.Inventory == None) //hack to keep Inv at last item in Instigator's inventory
    		break;
    }

    if ( W == None )
    {
	//hack - manually add to Instigator's inventory because pawn won't usually allow duplicates
	Inv.Inventory = self;
	Inventory = None;
	SetOwner(Instigator);
	if (Instigator.Controller != None)
		Instigator.Controller.NotifyAddInventory(self);

	bJustSpawned = true;
        ModifiedWeapon.SetOwner(Owner);
        bPossiblySwitch = true;
        W = self;
    }
    else if ( !W.HasAmmo() )
	    bPossiblySwitch = true;

    if ( Pickup == None )
        bPossiblySwitch = true;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if ( ModifiedWeapon.FireMode[m] != None )
        {
            ModifiedWeapon.FireMode[m].Instigator = Instigator;
            W.GiveAmmo(m,WeaponPickup(Pickup),bJustSpawned);
        }
    }

	if ( (Instigator.Weapon != None) && Instigator.Weapon.IsFiring() )
		bPossiblySwitch = false;

	if ( Instigator.Weapon != W )
		W.ClientWeaponSet(bPossiblySwitch);

    if (Instigator.Controller == Level.GetLocalPlayerController()) //can only do this on listen/standalone
    {
       	if (bIdentified)
		PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'IdentifyMessage', 1,,, self);
	else if (ModifiedWeapon.PickupClass != None)
	    	PlayerController(Instigator.Controller).ReceiveLocalizedMessage(ModifiedWeapon.PickupClass.default.MessageClass, 0,,,ModifiedWeapon.PickupClass);
    }

	SetHolderStatsInv();

    if ( !bJustSpawned )
    {
        for (m = 0; m < NUM_FIRE_MODES; m++)
        {
            Ammo[m] = None;
            ModifiedWeapon.Ammo[m] = None;
        }
	Destroy();
    }
    else
    {
    	//Hack for ChaosUT: spawn ChaosWeapon's ammo and make sure it sets up its firemode for the type of chaos ammo owner has
    	if (ModifiedWeapon.IsA('ChaosWeapon'))
    	{
    		ModifiedWeapon.SetPropertyText("OldCount", "-1");
    		ModifiedWeapon.Tick(0.f);
    		if (!ModifiedWeapon.bNoAmmoInstances)
    		{
    			//add initial ammo, if we haven't already via the GiveAmmo() call above
    			if (ModifiedWeapon.FireMode[0].default.AmmoClass == None)
    			{
	    			if (ModifiedWeapon.Ammo[0] == None)
	    			{
	    				ModifiedWeapon.Ammo[0] = spawn(ModifiedWeapon.AmmoClass[0]);
	    				ModifiedWeapon.Ammo[0].GiveTo(Other);
	    			}
	    			if (WeaponPickup(Pickup) != None && WeaponPickup(Pickup).AmmoAmount[0] > 0)
					ModifiedWeapon.Ammo[0].AddAmmo(WeaponPickup(Pickup).AmmoAmount[0]);
			    	else
					ModifiedWeapon.Ammo[0].AddAmmo(ModifiedWeapon.Ammo[0].InitialAmount);
			}

	    		//Spawn empty ammo for the other types, if necessary
	    		if (!Level.Game.IsA('ChaosDuel') || int(Level.Game.GetPropertyText("WeaponOption")) != 3)
	    		{
		    		//fill our clone ammo array with a copy of the contents from the weapon's array
		    		//can you believe this actually works?!
		    		//I've written a lot of hacks... it's part of being a mod author
				//But this... wow. Just wow.
		    		SetPropertyText("ChaosAmmoTypes", ModifiedWeapon.GetPropertyText("AmmoType"));

		    		for (m = 0; m < ChaosAmmoTypes.length; m++)
		    		{
		    			Inv = Instigator.FindInventoryType(ChaosAmmoTypes[m].AmmoClass);
		    			if (Inv == None)
		    			{
		    				Inv = spawn(ChaosAmmoTypes[m].AmmoClass);
		    				Inv.GiveTo(Instigator);
		    			}
		    		}
		    	}
		}
    	}

	for (m = 0; m < NUM_FIRE_MODES; m++)
		Ammo[m] = ModifiedWeapon.Ammo[m];
    }
}

////////////////////////////////////////////////////////////////////////////////

function DropFrom(
	vector StartLocation
) {
	local Vector                OriginalStartLocation;
	local WeaponModifier        CurrentModifier;
	local array<WeaponModifier> ModifiersToRemove;
	local int                   i;

	ResetFireModes();

	OriginalStartLocation = StartLocation;
	CurrentModifier       = FirstModifier;

	while (CurrentModifier != None) {
		CurrentModifier.DropFrom(
			OriginalStartLocation,
			StartLocation
		);

		if (CurrentModifier.OnDrop() == false) {
			ModifiersToRemove.Insert(0, 1);
			ModifiersToRemove[0] = CurrentModifier;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	for (i = 0; i < ModifiersToRemove.Length; ++i) {
		RemoveModifier(ModifiersToRemove[i]);
	}

	super.DropFrom(StartLocation);
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool KeyEvent(
	Interactions.EInputKey    key,
	Interactions.EInputAction action,
	string                    strKeyBinding,
	float                     fDelta
) {
	local WeaponModifier CurrentModifier;

	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		if (CurrentModifier.KeyEvent(key, action, fDelta) == true) {
			return true;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	// Only interact with key presses.
	if (Action != IST_Press) {
		return false;
	}

	if (strKeyBinding == "NextPrimaryFireMode") {
		NextPrimaryFireMode();

		return true;
	}

	if (strKeyBinding == "NextAlternateFireMode") {
		NextAlternateFireMode();

		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

simulated function LogDebug(
	coerce string strMessage
) {
	if (Debug == false) {
		return;
	}

	class'WeaponsOfPower'.static.Notify("[" $ ModifiedWeapon.class.name $ "] " $ strMessage);
}

////////////////////////////////////////////////////////////////////////////////

simulated function RenderDebugInformation(
	Canvas canvas
) {
	local int            i;
	local WeaponModifier CurrentModifier;

	canvas.DrawColor = WhiteColor;
	canvas.FontScaleX = 1;
	canvas.FontScaleY = 1;

	canvas.SetPos(10, 60);
	canvas.DrawText(ItemName);
	canvas.SetPos(10, 80);
	canvas.DrawText("Used slots: " $ GetUsedSlots());
	canvas.SetPos(10, 100);
	canvas.DrawText("Max Slots:  " $ GetMaxSlots());

	i = 0;
	CurrentModifier = FirstModifier;

	while (CurrentModifier != None) {
		canvas.SetPos(10, 120 + (i * 20));
		canvas.DrawText("Modifier " $ i $ ": [" $ CurrentModifier.class.name $ "] " $ CurrentModifier.GetDebugText());
		++i;

		CurrentModifier = CurrentModifier.NextModifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function RenderFireModesLists(
  Canvas canvas
) {
	local WeaponFireMode Current;
	local int i;

	canvas.DrawColor = WhiteColor;
	canvas.FontScaleX = 1;
	canvas.FontScaleY = 1;

	Current = PrimaryFireModes;

	while (Current != None) {
		canvas.SetPos(10, 120 + (i * 20));

		canvas.DrawText("Primary Fire Mode: " $ Current.class.name);

		++i;

		Current = Current.NextFireMode;
	}

	Current = AlternateFireModes;

	while (Current != None) {
		canvas.SetPos(10, 120 + (i * 20));

		canvas.DrawText("Alternate Fire Mode: " $ Current.class.name);

		++i;

		Current = Current.NextFireMode;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function RenderInventoryList(
  Canvas canvas
) {
	local int       i;
	local Inventory Inv;
	local WeaponModifierArtifactManager Manager;

	Inv = Owner.Inventory;

	canvas.DrawColor = WhiteColor;
	canvas.FontScaleX = 1;
	canvas.FontScaleY = 1;

	while (Inv != None) {
		canvas.SetPos(10, 120 + (i * 20));

		if (WeaponModifierArtifact(Inv) != None) {
			canvas.DrawText("Inventory " $ i $ ": [" $ Inv.class.name $ "] Uses: " $ WeaponModifierArtifact(Inv).RemainingUses);

			++i;
		} else if (WeaponOfPower(Inv) != None) {
			canvas.DrawText("Inventory " $ i $ ": [" $ Inv.class.name $ "] Modified Weapon: " $ WeaponOfPower(Inv).ModifiedWeapon.Class.name);
			++i;
		} else {
			canvas.DrawText("Inventory " $ i $ ": [" $ Inv.class.name $ "]");
			++i;
		}

		Inv = Inv.Inventory;
	}

	foreach DynamicActors(class'WeaponModifierArtifactManager', Manager) {
		if (Manager == None) {
			break;
		}

		canvas.SetPos(800, 100);
		canvas.DrawText("Modifier Information: (" @ Manager.CurrentWeaponModifiers.length @ "/" @ Manager.MaxWeaponModifiers $ ")");

		for (i = 0; i < Manager.CurrentWeaponModifiers.length; ++i) {
			canvas.SetPos(810, 120 + (i * 20));
			if (Manager.CurrentWeaponModifiers[i] != None) {
				canvas.DrawText("Modifier: " $ i $ ": [" $ Manager.CurrentWeaponModifiers[i].class.name $ "] ");
			} else {
				canvas.DrawText("Modifier: " $ i $ ": [None] ");
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function PostRender(
	Canvas canvas
) {
	if (Debug == true) {
		RenderDebugInformation(canvas);
		//RenderInventoryList(canvas);
		//RenderFireModesLists(canvas);
	}
}

////////////////////////////////////////////////////////////////////////////////

function NotifyOwner(
	class<Actor> messageClass,
	int          iMessage
) {
	local Pawn pawnOwner;

	pawnOwner = Pawn(self.Owner);

	if (pawnOwner != None) {
		LogDebug(messageClass.static.GetLocalString(iMessage));
		pawnOwner.ReceiveLocalizedMessage(
			Class'UnrealGame.StringMessagePlus',
			iMessage,,,
			messageClass
		);
	}
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "";

		case 1:
			return "Unloading weapons is not enabled.";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    WhiteColor=(R=255,G=255,B=255,A=255),
    DamagedColor=(R=164,G=96,B=164,A=255),
    PostfixPos=" of Power"
    PrefixNeg="Damaged "
    PostfixNeg=" of Power"
    bCanHaveZeroModifier=True
    bIdentified=True
    PickupClass=Class'WeaponOfPowerPickup'
}
