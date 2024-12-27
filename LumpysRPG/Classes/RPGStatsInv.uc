//applies weapon stats to each player's weapon and manages client<->server interaction
//although attached to a player's Pawn so it can receive events from it, it is also the inventory of the
//Controller for persistence. Just before the Pawn dies the RPGStatsInv is removed from its inventory chain
//so it doesn't get destroyed, and is then reconnected to the Controller's new Pawn when it respawns.
class RPGStatsInv extends Inventory
	DependsOn(RPGPlayerDataObject);

var RPGPlayerDataObject DataObject; //object holding player's data (server side only)
var RPGPlayerDataObject.RPGPlayerData Data; //struct version of data in DataObject - replicated to clients to show on HUD and stat menu
var MutLumpysRPG RPGMut; //server side only
var array<class<RPGAbility> > AllAbilities; //all abilities available
var int StatCaps[6]; //curse the need for it
var RPGStatsMenu StatsMenu; //clients only - pointer to stats menu if it exists so we don't have to do an iterator search
var bool bGotInstigator; //netplay only - set to true first tick after Instigator has been replicated
var bool bMagicWeapons; //does the server have magic weapons enabled?
var bool bSentInitialData; //sent initial data that requires function replication (ability list, stat caps, etc)
var int ClientVersion; //sent from client to server so server knows client's version (for hacking around old version clients not having new classes)
// Used by the WopRpgInteraction for item display.
var Inventory CurrentItem;
var Inventory DisplayItem;
var Inventory NextItem;

//Drones
var array<LumpyDrone> DroneList;
var int MaxDrones;

struct OldRPGWeaponInfo
{
	var RPGWeapon Weapon;
	var class<Weapon> ModifiedClass;
};
var array<OldRPGWeaponInfo> OldRPGWeapons; //used to prevent throwing a weapon just to try for a different modifier

//bot multikill tracking (the stock code doesn't track multikills for bots)
var int BotMultiKillLevel;
var float BotLastKillTime;

enum EStatType
{
	STAT_WSpeed,
	STAT_HealthBonus,
	STAT_AdrenalineMax,
	STAT_Attack,
	STAT_Defense,
	STAT_AmmoMax
};

delegate ProcessPlayerLevel(string PlayerString);

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		bMagicWeapons;
	reliable if (bNetDirty && Role == ROLE_Authority)
		Data;
	reliable if (Role < ROLE_Authority)
		ServerAddPointTo, ServerAddAbility, ServerAddClass, ServerRequestPlayerLevels, ServerResetData, ServerSetVersion;
	reliable if (Role == ROLE_Authority)
		ClientUpdateStatMenu, ClientAddAbility, ClientAddClass, ClientAdjustFireRate, ClientSendPlayerLevel, ClientReInitMenu,
		ClientResetData, ClientReceiveAbilityInfo, ClientReceiveAllowedAbility, ClientReceiveStatCap,
		ClientModifyVehicle, ClientUnModifyVehicle;
	unreliable if (Role == ROLE_Authority)
		ClientAdjustMaxAmmo;
}

function GiveTo(pawn Other, optional Pickup Pickup)
{
	local Inventory Inv;
	local ShieldAltFire S;
	local int x;

	Super.GiveTo(Other, Pickup);

	//hack to make shieldgun charge to its new MaxAmmo value
	Inv = Instigator.FindInventoryType(class'ShieldGun');
	if (Inv != None)
	{
		S = ShieldAltFire(ShieldGun(Inv).GetFireMode(1));
		if (S != None)
			S.SetTimer(S.AmmoRegenTime, true);
	}

	if (!bSentInitialData)
	{
		if (Instigator.Controller != Level.GetLocalPlayerController())
			for (x = 0; x < Data.Abilities.length; x++)
				ClientReceiveAbilityInfo(x, Data.Abilities[x], Data.AbilityLevels[x]);
		for (x = 0; x < RPGMut.Abilities.length; x++)
			ClientReceiveAllowedAbility(x, RPGMut.Abilities[x]);
		for (x = 0; x < 6; x++)
			ClientReceiveStatCap(x, RPGMut.StatCaps[x]);

		bMagicWeapons = (RPGMut.WeaponModifierChance > 0);

		bSentInitialData = true;
	}

	OwnerEvent('ChangedWeapon'); //Set initial weapon's FireRate
	Timer(); //Set initial ammo's maxammo values
	SetTimer(0.2, false); // call it again in a bit in case some weapons/ammo don't get replicated immediately
}

