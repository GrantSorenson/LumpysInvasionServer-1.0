class WeaponModifier extends Actor;

///	<summary>
///		The current level of this modifier. It ranges from 0 to MaxLevel.
///	</summary>
var int CurrentLevel;

///	<summary>
///		The player that owns this modifier.
///	</summary>
var Pawn PlayerOwner;

///	<summary>
///		This is the weapon to which the weapon modifier has been attached and
///		affects.
///	</summary>
var WeaponOfPower AttachedWeapon;

///	<summary>
///		When this is the predominant modifier, its material will be displayed on
///		the weapon.
///	</summary>
var Material ModifierEffect;

var WeaponModifier NextModifier;

///	<summary>
///		The cost of this modifier.
///	</summary>
var int ModifierCost;

///	<summary>
///	</summary>
var Color ModifierColor;

var bool bLocked;

var class<WeaponModifierConfiguration> Configuration;

var class<WeaponModifierArtifact> Artifact;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		NextModifier, ModifierCost, CurrentLevel, AttachedWeapon, PlayerOwner;
}

////////////////////////////////////////////////////////////////////////////////

static function string GetName() {
	return default.Configuration.default.ModifierName;
}

////////////////////////////////////////////////////////////////////////////////

static function int GetMaxLevel() {
	return default.Configuration.default.MaxLevel;
}

////////////////////////////////////////////////////////////////////////////////

static function string GetModifierName() {
	return default.Configuration.default.ModifierName;
}

////////////////////////////////////////////////////////////////////////////////

static function bool CanUnload() {
	return default.Configuration.default.AllowUnload;
}

////////////////////////////////////////////////////////////////////////////////

function SetOwnerInformation(
	Actor         Owner,
	WeaponOfPower Weapon
) {
	PlayerOwner    = Pawn(Owner);
	Instigator     = Pawn(Owner);
	AttachedWeapon = Weapon;

	RecalculateCost();
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
	if (Weapon.GetUsedSlots() + GetRequiredSlots() > Weapon.GetMaxSlots()) {
		Weapon.NotifyOwner(class'WeaponModifier', 0);
		return false;
	}

	return true;
}

