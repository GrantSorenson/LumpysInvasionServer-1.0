class RocketSeekerFireMode extends WeaponFireMode;

var float TargetCheckTime;

var float SeekerTargetingTime;

var() float SeekRange;

var() float LockAim;

var int MaxTargets;

var int AmmoCost;

var bool bTargeting;

// The array of targets that have been locked onto by this firing mode.
var array<Actor> Targets;

var float SavedSeekCheckTime;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		bTargeting;

	reliable if (Role == ROLE_Authority)
		ClientClearTargets, ClientAddTarget, ClientRemoveTarget;
}

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = CreateFireMode(class'RocketSeekerFire');

	SetMaxTargets(class'SeekerModifierConfiguration'.default.MaxSeekerTargets);
	SetAmmoCost(class'SeekerModifierConfiguration'.default.SeekerAmmoCost);

	RocketSeekerFire(FireMode).FireModeOwner = self;

	super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

function Deinitialize() {
	// Explicitly empty the back reference to us.
	RocketSeekerFire(FireMode).FireModeOwner = None;

	super.Deinitialize();
}

////////////////////////////////////////////////////////////////////////////////

function Activate() {
	EndTargetting();

	SavedSeekCheckTime = RocketLauncher(Weapon.ModifiedWeapon).SeekCheckTime;

	RocketLauncher(Weapon.ModifiedWeapon).SeekCheckTime = 999999999.0;
	RocketLauncher(Weapon.ModifiedWeapon).bReplicateAnimations = true;
}

////////////////////////////////////////////////////////////////////////////////

function Deactivate() {
	RocketLauncher(Weapon.ModifiedWeapon).SeekCheckTime = SavedSeekCheckTime;
}

////////////////////////////////////////////////////////////////////////////////

function SetMaxTargets(
	int NewMaxTargets
) {
	MaxTargets = NewMaxTargets;
}

////////////////////////////////////////////////////////////////////////////////

function SetAmmoCost(
	int NewAmmoCost
) {
	AmmoCost = NewAmmoCost;

	RocketSeekerFire(FireMode).SeekerAmmoPerFire = NewAmmoCost;
}

////////////////////////////////////////////////////////////////////////////////

function BeginTargetting() {
	local RPGStatsInv stats;

	ClearTargets();

	if (
		(FireMode != None) &&
		(FireMode.Instigator != None)
	) {
		stats = RPGStatsInv(FireMode.Instigator.FindInventoryType(class'RPGStatsInv'));

		if (stats != None) {
			SeekerTargetingTime = 1.5 - (stats.Data.WeaponSpeed / 100);
		}
	}

	if (SeekerTargetingTime < 0.5) {
		SeekerTargetingTime = 0.5;
	}

	bTargeting      = true;
	TargetCheckTime = Level.TimeSeconds + SeekerTargetingTime;
}

////////////////////////////////////////////////////////////////////////////////

function EndTargetting() {
	ClearTargets();
	bTargeting = false;
}

////////////////////////////////////////////////////////////////////////////////

