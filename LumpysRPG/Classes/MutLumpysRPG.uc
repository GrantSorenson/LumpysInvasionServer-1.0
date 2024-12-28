Class MutLumpysRPG extends Mutator config(LumpyRPG);

#EXEC OBJ LOAD FILE=RBTexturesINV.utx
#EXEC OBJ LOAD FILE=LumpyMeshes.usx


const LUMPYRPG_VERSION = 1.0;

var config array<name> SuperAmmoClassNames; // names of ammo classes that belong to superweapons (WARNING: subclasses MUST be listed seperately!)
struct XPBreakPoint
{
	var int Level;
	var int XPRequired;
};
var config array<XPBreakPoint> XPBreakPoints;
var config array<class<RPGAbility> > Abilities; //List of Abilities available to players
var config array<class<RPGAbility> > RemovedAbilities; //These Abilities failed an AbilityIsAllowed() check so try to re-add them next game

var config int NoobBonusXP;
var config int StartingLevel;//starting level - cannot be less than 1
var config int PointsPerLevel; //stat points per levelup
var config int SaveDuringGameInterval;//periodically save during game - to avoid losing data from game crash or server kill
var config int MaxLevelupEffectStacking; //maximum number of levelup effects that can be spawned if player gains multiple levels at once
var config int EXPForWin; //EXP for winning the match (given to each member of team in team games)
var config int StatCaps[6]; //by popular demand :(
var int TotalModifierChance; //precalculated total Chance of all WeaponModifiers
var int BotSpendAmount; //bots that are buying stats spend points in increments of this amount
var config int HighestLevelPlayerLevel;

var config float WeaponModifierChance; //chance any given pickup results in a weapon modifier (0 to 1)
var config float InvasionAutoAdjustFactor; //affects how dramatically monsters increase in level for each level of the lowest level player
var config float LevelDiffExpGainDiv; //divisor to extra experience from defeating someone of higher level (a value of 1 results in level difference squared EXP)

var config bool bMagicalStartingWeapons; //weapons given at start can have magical properties (same probability as picked up weapons)
var config bool bAutoAdjustInvasionLevel; //auto adjust invasion monsters' level based on lowest level player
var bool bHasInteraction;
var bool bJustSaved;
var config bool bNoUnidentified; //no unidentified items
var config bool bReset; //delete all player data on next startup
//var config bool bUseOfficialRedirect; //redirect clients to a special official redirect server instead of the server's usual redirect
var config bool bAllowMagicSuperWeaponReplenish; //allow RPGWeapon::FillToInitialAmmo() on superweapons
var config bool bFakeBotLevels; //if true, bots' data isn't saved and they're simply given a level near that of the players in the game

var localized string PropsDisplayText[16];
var localized string PropsDescText[16];
var localized string PropsExtras;
var config string HighestLevelPlayerName; //Highest level player ever to display in server query for all to see :)

var() array<string> DefaultWeapons;

//A modifier a weapon might be given
struct WeaponModifier
{
	var class<RPGWeapon> WeaponClass;
	var int Chance; //chance this modifier will be used, relative to all others in use
};
var config array<WeaponModifier> WeaponModifiers;

var transient RPGPlayerDataObject CurrentLowestLevelPlayer; //Data of lowest level player currently playing (for auto-adjusting monsters, etc)
var transient array<RPGPlayerDataObject> OldPlayers; //players who were playing and then left the server - used when playing Invasion in Ironman mode
//var transient string LastOverrideDownloadIP; //last IP sent to OverrideDownload() to make sure we don't override the REAL redirect for non-UT2004RPG files
var config array< class<Monster> > ConfigMonsterList; // configurable monster list override for summoning abilities
var array< class<Monster> > MonsterList; //monsters available in the current game; if ConfigMonsterList is empty, automatically filled
var array<VampireMarker> VampireMarkers;

//Drone Stuff
var config int ProjDamage;
var config int HealPerSec;
var config int ShotDelay;
var config int TargetDelay;
var config bool bPickup;
var config int spawnProb;

var int MaxDrones;
var array<LumpyDrone> DroneList;

/*
UTILITY-GetVersion
*/
static final function int GetVersion()
{
  return LUMPYRPG_VERSION;
}

/*
UTILITY-Get RPG mutator
*/
static final function MutLumpysRPG GetRPGMutator(GameInfo G)
{
  local Mutator M;
  local MutLumpysRPG RPGMut;

  for (M = G.BaseMutator; M != None && RPGMut != None; M=M.NextMutator)
  {
    RPGMut = MutLumpysRPG(M);
  }
  return RPGMut;
}

//returns true if the specified ammo belongs to a weapon that we consider a superweapon
static final function bool IsSuperWeaponAmmo(class<Ammunition> AmmoClass)
{
	local int i;

	if (AmmoClass.default.MaxAmmo < 5)
	{
		return true;
	}
	else
	{
		for (i = 0; i < default.SuperAmmoClassNames.length; i++)
		{
			if (AmmoClass.Name == default.SuperAmmoClassNames[i])
			{
				return true;
			}
		}
	}

	return false;
}