function bool HandlePickupQuery(Pickup item)
{
	local bool bResult;

	bResult = Super.HandlePickupQuery(item);

	//we only set the timer (which updates MaxAmmo on all ammos the player owns) when the player picks up something
	//with ammo to save CPU - however, this makes it unsimulatable without function replication
	if (item != None && (item.IsA('Ammo') || item.IsA('WeaponLocker') || (!bResult && item.IsA('WeaponPickup'))))
		SetTimer(0.1, false);

	return bResult;
}

function OwnerEvent(name EventName)
{

	if (EventName == 'ChangedWeapon' && Instigator != None && Instigator.Weapon != None)
	{
		AdjustFireRate(Instigator.Weapon);
		ClientAdjustFireRate(); //OwnerEvent() is serverside-only, so need to call a client version
	}
	else if (EventName == 'RPGScoreKill')
	{
		//the stock code doesn't record multikills for bots, so do it here where we can track it and increment EXP appropriately
		//the fact that we can also add the info to the stats for the bots is a cool bonus :)
		//however, unlike the normal player multikill code, the multikill level is lost on death due to Inventory being lost on death
		if (Level.TimeSeconds - BotLastKillTime < 4)
		{
			Instigator.Controller.AwardAdrenaline(DeathMatch(Level.Game).ADR_MajorKill);
			if ( TeamPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None )
			{
				TeamPlayerReplicationInfo(Instigator.PlayerReplicationInfo).MultiKills[BotMultiKillLevel] += 1;
				if ( BotMultiKillLevel > 0 )
					TeamPlayerReplicationInfo(Instigator.PlayerReplicationInfo).MultiKills[BotMultiKillLevel-1] -= 1;
			}
			BotMultiKillLevel++;
			UnrealMPGameInfo(Level.Game).SpecialEvent(Instigator.PlayerReplicationInfo,"multikill_"$BotMultiKillLevel);
			DataObject.Experience += int(Square(float(BotMultiKillLevel)));
			RPGMut.CheckLevelUp(DataObject, Instigator.PlayerReplicationInfo);
		}
		else
			BotMultiKillLevel=0;

		BotLastKillTime = Level.TimeSeconds;
	}

	Super.OwnerEvent(EventName);
}

simulated function AdjustFireRate(Weapon W)
{
	local int x;
	local float Modifier;
	local WeaponFire FireMode[2];

	FireMode[0] = W.GetFireMode(0);
	FireMode[1] = W.GetFireMode(1);
	if (MinigunFire(FireMode[0]) != None) //minigun needs a hack because it fires differently than normal weapons
	{
		Modifier = 1.f + 0.01 * Data.WeaponSpeed;
		MinigunFire(FireMode[0]).BarrelRotationsPerSec = MinigunFire(FireMode[0]).default.BarrelRotationsPerSec * Modifier;
		MinigunFire(FireMode[0]).FireRate = 1.f / (MinigunFire(FireMode[0]).RoundsPerRotation * MinigunFire(FireMode[0]).BarrelRotationsPerSec);
		MinigunFire(FireMode[0]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[0]).BarrelRotationsPerSec;
		MinigunFire(FireMode[1]).BarrelRotationsPerSec = MinigunFire(FireMode[1]).default.BarrelRotationsPerSec * Modifier;
		MinigunFire(FireMode[1]).FireRate = 1.f / (MinigunFire(FireMode[1]).RoundsPerRotation * MinigunFire(FireMode[1]).BarrelRotationsPerSec);
		MinigunFire(FireMode[1]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[1]).BarrelRotationsPerSec;
	}
	else if (!FireMode[0].IsA('TransFire') && !FireMode[0].IsA('BallShoot') && !FireMode[0].IsA('MeleeSwordFire'))
	{
		Modifier = 1.f + 0.01 * Data.WeaponSpeed;
		if (FireMode[0] != None)
		{
			if (ShieldFire(FireMode[0]) != None) //shieldgun primary needs a hack to do charging speedup
				ShieldFire(FireMode[0]).FullyChargedTime = ShieldFire(FireMode[0]).default.FullyChargedTime / Modifier;
			FireMode[0].FireRate = FireMode[0].default.FireRate / Modifier;
			FireMode[0].FireAnimRate = FireMode[0].default.FireAnimRate * Modifier;
			FireMode[0].MaxHoldTime = FireMode[0].default.MaxHoldTime / Modifier;
		}
		if (FireMode[1] != None)
		{
			FireMode[1].FireRate = FireMode[1].default.FireRate / Modifier;
			FireMode[1].FireAnimRate = FireMode[1].default.FireAnimRate * Modifier;
			FireMode[1].MaxHoldTime = FireMode[1].default.MaxHoldTime / Modifier;
		}
	}
	for (x = 0; x < Data.Abilities.length; x++)
		Data.Abilities[x].static.ModifyWeapon(W, Data.AbilityLevels[x]);
}

