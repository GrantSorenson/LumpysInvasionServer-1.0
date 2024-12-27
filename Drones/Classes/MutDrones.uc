class MutDrones extends Mutator config(Drones);

var localized string GUIDisplayText[6];
var localized string GUIDescText[6];

var config int ProjDamage;
var config int HealPerSec;
var config int ShotDelay;
var config int TargetDelay;
var config bool bPickup;
var config int spawnProb;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting(default.GameGroup,"ProjDamage",GetDisplayText("ProjDamage"),0,2,"Text","2;1:99");
	PlayInfo.AddSetting(default.GameGroup,"HealPerSec",GetDisplayText("HealPerSec"),0,2,"Text","2;1:50");
	PlayInfo.AddSetting(default.GameGroup,"ShotDelay",GetDisplayText("ShotDelay"),0,2,"Text","2;1:20",,,True);
	PlayInfo.AddSetting(default.GameGroup,"TargetDelay",GetDisplayText("TargetDelay"),0,2,"Text","2;1:99",,,True);
	PlayInfo.AddSetting(default.GameGroup,"bPickup",GetDisplayText("bPickup"),0,2,"Check");
	PlayInfo.AddSetting(default.GameGroup,"spawnProb",GetDisplayText("spawnProb"),0,2,"Text","3;1:100");
}

function ModifyPlayer(Pawn Other)
{
	if(!bPickup)
		SpawnDrone(Other.Location+vect(0,-32,64),Other.Rotation,Other);
	if(NextMutator != None)
		NextMutator.ModifyPlayer(Other);
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local DroneSpawner ds;
	bSuperRelevant=0;
	if(bPickup)
	{
		if(xPickUpBase(Other) != None && string(xPickUpBase(Other).PowerUp) ~= "XPickups.HealthPack")
		{
			ds = Spawn(class'DroneSpawner',,,Other.Location + vect(0,0,1)*(xPickUpBase(Other).SpawnHeight+48),rotator(vect(0,0,0)));
			ds.ProjDamage=ProjDamage;
			ds.HealPerSec=HealPerSec;
			ds.ShotDelay=ShotDelay;
			ds.TargetDelay=TargetDelay;
			ds.spawnProb=spawnProb;
			return false;
		}
	}
	return true;
}

function SpawnDrone(vector SpawnLoc, rotator SpawnRot, optional Pawn Owner)
{
	local Drone drone;
	drone = Spawn(class'Drone',Owner,,SpawnLoc,SpawnRot);
	drone.protPawn = Owner;
	drone.ProjDamage = ProjDamage;
	drone.HealPerSec = HealPerSec;
	drone.ShotDelay = ShotDelay;
	drone.TargetDelay = TargetDelay;
	drone.bActive = !bPickup;
}

static function string GetDisplayText(string PropName)
{
	switch(PropName)
	{
		case "ProjDamage":	return default.GUIDisplayText[0];
		case "HealPerSec":	return default.GUIDisplayText[1];
		case "ShotDelay":	return default.GUIDisplayText[2];
		case "TargetDelay":	return default.GUIDisplayText[3];
		case "bPickup":		return default.GUIDisplayText[4];
		case "spawnProb":	return default.GUIDisplayText[5];
	}
}

static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
		case "ProjDamage":	return default.GUIDescText[0];
		case "HealPerSec":	return default.GUIDescText[1];
		case "ShotDelay":	return default.GUIDescText[2];
		case "TargetDelay":	return default.GUIDescText[3];
		case "bPickup":		return default.GUIDescText[4];
		case "spawnProb":	return default.GUIDescText[5];
	}
	return Super.GetDescriptionText(PropName);
}

defaultproperties
{
    GUIDisplayText(0)="Damage"
    GUIDisplayText(1)="Health given"
    GUIDisplayText(2)="Delay between shots"
    GUIDisplayText(3)="Targeting interval"
    GUIDisplayText(4)="Pickups"
    GUIDisplayText(5)="Spawn probability"
    GUIDescText(0)="Amount of damage done by each drone projectile"
    GUIDescText(1)="Amount healed per second"
    GUIDescText(2)="Firing interval, measured in tenths of a second"
    GUIDescText(3)="Amount of time it takes for drones to spot a target. Also determines how long they must be without a target to start healing. Measured in tenths of a second."
    GUIDescText(4)="Drones are not given to players at spawn; instead, they appear randomly over health pickups."
    GUIDescText(5)="Probability (in percent) that a drone will spawn over each health pickup."
    ProjDamage=9
    HealPerSec=10
    ShotDelay=6
    TargetDelay=15
    spawnProb=50
    GroupName="Drones"
    FriendlyName="Drones 1.3"
    Description="Gives each player a drone that heals them and attacks their enemies."
}