function PostBeginPlay()
{
	local RPGRules G;
	local int x;
	local Pickup P;
	local RPGPlayerDataObject DataObject;
	local array<string> PlayerNames;

	//class'LumpysArtifactManager'.static.UpdateArtifactList();

	G = spawn(class'RPGRules');
	G.RPGMut = self;
	G.PointsPerLevel = PointsPerLevel;
	G.LevelDiffExpGainDiv = LevelDiffExpGainDiv;
	//RPGRules needs to be first in the list for compatibility with some other mutators (like UDamage Reward)
	if (Level.Game.GameRulesModifiers != None)
		G.NextGameRules = Level.Game.GameRulesModifiers;
	Level.Game.GameRulesModifiers = G;

	if (bReset)
	{
		//load em all up, and delete them one by one
		PlayerNames = class'RPGPlayerDataObject'.static.GetPerObjectNames("LumpysRPG",, 1000000);
		for (x = 0; x < PlayerNames.length; x++)
		{
			DataObject = new(None, PlayerNames[x]) class'RPGPlayerDataObject';
			DataObject.ClearConfig();
			//bleh, this sucks, what a waste of memory
			//if only ClearConfig() actually cleared the properties of the object instance...
			DataObject = new(None, PlayerNames[x]) class'RPGPlayerDataObject';
		}

		bReset = false;
		SaveConfig();
	}

	for (x = 0; x < WeaponModifiers.length; x++)
		TotalModifierChance += WeaponModifiers[x].Chance;

//spawn(class'LumpysArtifactManager');

	if (SaveDuringGameInterval > 0.0)
		SetTimer(SaveDuringGameInterval, true);

	if (StartingLevel < 1)
	{
		StartingLevel = 1;
		SaveConfig();
	}

	BotSpendAmount = PointsPerLevel * 3;

	//HACK - if another mutator played with the weapon pickups in *BeginPlay() (like Random Weapon Swap does)
	//we won't get CheckRelevance() calls on those pickups, so find any such pickups here and force it
	foreach DynamicActors(class'Pickup', P)
		if (P.bScriptInitialized && !P.bGameRelevant && !CheckRelevance(P))
			P.Destroy();

	//remove any disallowed abilities
	for (x = 0; x < Abilities.length; x++)
	{
		if (Abilities[x] == None)
		{
			Abilities.Remove(x, 1);
			SaveConfig();
			x--;
		}
		else if (!Abilities[x].static.AbilityIsAllowed(Level.Game, self))
		{
			RemovedAbilities[RemovedAbilities.length] = Abilities[x];
			Abilities.Remove(x, 1);
			SaveConfig();
			x--;
		}
	}
	//See if any abilities that weren't allowed last game are allowed this time
	//(so user doesn't have to fix ability list when switching gametypes/mutators a lot)
	for (x = 0; x < RemovedAbilities.length; x++)
		if (RemovedAbilities[x].static.AbilityIsAllowed(Level.Game, self))
		{
			Abilities[Abilities.length] = RemovedAbilities[x];
			RemovedAbilities.Remove(x, 1);
			SaveConfig();
			x--;
		}

	// // set up an extra download manager that we'll override later with the official UT2004RPG redirect
	// if (Level.NetMode != NM_StandAlone && bUseOfficialRedirect)
	// {
	// 	foreach AllObjects(class'TCPNetDriver', NetDriver)
	// 	{
	// 		DownloadManagers = NetDriver.GetPropertyText("DownloadManagers");
	// 		NetDriver.SetPropertyText("DownloadManagers", "(\"IpDrv.HTTPDownload\"," $ Right(DownloadManagers, Len(DownloadManagers) - 1));
	// 	}
	// }

	Super.PostBeginPlay();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local int x, i;
	local FakeMonsterWeapon w;
	local RPGWeaponPickup p;
	local WeaponLocker Locker;
	local RPGWeaponLocker RPGLocker;
	local Controller C;
	local RPGStatsInv StatsInv;
	local Weapon Weap;
	//local ExperiencePickup EXP;

	if (Other == None)
	{
		return true;
	}

	//hack to allow players to pick up above normal ammo from inital ammo pickup;
	//MaxAmmo will be set to a good value later by the player's RPGStatsInv
	if (Ammunition(Other) != None && ShieldAmmo(Other) == None)
		Ammunition(Other).MaxAmmo = 999;

	/*if (AdrenalinePickup(Other) != None && bExperiencePickups)
	{
		EXP = ExperiencePickup(ReplaceWithActor(Other, "UT2004RPG.ExperiencePickup"));
		if (EXP != None)
			EXP.RPGMut = self;
		return false;
	}*/

	if (WeaponModifierChance > 0)
	{
		if (Other.IsA('WeaponLocker') && !Other.IsA('RPGWeaponLocker'))
		{
			Locker = WeaponLocker(Other);
			RPGLocker = RPGWeaponLocker(ReplaceWithActor(Other, "LumpysRPG.RPGWeaponLocker"));
			if (RPGLocker != None)
			{
				RPGLocker.SetLocation(Locker.Location);
				RPGLocker.RPGMut = self;
				RPGLocker.ReplacedLocker = Locker;
				Locker.GotoState('Disabled');
			}
			for (x = 0; x < Locker.Weapons.length; x++)
				if (Locker.Weapons[x].WeaponClass == class'LinkGun')
					Locker.Weapons[x].WeaponClass = class'RPGLinkGun';
		}

		// don't affect the translocator because it breaks bots
		// don't affect Weapons of Evil's Sentinel Deployer because it doesn't work at all
		if ( Other.IsA('WeaponPickup') && !Other.IsA('TransPickup') && !Other.IsA('RPGWeaponPickup')
			&& !Other.IsA('SentinelDeployerPickup') )
		{
			p = RPGWeaponPickup(ReplaceWithActor(Other, "LumpysRPG.RPGWeaponPickup"));
			if (p != None)
			{
				p.RPGMut = self;
				p.FindPickupBase();
				p.GetPropertiesFrom(class<WeaponPickup>(Other.Class));
			}
			return false;
		}

		//various weapon hacks to work around casts of Pawn.Weapon
		if (xWeaponBase(Other) != None)
		{
			if (xWeaponBase(Other).WeaponType == class'LinkGun')
				xWeaponBase(Other).WeaponType = class'RPGLinkGun';
		}
		else
		{
			Weap = Weapon(Other);
			if (Weap != None)
			{
				for (x = 0; x < Weap.NUM_FIRE_MODES; x++)
				{
					if (Weap.FireModeClass[x] == class'ShockProjFire')
						Weap.FireModeClass[x] = class'RPGShockProjFire';
					else if (Weap.FireModeClass[x] == class'PainterFire')
						Weap.FireModeClass[x] = class'RPGPainterFire';
				}
			}
		}
	}
	else if (Other.IsA('Weapon'))
	{
		// need ammo instances for Max Ammo stat to work without magic weapons
		// I hate this but I couldn't think of a better way
		Weapon(Other).bNoAmmoInstances = false;
	}

	//Give monsters a fake weapon
	if (Other.IsA('Monster'))
	{
		Pawn(Other).HealthMax = Pawn(Other).Health;
		w = spawn(class'FakeMonsterWeapon',Other,,,rot(0,0,0));
		w.GiveTo(Pawn(Other));
	}
	else if (Pawn(Other) != None)
	{
		// evil hack for bad Assault code
		// when Assault does its respawn and teleport stuff (e.g. when finished spacefighter part of AS-Mothership)
		// it spawns a new pawn and destroys the old without calling any of the proper functions
		C = Controller(Other.Owner);
		if (C != None && C.Pawn != None)
		{
			// NOTE - the use of FindInventoryType() here is intentional
			// we don't need to do anything if the old pawn doesn't have possession of an RPGStatsInv
			StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None)
				StatsInv.OwnerDied();
		}
	}
if(Controller(Other) != None)
	Controller(Other).bAdrenalineEnabled = true;

/*			~Lumpy
	Lets get rid of all the players starting equipment weapons that we dont want
*/

	if (xPawn(Other) != None)
	{
		for(i=0;i<16;i++)
		{
			xPawn(Other).RequiredEquipment[i] = "";
		}
	}

	return true;
}