//Call AdjustFireRate() clientside
simulated function ClientAdjustFireRate()
{
	if (Instigator != None && Instigator.Weapon != None)
	{
		AdjustFireRate(Instigator.Weapon);
	}
}

//Adjust player's maxammo values and then call ClientAdjustMaxAmmo() to do same on client
function Timer()
{
	if (Instigator != None)
	{
		AdjustMaxAmmo();
		ClientAdjustMaxAmmo();
	}
}

simulated function AdjustMaxAmmo()
{
	local Inventory Inv;
	local Ammunition Ammo;
	local int Count;
	local float Modifier;

	Modifier = 1.0 + float(Data.AmmoMax) * 0.01;
	for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		Ammo = Ammunition(Inv);
		if (Ammo != None)
		{
			Ammo.MaxAmmo = Ammo.default.MaxAmmo * Modifier;
			if (Ammo.AmmoAmount > Ammo.MaxAmmo)
				Ammo.AmmoAmount = Ammo.MaxAmmo;
			if (!class'MutLumpysRPG'.static.IsSuperWeaponAmmo(Ammo.Class))
			{
				Ammo.InitialAmount = Ammo.default.InitialAmount * Modifier;
			}
		}
		Count++;
		if (Count > 1000)
			break;
	}
}

//Call AdjustMaxAmmo() clientside
simulated function ClientAdjustMaxAmmo()
{
	local Inventory Inv;
	local int Count;

	if (Level.NetMode == NM_Client && Instigator != None)
		AdjustMaxAmmo();
	// need ammo instances for Max Ammo stat to work without magic weapons
	// I hate this but I couldn't think of a better way
	if (!bMagicWeapons)
	{
		for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			if (Inv.IsA('Weapon'))
			{
				Weapon(Inv).bNoAmmoInstances = false;
			}
			Count++;
			if (Count > 1000)
			{
				break;
			}
		}
	}
}

function DropFrom(vector StartLocation)
{
	if (Instigator != None && Instigator.Controller != None)
		SetOwner(Instigator.Controller);
}

//owning pawn died
function OwnerDied()
{
	local int x;
	local Controller C;

	for (x = 0; x < OldRPGWeapons.Length; x++)
		if (OldRPGWeapons[x].Weapon != None)
			OldRPGWeapons[x].Weapon.RemoveReference();
	OldRPGWeapons.length = 0;

	//prevent RPGStatsInv from being destroyed and keep it relevant to owning player
	if (Instigator != None)
	{
		C = Instigator.Controller;
		if (C == None && Instigator.DrivenVehicle != None)
			C = Instigator.DrivenVehicle.Controller;
		Instigator.DeleteInventory(self);
		SetOwner(C);
	}
}

//returns true and sends a message to the player if the game is already restarting (servertraveling or voting for next map)
function bool GameRestarting()
{
	local PlayerController PC;

	if (Level.Game.bGameRestarted)
	{
		// we can get here if game restart was interrupted by mapvote
		// DataObject has already been cleared so we can't do anything but tell the player to try again later
		if (Instigator != None)
		{
			PC = PlayerController(Instigator.Controller);
		}
		if (PC == None)
		{
			PC = PlayerController(Owner);
		}
		if (PC != None)
		{
			//FIXME should be clientside message but can't add new server-to-client function
			//because it would break compatibility
			PC.ClientOpenMenu("GUI2K4.UT2K4GenericMessageBox",,, "Sorry, you cannot use stat points once endgame voting has begun.");
		}

		return true;
	}

	return false;
}