function ClearTargets() {
	Targets.Remove(0, Targets.Length);
	ClientClearTargets();
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientClearTargets() {
	Targets.Remove(0, Targets.Length);
}

////////////////////////////////////////////////////////////////////////////////

function AddTarget(
	Pawn Other
) {
	Targets.Insert(Targets.Length, 1);
	Targets[Targets.Length - 1] = Other;

	if (Level.NetMode == NM_DedicatedServer) {
		ClientAddTarget(Other);
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientAddTarget(
	Pawn Other
) {
	Targets.Insert(Targets.Length, 1);
	Targets[Targets.Length - 1] = Other;
}

////////////////////////////////////////////////////////////////////////////////

function RemoveTarget(
	int i
) {
	Targets.Remove(i, 1);
	ClientRemoveTarget(i);
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientRemoveTarget(
	int i
) {
	Targets.Remove(i, 1);
}

////////////////////////////////////////////////////////////////////////////////

function ModeTick(
	float fDeltaTime
) {
	local Pawn    Other;
	local Vector  StartTrace;
	local Rotator Aim;
	local float   BestDist, BestAim;

	// Prevent normal rocket seeker from activating.
	if (
		(Weapon != None) &&
		(Weapon.ModifiedWeapon != None)
	) {
		RocketLauncher(Weapon.ModifiedWeapon).SeekCheckTime = Level.TimeSeconds + 5;
	}

	if (
		(bTargeting == true) &&
		(Targets.Length < MaxTargets) &&
		(TargetCheckTime < Level.TimeSeconds)
	) {
		StartTrace = Instigator.Location + Instigator.EyePosition();
		Aim = Instigator.GetViewRotation();

		BestAim = LockAim;

		Other = Instigator.Controller.PickTarget(
			BestAim,
			BestDist,
			Vector(Aim),
			StartTrace,
			SeekRange
		);

		if (CanLockOnTo(Other) == true) {
			AddTarget(Other);

			PlayerController(Instigator.Controller).ClientPlaySound(Sound'WeaponSounds.LockOn');
			//RocketLauncher(Weapon.ModifiedWeapon).PlayLoad(false);

			if (PlayerController(Other.Controller) != None) {
				PlayerController(Other.Controller).ClientPlaySound(Sound'WeaponSounds.BaseGunTech.BSeekLost1');

				PlayerController(Other.Controller).ReceiveLocalizedMessage(
					class'WeaponsOfPower.SeekerLockedOnMessage',
					0,
					Instigator.PlayerReplicationInfo
				);
			}

			TargetCheckTime = Level.TimeSeconds + SeekerTargetingTime;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool CanLockOnTo(
	Actor Other
) {
	local Pawn PawnOther;
	local int  i;

	PawnOther = Pawn(Other);

	if (
		(PawnOther == None) ||
		(PawnOther == Instigator) ||
		(PawnOther.bProjTarget == false)
	) {
		return false;
	}

	// Remove any enemies that might have been destroyed.
	i = 0;

	while (i < Targets.Length) {
		if (Targets[i] == None) {
			RemoveTarget(i);
		} else {
			++i;
		}
	}

	// Verify there's enough ammo to lock onto another target.
	if (Weapon.AmmoAmount(ModeNum) < (Targets.length + 1) * AmmoCost) {
		return false;
	}

	for (i = 0; i < Targets.Length; ++i) {
		if (Targets[i] == Other) {
			return false;
		}
	}

	if (Level.Game.bTeamGame == false) {
		return true;
	}

	if (
		(Instigator.Controller != None) &&
		(Instigator.Controller.SameTeamAs(PawnOther.Controller) == true)
	) {
		return false;
	}

	return (
		(PawnOther.PlayerReplicationInfo == None) ||
		(PawnOther.PlayerReplicationInfo.Team != Instigator.PlayerReplicationInfo.Team)
	);
}

////////////////////////////////////////////////////////////////////////////////

simulated function RenderOverlays(
	Canvas canvas
) {
	local vector  ScreenPos;
	local int     i;
	local vector  CameraLocation;
	local rotator CameraRotation;
	local float   fDistance;

	if (bTargeting == false) {
		return;
	}

	canvas.Style = 1;
	canvas.DrawColor = class'HudCDeathmatchHelper'.static.GetHudTeamColor(
		Instigator
	);

	for (i = 0; i < Targets.length; ++i) {
		if (Targets[i] == None) {
			continue;
		}

		canvas.GetCameraLocation(CameraLocation, CameraRotation);

		if (Normal(Targets[i].Location - CameraLocation) dot vector(CameraRotation) < 0) {
			continue;
		}

		ScreenPos = canvas.WorldToScreen(Targets[i].Location);

		fDistance = 1000.0 / vsize(Targets[i].Location - CameraLocation);

		if (ScreenPos.Z > 0) {
			canvas.SetPos(ScreenPos.X - 36 * fDistance, ScreenPos.Y - 36 * fDistance);
			canvas.DrawTile(
				Shader'WeaponsOfPowerTextures.HUD.SeekerTarget',
				72 * fDistance,
				72 * fDistance,
				28,
				28,
				72,
				72
			);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SeekerTargetingTime=1.50
    SeekRange=2000.00
    MaxTargets=5
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=222.00,Height=0.00),
}