//Replace an actor and then return the new actor
function Actor ReplaceWithActor(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( aClassName == "" )
		return None;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);
	if ( Other.IsA('Pickup') )
	{
		if ( Pickup(Other).MyMarker != None )
		{
			Pickup(Other).MyMarker.markedItem = Pickup(A);
			if ( Pickup(A) != None )
			{
				Pickup(A).MyMarker = Pickup(Other).MyMarker;
				A.SetLocation(A.Location
					+ (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
			}
			Pickup(Other).MyMarker = None;
		}
		else if ( A.IsA('Pickup') )
			Pickup(A).Respawntime = 0.0;
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return A;
	}
	return None;
}

function ModifyPlayer(Pawn Other)
{
	local RPGPlayerDataObject data;
	local int x, FakeBotLevelDiff, i;
	local RPGStatsInv StatsInv;
	local Inventory Inv;
	local array<Weapon> StartingWeapons;
	local class<Weapon> StartingWeaponClass;
	local RPGWeapon MagicWeapon;

	Super.ModifyPlayer(Other);

	if (Other.Controller == None || !Other.Controller.bIsPlayer)
		return;
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
	if (StatsInv != None)
	{//Lets call modify Pawn on all our abilities if we find a stats inv
		if (StatsInv.Instigator != None)
			for (x = 0; x < StatsInv.Data.Abilities.length; x++)
				StatsInv.Data.Abilities[x].static.ModifyPawn(StatsInv.Instigator, StatsInv.Data.AbilityLevels[x]);
		return;
	}
	else
	{
		for (Inv = Other.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			StatsInv = RPGStatsInv(Inv);
			if (StatsInv != None)
				break;
			//I fail to understand why I need this check... am I missing something obvious or is this some weird script bug?
			if (Inv.Inventory == None)
			{
				Inv.Inventory = None;
				break;
			}
		}
	}

	if (StatsInv != None)
		data = StatsInv.DataObject;
	else
	{
		data = RPGPlayerDataObject(FindObject("Package." $ Other.PlayerReplicationInfo.PlayerName, class'RPGPlayerDataObject'));
		if (data == None)
			data = new(None, Other.PlayerReplicationInfo.PlayerName) class'RPGPlayerDataObject';
		//BOT RPG SETUP
		if (bFakeBotLevels && PlayerController(Other.Controller) == None) //a bot, and fake bot levels is turned on
		{
			// if the bot has data, delete it
			if (data.Level != 0)
			{
				data.ClearConfig();
				data = new(None, Other.PlayerReplicationInfo.PlayerName) class'RPGPlayerDataObject';
			}

			// give the bot a level near the current lowest level
			if (CurrentLowestLevelPlayer != None)
			{
				FakeBotLevelDiff = 3 + Min(25, CurrentLowestLevelPlayer.Level * 0.1);
				data.Level = Max(StartingLevel, CurrentLowestLevelPlayer.Level - FakeBotLevelDiff + Rand(FakeBotLevelDiff * 2));
			}
			else
				data.Level = StartingLevel;

			data.PointsAvailable = PointsPerLevel * data.Level + default.NoobBonusXP;
			data.AdrenalineMax = 100;
			data.NeededExp = GetNeededXP(data.Level);

			// give some random amount of EXP toward next level so some will gain a level or two during the match
			data.Experience = Rand(data.NeededExp);

			data.OwnerID = "Bot";
		}
		//END BOT RPG SETUP
		else if (data.Level == 0) //new player, fixed for limited xp and bonus stat start
		{
			data.Level = StartingLevel;
			data.PointsAvailable = PointsPerLevel * StartingLevel + NoobBonusXP;
			data.AdrenalineMax = 100;
			data.NeededExp = GetNeededXP(data.Level);//Let calc our breakpoint and levels here
			data.ClassPoints = 10;
			if (PlayerController(Other.Controller) != None)
				data.OwnerID = PlayerController(Other.Controller).GetPlayerIDHash();
			else
				data.OwnerID = "Bot";
		}
		else //returning player
		{
			if ( (PlayerController(Other.Controller) != None && !(PlayerController(Other.Controller).GetPlayerIDHash() ~= data.OwnerID))
			     || (Bot(Other.Controller) != None && data.OwnerID != "Bot") )
			{
				//imposter using somebody else's name
				if (PlayerController(Other.Controller) != None)
					PlayerController(Other.Controller).ReceiveLocalizedMessage(class'RPGNameMessage', 0);
				Level.Game.ChangeName(Other.Controller, Other.PlayerReplicationInfo.PlayerName$"_Imposter", true);
				if (string(data.Name) ~= Other.PlayerReplicationInfo.PlayerName) //initial name change failed
					Level.Game.ChangeName(Other.Controller, string(Rand(65000)), true); //That's gotta suck, having a number for a name
				ModifyPlayer(Other);
				return;
			}
			ValidateData(data);
		}
	}

	if (data.PointsAvailable > 0 && Bot(Other.Controller) != None)
	{
		x = 0;
		do
		{
			BotLevelUp(Bot(Other.Controller), data);
			x++;
		} until (data.PointsAvailable <= 0 || data.BotAbilityGoal != None || x > 10000)
	}

	if ((CurrentLowestLevelPlayer == None || data.Level < CurrentLowestLevelPlayer.Level) && (!bFakeBotLevels || Other.Controller.IsA('PlayerController')))
		CurrentLowestLevelPlayer = data;

	//spawn the stats inventory item
	if (StatsInv == None)
	{
		StatsInv = spawn(class'RPGStatsInv',Other,,,rot(0,0,0));
		if (Other.Controller.Inventory == None)
			Other.Controller.Inventory = StatsInv;
		else
		{
			for (Inv = Other.Controller.Inventory; Inv.Inventory != None; Inv = Inv.Inventory)
			{}
			Inv.Inventory = StatsInv;
		}
	}
	StatsInv.DataObject = data;
	data.CreateDataStruct(StatsInv.Data, false);
	StatsInv.RPGMut = self;
	StatsInv.GiveTo(Other);
	/*			~Lumpy
		Before we setup the starting weapons with bMagicalStartingWeapons, lets declare some default weapons we want the player to get right after they spawn.
		Default Weapons: Translocator, MP5
	*/

	if(Other != None)
	{
		for(i=0;i<DefaultWeapons.Length;i++)
		{
			if(DefaultWeapons[i] != "")
			{
				Other.GiveWeapon(DefaultWeapons[i]);
			}
		}
	}

	if (WeaponModifierChance > 0)
	{
		x = 0;
		for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			if (Weapon(Inv) != None && RPGWeapon(Inv) == None)
				StartingWeapons[StartingWeapons.length] = Weapon(Inv);
			x++;
			if (x > 1000)
				break;
		}

		for (x = 0; x < StartingWeapons.length; x++)
		{
			StartingWeaponClass = StartingWeapons[x].Class;
			// don't affect the translocator because it breaks bots
			// don't affect Weapons of Evil's Sentinel Deployer because it doesn't work at all
			if (StartingWeaponClass.Name != 'TransLauncher' && StartingWeaponClass.Name != 'SentinelDeployer')
			{
				StartingWeapons[x].Destroy();
				if (bMagicalStartingWeapons)
					MagicWeapon = spawn(GetRandomWeaponModifier(StartingWeaponClass, Other), Other,,, rot(0,0,0));
				else
					MagicWeapon = spawn(class'RPGWeapon', Other,,, rot(0,0,0));
				MagicWeapon.Generate(None);
				MagicWeapon.SetModifiedWeapon(spawn(StartingWeaponClass,Other,,,rot(0,0,0)), bNoUnidentified);
				MagicWeapon.GiveTo(Other);
			}
		}
		Other.Controller.ClientSwitchToBestWeapon();
	}

	//set pawn's properties
	Other.Health = Other.default.Health + data.HealthBonus;
	Other.HealthMax = Other.default.HealthMax + data.HealthBonus;
	Other.SuperHealthMax = Other.HealthMax + (Other.default.SuperHealthMax - Other.default.HealthMax);
	Other.Controller.AdrenalineMax = data.AdrenalineMax;
	for (x = 0; x < data.Abilities.length; x++)
		data.Abilities[x].static.ModifyPawn(Other, data.AbilityLevels[x]);
}

function SpawnDrone(vector SpawnLoc, rotator SpawnRot, int DroneClass, optional Pawn Owner)
{
	local LumpyDrone drone;
	local RPGStatsInv StatsInv;
	//local class<LumpyDrone> MD;
	local int f,i,x;

	if (Owner.Controller == None || !Owner.Controller.bIsPlayer)
		return;
	StatsInv = RPGStatsInv(Owner.FindInventoryType(class'RPGStatsInv'));

	if (StatsInv.DroneList.Length > 0)
	{
		for(f=0;f<StatsInv.DroneList.length;f++)
		{

			if(DroneList.length > 0)
			{
				for(i=0;i<DroneList.length;i++)
				{
					if((StatsInv.DroneList[f].class == DroneList[i].class) && (StatsInv.DroneList[f] != None && DroneList[i] != None))
					{
						DroneList[i].Destroyed();
						DroneList[i].Destroy();
						DroneList.Remove(i,1);
						Log("Drone Entry Accessed: "$DroneList[i]$" i:"$i$"DroneListLengthAfter:"$DroneList.length,'LumpysRPG');
						StatsInv.DroneList[f].Destroyed();
						StatsInv.DroneList[f].Destroy();
						StatsInv.DroneList.Remove(f,1);
						Log("StatsInv.Drone Entry Accessed: "$StatsInv.DroneList[f]$" f:"$f,'LumpysRPG');
					}
				}
			}

		}
	}

		if(DroneClass == 0 || StatsInv.RegDrones > 0)
		{
			for(x=0;x<StatsInv.RegDrones;x++)
			{
				Log("We spawned a Regular Drone", 'LumpysRPG');
				drone = Spawn(class'LumpyDrone',Owner,,SpawnLoc,SpawnRot);

				if (drone != None)
				{
					drone.protPawn = Owner;
					drone.ProjDamage = ProjDamage;
					drone.HealPerSec = HealPerSec;
					drone.ShotDelay = ShotDelay;
					drone.TargetDelay = TargetDelay;
					drone.bActive = !bPickup;
					StatsInv.DroneList.Insert(StatsInv.DroneList.length, 1);
					StatsInv.DroneList[StatsInv.DroneList.length] = drone;
					DroneList.Insert(DroneList.length,1);
					DroneList[DroneList.length] = drone;
				}
			}
		}
		if(DroneClass == 1 || StatsInv.MedicDrones > 0)
		{
			for(x=0;x<StatsInv.MedicDrones;x++)
			{
				Log("We spawned a Regular Drone", 'LumpysRPG');
				drone = Spawn(class'MedicDrone',Owner,,SpawnLoc,SpawnRot);

				if (drone != None)
					{
					drone.protPawn = Owner;
					drone.ProjDamage = ProjDamage;
					drone.HealPerSec = HealPerSec;
					drone.ShotDelay = ShotDelay;
					drone.TargetDelay = TargetDelay;
					drone.bActive = !bPickup;
					StatsInv.DroneList.Insert(StatsInv.DroneList.length, 1);
					StatsInv.DroneList[StatsInv.DroneList.length] = drone;
					DroneList.Insert(DroneList.length,1);
					DroneList[DroneList.length] = drone;
				}
			}
		}
	// foreach DynamicActors(MD, drone)
	// 	drone.Destroy();

	// for(x=0;x<StatsInv.MaxDrones;x++)
	// {
	// 	if(DroneClass == 0)
	// 	{
	// 		Log("We spawned a Regular Drone", 'LumpysRPG');
	// 		drone = Spawn(class'LumpyDrone',Owner,,SpawnLoc,SpawnRot);
	// 	}
	// 	else if(DroneClass == 1)
	// 	{
	// 		Log("We spawned a medic Drone", 'LumpysRPG');
	// 		drone = Spawn(class'MedicDrone',Owner,,SpawnLoc,SpawnRot);
	// 	}


	// }
}