//Called by owning player's stat menu to add stat points to a statistic
function ServerAddPointTo(int Amount, EStatType Stat)
{
	if (GameRestarting())
	{
		return;
	}

	if (DataObject.PointsAvailable < Amount)
		return;

	switch (Stat)
	{
		case STAT_WSpeed:
			if (RPGMut.StatCaps[0] >= 0 && RPGMut.StatCaps[0] - DataObject.WeaponSpeed < Amount)
				Amount = RPGMut.StatCaps[0] - DataObject.WeaponSpeed;
			DataObject.WeaponSpeed += Amount;
			Data.WeaponSpeed = DataObject.WeaponSpeed;
			break;
		case STAT_HealthBonus:
			if (RPGMut.StatCaps[1] >= 0 && RPGMut.StatCaps[1] - DataObject.HealthBonus < Amount * 2)
				Amount = (RPGMut.StatCaps[1] - DataObject.HealthBonus) / 2;
			DataObject.HealthBonus += 2 * Amount;
			Data.HealthBonus = DataObject.HealthBonus;
			if (Instigator != None)
			{
				Instigator.HealthMax += 2 * Amount;
				Instigator.SuperHealthMax += 2 * Amount;
			}
			break;
		case STAT_AdrenalineMax:
			if (RPGMut.StatCaps[2] >= 0 && RPGMut.StatCaps[2] - DataObject.AdrenalineMax < Amount)
				Amount = RPGMut.StatCaps[2] - DataObject.AdrenalineMax;
			DataObject.AdrenalineMax += Amount;
			Data.AdrenalineMax = DataObject.AdrenalineMax;
			if (Instigator != None && Instigator.Controller != None)
				Instigator.Controller.AdrenalineMax += Amount;
			break;
		case STAT_Attack:
			if (RPGMut.StatCaps[3] >= 0 && RPGMut.StatCaps[3] - DataObject.Attack < Amount)
				Amount = RPGMut.StatCaps[3] - DataObject.Attack;
			DataObject.Attack += Amount;
			Data.Attack = DataObject.Attack;
			break;
		case STAT_Defense:
			if (RPGMut.StatCaps[4] >= 0 && RPGMut.StatCaps[4] - DataObject.Defense < Amount)
				Amount = RPGMut.StatCaps[4] - DataObject.Defense;
			DataObject.Defense += Amount;
			Data.Defense = DataObject.Defense;
			break;
		case STAT_AmmoMax:
			if (RPGMut.StatCaps[5] >= 0 && RPGMut.StatCaps[5] - DataObject.AmmoMax < Amount)
				Amount = RPGMut.StatCaps[5] - DataObject.AmmoMax;
			DataObject.AmmoMax += Amount;
			Data.AmmoMax = DataObject.AmmoMax;
			break;
	}
	DataObject.PointsAvailable -= Amount;
	Data.PointsAvailable = DataObject.PointsAvailable;

	ClientUpdateStatMenu(Amount, Stat);
}

//After server adds points to a statistic, it calls this to update the local player's stat menu
simulated function ClientUpdateStatMenu(int Amount, EStatType Stat)
{
	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		switch (Stat)
		{
			case STAT_WSpeed:
				Data.WeaponSpeed += Amount;
				break;
			case STAT_HealthBonus:
				Data.HealthBonus += 2 * Amount;
				break;
			case STAT_AdrenalineMax:
				Data.AdrenalineMax += Amount;
				if (Instigator != None && Instigator.Controller != None)
					Instigator.Controller.AdrenalineMax += Amount;
				break;
			case STAT_Attack:
				Data.Attack += Amount;
				break;
			case STAT_Defense:
				Data.Defense += Amount;
				break;
			case STAT_AmmoMax:
				Data.AmmoMax += Amount;
				break;
		}
		Data.PointsAvailable -= Amount;
	}

	if (StatsMenu != None)
		StatsMenu.InitFor(self);
}
static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2)
		return "You can Only subclass after level 1000";
  else if (Switch == 3)
		return "You must first reach the Maximum Level in at least 1 class to purchase points in a different one";
	else if (Switch == 4)
		return "You must first reach the Maximum Level in at least 2 classes to purchase points in a different one";

	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}
