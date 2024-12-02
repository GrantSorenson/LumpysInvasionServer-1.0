class WeaponModifierArtifactManager extends Info config(WeaponsOfPower);

///	<summary>
///		The rate at which to spawn power ups.
///	</summary>
var config int WeaponModifierDelay;

///	<summary>
///		The maximum number of artifacts to have in play at a single time.
///	</summary>
var config int MaxWeaponModifiers;

///	<summary>
///		The maximum number of modifiers a monster can hold.
///	</summary>
var config int MaxModifiersPerMonster;

///	<summary>
///		The maximum number of modifiers a player can hold.
///	</summary>
var config int MaxCopiesPerPlayer;

///	<summary>
///		Specifies that instead of tossing artifacts, destroy them.
///	</summary>
var config bool DestroyWhenTossed;

///	<summary>
///		Specifies that instead of tossing on death, artifacts should be destroyed.
///	</summary>
var config bool DestroyOnDeath;

///	<summary>
///		When set, a player must have a weapon of power to pick up power ups.
///	</summary>
var config bool RequireWopForPickup;

///	<summary>
///		When set, a player with denial 2 keeps modifiers after death.
///	</summary>
var config bool DenialSavesModifiers;

///	<summary>
///		When set, dropped weapons are cleared of modifiers.
///	</summary>
var config bool DroppedWeaponsLoseModifiers;

///	<summary>
///		When set, dropped modifiers will be affected by player fire.
///	</summary>
var config bool DroppedModifiersRespondToPhysics;

///	<summary>
///		The lifespan of spawned artifacts.
///	</summary>
var config float SpawnedLifeSpan;

struct WeaponModifierConfig {
	var class<WeaponModifierArtifact> Artifact;
	var int                           Chance;
};

///	<summary>
///		The list of powerups.
///	</summary>
var config array<WeaponModifierConfig> WeaponModifiers;

///	<summary>
///		The max random number to generate in order to determine which modifier
///		to spawn.
///	</summary>
var int ChanceRandomFactor;

///	<summary>
///		The list of currently held modifiers.
///	</summary>
var array<RPGArtifact> CurrentWeaponModifiers;

///	<summary>
///		Path nodes that can be used to spawn power ups.
///	</summary>
var array<PathNode> PathNodes;

var localized string PropertyGroupName;

var localized string PropertyText[11];

var localized string PropertyDesc[11];

////////////////////////////////////////////////////////////////////////////////

static function CheckConfig() {
	if (default.WeaponModifierDelay < 0) {
		default.WeaponModifierDelay = 10;
	}

	if (default.MaxWeaponModifiers < 0) {
		default.MaxWeaponModifiers = 10;
	}

	if (default.MaxModifiersPerMonster < 0) {
		default.MaxModifiersPerMonster = 2;
	}
}

////////////////////////////////////////////////////////////////////////////////