function int GetNeededXP(int Playerlevel)
{
  local int x;
  for (x=0;x<default.XPBreakPoints.Length;x++)
  {
    if (Playerlevel < default.XPBreakPoints[x].Level)
      return default.XPBreakPoints[x].XPRequired;
  }
  //as soon as the above becomes false, we should be at max level
  return default.XPBreakPoints[5].XPRequired;
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local int DefHealth, i;
	local float DefLinkHealMult, HealthPct;
	local array<RPGArtifact> Artifacts;

	if (V.Controller != None)
	{
		for (Inv = V.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			StatsInv = RPGStatsInv(Inv);
			if (StatsInv != None)
				break;
		}
	}

	if (StatsInv == None)
		StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
	if (StatsInv != None)
	{
		//FIXME maybe give it inventory to remember original values instead so it works with other mods that change vehicle properties?
		if (ASVehicleFactory(V.ParentFactory) != None)
		{
			DefHealth = ASVehicleFactory(V.ParentFactory).VehicleHealth;
			DefLinkHealMult = ASVehicleFactory(V.ParentFactory).VehicleLinkHealMult;
		}
		else
		{
			DefHealth = V.default.Health;
			DefLinkHealMult = V.default.LinkHealMult;
		}
		HealthPct = float(V.Health) / V.HealthMax;
		V.HealthMax = DefHealth + StatsInv.Data.HealthBonus;
		V.Health = HealthPct * V.HealthMax;
		V.LinkHealMult = DefLinkHealMult * (V.HealthMax / DefHealth); //FIXME maybe make faster link healing an ability instead?

		StatsInv.ModifyVehicle(V);
		StatsInv.ClientModifyVehicle(V);
	}
	else
		Warn("Couldn't find RPGStatsInv for "$P.GetHumanReadableName());

	//move all artifacts from driver to vehicle, so player can still use them
	for (Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
		if (RPGArtifact(Inv) != None)
			Artifacts[Artifacts.length] = RPGArtifact(Inv);

	//hack - temporarily give the pawn its Controller back because RPGArtifact::Activate() needs it
	P.Controller = V.Controller;
	for (i = 0; i < Artifacts.length; i++)
	{
		if (Artifacts[i].bActive)
		{
			//turn it off first
			Artifacts[i].ActivatedTime = -1000000; //force it to allow deactivation
			Artifacts[i].Activate();
		}
		if (Artifacts[i] == P.SelectedItem)
			V.SelectedItem = Artifacts[i];
		P.DeleteInventory(Artifacts[i]);
		Artifacts[i].GiveTo(V);
	}
	P.Controller = None;

	Super.DriverEnteredVehicle(V, P);
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local array<RPGArtifact> Artifacts;
	local int i;

	if (P.Controller != None)
	{
		for (Inv = P.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			StatsInv = RPGStatsInv(Inv);
			if (StatsInv != None)
				break;
		}
	}

	if (StatsInv == None)
		StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
	if (StatsInv != None)
	{
		// yet another Assault hack (spacefighters)
		if (StatsInv.Instigator == V)
			V.DeleteInventory(StatsInv);

		StatsInv.UnModifyVehicle(V);
		StatsInv.ClientUnModifyVehicle(V);
	}
	else
		Warn("Couldn't find RPGStatsInv for "$P.GetHumanReadableName());

	//move all artifacts from vehicle to driver
	for (Inv = V.Inventory; Inv != None; Inv = Inv.Inventory)
		if (RPGArtifact(Inv) != None)
			Artifacts[Artifacts.length] = RPGArtifact(Inv);

	//hack - temporarily give the vehicle its Controller back because RPGArtifact::Activate() needs it
	V.Controller = P.Controller;
	for (i = 0; i < Artifacts.length; i++)
	{
		if (Artifacts[i].bActive)
		{
			//turn it off first
			Artifacts[i].ActivatedTime = -1000000; //force it to allow deactivation
			Artifacts[i].Activate();
		}
		if (Artifacts[i] == V.SelectedItem)
			P.SelectedItem = Artifacts[i];
		V.DeleteInventory(Artifacts[i]);
		Artifacts[i].GiveTo(P);
	}
	V.Controller = None;

	Super.DriverLeftVehicle(V, P);
}

//Check the player data at the given index for errors (too many/not enough stat points, invalid abilities)
//Converts the data by giving or taking the appropriate number of stat points and refunding points for abilities bought that are no longer allowed
//This allows the server owner to change points per level settings and/or the abilities allowed and have it affect already created players properly
function ValidateData(RPGPlayerDataObject Data)
{
	local int TotalPoints, x, y;
	local bool bAllowedAbility;

	//check stat caps
	if (StatCaps[0] >= 0)
		Data.WeaponSpeed = Min(Data.WeaponSpeed, StatCaps[0]);
	if (StatCaps[1] >= 0)
		Data.HealthBonus = Min(Data.HealthBonus, StatCaps[1]);
	if (StatCaps[2] >= 0)
		Data.AdrenalineMax = Max(Min(Data.AdrenalineMax, StatCaps[2]), Min(StatCaps[2], 100));
	else
		Data.AdrenalineMax = Max(Data.AdrenalineMax, 100); // make sure adrenaline max is above starting value
	if (StatCaps[3] >= 0)
		Data.Attack = Min(Data.Attack, StatCaps[3]);
	if (StatCaps[4] >= 0)
		Data.Defense = Min(Data.Defense, StatCaps[4]);
	if (StatCaps[5] >= 0)
		Data.AmmoMax = Min(Data.AmmoMax, StatCaps[5]);

	TotalPoints += Data.WeaponSpeed + Data.Attack + Data.Defense + Data.AmmoMax;
	TotalPoints += Data.HealthBonus / 2;
	TotalPoints += Data.AdrenalineMax - 100;
	for (x = 0; x < Data.Abilities.length; x++)
	{
		bAllowedAbility = false;
		for (y = 0; y < Abilities.length; y++)
			if (Data.Abilities[x] == Abilities[y])
			{
				bAllowedAbility = true;
				y = Abilities.length;		//kill loop without break due to UnrealScript bug that causes break to kill both loops
			}
		if (bAllowedAbility)
		{
			for (y = 0; y < Data.AbilityLevels[x]; y++)
				TotalPoints += Data.Abilities[x].static.Cost(Data, y);
		}
		else
		{
			for (y = 0; y < Data.AbilityLevels[x]; y++)
				Data.PointsAvailable += Data.Abilities[x].static.Cost(Data, y);
			Log("Ability"@Data.Abilities[x]@"was in"@Data.Name$"'s data but is not an available ability - removed (stat points refunded)");
			Data.Abilities.Remove(x, 1);
			Data.AbilityLevels.Remove(x, 1);
			x--;
		}
	}
	TotalPoints += Data.PointsAvailable;

	if ( TotalPoints != ((Data.Level) * PointsPerLevel + default.NoobBonusXP) )
	{
		Data.PointsAvailable += ((Data.Level) * PointsPerLevel + default.NoobBonusXP) - TotalPoints;
		Log(Data.Name$" had "$TotalPoints$" total stat points at Level "$Data.Level$", should be "$((Data.Level - 1) * PointsPerLevel)$", PointsAvailable changed by "$(((Data.Level - 1) * PointsPerLevel) - TotalPoints)$" to compensate");
	}
}

function BotLevelUp(Bot B, RPGPlayerDataObject Data)
{
	local int WSpeedChance, HealthBonusChance, AdrenalineMaxChance, AttackChance, DefenseChance, AmmoMaxChance, AbilityChance;
	local int Chance, TotalAbilityChance;
	local int x, y, Index;
	local bool bHasAbility, bAddAbility;

	if (Data.BotAbilityGoal != None)
	{
		if (Data.BotAbilityGoal.static.Cost(Data, Data.BotGoalAbilityCurrentLevel) > Data.PointsAvailable)
			return;

		Index = -1;
		for (x = 0; x < Data.Abilities.length; x++)
			if (Data.Abilities[x] == Data.BotAbilityGoal)
			{
				Index = x;
				break;
			}
		if (Index == -1)
			Index = Data.Abilities.length;
		Data.PointsAvailable -= Data.BotAbilityGoal.static.Cost(Data, Data.BotGoalAbilityCurrentLevel);
		Data.Abilities[Index] = Data.BotAbilityGoal;
		Data.AbilityLevels[Index]++;
		Data.BotAbilityGoal = None;
		return;
	}

	//Bots always allocate all their points to one stat - random, but tilted towards the bot's tendencies

	WSpeedChance = 2;
	HealthBonusChance = 2;
	AdrenalineMaxChance = 1;
	AttackChance = 2;
	DefenseChance = 2;
	AmmoMaxChance = 1; //less because bots don't get ammo half the time as it is, so it's not as useful a stat for them
	AbilityChance = 3;

	if (B.Aggressiveness > 0.25)
	{
		WSpeedChance += 3;
		AttackChance += 3;
		AmmoMaxChance += 2;
	}
	if (B.Accuracy < 0)
	{
		WSpeedChance++;
		DefenseChance++;
		AmmoMaxChance += 2;
	}
	if (B.FavoriteWeapon != None && B.FavoriteWeapon.default.FireModeClass[0] != None && B.FavoriteWeapon.default.FireModeClass[0].default.FireRate > 1.25)
		WSpeedChance += 2;
	if (B.Tactics > 0.9)
	{
		HealthBonusChance += 3;
		AdrenalineMaxChance += 3;
		DefenseChance += 3;
	}
	else if (B.Tactics > 0.4)
	{
		HealthBonusChance += 2;
		AdrenalineMaxChance += 2;
		DefenseChance += 2;
	}
	else if (B.Tactics > 0)
	{
		HealthBonusChance++;
		AdrenalineMaxChance++;
		DefenseChance++;
	}
	if (B.StrafingAbility < 0)
	{
		HealthBonusChance++;
		AdrenalineMaxChance++;
		DefenseChance += 2;
	}
	if (B.CombatStyle < 0)
	{
		HealthBonusChance += 2;
		AdrenalineMaxChance += 2;
		DefenseChance += 2;
	}
	else if (B.CombatStyle > 0)
	{
		AttackChance += 2;
		AmmoMaxChance++;
	}
	if (Data.Level < 20)
		AbilityChance--;	//very few abilities to choose from at this low level so reduce chance
	else
	{
		//More likely to buy an ability if don't have that many
		y = 0;
		for (x = 0; x < Data.AbilityLevels.length; x++)
			y += Data.AbilityLevels[x];
		if (y < (Data.Level - 20) / 10)
			AbilityChance++;
	}

	if (Data.AmmoMax >= 50)
		AmmoMaxChance = Max(AmmoMaxChance / 1.5, 1);
	if (Data.AdrenalineMax >= 175)
		AdrenalineMaxChance /= 1.5;  //too much adrenaline and you'll never get to use any combos!

	//disable choosing of stats that are maxxed out
	if (StatCaps[0] >= 0 && Data.WeaponSpeed >= StatCaps[0])
		WSpeedChance = 0;
	if (StatCaps[1] >= 0 && Data.HealthBonus >= StatCaps[1])
		HealthBonusChance = 0;
	if (StatCaps[2] >= 0 && Data.AdrenalineMax >= StatCaps[2])
		AdrenalineMaxChance = 0;
	if (StatCaps[3] >= 0 && Data.Attack >= StatCaps[3])
		AttackChance = 0;
	if (StatCaps[4] >= 0 && Data.Defense >= StatCaps[4])
		DefenseChance = 0;
	if (StatCaps[5] >= 0 && Data.AmmoMax >= StatCaps[5])
		AmmoMaxChance = 0;

	//choose a stat
	Chance = Rand(WSpeedChance + HealthBonusChance + AdrenalineMaxChance + AttackChance + DefenseChance + AmmoMaxChance + AbilityChance);
	bAddAbility = false;
	if (Chance < WSpeedChance)
		Data.WeaponSpeed += Min(Data.PointsAvailable, BotSpendAmount);
	else if (Chance < WSpeedChance + HealthBonusChance)
		Data.HealthBonus += Min(Data.PointsAvailable, BotSpendAmount) * 2;
	else if (Chance < WSpeedChance + HealthBonusChance + AdrenalineMaxChance)
		Data.AdrenalineMax += Min(Data.PointsAvailable, BotSpendAmount);
	else if (Chance < WSpeedChance + HealthBonusChance + AdrenalineMaxChance + AttackChance)
		Data.Attack += Min(Data.PointsAvailable, BotSpendAmount);
	else if (Chance < WSpeedChance + HealthBonusChance + AdrenalineMaxChance + AttackChance + DefenseChance)
		Data.Defense += Min(Data.PointsAvailable, BotSpendAmount);
	else if (Chance < WSpeedChance + HealthBonusChance + AdrenalineMaxChance + AttackChance + DefenseChance + AmmoMaxChance)
		Data.AmmoMax += Min(Data.PointsAvailable, BotSpendAmount);
	else
		bAddAbility = true;
	if (!bAddAbility)
		Data.PointsAvailable -= Min(Data.PointsAvailable, BotSpendAmount);
	else
	{
		TotalAbilityChance = 0;
		for (x = 0; x < Abilities.length; x++)
		{
			bHasAbility = false;
			for (y = 0; y < Data.Abilities.length; y++)
				if (Abilities[x] == Data.Abilities[y])
				{
					bHasAbility = true;
					TotalAbilityChance += Abilities[x].static.BotBuyChance(B, Data, Data.AbilityLevels[y]);
					y = Data.Abilities.length; //kill loop without break
				}
			if (!bHasAbility)
				TotalAbilityChance += Abilities[x].static.BotBuyChance(B, Data, 0);
		}
		if (TotalAbilityChance == 0)
			return; //no abilities can be bought
		Chance = Rand(TotalAbilityChance);
		TotalAbilityChance = 0;
		for (x = 0; x < Abilities.length; x++)
		{
			bHasAbility = false;
			for (y = 0; y < Data.Abilities.length; y++)
				if (Abilities[x] == Data.Abilities[y])
				{
					bHasAbility = true;
					TotalAbilityChance += Abilities[x].static.BotBuyChance(B, Data, Data.AbilityLevels[y]);
					if (Chance < TotalAbilityChance)
					{
						Data.BotAbilityGoal = Abilities[x];
						Data.BotGoalAbilityCurrentLevel = Data.AbilityLevels[y];
						Index = y;
					}
					y = Data.Abilities.length; //kill loop without break
				}
			if (!bHasAbility)
			{
				TotalAbilityChance += Abilities[x].static.BotBuyChance(B, Data, 0);
				if (Chance < TotalAbilityChance)
				{
					Data.BotAbilityGoal = Abilities[x];
					Data.BotGoalAbilityCurrentLevel = 0;
					Index = Data.Abilities.length;
					Data.AbilityLevels[Index] = 0;
				}
			}
			if (Chance < TotalAbilityChance)
				break; //found chosen ability
		}
		if (Data.BotAbilityGoal.static.Cost(Data, Data.BotGoalAbilityCurrentLevel) <= Data.PointsAvailable)
		{
			Data.PointsAvailable -= Data.BotAbilityGoal.static.Cost(Data, Data.BotGoalAbilityCurrentLevel);
			Data.Abilities[Index] = Data.BotAbilityGoal;
			Data.AbilityLevels[Index]++;
			Data.BotAbilityGoal = None;
		}
	}
}

function CheckLevelUp(RPGPlayerDataObject data, PlayerReplicationInfo MessagePRI)
{
	local LevelUpEffect Effect;
	local int Count;

	while (data.Experience >= data.NeededExp && Count < 10000)
	{

		Count++;
		data.Level++;
		data.PointsAvailable += PointsPerLevel;
		data.Experience -= data.NeededExp;
    data.NeededExp = GetNeededXP(data.Level);

		if (data.Level % 1000 == 0)
		{
			data.ClassPoints += 10;
		}

		if (MessagePRI != None)
		{
			if (Count <= MaxLevelupEffectStacking && Controller(MessagePRI.Owner) != None && Controller(MessagePRI.Owner).Pawn != None)
			{
				Effect = Controller(MessagePRI.Owner).Pawn.spawn(class'LevelUpEffect', Controller(MessagePRI.Owner).Pawn);
				Effect.SetDrawScale(Controller(MessagePRI.Owner).Pawn.CollisionRadius / Effect.CollisionRadius);
				Effect.Initialize();
			}
		}

		if (data.Level > HighestLevelPlayerLevel && (!bFakeBotLevels || data.OwnerID != "Bot"))
		{
			HighestLevelPlayerName = string(data.Name);
			HighestLevelPlayerLevel = data.Level;
			SaveConfig();
		}
	}

	if (Count > 0 && Count < 3 && MessagePRI != None)
		Level.Game.BroadCastLocalized(self, class'GainLevelMessage', data.Level, MessagePRI);

  // Save the Players data on levelup so we dont miss anything due to invasion funkiness
  data.SaveConfig();
}

function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other)
{
	local int x, Chance;

	if (FRand() < WeaponModifierChance)
	{
		Chance = Rand(TotalModifierChance);
		for (x = 0; x < WeaponModifiers.Length; x++)
		{
			Chance -= WeaponModifiers[x].Chance;
			if (Chance < 0 && WeaponModifiers[x].WeaponClass.static.AllowedFor(WeaponType, Other))
				return WeaponModifiers[x].WeaponClass;
		}
	}

	return class'RPGWeapon';
}