function AddClass(class<RPGClass> SelectedClass, int index)
{
	local int Cost;

	DataObject.ClassAbilities[index] = SelectedClass;
	DataObject.ClassLevels[index]++;
	Cost = SelectedClass.static.Cost(DataObject, DataObject.ClassLevels[index]);
	DataObject.ClassPoints -= Cost;
	Data.ClassAbilities[index] = SelectedClass;
	Data.ClassLevels[index]++;
	Data.ClassPoints = DataObject.ClassPoints;
}
//Please let me find a better way to do this
function ServerAddClass(class<RPGClass> SelectedClass)
{
	local int x, Index, Cost, Count;
	Log("Add Class Called");
	if (GameRestarting())
	{
		return;
	}
//BEGIN SWITCH
	switch (DataObject.ClassAbilities.length)
	{
		case 0:
			Log("Add Class Called : Case 0");
			DataObject.ClassLevels[Index] = 0;
			Data.ClassLevels[Index] = 0;
			Count = DataObject.ClassAbilities.length;
			AddClass(SelectedClass, Count);
			break;

		case 1:
			Log("Add Class Called : Case 1");
			if(DataObject.Level < 1000)
			{
				if (SelectedClass == DataObject.ClassAbilities[0])//we already have the ability allow the upgrade
				{
					Count = 0;
					AddClass(SelectedClass, Count);
					break;
				}else{//The player is trying to subclass
					//Send an error that subclassing is not available for players below level 1000 and return
					Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
					GotoState('');
					return;
				}
			}
			else if(SelectedClass == DataObject.ClassAbilities[0])
			{
				Count = 0;
				AddClass(SelectedClass, Count);
				break;
			}
			else
			{//The player is able to subclass, so let them buy it even if its different
				Count = DataObject.ClassAbilities.length;
				DataObject.ClassLevels[Count] = 0;
				Data.ClassLevels[Count] = 0;
				Log("We should have subclassed");
				AddClass(SelectedClass, Count);
				break;
			}
		case 2:
			if (SelectedClass == DataObject.ClassAbilities[0] || SelectedClass == DataObject.ClassAbilities[1])// we already have the ability allow the upgrade
			{
				if (SelectedClass == DataObject.ClassAbilities[0])
						Count = 0;
				else
						Count = 1;

				AddClass(SelectedClass, Count);
				break;
			}
			//Player is trying to add a new class, make sure they have one maxxed out first
			if (DataObject.ClassLevels[0] < 20 && DataObject.ClassLevels[1] < 20)
			{
				//supply an error message about how they need to max out one class before they can subclass into another one
				Instigator.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
				GotoState('');
				return;
			}
			else //at least one abilit is maxed, Allow the purhcase of another
			{
				DataObject.ClassLevels[2] = 0;
				Data.ClassLevels[2] = 0;
				AddClass(SelectedClass, 2);
				break;
			}
		case 3:
			if (SelectedClass == DataObject.ClassAbilities[0] || SelectedClass == DataObject.ClassAbilities[1] || SelectedClass == DataObject.ClassAbilities[2])
			{// we already have the ability allow the upgrade
				if (SelectedClass == DataObject.ClassAbilities[0])
						Count = 0;
				else if (SelectedClass == DataObject.ClassAbilities[1])
						Count = 1;
				else if (SelectedClass == DataObject.ClassAbilities[2])
						Count = 2;

				AddClass(SelectedClass, Count);
				break;
			}
			//Player is trying to add a new class, make sure they have 3 maxxed out first
			if (DataObject.ClassLevels[0] < 20 && DataObject.ClassLevels[1] < 20 && DataObject.ClassLevels[2] < 20)
			{
				//supply an error message about how they need to max out one class before they can subclass into another one
				Instigator.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
				GotoState('');
				return;
			}
			else//all three abilities are maxxed, allow upgrades of anything
			{
				DataObject.ClassLevels[3] = 0;
				Data.ClassLevels[3] = 0;
				AddClass(SelectedClass, Count);
				break;
			}

		case 4:
			for (x = 0; x < DataObject.ClassAbilities.length; x++)
				if (DataObject.ClassAbilities[x] == SelectedClass)
				{
				AddClass(SelectedClass, x);
				break;
				}
				else//New Class
				AddClass(SelectedClass, DataObject.ClassAbilities.length);
				break;

		case 5:
		for (x = 0; x < DataObject.ClassAbilities.length; x++)
			if (DataObject.ClassAbilities[x] == SelectedClass)
			{
			AddClass(SelectedClass, x);
			break;
			}
	}

	ClientAddClass(SelectedClass, Cost);
}

simulated function ClientAddClass(class<RPGClass> SelectedClass, int Cost)
{
	local int x, Index;

	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		Index = -1;
		for (x = 0; x < Data.ClassAbilities.length; x++)
			if (Data.ClassAbilities[x] == SelectedClass)
			{
				Index = x;
				break;
			}
		if (Index == -1)
		{
			Index = Data.ClassAbilities.length;
			Data.ClassLevels[Index] = 0;
		}

		Data.ClassAbilities[Index] = SelectedClass;
		Data.ClassLevels[Index]++;
		Data.ClassPoints -= Cost;

		//Activate ability immediately
	}

	if (StatsMenu != None)
		StatsMenu.InitFor(self);
}