///	<summary>
///	</summary>
///	<param name="Owner">
///	</param>
///	<param name="Weapon">
///	</param>
simulated function Apply() {
	CurrentLevel = 1;

	RecalculateCost();
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied in order to upgrade the
///		weapon for the current player.
///	</summary>
function bool CanUpgrade() {
	// If the slots required of upgrade causes the weapon to exceed its
	// maximum, you can't upgrade.
	if (GetWeapon().GetUsedSlots() + GetRequiredUpgradeSlots() > GetWeapon().GetMaxSlots()) {
		GetWeapon().NotifyOwner(class'WeaponModifier', 0);
		return false;
	}

	return true;
}

///	<summary>
///	</summary>
simulated function Upgrade() {
	++CurrentLevel;

	RecalculateCost();
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Manually changes the level of this modifier to the specified level.
///		Children can override this to do additional taste. This is called whenever
///		weapons are copied so it's important to implement this.
///	</summary>
function SetLevel(
	int iNewLevel
) {
	CurrentLevel = iNewLevel;

	RecalculateCost();
}

///	<summary>
///		Sets the locked state of the power up. This controls whether the power
///		up can be removed from the weapon of not.
///	</summary>
function SetLocked(
	bool bNewLocked
) {
	bLocked = bNewLocked;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
///	<returns>
///	</returns>
function bool CanDowngrade() {
	return (bLocked == false);
}

///	<summary>
///	</summary>
simulated function Downgrade() { }

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks if a modifier can be completely removed as it is.
///	</summary>
///	<returns>
///		True if the modifier can be removed.
///	</returns>
function bool CanRemove() {
	return (bLocked == false);
}

///	<summary>
///		Removes this modifier from the weapon it is attached.
///	</summary>
simulated function Remove() { }

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Called when a power up is being unloaded from a weapon. Remove is still
///		called so this is only so that the power up may perform some additional
///		operations prior to Remove.
///	</summary>
simulated function bool OnUnload() {
	return CanUnload();
}

////////////////////////////////////////////////////////////////////////////////

function RecalculateCost() {
	if (CurrentLevel == 0) {
		ModifierCost = 0;
	} else {
		ModifierCost = GetRequiredSlots() + (CurrentLevel - 1) * GetRequiredUpgradeSlots();
	}
}

////////////////////////////////////////////////////////////////////////////////

function Pawn GetOwner() {
	return PlayerOwner;
}

////////////////////////////////////////////////////////////////////////////////

simulated function WeaponOfPower GetWeapon() {
	return AttachedWeapon;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Material GetEffect() {
	return ModifierEffect;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Color GetColor() {
	return ModifierColor;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Returns the current level of this modification.
///	</summary>
///	<returns>
///		The current modification level.
///	</returns>
function int GetCurrentLevel() {
	return CurrentLevel;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Returns the number of slots this modifier takes up.
///	</summary>
///	<returns>
///		The slots used by this modifier.
///	</returns>
simulated function int GetSlotsUsed() {
	return ModifierCost;
}

///	<summary>
///		Returns the number of slots required to used this modifier for the first
///		time.
///	</summary>
///	<returns>
///		The base number of slots this modifier requires.
///	</returns>
static function int GetRequiredSlots() {
	return 1;
}

///	<summary>
///		Returns the number of slots needed to upgrade this modifier to the next
///		level.
///	</summary>
///	<returns>
///		The number of slots required to upgrade this modifier.
///	</returns>
function int GetRequiredUpgradeSlots() {
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

function bool OnDrop() {
	return true;
}

function bool OnDenial() {
	return true;
}

function bool OnGhost() {
	return true;
}

////////////////////////////////////////////////////////////////////////////////

function string GetDebugText() {
	return "Level: (" $ CurrentLevel $ "/" $ GetMaxLevel() $ ")";
}

////////////////////////////////////////////////////////////////////////////////

function AdjustTargetDamage(
	int               OriginalDamage,
	out int           Damage,
	Actor             Victim,
	vector            HitLocation,
	vector            OriginalMomentum,
	out Vector        Momentum,
	class<DamageType> DamageType
) { }

////////////////////////////////////////////////////////////////////////////////

function AdjustPlayerDamage(
	int               OriginalDamage,
	out int           Damage,
	Pawn              InstigatedBy,
	vector            HitLocation,
	vector            OriginalMomentum,
	out Vector        Momentum,
	class<DamageType> DamageType
) { }

////////////////////////////////////////////////////////////////////////////////

simulated event WeaponTick(
	float deltaTime
) { }

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) { }

////////////////////////////////////////////////////////////////////////////////

simulated function bool PutDown() {
	return true;
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool ClientStartFire(
	int iMode
) {
	return true;
}

////////////////////////////////////////////////////////////////////////////////

simulated function bool ClientStopFire(
	int iMode
) {
	return true;
}

////////////////////////////////////////////////////////////////////////////////

function HolderDeathPrevented() { }

function HolderDied() { }

////////////////////////////////////////////////////////////////////////////////

function GiveFromDenial(
	Pawn            Other,
	optional Pickup Pickup
) { }

function GiveTo(
	Pawn            Other,
	optional Pickup Pickup
) { }

////////////////////////////////////////////////////////////////////////////////

function DropFrom(
	vector     OriginalStartLocation,
	out vector StartLocation
) { }

////////////////////////////////////////////////////////////////////////////////

simulated function bool KeyEvent(
	Interactions.EInputKey    key,
	Interactions.EInputAction action,
	float                     fDelta
) {
	return false;
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Insufficient power slots to apply power up!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CurrentLevel=1
    ModifierColor=(R=255,G=255,B=255,A=0),
    DrawType=0
    bReplicateInstigator=True
    bGameRelevant=True
}