function FillMonsterList()
{
	local Object O;
	local class<Monster> MonsterClass;

	if (MonsterList.length == 0)
	{
		if (ConfigMonsterList.length > 0)
		{
			MonsterList = ConfigMonsterList;
		}
		else
		{
			foreach AllObjects(class'Object', O)
			{
				MonsterClass = class<Monster>(O);
				if ( MonsterClass != None && MonsterClass != class'Monster' && MonsterClass.default.Mesh != class'xPawn'.default.Mesh
					&& MonsterClass.default.ScoringValue < 100 )
					MonsterList[MonsterList.length] = MonsterClass;
			}
		}
	}
}

function NotifyLogout(Controller Exiting)
{
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local RPGPlayerDataObject DataObject;

	if (Level.Game.bGameRestarted)
	{
		return;
	}

	for (Inv = Exiting.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		StatsInv = RPGStatsInv(Inv);
		if (StatsInv != None)
			break;
	}

	if (StatsInv == None)
		return;

	DataObject = StatsInv.DataObject;
	StatsInv.Destroy();

	// possibly save data
	if (!bFakeBotLevels || Exiting.IsA('PlayerController'))
	{
			DataObject.SaveConfig();
	}

	if (DataObject == CurrentLowestLevelPlayer)
		FindCurrentLowestLevelPlayer();
}