//Called by owning player's stat menu to buy an ability
function ServerAddAbility(class<RPGAbility> Ability)
{
	local int x, Index, Cost;
	local bool bAllowed;

	if (GameRestarting())
	{
		return;
	}

	bAllowed = false;
	for (x = 0; x < RPGMut.Abilities.length; x++)
		if (RPGMut.Abilities[x] == Ability)
		{
			bAllowed = true;
			break;
		}
	if (!bAllowed)
		return;

	Index = -1;
	for (x = 0; x < DataObject.Abilities.length; x++)
		if (DataObject.Abilities[x] == Ability)
		{
			Cost = Ability.static.Cost(DataObject, DataObject.AbilityLevels[x]);
			if (Cost <= 0 || Cost > DataObject.PointsAvailable)
				return;
			Index = x;
			break;
		}
	if (Index == -1)
	{
		Cost = Ability.static.Cost(DataObject, 0);
		if (Cost <= 0 || Cost > DataObject.PointsAvailable)
			return;
		Index = DataObject.Abilities.length;
		DataObject.AbilityLevels[Index] = 0;
		Data.AbilityLevels[Index] = 0;
	}

	DataObject.Abilities[Index] = Ability;
	DataObject.AbilityLevels[Index]++;
	DataObject.PointsAvailable -= Cost;
	Data.Abilities[Index] = Ability;
	Data.AbilityLevels[Index]++;
	Data.PointsAvailable = DataObject.PointsAvailable;

	//Activate ability immediately
	if (Instigator != None)
	{
		Ability.static.ModifyPawn(Instigator, DataObject.AbilityLevels[Index]);
		if (Instigator.Weapon != None)
			Ability.static.ModifyWeapon(Instigator.Weapon, DataObject.AbilityLevels[Index]);
		if (Instigator.Controller != None && Vehicle(Instigator.Controller.Pawn) != None)
			ModifyVehicle(Vehicle(Instigator.Controller.Pawn));
	}

	//Send to client
	ClientAddAbility(Ability, Cost);
}

//After server adds an ability, it calls this to do the same on the client
simulated function ClientAddAbility(class<RPGAbility> Ability, int Cost)
{
	local int x, Index;

	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		Index = -1;
		for (x = 0; x < Data.Abilities.length; x++)
			if (Data.Abilities[x] == Ability)
			{
				Index = x;
				break;
			}
		if (Index == -1)
		{
			Index = Data.Abilities.length;
			Data.AbilityLevels[Index] = 0;
		}

		Data.Abilities[Index] = Ability;
		Data.AbilityLevels[Index]++;
		Data.PointsAvailable -= Cost;

		//Activate ability immediately
		if (Instigator != None)
		{
			Ability.static.ModifyPawn(Instigator, Data.AbilityLevels[Index]);
			if (Instigator.Weapon != None)
				Ability.static.ModifyWeapon(Instigator.Weapon, Data.AbilityLevels[Index]);
			if (Instigator.Controller != None && Vehicle(Instigator.Controller.Pawn) != None)
				ModifyVehicle(Vehicle(Instigator.Controller.Pawn));
		}
	}

	if (StatsMenu != None)
		StatsMenu.InitFor(self);
}

simulated function Tick(float deltaTime)
{
	local bool bLevelUp;
	local int x;
	local float RealNextFireTime;
	local WeaponFire FireMode[2];

	//Set initial values clientside (e.g. ModifyPawn() changes that don't get replicated for whatever reason)
	//We don't use PostNetBeginPlay() because it doesn't seem to be guaranteed that the values have all been replicated
	//at the time that function is called
	if (Level.NetMode == NM_Client)
	{
		if (Instigator != None && Instigator.Controller != None)
		{
			CheckPlayerViewShake();
			if (!bGotInstigator)
			{
				Instigator.Controller.AdrenalineMax = Data.AdrenalineMax;
				for (x = 0; x < Data.Abilities.length; x++)
					Data.Abilities[x].static.ModifyPawn(Instigator, Data.AbilityLevels[x]);
				bGotInstigator = true;
			}
		}
		else
			bGotInstigator = false;

		return;
	}

	if (Instigator != None)
	{
		CheckPlayerViewShake();

		//Awful hack to get around WeaponFire capping FireRate to tick delta
		if (Instigator.Weapon != None)
		{
			FireMode[0] = Instigator.Weapon.GetFireMode(0);
			FireMode[1] = Instigator.Weapon.GetFireMode(1);
			if (FireMode[0] != None && FireMode[0].bIsFiring && !FireMode[0].bFireOnRelease && !FireMode[0].bNowWaiting)
			{
				x = 0;
				while (FireMode[0].NextFireTime + FireMode[0].FireRate < Level.TimeSeconds && x < 10000)
				{
					RealNextFireTime = FireMode[0].NextFireTime + FireMode[0].FireRate;
					FireMode[0].ModeDoFire();
					FireMode[0].NextFireTime = RealNextFireTime;
					x++;
				}
			}
			if (FireMode[1] != None && FireMode[1].bIsFiring && !FireMode[1].bFireOnRelease && !FireMode[1].bNowWaiting)
			{
				x = 0;
				while (FireMode[1].NextFireTime + FireMode[1].FireRate < Level.TimeSeconds && x < 10000)
				{
					RealNextFireTime = FireMode[1].NextFireTime + FireMode[1].FireRate;
					FireMode[1].ModeDoFire();
					FireMode[1].NextFireTime = RealNextFireTime;
					x++;
				}
			}
		}
	}

	//update data with 'official' data from mutator if necessary
	if (DataObject.Experience != Data.Experience || DataObject.Level != Data.Level)
	{
		if (DataObject.Level > Data.Level)
			bLevelUp = true;
		DataObject.CreateDataStruct(Data, true);
		if (bLevelUp)
			ClientReInitMenu();
	}
			
}

