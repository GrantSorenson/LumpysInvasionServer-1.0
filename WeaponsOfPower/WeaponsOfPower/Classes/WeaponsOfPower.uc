class WeaponsOfPower extends Mutator config(WeaponsOfPower);

#exec OBJ LOAD FILE=..\StaticMeshes\WeaponsOfPowerMeshes.usx
#exec OBJ LOAD FILE=..\Textures\WeaponsOfPowerTextures.utx

const Version = "1.5.1";

var MutUT2004RPG RPGMutator;

var config bool EnableWeaponPickups;

var config bool EnableHud;

var bool bHasInteraction;

var WeaponsOfPower SelfMutator;

var localized string PropertyGroupName;

var localized string PropertyText[2];

var localized string PropertyDesc[2];

var array<class<Weapon> > WeaponClasses;

var WeaponModifierArtifactManager ArtifactManager;

////////////////////////////////////////////////////////////////////////////////

var WopRpgInteraction clientWopRpgInteraction;

var WeaponInteraction clientWeaponInteraction;

var AwarenessModifierInteraction clientAwarenessInteraction;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role == ROLE_Authority)
		UpdateHudOwnerStats;
}

////////////////////////////////////////////////////////////////////////////////

static function StaticPrecache(
	LevelInfo level
) {
	level.AddPrecacheStaticMesh(StaticMesh'RepairKitPickup');
	level.AddPrecacheStaticMesh(StaticMesh'RevivePickUp');
	level.AddPrecacheStaticMesh(StaticMesh'UpgradeKitPickUp');

	level.AddPrecacheMaterial(Texture'BasePickUpEffect');
	level.AddPrecacheMaterial(Texture'LuckyPickUpEffect');
	level.AddPrecacheMaterial(Texture'RepairKitIcon');
	level.AddPrecacheMaterial(Texture'RevivePickupIcon');
	level.AddPrecacheMaterial(Texture'RevivePickupTexture');
	level.AddPrecacheMaterial(Texture'UpgradeKitIcon');
	level.AddPrecacheMaterial(Texture'WeaponsOfPowerHud');

	class'WeaponsOfPower.WeaponModifierArtifactManager'.static.AddPrecacheStaticMeshes(level);
	class'WeaponsOfPower.WeaponModifierArtifactManager'.static.AddPrecacheMaterials(level);
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdatePrecacheStaticMeshes() {
	level.AddPrecacheStaticMesh(StaticMesh'RepairKitPickup');
	level.AddPrecacheStaticMesh(StaticMesh'RevivePickUp');
	level.AddPrecacheStaticMesh(StaticMesh'UpgradeKitPickUp');

	class'WeaponsOfPower.WeaponModifierArtifactManager'.static.AddPrecacheStaticMeshes(level);
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdatePrecacheMaterials() {
	level.AddPrecacheMaterial(Texture'BasePickUpEffect');
	level.AddPrecacheMaterial(Texture'LuckyPickUpEffect');
	level.AddPrecacheMaterial(Texture'RepairKitIcon');
	level.AddPrecacheMaterial(Texture'RevivePickupIcon');
	level.AddPrecacheMaterial(Texture'RevivePickupTexture');
	level.AddPrecacheMaterial(Texture'UpgradeKitIcon');
	level.AddPrecacheMaterial(Texture'WeaponsOfPowerHud');

	class'WeaponsOfPower.WeaponModifierArtifactManager'.static.AddPrecacheMaterials(level);
}

////////////////////////////////////////////////////////////////////////////////

function PostBeginPlay() {
	local WeaponsOfPowerGameRules NewGameRules;

	class'WeaponOfPowerConfiguration'.static.CheckConfig();
	class'WeaponModifierArtifactManager'.static.CheckConfig();

	ArtifactManager = spawn(class'WeaponModifierArtifactManager');

	default.SelfMutator = self;

	NewGameRules = spawn(class'WeaponsOfPowerGameRules');
	NewGameRules.WopMutator = self;

	// Yeah.. RPG says it should be first, but we want to be uber first.
	NewGameRules.NextGameRules    = Level.Game.GameRulesModifiers;
	Level.Game.GameRulesModifiers = NewGameRules;

	super.PostBeginPlay();
}

////////////////////////////////////////////////////////////////////////////////

function ModifyPlayer(
	Pawn Other
) {
	local Inventory        Inv;
	local Inventory        LastInv;
	local WopStatsInv      StatsInv;
	local array<Inventory> InvToRemove;
	local int              i;
	local bool             bRemoved;
	local GhostInv         GhostInv;

	if (
		(Other == None) ||
		(Other.Controller == None)
	) {
		super.ModifyPlayer(Other);
		return;
	}

	StatsInv = None;

	// Search the controller inventory to see if we saved off an existing copy.
	Inv = Other.Controller.Inventory;

	while (Inv != None) {
		if (WopStatsInv(Inv) != None) {
			StatsInv = WopStatsInv(Inv);
			break;
		}

		Inv = Inv.Inventory;
	}

	if (StatsInv == None) {
		StatsInv = WopStatsInv(Other.FindInventoryType(class'WopStatsInv'));
	}

	// If we didn't find an existing copy, spawn a new one for this player,
	// otherwise just give the old one back to them.
	if (StatsInv == None) {
		StatsInv = spawn(class'WopStatsInv', Other);

		StatsInv.OwnerMutator = self;

		if (
			(Level.NetMode == NM_DedicatedServer) ||
			(Other.Controller == Level.GetLocalPlayerController())
		) {
			UpdateHudOwnerStats(statsInv);
		}

		StatsInv.GiveTo(Other);
	}

	// Notify weapons of ghosting.
	GhostInv = GhostInv(Other.FindInventoryType(class'GhostInv'));

	if (
		(GhostInv != None) &&
		(GhostInv.bDisabled == false)
	) {
		Inv = Other.Inventory;

		while (Inv != None) {
			if (WeaponOfPower(Inv) != None) {
				WeaponOfPower(Inv).OnGhost();
			}

			Inv = Inv.Inventory;
		}
	}

	// Loop through all controller inventory and any player modifier inventories
	// we'll allow them to modify the player. Also remove any of the modifiers
	// that should no longer take effect and then remove and destroy them.
	Inv = Other.Controller.Inventory;

	LastInv = None;

	while (Inv != None) {
		bRemoved = true;

		while (
			(Inv != None) &&
			(bRemoved == true)
		) {
			bRemoved = false;

			if (WeaponsOfPowerPlayerModifier(Inv) != None) {
				WeaponsOfPowerPlayerModifier(Inv).ModifyPlayer(Other);

				if (WeaponsOfPowerPlayerModifier(Inv).ShouldRemove() == True) {
					if (
						(Other.Controller.Inventory == Inv) ||
						(LastInv == None)
					) {
						Other.Controller.Inventory = Inv.Inventory;
					} else {
						LastInv.Inventory = Inv.Inventory;
					}

					InvToRemove.Insert(0, 1);
					InvToRemove[0] = Inv;
					bRemoved = true;
				}
			}

			Inv = Inv.Inventory;
		}

		LastInv = Inv;
	}

	for (i = 0; i < InvToRemove.Length; ++i) {
		InvToRemove[i].Inventory = None;
		InvToRemove[i].Destroy();
	}

	super.ModifyPlayer(Other);
}

////////////////////////////////////////////////////////////////////////////////

function class<Weapon> GetRandomWeaponClass(
	bool bAllowSupers
) {
	local class<Weapon> RandomWeapon;
	local int           iSanity;

	iSanity = 0;

	do {
		RandomWeapon = WeaponClasses[rand(WeaponClasses.Length)];
		++iSanity;
	} until (
		(
			(RandomWeapon != None) &&
			(
				(bAllowSupers == True) ||
				(class'MutUT2004RPG'.static.IsSuperWeaponAmmo(RandomWeapon.default.FireModeClass[0].default.AmmoClass) == False)
			)
		) ||
		(iSanity > 100)
	);

	// Fallback in case something goes wrong.
	if (iSanity >= 100) {
		RandomWeapon = class'XWeapons.AssaultRifle';
	}

	return RandomWeapon;
}

////////////////////////////////////////////////////////////////////////////////

function class<RPGWeapon> GetRandomWeaponModifier(
	class<Weapon> WeaponType,
	Pawn          Other
) {
	local int x, Chance;

	if (FRand() < RPGMutator.WeaponModifierChance) {
		Chance = Rand(RPGMutator.TotalModifierChance);

		for (x = 0; x < RPGMutator.WeaponModifiers.Length; ++x) {
			Chance -= RPGMutator.WeaponModifiers[x].Chance;

			if (
				(Chance < 0) &&
				(RPGMutator.WeaponModifiers[x].WeaponClass.static.AllowedFor(WeaponType, Other))
			) {
				return RPGMutator.WeaponModifiers[x].WeaponClass;
			}
		}
	}

	return class'RPGWeapon';
}

////////////////////////////////////////////////////////////////////////////////

simulated function Tick(float deltaTime) {
	foreach DynamicActors(class'MutUT2004RPG', RPGMutator) {
		break;
	}

	if (RPGMutator == None) {
		return;
	}

	if (Level.NetMode == NM_DedicatedServer || bHasInteraction) {
		disable('Tick');
	} else if (RPGMutator.bHasInteraction) {
		UpdateHud();
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdateHud() {
	local PlayerController PC;
	local WopStatsInv      statsInv;
	local float            fOldPulse;
	local Int              motdState;

	PC = Level.GetLocalPlayerController();

	if (
		(PC == None) ||
		(PC.Pawn == None)
	) {
		return;
	}

	statsInv = WopStatsInv(PC.Pawn.FindInventoryType(class'WopStatsInv'));

	if (statsInv == None) {
		return;
	}

	RemoveRpgInteraction(PC.Player);
	RemoveRpgAwarenessInteraction(PC.Player);

	clientWopRpgInteraction    = WopRpgInteraction(PC.Player.InteractionMaster.AddInteraction("WeaponsOfPower.WopRpgInteraction", PC.Player));
	clientWeaponInteraction    = WeaponInteraction(PC.Player.InteractionMaster.AddInteraction("WeaponsOfPower.WeaponInteraction", PC.Player));
	clientAwarenessInteraction = AwarenessModifierInteraction(PC.Player.InteractionMaster.AddInteraction("WeaponsOfPower.AwarenessModifierInteraction", PC.Player));

	if (PC.myHUD.IsA('HUDInvasion') == true) {
		fOldPulse = HUDInvasion(PC.myHUD).RadarPulse;
		motdState = HUDInvasion(PC.myHUD).MOTDState;

		PC.ClientSetHUD(
			class'WeaponsOfPower.AwarenessInvasionHud',
			class'Skaarjpack.ScoreboardInvasion'
		);

		if (AwarenessInvasionHud(PC.myHUD) != None) {
			AwarenessInvasionHud(PC.myHUD).RadarPulse = fOldPulse;
			AwarenessInvasionHud(PC.myHUD).MOTDState  = motdState;
		}
	}

	UpdateHudOwnerStats(statsInv);

	bHasInteraction = True;

	return;
}

////////////////////////////////////////////////////////////////////////////////

static function bool RemoveRpgInteraction(
	Player player
) {
	local int i;

	for (i = 0; i < player.LocalInteractions.Length; ++i) {
		if (player.LocalInteractions[i].IsA('RPGInteraction') == True) {
			player.InteractionMaster.RemoveInteraction(player.LocalInteractions[i]);
			return True;
		}
	}

	return False;
}

////////////////////////////////////////////////////////////////////////////////

static function bool RemoveRpgAwarenessInteraction(
	Player player
) {
	local int i;

	for (i = 0; i < player.LocalInteractions.Length; ++i) {
		if (player.LocalInteractions[i].IsA('AwarenessInteraction') == True) {
			player.InteractionMaster.RemoveInteraction(player.LocalInteractions[i]);
			return True;
		}
	}

	return False;
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdateHudOwnerStats(
	WopStatsInv newStatsInv
) {
	local PlayerController PC;

	if (Level.NetMode == NM_DedicatedServer) {
		return;
	}

	PC = Level.GetLocalPlayerController();

	if (
		(PC == None) ||
		(PC.Player == None) ||
		(clientAwarenessInteraction == None)
	) {
		return;
	}

	clientAwarenessInteraction.OwnerStats = newStatsInv;

	if (PC.myHUD.IsA('AwarenessInvasionHud') == true) {
  		AwarenessInvasionHud(PC.myHUD).OwnerStats = newStatsInv;
	}

	newStatsInv.UpdateAwarenessLevel();
}

////////////////////////////////////////////////////////////////////////////////

function string ParseChatPercVar(
	Controller who,
	string     command
) {
	if (command ~= "%i") {
		if (
			(who != None) &&
			(who.Pawn != None) &&
			(who.Pawn.SelectedItem != None)
		) {
			return who.Pawn.SelectedItem.ItemName;
		}
	}

	return NextMutator.ParseChatPercVar(who, command);
}

////////////////////////////////////////////////////////////////////////////////

function GetServerDetails(
	out GameInfo.ServerResponseLine ServerState
) {
	local int i;

	super.GetServerDetails(ServerState);

	i = ServerState.ServerInfo.length;

	ServerState.ServerInfo.length = i+1;
	ServerState.ServerInfo[i].Key = "Weapons of Power Version";
	ServerState.ServerInfo[i++].Value = Version;
}

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(PlayInfo PlayInfo) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "EnableWeaponPickups", default.PropertyText[0], 0, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "EnableHud",           default.PropertyText[1], 0, 10, "Check");

	class'WeaponOfPowerConfiguration'.static.FillPlayInfo(PlayInfo);
	class'WeaponModifierArtifactManager'.static.FillPlayInfo(PlayInfo);
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "EnableWeaponPickups": return default.PropertyDesc[0];
		case "EnableHud":           return default.PropertyDesc[1];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

static function Notify(coerce string s) {
	if (default.SelfMutator != None) {
		default.SelfMutator.InternalNotify(s);
	} else {
		Log(s);
	}
}

////////////////////////////////////////////////////////////////////////////////

static function NotifyColor(coerce string s, color c) {
	if (default.SelfMutator != None) {
		default.SelfMutator.InternalNotify(s $ ": " $ c.R $ ", " $ c.G $ ", " $ c.B $ ", " $ c.A);
	} else {
		Log(s $ ": " $ c.R $ ", " $ c.G $ ", " $ c.B $ ", " $ c.A);
	}
}

////////////////////////////////////////////////////////////////////////////////

function InternalNotify(coerce string s) {
	local string t;

	t = "[" $ Level.Minute $ ":" $ Level.Second $ "]" @ s;

	Level.Game.Broadcast(self, t, 'Say');
	Log(t);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    EnableWeaponPickups=True
    EnableHud=True
    PropertyGroupName="WOP: General"
    PropertyText(0)="Enable Weapons of Power"
    PropertyText(1)="Enable GUI"
    PropertyDesc(0)="Disable or enables whether Weapon of Power weapons can be picked up (Do not set this with magic weapon chance set to 100%)."
    PropertyDesc(1)="Shows or hides the GUI."
    WeaponClasses=
    bAddToServerPackages=True
    GroupName="WOP"
    FriendlyName="Weapons of Power"
    Description="Updates UT2004RPG with a new set of weapons that allow all of the familiar modifiers, and some new ones, to be applied as power ups, creating a plethora of weapon combinations!"
    bAlwaysRelevant=True
    RemoteRole=2
}