//find who is now the lowest level player
function FindCurrentLowestLevelPlayer()
{
	local Controller C;
	local Inventory Inv;

	CurrentLowestLevelPlayer = None;
	for (C = Level.ControllerList; C != None; C = C.NextController)
		if (C.bIsPlayer && C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bOutOfLives && (!bFakeBotLevels || C.IsA('PlayerController')))
			for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
				if ( RPGStatsInv(Inv) != None && ( CurrentLowestLevelPlayer == None
								  || RPGStatsInv(Inv).DataObject.Level < CurrentLowestLevelPlayer.Level ) )
					CurrentLowestLevelPlayer = RPGStatsInv(Inv).DataObject;
}

simulated function Tick(float deltaTime)
{
	local PlayerController PC;
	local Controller C;
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local RPGPlayerDataObject NewDataObject;

	// see PreSaveGame() for comments on this
	if (bJustSaved)
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if (C.bIsPlayer)
			{
				for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
				{
					StatsInv = RPGStatsInv(Inv);
					if (StatsInv != None)
					{
						NewDataObject = RPGPlayerDataObject(FindObject("Package." $ string(StatsInv.DataObject.Name), class'RPGPlayerDataObject'));
						if (NewDataObject == None)
							NewDataObject = new(None, string(StatsInv.DataObject.Name)) class'RPGPlayerDataObject';
						NewDataObject.CopyDataFrom(StatsInv.DataObject);
						StatsInv.DataObject = NewDataObject;
					}
				}
			}
		}

		FindCurrentLowestLevelPlayer();
		bJustSaved = false;
	}

	if (Level.NetMode == NM_DedicatedServer || bHasInteraction)
	{
		disable('Tick');
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if (PC != None)
		{
			PC.Player.InteractionMaster.AddInteraction("LumpysRPG.RPGInteraction", PC.Player);
			if (GUIController(PC.Player.GUIController) != None)
			{
				GUIController(PC.Player.GUIController).RegisterStyle(class'STY_AbilityList');
				GUIController(PC.Player.GUIController).RegisterStyle(class'STY_ResetButton');
			}
			bHasInteraction = true;
			disable('Tick');
		}
	}
}

function Timer()
{
	SaveData();
}

function SaveData()
{
	local Controller C;
	local Inventory Inv;

	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if ( C.bIsPlayer && (!bFakeBotLevels || C.IsA('PlayerController'))
		     && ((C.PlayerReplicationInfo != None && C.PlayerReplicationInfo == Level.Game.GameReplicationInfo.Winner)
		          || (C.PlayerReplicationInfo.Team != None && C.PlayerReplicationInfo.Team == Level.Game.GameReplicationInfo.Winner) ) )
		{
			for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
				if (Inv.IsA('RPGStatsInv'))
				{
					RPGStatsInv(Inv).DataObject.SaveConfig();
					break;
				}
		}
	}
}