//High level players can potentially take a lot of damage in one hit, which screws up PlayerController
//viewshaking functions because they're scaled to damage but not capped so if a player survives
//a high damage hit it'll totally screw up his screen.
simulated function CheckPlayerViewShake()
{
	local PlayerController PC;
	local float ShakeScaling;

	PC = PlayerController(Instigator.Controller);
	if (PC == None)
		return;

	ShakeScaling = VSize(PC.ShakeRotMax) / 7500;
	if (ShakeScaling <= 1)
		return;

	PC.ShakeRotMax /= ShakeScaling;
	PC.ShakeRotTime /= ShakeScaling;
	PC.ShakeOffsetMax /= ShakeScaling;
}

//Just update the menu. Used when a levelup occurs while the menu is open (rare, but possible)
simulated function ClientReInitMenu()
{
	if (StatsMenu != None)
		StatsMenu.InitFor(self);
}

simulated function Destroyed()
{
	local int x;
	local PlayerController PC;

	if (Role == ROLE_Authority)
	{
		for (x = 0; x < OldRPGWeapons.Length; x++)
			if (OldRPGWeapons[x].Weapon != None)
				OldRPGWeapons[x].Weapon.RemoveReference();
		OldRPGWeapons.length = 0;
	}

	if (StatsMenu != None)
		StatsMenu.StatsInv = None;
	StatsMenu = None;

	DataObject = None;

	//Log("DESTROYED"@self);
	//if (Instigator != None)
	//	Log(self@"BELONGED TO"@Instigator);

	//since various gametypes enjoy destroying pawns (and thus their inventory) without giving notification,
	//it's possible for RPGStatsInv to get destroyed while the player owning it is still playing. Since there's
	//no way to prevent the destruction, the only choice is to reset everything and wait for a new one.
	if (Level.NetMode != NM_DedicatedServer)
	{
		PC = Level.GetLocalPlayerController();
		if (PC.Player != None)
		{
			for (x = 0; x < PC.Player.LocalInteractions.length; x++)
			{
				if (RPGInteraction(PC.Player.LocalInteractions[x]) != None && RPGInteraction(PC.Player.LocalInteractions[x]).StatsInv == self)
				{
					RPGInteraction(PC.Player.LocalInteractions[x]).StatsInv = None;
					//this is a horrible memory leak, not to mention potential stats loss, so print a big warning
					Log("RPGStatsInv destroyed prematurely!", 'Warning');
				}
			}
		}
	}

	Super.Destroyed();
}

function ServerRequestPlayerLevels()
{
	local Controller C;
	local Inventory Inv;
	local RPGStatsInv StatsInv;

	if (RPGMut == None || Level.Game.bGameRestarted)
		return;

	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if (C.bIsPlayer)
		{
			for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
			{
				StatsInv = RPGStatsInv(Inv);
				if (StatsInv != None)
					ClientSendPlayerLevel(StatsInv.DataObject.Name$": "$StatsInv.DataObject.Level);
			}
		}
	}
}

simulated function ClientSendPlayerLevel(string PlayerString)
{
	ProcessPlayerLevel(PlayerString);
}

