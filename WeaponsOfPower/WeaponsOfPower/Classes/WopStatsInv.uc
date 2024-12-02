class WopStatsInv extends Inventory config(WeaponsOfPower);

var WeaponsOfPower OwnerMutator;

var WeaponOfPowerEmitter Emitter;

// Used to total the speed changes applied to the player that owns this inv.
var int SpeedModifier;

// This is a scale used to shrink or grow the player. This will affect the
// player's movement.
var float PlayerSize;

// When true, the player's size is being forced to the specified value.
var bool ForcePlayerSize;

// The forced player size.
var float ForcedPlayerSize;

// This is the actual size applied. We don't used PlayerSize directly because
// PlayerSize may fall below or above the min or max values. We don't want to
// restrict PlayerSize directly because it should be adjusted relatively and
// readjusted to counter the affect.
var float AppliedPlayerSize;

// This allows us to smooth the animation of growing and shrinking so the player
// just doesn't suddenly become a giant or midget.
var float CurrentAppliedPlayerSize;

// The rate at which resizing occurs.
var float ResizeRate;

var config float GlobalResizeRate;

// Limit to how smaller a player can become.
var config float MinPlayerSize;

// Limit to how big a player can become.
var config float MaxPlayerSize;

var bool bWasFirstPerson;

// Used when the player has an awareness modifier on their weapons. It's
// maintained here so that only one copy needs to exist.
var Interaction AwarenessInteraction;

var bool bHudNeedsRestore;

var int iAwarenessReferences;

var int CurrentAwarenessLevel;

var int RpgAwarenessLevel;

var RPGStatsInv StatsInv;

var bool bIsInvasion;

////////////////////////////////////////////////////////////////////////////////

// Used by the WopRpgInteraction for item display.
var Inventory CurrentItem;
var Inventory DisplayItem;
var Inventory NextItem;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetDirty && Role == ROLE_Authority)
		Emitter, RpgAwarenessLevel, CurrentAwarenessLevel, bIsInvasion;

	reliable if (Role < ROLE_Authority)
		ServerAdjustPlayerSize, ServerSetPlayerSize, ServerUpdateAwarenessLevel;
}

////////////////////////////////////////////////////////////////////////////////

simulated function PostNetBeginPlay() {
	super.PostNetBeginPlay();

	if (Invasion(Level.Game) != None) {
		bIsInvasion = true;
	}

	UpdateAwarenessLevel();

	SetTimer(1 * Level.TimeDilation, True);
}

////////////////////////////////////////////////////////////////////////////////