function GetServerDetails(out GameInfo.ServerResponseLine ServerState)
{
	local int i, NumPlayers;
	local float AvgLevel;
	local Controller C;
	local Inventory Inv;

	Super.GetServerDetails(ServerState);

	i = ServerState.ServerInfo.Length;

	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "LumpyRPG Version";
	ServerState.ServerInfo[i++].Value = ""$(LUMPYRPG_VERSION);

	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "Starting Level";
	ServerState.ServerInfo[i++].Value = string(StartingLevel);

	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "Stat Points Per Level";
	ServerState.ServerInfo[i++].Value = string(PointsPerLevel);

	//find average level of players currently on server
	if (!Level.Game.bGameRestarted)
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if (C.bIsPlayer && (!bFakeBotLevels || C.IsA('PlayerController')))
			{
				for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
					if (Inv.IsA('RPGStatsInv'))
					{
						AvgLevel += RPGStatsInv(Inv).DataObject.Level;
						NumPlayers++;
					}
			}
		}
		if (NumPlayers > 0)
			AvgLevel = AvgLevel / NumPlayers;

		ServerState.ServerInfo.Length = i+1;
		ServerState.ServerInfo[i].Key = "Current Avg. Level";
		ServerState.ServerInfo[i++].Value = ""$AvgLevel;
	}

	if (HighestLevelPlayerLevel > 0)
	{
		ServerState.ServerInfo.Length = i+1;
		ServerState.ServerInfo[i].Key = "Highest Level Player";
		ServerState.ServerInfo[i++].Value = HighestLevelPlayerName@"("$HighestLevelPlayerLevel$")";
	}

	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "Magic Weapon Chance";
	ServerState.ServerInfo[i++].Value = string(int(WeaponModifierChance*100))$"%";

	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "Magical Starting Weapons";
	ServerState.ServerInfo[i++].Value = string(bMagicalStartingWeapons);

	// ServerState.ServerInfo.Length = i+1;
	// ServerState.ServerInfo[i].Key = "Artifacts";
	// ServerState.ServerInfo[i++].Value = string(class'LumpysArtifactManager'.default.MaxArtifacts > 0 && class'LumpysArtifactManager'.default.ArtifactDelay > 0);

	if (Level.Game.IsA('Invasion'))
	{
		ServerState.ServerInfo.Length = i+1;
		ServerState.ServerInfo[i].Key = "Auto Adjust Invasion Monster Level";
		ServerState.ServerInfo[i++].Value = string(bAutoAdjustInvasionLevel);
		if (bAutoAdjustInvasionLevel)
		{
			ServerState.ServerInfo.Length = i+1;
			ServerState.ServerInfo[i].Key = "Monster Adjustment Factor";
			ServerState.ServerInfo[i++].Value = string(InvasionAutoAdjustFactor);
		}
	}
}

// event bool OverrideDownload(string PlayerIP, string PlayerID, string PlayerURL, out string RedirectURL)
// {
// 	//only override the redirect once for each connect
// 	//since we added an extra HTTPDownload to the DownloadManagers list in PostBeginPlay()
// 	//this effectively creates an extra redirect for UT2004RPG files so servers always have one for
// 	//the latest UT2004RPG version even if their own is outdated
// 	if (!bUseOfficialRedirect || LastOverrideDownloadIP ~= PlayerIP)
// 	{
// 		return Super.OverrideDownload(PlayerIP, PlayerID, PlayerURL, RedirectURL);
// 	}
// 	else
// 	{
// 		RedirectURL = "http://mysterial.linuxgangster.org/files/";
// 		LastOverrideDownloadIP = PlayerIP;
// 		return true;
// 	}
// }

function Mutate(string MutateString, PlayerController Sender)
{
	local GhostInv Inv;
	local Pawn P;

	// "mutate ghostsuicide" suicides while being affected by Ghost (since normal suicide doesn't work then)
	if (MutateString ~= "ghostsuicide")
	{
		P = Pawn(Sender.ViewTarget);
		if (P != None)
		{
			Inv = GhostInv(P.FindInventoryType(class'GhostInv'));
			if (Inv != None)
			{
				Inv.ReviveInstigator();
				P.Suicide();
			}
		}
	}

	Super.Mutate(MutateString, Sender);
}

event PreSaveGame()
{
	local Controller C;
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local RPGPlayerDataObject NewDataObject;

	//create new RPGPlayerDataObjects with the same data but the Level as their Outer, so that savegames will work
	//(can't always have the objects this way because using the Level as the Outer for a PerObjectConfig
	//object causes it to be saved in LevelName.ini)
	//second hack of mine in UT2004's code that's backfired in two days. Ugh.
	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if (C.bIsPlayer)
		{
			for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
			{
				StatsInv = RPGStatsInv(Inv);
				if (StatsInv != None)
				{
					NewDataObject = RPGPlayerDataObject(FindObject(string(xLevel) $ "." $ string(StatsInv.DataObject.Name), class'RPGPlayerDataObject'));
					if (NewDataObject == None)
						NewDataObject = new(xLevel, string(StatsInv.DataObject.Name)) class'RPGPlayerDataObject';
					NewDataObject.CopyDataFrom(StatsInv.DataObject);
					StatsInv.DataObject = NewDataObject;
				}
			}
		}
	}

	Level.GetLocalPlayerController().Player.GUIController.CloseAll(false);

	bJustSaved = true;
	enable('Tick');
}

event PostLoadSavedGame()
{
	// interactions are not saved in savegames so we have to recreate it
	bHasInteraction = false;
	enable('Tick');
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	local int i;

	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting("LumpysRPG", "SaveDuringGameInterval", default.PropsDisplayText[i++], 1, 10, "Text", "3;0:999");
	PlayInfo.AddSetting("LumpysRPG", "StartingLevel", default.PropsDisplayText[i++], 1, 10, "Text", "2;1:99");
	PlayInfo.AddSetting("LumpysRPG", "PointsPerLevel", default.PropsDisplayText[i++], 5, 10, "Text", "2;1:99");
	PlayInfo.AddSetting("LumpysRPG", "LevelDiffExpGainDiv", default.PropsDisplayText[i++], 1, 10, "Text", "5;0.001:100.0",,, true);
	PlayInfo.AddSetting("LumpysRPG", "EXPForWin", default.PropsDisplayText[i++], 10, 10, "Text", "3;0:999");
	PlayInfo.AddSetting("LumpysRPG", "bFakeBotLevels", default.PropsDisplayText[i++], 4, 10, "Check");
	PlayInfo.AddSetting("LumpysRPG", "bReset", default.PropsDisplayText[i++], 0, 10, "Check");
	PlayInfo.AddSetting("LumpysRPG", "WeaponModifierChance", default.PropsDisplayText[i++], 50, 10, "Text", "4;0.0:1.0");
	PlayInfo.AddSetting("LumpysRPG", "bMagicalStartingWeapons", default.PropsDisplayText[i++], 0, 10, "Check");
	PlayInfo.AddSetting("LumpysRPG", "bNoUnidentified", default.PropsDisplayText[i++], 0, 10, "Check");
	PlayInfo.AddSetting("LumpysRPG", "bAutoAdjustInvasionLevel", default.PropsDisplayText[i++], 1, 10, "Check");
	PlayInfo.AddSetting("LumpysRPG", "InvasionAutoAdjustFactor", default.PropsDisplayText[i++], 1, 10, "Text", "4;0.01:3.0");
	PlayInfo.AddSetting("LumpysRPG", "MaxLevelupEffectStacking", default.PropsDisplayText[i++], 1, 10, "Text", "2;1:10",,, true);
	PlayInfo.AddSetting("LumpysRPG", "StatCaps", default.PropsDisplayText[i++], 1, 14, "Text",,,, true);
	//PlayInfo.AddSetting("UT2004RPG", "InfiniteReqEXPOp", default.PropsDisplayText[i++], 1, 12, "Select", default.PropsExtras,,, true);
	//PlayInfo.AddSetting("UT2004RPG", "InfiniteReqEXPValue", default.PropsDisplayText[i++], 1, 13, "Text", "3;0:999",,, true);
	PlayInfo.AddSetting("LumpysRPG", "Levels", default.PropsDisplayText[i++], 1, 11, "Text",,,, true);
	//FIXME perhaps make Abilities menu a "Select" option, using .int or .ucl to find all available abilities?
	PlayInfo.AddSetting("LumpysRPG", "Abilities", default.PropsDisplayText[i++], 1, 15, "Text",,,, true);
	//PlayInfo.AddSetting("UT2004RPG", "bIronmanMode", default.PropsDisplayText[i++], 4, 10, "Check",,,, true);
	//PlayInfo.AddSetting("UT2004RPG", "bUseOfficialRedirect", default.PropsDisplayText[i++], 4, 10, "Check",,, true, true);
	//PlayInfo.AddSetting("UT2004RPG", "BotBonusLevels", default.PropsDisplayText[i++], 4, 10, "Text", "2;0:99",,, true);
	//PlayInfo.AddSetting("UT2004RPG", "bExperiencePickups", "Experience Pickups", 0, 10, "Check");

	// class'LumpysArtifactManager'.static.FillPlayInfo(PlayInfo);
}

