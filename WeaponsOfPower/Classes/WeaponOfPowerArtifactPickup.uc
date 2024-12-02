class WeaponOfPowerArtifactPickup extends RPGArtifactPickup;

var config int Uses;

var bool bDestroying;

var config float DestroyDelay;

var config float DestroyStartTime;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		Uses, bDestroying;

	reliable if (Role == ROLE_Authority)
		ClientSpawnExplosion;
}

////////////////////////////////////////////////////////////////////////////////

function int GetIntialUses() {
	return Uses;
}

////////////////////////////////////////////////////////////////////////////////

function int GetAdditionalUses(
	int iCurrentCount
) {
	return Uses;
}

////////////////////////////////////////////////////////////////////////////////

function SetRespawn() {
	if (self != None && bDeleteMe == false) {
		if (Level.Game.ShouldRespawn(self)) {
			StartSleeping();
		} else {
			Destroy();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function InitPickupFor(
	Inventory Inv,
	Float     SpawnedLifeSpan
) {
	SetPhysics(PHYS_Falling);
	GotoState('FallingPickup');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bDropped = true;
	LifeSpan = SpawnedLifeSpan;
	bIgnoreEncroachers = false;
	NetUpdateFrequency = 8;
}

////////////////////////////////////////////////////////////////////////////////

function InitDroppedPickupFor(
	Inventory Inv
) {
	SetPhysics(PHYS_Falling);

	if (bDestroying == true) {
		GotoState('DestroyingFallingPickup');
	} else {
		GotoState('FallingPickup');
	}

	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bDropped = true;
	LifeSpan = 16;
	bIgnoreEncroachers = false;
	NetUpdateFrequency = 8;
}

////////////////////////////////////////////////////////////////////////////////

event Landed(Vector HitNormal) {
	if (bDestroying == true) {
		DestroyDelay -= (Level.TimeSeconds - DestroyStartTime);
		GotoState('Destroying');
	} else {
		GotoState('Pickup', 'Begin');
	}
}

////////////////////////////////////////////////////////////////////////////////

static function WeaponOfPowerArtifact FindExistingArtifact(
	Pawn             Owner,
	class<Inventory> ArtifactClass
) {
	local Inventory             ReceiverInventory;
	local WeaponOfPowerArtifact ExistingItem;

	ReceiverInventory = Owner.Inventory;

	while (ReceiverInventory != None) {
		if (ReceiverInventory.class == ArtifactClass) {
			ExistingItem = WeaponOfPowerArtifact(ReceiverInventory);
			break;
		}

		ReceiverInventory = ReceiverInventory.Inventory;
	}

	return ExistingItem;
}

////////////////////////////////////////////////////////////////////////////////

function bool CanPickupArtifact(
	Pawn Other
) {
	if (bDestroying == true) {
		return false;
	}

	if (class'WeaponModifierArtifactManager'.default.MaxCopiesPerPlayer == 0) {
		return false;
	}

	if (super.CanPickupArtifact(Other) == false) {
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////////////////////

function Inventory SpawnCopy(
	Pawn Other
) {
	local WeaponOfPowerArtifact ExistingItem;
	local Inventory             Copy;

	if (bDestroying == true) {
		return None;
	}

	if (Other == None || class<WeaponOfPowerArtifact>(InventoryType) == None) {
		super.Touch(Other);
		return None;
	}

	ExistingItem = FindExistingArtifact(
		Other,
		InventoryType
	);

	if (ExistingItem == None) {
		Copy = super.SpawnCopy(Other);

		if (Copy != None) {
			if (WeaponOfPowerArtifact(Copy) != None) {
				WeaponOfPowerArtifact(Copy).RemainingUses = GetIntialUses();
			}
		}
	} else {
		ExistingItem.RemainingUses += GetAdditionalUses(ExistingItem.RemainingUses);

		// Player doesn't actually recieve anything.
		Copy = None;
	}

	return Copy;
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientSpawnExplosion() {
	local Actor A;

	A = spawn(class'SafeRocketExplosion',,, Location);

	if (A != None) {
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(
			sound'WeaponSounds.BExplosion3',
			,
			2.5 * TransientSoundVolume,
			,
			TransientSoundRadius
		);
	}
}

////////////////////////////////////////////////////////////////////////////////

state DestroyingFallingPickup extends Pickup {
	function CheckTouching() { }

	function bool ValidTouch(
		Actor Other
	) {
		return false;
	}

	function Timer() {
		GotoState('Exploding');
	}

	function BeginState() {
		SetTimer(DestroyDelay, false);
	}
}

////////////////////////////////////////////////////////////////////////////////

state Destroying extends Pickup {
	function bool ValidTouch(
		Actor Other
	) {
		return false;
	}

	function Timer() {
		GotoState('Exploding');
	}

	function BeginState() {
	  SetTimer(DestroyDelay, false);
	}
}

////////////////////////////////////////////////////////////////////////////////

state Exploding extends Pickup {
	function bool ValidTouch(
		Actor Other
	) {
		return false;
	}

	function BeginState() {
		bDestroying = false;

		ClientSpawnExplosion();
		SetRespawn();
	}
}

////////////////////////////////////////////////////////////////////////////////

state FallingPickup {
	function bool ValidTouch(Actor Other) {
		if (!Super.ValidTouch(Other))
			return false;

		return CanPickupArtifact(Pawn(Other));
	}
}

////////////////////////////////////////////////////////////////////////////////

State FadeOut {
	function bool ValidTouch(Actor Other) {
		if (!Super.ValidTouch(Other))
			return false;

		return CanPickupArtifact(Pawn(Other));
	}
}

////////////////////////////////////////////////////////////////////////////////

function SetDestroying() {
	if (bDestroying == False) {
		bDestroying = true;
		SetCollision(false,false,false);
		DestroyStartTime = Level.TimeSeconds;
		GotoState('Destroying');
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Uses=1
    DestroyDelay=1.00
    DrawType=8
    StaticMesh=StaticMesh'UTRPGStatics.Artifacts.MonsterCoin'
    DrawScale=0.08
}