simulated event Destroyed() {
	if (Emitter != None) {
		Emitter.Destroy();
	}

	super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

function GiveTo(
	Pawn            Other,
	optional Pickup Pickup
) {
	Super.GiveTo(Other, Pickup);

	RpgAwarenessLevel = GetRpgAwarenessLevel();

	if (
		(Emitter                     == None) &&
		(Other.PlayerReplicationInfo != None)
	) {
		Emitter = Controller(Other.PlayerReplicationInfo.Owner).Pawn.spawn(
			class'WeaponOfPowerEmitter',
			Controller(Other.PlayerReplicationInfo.Owner).Pawn
		);

		UpdateEmitter();
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool FindStatsInv() {
	if (StatsInv == None) {
		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
	}

	if (StatsInv == None) {
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////////////////////

function UpdateEmitter() {
	local WeaponOfPower Weapon;

	if (
		(Instigator        == None) ||
		(Instigator.Weapon == None)
	) {
		return;
	}

	Weapon = WeaponOfPower(Instigator.Weapon);

	if (Weapon == None) {
		Emitter.SetEmitterColor(class'Colors'.default.Invisible);
		return;
	}

	Emitter.SetEmitterColor(Weapon.GetEmitterColor());
}

////////////////////////////////////////////////////////////////////////////////

function OwnerEvent(name EventName) {
	if (EventName == 'ChangedWeapon') {
		UpdateEmitter();

		// Update the weapon size.
		if (
			(Instigator != None) &&
			(Instigator.Weapon.ThirdPersonActor != None)
		) {
			Instigator.Weapon.ThirdPersonActor.SetDrawScale(AppliedPlayerSize * Instigator.Weapon.ThirdPersonActor.default.DrawScale);
		}
	}

	super.OwnerEvent(EventName);
}

////////////////////////////////////////////////////////////////////////////////

function WeaponUpgraded() {
	UpdateEmitter();
}

////////////////////////////////////////////////////////////////////////////////

function int GetSpeedLevel() {
	local int         i;

	if (Instigator == None) {
		return 0;
	}

	if (FindStatsInv() == false) {
		return 0;
	}

	for (i = 0; i < StatsInv.Data.Abilities.length; ++i) {
		if (StatsInv.Data.Abilities[i] == class'AbilitySpeed') {
			return StatsInv.Data.AbilityLevels[i];
		}
	}

	return 0;
}

////////////////////////////////////////////////////////////////////////////////

function AdjustPlayerSpeed(
	int iModifier
) {
	SpeedModifier += iModifier;

	UpdateSpeed();
}

////////////////////////////////////////////////////////////////////////////////

function UpdateSpeed() {
	local int   iModifier;
	local float fSizeModifier;

	if (Instigator == None) {
		return;
	}

	iModifier = GetSpeedLevel() + SpeedModifier;

	if (iModifier >= 0) {
		Instigator.GroundSpeed = Instigator.default.GroundSpeed * (1.0 + 0.05 * float(iModifier));
		Instigator.WaterSpeed  = Instigator.default.WaterSpeed  * (1.0 + 0.05 * float(iModifier));
		Instigator.AirSpeed    = Instigator.default.AirSpeed    * (1.0 + 0.05 * float(iModifier));
		Instigator.LadderSpeed = Instigator.default.LadderSpeed * (1.0 + 0.05 * float(iModifier));
		Instigator.AccelRate   = Instigator.default.AccelRate   * (1.0 + 0.05 * float(iModifier));
		Instigator.JumpZ       = Instigator.default.JumpZ       * (1.0 + 0.05 * float(iModifier));
	} else {
		Instigator.GroundSpeed = Instigator.default.GroundSpeed / (1.0 + 0.05 * abs(iModifier));
		Instigator.WaterSpeed  = Instigator.default.WaterSpeed  / (1.0 + 0.05 * abs(iModifier));
		Instigator.AirSpeed    = Instigator.default.AirSpeed    / (1.0 + 0.05 * abs(iModifier));
		Instigator.LadderSpeed = Instigator.default.LadderSpeed / (1.0 + 0.05 * abs(iModifier));
		Instigator.AccelRate   = Instigator.default.AccelRate   / (1.0 + 0.05 * abs(iModifier));
		Instigator.JumpZ       = Instigator.default.JumpZ       / (1.0 + 0.05 * abs(iModifier));
	}

	fSizeModifier = sqrt(AppliedPlayerSize);

	// Now adjust the speed values base upon the player's size. Bigger is faster,
	// smaller is slower.
	Instigator.GroundSpeed *= fSizeModifier;
	Instigator.WaterSpeed  *= fSizeModifier;
	Instigator.AirSpeed    *= fSizeModifier;
	Instigator.LadderSpeed *= fSizeModifier;
	Instigator.AccelRate   *= fSizeModifier;
	Instigator.JumpZ       *= fSizeModifier;
}

////////////////////////////////////////////////////////////////////////////////

simulated function AdjustPlayerSize(
	float fModifier
) {
	SetPlayerSize(
		fModifier * PlayerSize
	);
}

////////////////////////////////////////////////////////////////////////////////

function ServerAdjustPlayerSize(
	float fModifier
) {
	AdjustPlayerSize(fModifier);
}

////////////////////////////////////////////////////////////////////////////////

simulated function DoSetPlayerSize(
	float fNewScale
) {
	local PlayerController PC;

	if (fNewScale == 0) {
		return;
	}

	if (Instigator == None) {
		return;
	}

	AppliedPlayerSize = fNewScale;

	if (
		Instigator.SetCollisionSize(
			Instigator.Default.CollisionRadius * AppliedPlayerSize,
			Instigator.Default.CollisionHeight * AppliedPlayerSize
		)
	) {
		if (Instigator.Controller != None) {
			PC = PlayerController(Instigator.Controller);

			if (PC != None) {
				PC.CameraDist = PC.Default.CameraDist * AppliedPlayerSize;
			}
		}

		// Unforunately, if their size is not normal we cannot allow crouching.
		// Crouching resets the collision volume so weird things will happen.
		if (AppliedPlayerSize == 1.0) {
			Instigator.bCanCrouch = True;
		} else {
			Instigator.bCanCrouch = False;
		}

		// Adjust crouching.
		Instigator.CrouchHeight = Instigator.Default.CrouchHeight * AppliedPlayerSize;
		Instigator.CrouchRadius = Instigator.Default.CrouchRadius * AppliedPlayerSize;

		Instigator.SetDrawScale(AppliedPlayerSize);

		// Adjust the mass.
		Instigator.Mass          *= Instigator.default.Mass * (AppliedPlayerSize * AppliedPlayerSize);

		// Fix the camera.
		Instigator.BaseEyeHeight  = Instigator.Default.BaseEyeHeight * AppliedPlayerSize;

		// Restrict a shrimps falling speed.
		Instigator.MaxFallSpeed   = Instigator.Default.MaxFallSpeed * AppliedPlayerSize;

		if (Instigator.Weapon.ThirdPersonActor != None) {
			Instigator.Weapon.ThirdPersonActor.SetDrawScale(AppliedPlayerSize * Instigator.Weapon.ThirdPersonActor.default.DrawScale);
		}

		Instigator.SetLocation(Instigator.Location);

		UpdateSpeed();
	}
}


////////////////////////////////////////////////////////////////////////////////

function ServerSetPlayerSize(
	float fNewScale
) {
	SetPlayerSize(fNewScale);
}

////////////////////////////////////////////////////////////////////////////////

function SetForcedPlayerSize(
	float fNewScale
) {
	// When forcing the player size, do not resize.
	ForcePlayerSize = true;

	ForcedPlayerSize = fNewScale;

	CurrentAppliedPlayerSize = AppliedPlayerSize;

	AppliedPlayerSize = ForcedPlayerSize;

	ResizeRate = (AppliedPlayerSize - CurrentAppliedPlayerSize) * GlobalResizeRate;
}

////////////////////////////////////////////////////////////////////////////////

function UnsetForcedPlayerSize() {
	ForcePlayerSize = false;

	SetPlayerSize(PlayerSize);
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetPlayerSize(
	float fNewScale
) {
	PlayerSize = fNewScale;

	// When forcing the player size, save the new size, but don't actually resize.
	if (ForcePlayerSize == true) {
		return;
	}

	CurrentAppliedPlayerSize = AppliedPlayerSize;

	AppliedPlayerSize = PlayerSize;

	if (AppliedPlayerSize < MinPlayerSize) {
		AppliedPlayerSize = MinPlayerSize;
	}

	if (AppliedPlayerSize > MaxPlayerSize) {
		AppliedPlayerSize = MaxPlayerSize;
	}

	ResizeRate = (AppliedPlayerSize - CurrentAppliedPlayerSize) * GlobalResizeRate;
}

////////////////////////////////////////////////////////////////////////////////

function UpdatePlayerSize(
	float fDeltaTime
) {
	local bool bRequiresUpdate;
	local bool bCurrentState;

	bRequiresUpdate = false;

	if (ResizeRate != 0 && CurrentAppliedPlayerSize != AppliedPlayerSize) {
		if (ResizeRate > 0) {
			if (CurrentAppliedPlayerSize < AppliedPlayerSize) {
				CurrentAppliedPlayerSize += ResizeRate * fDeltaTime;

				if (CurrentAppliedPlayerSize >= AppliedPlayerSize) {
					CurrentAppliedPlayerSize = AppliedPlayerSize;
					ResizeRate = 0;
				}

				bRequiresUpdate = true;
			}
		} else {
			if (CurrentAppliedPlayerSize > AppliedPlayerSize) {
				CurrentAppliedPlayerSize += ResizeRate * fDeltaTime;

				if (CurrentAppliedPlayerSize <= AppliedPlayerSize) {
					CurrentAppliedPlayerSize = AppliedPlayerSize;
					ResizeRate = 0;
				}

				bRequiresUpdate = true;
			}
		}
	}

	bCurrentState = Instigator.IsFirstPerson();

	if (bWasFirstPerson != bCurrentState) {
		CurrentAppliedPlayerSize = AppliedPlayerSize;
		bWasFirstPerson = bCurrentState;
		bRequiresUpdate = true;
	}

	if (bRequiresUpdate == true) {
		DoSetPlayerSize(CurrentAppliedPlayerSize);
	} else if (Instigator.bIsCrouched == false) {
		// Unfortunately we need to keep resetting this...
//		PawnOwner.SetCollisionSize(
//			PawnOwner.Default.CollisionRadius * AppliedPlayerSize,
//			PawnOwner.Default.CollisionHeight * AppliedPlayerSize
//		);
	}
}

////////////////////////////////////////////////////////////////////////////////

//exec function SetPlayerSizeNow(
//	float fNewScale
//) {
//	if (Role < ROLE_Authority) {
//		ServerSetPlayerSize(fNewScale);
//	}
//
//	SetPlayerSize(fNewScale);
//}

////////////////////////////////////////////////////////////////////////////////

simulated function GetBigger() {
	if (Role < ROLE_Authority) {
		ServerAdjustPlayerSize(1.25);
	}

	AdjustPlayerSize(1.25);
}

////////////////////////////////////////////////////////////////////////////////

simulated function GetSmaller() {
	if (Role < ROLE_Authority) {
		ServerAdjustPlayerSize(DrawScale * 0.8);
	}

	AdjustPlayerSize(0.8);
}

////////////////////////////////////////////////////////////////////////////////

function int GetRpgAwarenessLevel() {
	local int i;

	if (Instigator == None) {
		return 0;
	}

	if (FindStatsInv() == false) {
		return 0;
	}

	for (i = 0; i < statsInv.Data.Abilities.Length; ++i) {
		if (class<AbilityAwareness>(statsInv.Data.Abilities[i]) != None) {
			return statsInv.Data.AbilityLevels[i];
		}
	}

	return 0;
}

////////////////////////////////////////////////////////////////////////////////

function ServerUpdateAwarenessLevel() {
	UpdateAwarenessLevel();
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdateAwarenessLevel() {
	local WeaponOfPower     Weapon;
	local AwarenessModifier Awareness;

	if (Instigator == None) {
		return;
	}

	if (Level.NetMode == NM_CLIENT) {
		ServerUpdateAwarenessLevel();
	} else {
		CurrentAwarenessLevel = 0;

		if (Instigator.PendingWeapon != None) {
			Weapon = WeaponOfPower(Instigator.PendingWeapon);
		} else {
			Weapon = WeaponOfPower(Instigator.Weapon);
		}

		if (Weapon != None) {
			Awareness = AwarenessModifier(Weapon.FindModifier(class'AwarenessModifier'));

			if (Awareness != None) {
				CurrentAwarenessLevel = Awareness.CurrentLevel;
			}
		}

		RpgAwarenessLevel = GetRpgAwarenessLevel();

		// Add the rpg awareness level.
		CurrentAwarenessLevel += RpgAwarenessLevel;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool ShouldShowRadar() {
	local int PowerUpLevel;

	PowerUpLevel = (CurrentAwarenessLevel - RpgAwarenessLevel);

	if (
		(bIsInvasion == false) &&
		(PowerUpLevel > 0)
	) {
		return true;
	}

	if (CurrentAwarenessLevel >= 3) {
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Timer() {
	local PlayerController PC;

	// Update the awareness level. This only picks up when RPG changes the
	// players awareness ability level. The modifier will call update awareness
	// level.
	if (Level.NetMode == NM_DedicatedServer) {
		UpdateAwarenessLevel();
	} else {
		PC = Level.GetLocalPlayerController();

		if (PC != None && PC.Player != None) {
			if (class'WeaponsOfPower'.static.RemoveRpgAwarenessInteraction(PC.Player) == True) {
				SetTimer(0.0, False);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    PlayerSize=1.00
    AppliedPlayerSize=1.00
    GlobalResizeRate=1.00
    MinPlayerSize=0.01
    MaxPlayerSize=200.00
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