static function string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "SaveDuringGameInterval":	return default.PropsDescText[0];
		case "StartingLevel":		return default.PropsDescText[1];
		case "PointsPerLevel":		return default.PropsDescText[2];
		case "LevelDiffExpGainDiv":	return default.PropsDescText[3];
		case "EXPForWin":		return default.PropsDescText[4];
		case "bFakeBotLevels":		return default.PropsDescText[5];
		case "bReset":			return default.PropsDescText[6];
		case "WeaponModifierChance":	return default.PropsDescText[7];
		case "bMagicalStartingWeapons":	return default.PropsDescText[8];
		case "bNoUnidentified":		return default.PropsDescText[9];
		case "bAutoAdjustInvasionLevel":return default.PropsDescText[10];
		case "InvasionAutoAdjustFactor":return default.PropsDescText[11];
		case "MaxLevelupEffectStacking":return default.PropsDescText[12];
		case "StatCaps":		return default.PropsDescText[13];
		//case "InfiniteReqEXPOp":	return default.PropsDescText[14];
		//case "InfiniteReqEXPValue":	return default.PropsDescText[15];
		case "Levels":			return default.PropsDescText[14];
		case "Abilities":		return default.PropsDescText[15];
		//case "bIronmanMode":		return default.PropsDescText[18];
		//case "bUseOfficialRedirect":	return default.PropsDescText[19];
		//case "BotBonusLevels":		return default.PropsDescText[20];
	}
}

defaultproperties
{
	ProjDamage=9
	HealPerSec=10
	ShotDelay=6
	TargetDelay=15
	spawnProb=50
	DefaultWeapons(0)="XWeapons.TransLauncher"
	DefaultWeapons(1)="tk_ZenCoders.MP5Gun"
	WeaponModifiers(0)=(WeaponClass=Class'LumpysRPG.RW_Healing',Chance=1)
	WeaponModifiers(1)=(WeaponClass=Class'LumpysRPG.RW_Adrenal',Chance=2)
	WeaponModifiers(2)=(WeaponClass=Class'LumpysRPG.RW_Rejuvination',Chance=2)
	WeaponModifiers(3)=(WeaponClass=Class'LumpysRPG.RW_MedicHealing',Chance=1)
	Abilities(0)=Class'LumpysRPG.AbilitySpeed'
	Abilities(1)=Class'LumpysRPG.AbilityJumpZ'
	Abilities(2)=Class'LumpysRPG.AbilityHermesSandals'
	Abilities(3)=Class'LumpysRPG.ClassMedicMaster'
	Abilities(4)=Class'LumpysRPG.ClassAdrenalineMaster'
	Abilities(5)=Class'LumpysRPG.ClassWeaponMaster'
	Abilities(6)=Class'LumpysRPG.CA_MedicArtifacts'
	Abilities(7)=Class'LumpysRPG.CA_AdrenalineArtifacts'
	Abilities(8)=Class'LumpysRPG.AbilityAwareness'
	Abilities(9)=Class'LumpysRPG.AbilityDrones'

	//These berakpoints should be used for XP ability unlock requirements and increase gain by 50x
	XPBreakPoints(0)=(Level=500,XPRequired=500)
	XPBreakPoints(1)=(Level=1000,XPRequired=1000)
	XPBreakPoints(2)=(Level=2500,XPRequired=1500)//At this point the player should be able to solo
	XPBreakPoints(3)=(Level=5000,XPRequired=2500)
	XPBreakPoints(4)=(Level=10000,XPRequired=5000)
	XPBreakPoints(5)=(Level=50000,XPRequired=10000)
	StatCaps(0)=700
	StatCaps(1)=-1
	StatCaps(2)=-1
	StatCaps(3)=-1
	StatCaps(4)=-1
	StatCaps(5)=-1
	SaveDuringGameInterval=5
	LevelDiffExpGainDiv=2.000000
	MaxLevelupEffectStacking=1
	EXPForWin=50
	WeaponModifierChance=0.50000
	StartingLevel=50
	PointsPerLevel=25
	NoobBonusXP=2000
	SuperAmmoClassNames(0)="RedeemerAmmo"
	SuperAmmoClassNames(1)="BallAmmo"
	SuperAmmoClassNames(2)="SCannonAmmo"
	PropsDisplayText(0)="Autosave Interval (seconds)"
	PropsDisplayText(1)="Starting Level"
	PropsDisplayText(2)="Stat Points per Level"
	PropsDisplayText(3)="Divisor to EXP from Level Diff"
	PropsDisplayText(4)="EXP for Winning"
	PropsDisplayText(5)="Fake Bot Levels"
	PropsDisplayText(6)="Reset Player Data Next Game"
	PropsDisplayText(7)="Magic Weapon Chance"
	PropsDisplayText(8)="Magical Starting Weapons"
	PropsDisplayText(9)="No Unidentified Items"
	PropsDisplayText(10)="Auto Adjust Invasion Monster Level"
	PropsDisplayText(11)="Monster Adjustment Factor"
	PropsDisplayText(12)="Max Levelup Effects at Once"
	PropsDisplayText(13)="Stat Caps"
	PropsDisplayText(14)="EXP Required for Each Level"
	PropsDisplayText(15)="Allowed Abilities"
	PropsDescText(0)="During the game, all data will be saved every this many seconds."
	PropsDescText(1)="New players start at this Level."
	PropsDescText(2)="The number of stat points earned from a levelup."
	PropsDescText(3)="Lower values = more exp when killing someone of higher level."
	PropsDescText(4)="The EXP gained for winning a match."
	PropsDescText(5)="If checked, bots' data is not saved and instead they are simply given a level near that of the human player(s)."
	PropsDescText(6)="If checked, player data will be reset before the next match begins."
	PropsDescText(7)="Chance of any given weapon having magical properties."
	PropsDescText(8)="If checked, weapons given to players when they spawn can have magical properties."
	PropsDescText(9)="If checked, magical weapons will always be identified."
	PropsDescText(10)="If checked, Invasion monsters' level will be adjusted based on the lowest level player."
	PropsDescText(11)="Invasion monsters will be adjusted based on this fraction of the weakest player's level."
	PropsDescText(12)="The maximum number of levelup particle effects that can be spawned on a character at once."
	PropsDescText(13)="Limit on how high stats can go. Values less than 0 mean no limit. The stats are: 1: Weapon Speed 2: Health Bonus 3: Max Adrenaline 4: Damage Bonus 5: Damage Reduction 6: Max Ammo Bonus"
	PropsDescText(14)="Change the EXP required for each level. Levels after the last in your list will use the last value in the list."
	PropsDescText(15)="Change the list of abilities players can choose from."
	PropsExtras="0;Add Specified Value;1;Add Specified Percent"
	bAddToServerPackages=True
	GroupName="RPG"
	FriendlyName="Lumpys RPG"
	Description="UT2004RPG Modified by Lumpy with new abilities, artifacts, weapons, monsters, and more...."
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy

}