function PostBeginPlay() {
	local int             i;
	local NavigationPoint navPoint;
	local int             ModifierCount;

	local WeaponArtifactChanceConfiguration Chances;

	Super.PostBeginPlay();

	if (class'WeaponArtifactChanceConfiguration'.default.OverrideIni == true) {
		ModifierCount = WeaponModifiers.length;

		if (ModifierCount > 99) {
			ModifierCount = 99;
		}

		Chances = spawn(class'WeaponsOfPower.WeaponArtifactChanceConfiguration');

		for (i = 0; i < ModifierCount; ++i) {
			WeaponModifiers[i].Chance = Int(Chances.GetPropertyText("PowerUpChance" $ i));
		}
	}

	for (i = 0; i < WeaponModifiers.length; ++i) {
		if (
			(WeaponModifiers[i].Artifact == None) ||
			(!WeaponModifiers[i].Artifact.static.ArtifactIsAllowed(Level.Game))
		) {
			WeaponModifiers.Remove(i, 1);
			--i;
		}
	}

	ChanceRandomFactor = 0;

	for (i = 0; i < WeaponModifiers.length; ++i) {
		ChanceRandomFactor += WeaponModifiers[i].Chance;
	}

	if (
		(WeaponModifierDelay    > 0) &&
		(MaxWeaponModifiers     > 0) &&
		(WeaponModifiers.length > 0)
	) {
		navPoint = Level.NavigationPointList;

		while (navPoint != None) {
			if (
				(PathNode(navPoint)             != None) &&
				(navPoint.IsA('FlyingPathNode') == false)
			) {
				PathNodes[PathNodes.length] = PathNode(navPoint);
			}

			navPoint = navPoint.NextNavigationPoint;
		}
	} else {
		Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////

function MatchStarting() {
	SetTimer(WeaponModifierDelay, true);
}

////////////////////////////////////////////////////////////////////////////////

function RemovePlayerPickup(
	WeaponModifierArtifact modifier
) {
	local int i;

	for (i = 0; i < CurrentWeaponModifiers.length; ++i) {
		if (CurrentWeaponModifiers[i] == modifier) {
			CurrentWeaponModifiers.Remove(i, 1);
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function Timer() {
	local int i;

	// Purge any expired artifacts.
	for (i = 0; i < CurrentWeaponModifiers.length; ++i) {
		if (CurrentWeaponModifiers[i] == None) {
			CurrentWeaponModifiers.Remove(i, 1);
			--i;
		}
	}

	if (CurrentWeaponModifiers.length >= MaxWeaponModifiers) {
		return;
	}

	SpawnArtifact(GetRandomArtifact());
}

////////////////////////////////////////////////////////////////////////////////

function class<WeaponModifierArtifact> GetRandomArtifact() {
	local int iChance;
	local int iCurrent;
	local int i;

	iCurrent = 0;
	iChance  = Rand(ChanceRandomFactor);

	for (i = 0; i < WeaponModifiers.length; ++i) {
		iCurrent += WeaponModifiers[i].Chance;

 		if (iChance < iCurrent) {
			return WeaponModifiers[i].Artifact;
		}
	}

	// This should never happen.
	return None;
}

////////////////////////////////////////////////////////////////////////////////

function SpawnArtifact(
	class<WeaponModifierArtifact> artifact
) {
	local Pickup                 APickup;
	local Controller             c;
	local WeaponModifierArtifact newModifier;
	local int                    iNumMonsters;
	local int                    iPickedMonster;
	local int                    iCurrentMonster;
	local Inventory              Inv;
	local int                    iCount;
	local int                    iSanity;

	if (Level.Game.IsA('Invasion')) {
		iNumMonsters = int(Level.Game.GetPropertyText("NumMonsters"));

		if (iNumMonsters == 0) {
			return;
		}

		if (
			(MaxModifiersPerMonster != 0) &&
			(iNumMonsters * MaxModifiersPerMonster <= CurrentWeaponModifiers.length)
		) {
			return;
		}

		iSanity = 0;

		do {
			iPickedMonster = Rand(iNumMonsters);
			c              = Level.ControllerList;

			while (c != None) {
				if (
					(c.Pawn != None) &&
					(c.Pawn.IsA('Monster') == true) &&
					(c.IsA('FriendlyMonsterController') == false)
				) {
					if (iCurrentMonster >= iPickedMonster) {
						if (MaxModifiersPerMonster != 0) {
							Inv    = c.Pawn.Inventory;
							iCount = 0;

							while (Inv != None) {
								if (WeaponModifierArtifact(Inv) != None) {
									++iCount;
								}

								Inv = Inv.Inventory;
							}

							if (iCount >= MaxModifiersPerMonster) {
								++iCurrentMonster;
								c = c.NextController;
								continue;
							}
						}

						newModifier = spawn(artifact);

						if (newModifier != None) {
							newModifier.GiveTo(c.Pawn);
						}

						break;
					} else {
						++iCurrentMonster;
					}
				}

				c = c.NextController;
			}

			++iSanity;
		} until (newModifier != None || iSanity > 100)

		if (newModifier != None) {
			CurrentWeaponModifiers[CurrentWeaponModifiers.length] = newModifier;
		}
	} else {
		APickup = spawn(
			artifact.default.PickupClass,
			,
			,
			PathNodes[Rand(PathNodes.length)].Location
		);

		if (APickup == None) {
			return;
		}

		newModifier = spawn(artifact);

		if (WeaponModifierPickup(APickup) != None) {
			// Cause the power up to respond to physics.
			if (class'WeaponModifierArtifactManager'.default.DroppedModifiersRespondToPhysics == true) {
				WeaponModifierPickup(APickup).SetRespondToPhysics();
			}
		}

		APickup.RespawnEffect();
		APickup.RespawnTime = 0.0;
		APickup.AddToNavigation();

		if (WeaponModifierPickup(APickup) != None) {
			WeaponModifierPickup(APickup).InitPickupFor(newModifier, default.SpawnedLifeSpan);
		} else {
			APickup.bDropped  = true;
			APickup.Inventory = newModifier;
		}

		CurrentWeaponModifiers[CurrentWeaponModifiers.length] = newModifier;
	}
}

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	local int i;

	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "DestroyWhenTossed",                default.PropertyText[4],  1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "DestroyOnDeath",                   default.PropertyText[5],  1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "RequireWopForPickup",              default.PropertyText[6],  1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "DenialSavesModifiers",             default.PropertyText[7],  1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "DroppedWeaponsLoseModifiers",      default.PropertyText[8],  1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "DroppedModifiersRespondToPhysics", default.PropertyText[10], 1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "WeaponModifierDelay",              default.PropertyText[0],  1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "MaxWeaponModifiers",               default.PropertyText[1],  1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "MaxModifiersPerMonster",           default.PropertyText[2],  1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "MaxCopiesPerPlayer",               default.PropertyText[3],  1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "SpawnedLifeSpan",                  default.PropertyText[9],  1, 10, "Text", "3;1.0:600.0");
	PlayInfo.PopClass();

	class'WeaponArtifactChanceConfiguration'.static.FillPlayInfo(PlayInfo);

	for (i = 0; i < default.WeaponModifiers.Length; ++i) {
		if (default.WeaponModifiers[i].Artifact.default.ModifierClass.default.Configuration != None) {
			default.WeaponModifiers[i].Artifact.default.ModifierClass.default.Configuration.static.FillPlayInfo(PlayInfo);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "WeaponModifierDelay":              return default.PropertyDesc[0];
		case "MaxWeaponModifiers":               return default.PropertyDesc[1];
		case "MaxModifiersPerMonster":           return default.PropertyDesc[2];
		case "MaxCopiesPerPlayer":               return default.PropertyDesc[3];
		case "DestroyWhenTossed":                return default.PropertyDesc[4];
		case "DestroyOnDeath":                   return default.PropertyDesc[5];
		case "RequireWopForPickup":              return default.PropertyDesc[6];
		case "DenialSavesModifiers":             return default.PropertyDesc[7];
		case "DroppedWeaponsLoseModifiers":      return default.PropertyDesc[8];
		case "SpawnedLifeSpan":                  return default.PropertyDesc[9];
		case "DroppedModifiersRespondToPhysics": return default.PropertyDesc[10];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Weapon Power-Ups can only be applied to Weapons of Power!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

static function AddPrecacheStaticMeshes(
	LevelInfo level
) {
	local int i;

	for (i = 0; i < default.WeaponModifiers.Length; ++i) {
		default.WeaponModifiers[i].Artifact.static.AddPrecacheStaticMeshes(level);
	}
}

////////////////////////////////////////////////////////////////////////////////

static function AddPrecacheMaterials(
	LevelInfo level
) {
	local int i;

	for (i = 0; i < default.WeaponModifiers.Length; ++i) {
		default.WeaponModifiers[i].Artifact.static.AddPrecacheMaterials(level);
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    WeaponModifierDelay=1
    MaxWeaponModifiers=25
    MaxModifiersPerMonster=5
    MaxCopiesPerPlayer=5
    DestroyWhenTossed=True
    DestroyOnDeath=True
    RequireWopForPickup=True
    DenialSavesModifiers=True
    SpawnedLifeSpan=30.00
		//add any artifacts that want to drop from monsters here
WeaponModifiers(0)=(Artifact=Class'AwarenessModifierArtifact',Chance=30)
WeaponModifiers(1)=(Artifact=Class'DamageModifierArtifact',Chance=50)
WeaponModifiers(2)=(Artifact=Class'EnergyModifierArtifact',Chance=30)
WeaponModifiers(3)=(Artifact=Class'ForceModifierArtifact',Chance=40)
WeaponModifiers(4)=(Artifact=Class'HealingModifierArtifact',Chance=20)
WeaponModifiers(5)=(Artifact=Class'InfinityModifierArtifact',Chance=5)
WeaponModifiers(6)=(Artifact=Class'LuckyModifierArtifact',Chance=40)
WeaponModifiers(7)=(Artifact=Class'PiercingModifierArtifact',Chance=5)
WeaponModifiers(8)=(Artifact=Class'PenetratingModifierArtifact',Chance=15)
WeaponModifiers(9)=(Artifact=Class'PoisonModifierArtifact',Chance=30)
WeaponModifiers(10)=(Artifact=Class'ProtectionModifierArtifact',Chance=20)
WeaponModifiers(11)=(Artifact=Class'RetaliationModifierArtifact',Chance=30)
WeaponModifiers(12)=(Artifact=Class'RetentionModifierArtifact',Chance=20)
WeaponModifiers(13)=(Artifact=Class'ResupplyModifierArtifact',Chance=20)
WeaponModifiers(14)=(Artifact=Class'SeekerModifierArtifact',Chance=15)
WeaponModifiers(15)=(Artifact=Class'SpeedModifierArtifact',Chance=25)
WeaponModifiers(16)=(Artifact=Class'SpreadModifierArtifact',Chance=15)
WeaponModifiers(17)=(Artifact=Class'SturdyModifierArtifact',Chance=25)
WeaponModifiers(18)=(Artifact=Class'ShieldedRedeemerModifierArtifact',Chance=15)
WeaponModifiers(19)=(Artifact=Class'WeaponSummonModifierArtifact',Chance=5)
    PropertyGroupName="WOP: Artifact Manager"
    PropertyText(0)="Spawn Delay (seconds)"
    PropertyText(1)="Max Power-Up Count"
    PropertyText(2)="Max Power-Ups per Monster"
    PropertyText(3)="Max Power-Up Copies per Player"
    PropertyText(4)="Destroy instead of Toss"
    PropertyText(5)="Destroy on Player Death"
    PropertyText(6)="Require Weapon of Power for Picking up Power-Ups"
    PropertyText(7)="Denial retains Power-Ups"
    PropertyText(8)="Dropped Weapons Lose Power-Ups"
    PropertyText(9)="Spawned Power-Up Lifespan"
    PropertyText(10)="Power-Ups respond to Physics"
    PropertyDesc(0)="Delay in seconds between spawning artifacts."
    PropertyDesc(1)="The maximum number of power ups that can exist on the field (excludes player inventories)."
    PropertyDesc(2)="The maximum number of power ups a monster can hold."
    PropertyDesc(3)="Sets the maximum number of instances of a Power-Up a player can hold before they can no longer pick up any more of that type. (-1 allows unlimited, 0 disables pickups)"
    PropertyDesc(4)="When set, players can no longer toss Power-Ups. Instead the Power-Ups will be destroyed."
    PropertyDesc(5)="When set, artifacts are destroyed when a player dies."
    PropertyDesc(6)="When set, if a player does not have a weapon of power, they cannot pick up any power-ups."
    PropertyDesc(7)="When set, if a player has denial, their modifiers will be saved when they die."
    PropertyDesc(8)="When set, a dropped weapon loses all power-ups that have been applied to it."
    PropertyDesc(9)="The number of seconds power-ups that are spawned remain on the map before dissapearing."
    PropertyDesc(10)="When set, dropped power-ups will be affected by weapon fire."
    bBlockZeroExtentTraces=False
    bBlockNonZeroExtentTraces=False
}