//Reset the player's data. Called by the client from the stats menu, after clicking the obscenely small button and confirming it
function ServerResetData(PlayerReplicationInfo PRI)
{
	local string OwnerID;

	if (RPGMut != None && !Level.Game.bGameRestarted && DataObject.Level >= RPGMut.StartingLevel)
	{
		OwnerID = DataObject.OwnerID;

		// hmmm... ClearConfig() doesn't reset the actual object instance
		// and ResetConfig() just plain crashes.
		DataObject.ClearConfig();
		DataObject = new(None, string(DataObject.Name)) class'RPGPlayerDataObject';

		DataObject.OwnerID = OwnerID;
		DataObject.Level = RPGMut.StartingLevel;
		DataObject.PointsAvailable = RPGMut.PointsPerLevel * (RPGMut.StartingLevel) + 2000;
		DataObject.ClassPoints = 50;
		DataObject.AdrenalineMax = 100;
		DataObject.NeededExp = RPGMut.GetNeededXP(DataObject.Level);
		DataObject.CreateDataStruct(data, false);
		if (Instigator != None && Instigator.Health > 0)
		{
			Level.Game.SetPlayerDefaults(Instigator);
			OwnerEvent('ChangedWeapon');
			Timer();
		}
		Level.Game.BroadCastLocalized(self, class'GainLevelMessage', Data.Level, PRI);
		if (RPGMut.HighestLevelPlayerName ~= string(DataObject.Name))
		{
			//FIXME highest level player will be incorrect until the next time the real highest level
			//player logs on. Fixable, but it would be really slow, so not going to bother unless
			//someone really cares.
			RPGMut.HighestLevelPlayerLevel = 0;
			RPGMut.SaveConfig();
		}
		ClientResetData();
	}
}

simulated function ClientResetData()
{
	Log("Client Data Reset");
	Data.Abilities.length = 0;
	Data.ClassAbilities.length = 0;
	Data.AbilityLevels.length = 0;
	Data.ClassLevels.length = 0;
}

simulated function ClientReceiveAbilityInfo(int Index, class<RPGAbility> Ability, int Level)
{
	Data.Abilities[Index] = Ability;
	Data.AbilityLevels[Index] = Level;
}

simulated function ClientReceiveAllowedAbility(int Index, class<RPGAbility> Ability)
{
	AllAbilities[Index] = Ability;
}

//Even though it's a static length array, StatCaps doesn't seem to replicate the normal way...
simulated function ClientReceiveStatCap(int Index, int Cap)
{
	StatCaps[Index] = Cap;

	//FIXME compatibility hack to send version - should have server call a function to ask, but that breaks
	//old versions that don't have the function
	if (Index == ArrayCount(StatCaps) - 1)
	{
		ServerSetVersion(class'MutLumpysRPG'.static.GetVersion());
	}
}

function ServerSetVersion(int Version)
{
	ClientVersion = Version;
}

simulated function ModifyVehicle(Vehicle V)
{
	local int i;
	local ONSVehicle OV;
	local ONSWeaponPawn WP;

	//for some reason we need this to continue sending data updates to the client
	if (Owner == Instigator)
		SetOwner(V);

	OV = ONSVehicle(V);
	if (OV != None)
	{
		for (i = 0; i < OV.Weapons.length; i++)
			OV.Weapons[i].SetFireRateModifier(1.f + 0.01 * Data.WeaponSpeed);
	}
	else
	{
		WP = ONSWeaponPawn(V);
		if (WP != None)
			WP.Gun.SetFireRateModifier(1.f + 0.01 * Data.WeaponSpeed);
		else if (V.Weapon != None) //some other type of vehicle using standard weapon system
			AdjustFireRate(V.Weapon);
	}

	for (i = 0; i < Data.Abilities.length; i++)
		Data.Abilities[i].static.ModifyVehicle(V, Data.AbilityLevels[i]);
}

simulated function ClientModifyVehicle(Vehicle V)
{
	if (V != None)
		ModifyVehicle(V);
}

simulated function UnModifyVehicle(Vehicle V)
{
	local int i;

	if (Owner == V)
		SetOwner(Instigator);

	for (i = 0; i < Data.Abilities.length; i++)
		Data.Abilities[i].static.UnModifyVehicle(V, Data.AbilityLevels[i]);
}

simulated function ClientUnModifyVehicle(Vehicle V)
{
	if (V != None)
		UnModifyVehicle(V);
}

defaultproperties
{
    bReplicateInstigator=True
	MessageClass=class'StringMessagePlus'
	bNetNotify=True
}
