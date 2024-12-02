//The artifact manager spawns artifacts at random PathNodes.
//It tries to make sure there's at least one artifact of every type available
//Monster drop table is based in ut2004rpg ini, those values will overwrite? this table
class RPGArtifactManager extends Info
	config(UT2004RPG);

var config int ArtifactDelay; //spawn an artifact every this many seconds - zero disables
var config int MaxArtifacts;
var config int MaxHeldArtifacts; //maximum number of artifacts a player can hold
var config array<class<RPGArtifact> > Artifacts; // FIXME: obsolete, for backwards compatibility
struct ArtifactChance
{
	var class<RPGArtifact> ArtifactClass;
	var int Chance;
};
var config array<ArtifactChance> AvailableArtifacts;
var int TotalArtifactChance; // precalculated total Chance of all artifacts
var array<RPGArtifact> CurrentArtifacts;
var array<PathNode> PathNodes;

var localized string PropsDisplayText[3];
var localized string PropsDescText[3];

function PostBeginPlay()
{
	// local NavigationPoint N;
	// local int x;
	//
	// Super.PostBeginPlay();
	//
	// for (x = 0; x < AvailableArtifacts.length; x++)
	// 	if (AvailableArtifacts[x].ArtifactClass == None || !AvailableArtifacts[x].ArtifactClass.static.ArtifactIsAllowed(Level.Game))
	// 	{
	// 		AvailableArtifacts.Remove(x, 1);
	// 		x--;
	// 	}
	//
	// if (ArtifactDelay > 0 && MaxArtifacts > 0 && AvailableArtifacts.length > 0)
	// {
	// 	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	// 		if (PathNode(N) != None && !N.IsA('FlyingPathNode'))
	// 			PathNodes[PathNodes.length] = PathNode(N);
	//
	// 	for (x = 0; x < AvailableArtifacts.length; x++)
	// 	{
	// 		TotalArtifactChance += AvailableArtifacts[x].Chance;
	// 	}
	// }
	// else
	// 	Destroy();
}

function MatchStarting()
{
	// SetTimer(ArtifactDelay, true);
}

// select a random artifact based on the Chance entries in the artifact list and return its index
function int GetRandomArtifactIndex()
{
	// local int i;
	// local int Chance;
	//
	// Chance = Rand(TotalArtifactChance);
	// for (i = 0; i < AvailableArtifacts.Length; i++)
	// {
	// 	Chance -= AvailableArtifacts[i].Chance;
	// 	if (Chance < 0)
	// 	{
	// 		return i;
	// 	}
	// }
}

function Timer()
{
	// local int Chance, Count, x;
	// local bool bTryAgain;
	//
	// for (x = 0; x < CurrentArtifacts.length; x++)
	// 	if (CurrentArtifacts[x] == None)
	// 	{
	// 		CurrentArtifacts.Remove(x, 1);
	// 		x--;
	// 	}
	//
	// if (CurrentArtifacts.length >= MaxArtifacts)
	// 	return;
	//
	// 	Chance = GetRandomArtifactIndex();
	// 	SpawnArtifact(Chance);

//WE WANT MORE THAN ONE OF EVERYTHING IF A PLAYER HASNT GOTTEN ARTIFACTS
	// if (CurrentArtifacts.length >= AvailableArtifacts.length)
	// {
	// 	//there's one of everything already
	// 	Chance = GetRandomArtifactIndex();
	// 	SpawnArtifact(Chance);
	// 	return;
	// }

//THIS IS PRETTY SHODDY MATE
// 	while (Count < 250)
// 	{
// 		// FIXME: make this not slow (just advance through list until we find one that isn't in use)
// 		Chance = GetRandomArtifactIndex();
// 		for (x = 0; x < CurrentArtifacts.length; x++)
// 			if (CurrentArtifacts[x].Class == AvailableArtifacts[Chance].ArtifactClass)
// 			{
// 				bTryAgain = true;
// 				x = CurrentArtifacts.length;
// 			}
// 		if (!bTryAgain)
// 		{
// 			SpawnArtifact(Chance);
// 			return;
// 		}
// 		bTryAgain = false;
// 		Count++;
// 	}
 }
//this has been adjusted so monsters drop items more frequently
function SpawnArtifact(int Index)
{
	// local Pickup APickup;
	// local Inventory Inv;
	// local Controller C;
	// local RPGArtifact newArt;
	// local int NumMonsters, PickedMonster, CurrentMonster, count;
	//
	// if (Level.Game.IsA('Invasion'))
	// {
	// 	NumMonsters = int(Level.Game.GetPropertyText("NumMonsters"));
	//
	// 	if (NumMonsters == 0)
	// 		return;
	//
	// 	if (NumMonsters * 5 <= CurrentArtifacts.length)
	// 		return;
	// 	do
	// 	{
	// 		PickedMonster = Rand(NumMonsters);
	//
	// 		for (C = Level.ControllerList; C != None; C = C.NextController)
	// 			if (C.Pawn != None && C.Pawn.IsA('Monster') && !C.IsA('FriendlyMonsterController'))
	// 			{
	// 				if (CurrentMonster >= PickedMonster){
	// 					Inv = C.Pawn.Inventory;
	// 					count = 0;
	// 					while (Inv != None){
	// 						if (RPGArtifact(Inv) != None){
	// 							++count;
	// 						}
	//
	// 						Inv = Inv.Inventory;
	// 					}
	// 					if (count >= 5){
	// 						++CurrentMonster;
	// 					}
	// 				}
	//
	//
	// 					//Assumes monster doesn't get inventory from anywhere else!
	// 					if (RPGArtifact(C.Pawn.Inventory) == None)
	// 					{
	// 						newArt = spawn(AvailableArtifacts[Index].ArtifactClass);
	// 						newArt.GiveTo(C.Pawn);
	// 						break;
	// 					}
	// 				}
	// 				else
	// 					CurrentMonster++;
	//
	// 	} until (newArt != None)
	//
	// 	if (newArt != None)
	// 		CurrentArtifacts[CurrentArtifacts.length] = newArt;
	// }
	// else
	// {
	// 	APickup = spawn(AvailableArtifacts[Index].ArtifactClass.default.PickupClass,,, PathNodes[Rand(PathNodes.length)].Location);
	// 	if (APickup == None)
	// 		return;
	// 	APickup.RespawnEffect();
	// 	APickup.RespawnTime = 0.0;
	// 	APickup.AddToNavigation();
	// 	APickup.bDropped = true;
	// 	APickup.Inventory = spawn(AvailableArtifacts[Index].ArtifactClass);
	// 	CurrentArtifacts[CurrentArtifacts.length] = RPGArtifact(APickup.Inventory);
	// }
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	local int i;

	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting("UT2004RPG", "MaxArtifacts", default.PropsDisplayText[i++], 3, 10, "Text", "2;0:25");
	PlayInfo.AddSetting("UT2004RPG", "ArtifactDelay", default.PropsDisplayText[i++], 30, 10, "Text", "3;1:100");
	PlayInfo.AddSetting("UT2004RPG", "MaxHeldArtifacts", default.PropsDisplayText[i++], 0, 10, "Text", "2;0:99");
}

static function string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "MaxArtifacts":	return default.PropsDescText[0];
		case "ArtifactDelay":	return default.PropsDescText[1];
		case "MaxHeldArtifacts":return default.PropsDescText[2];
	}
}

// update artifact list to latest version
static final function UpdateArtifactList()
{
	local int i;

	if (default.Artifacts.length > 0 && default.AvailableArtifacts.length == 6)
	{
		default.AvailableArtifacts.length = default.Artifacts.length;
		for (i = 0; i < default.Artifacts.length; i++)
		{
			default.AvailableArtifacts[i].ArtifactClass = default.Artifacts[i];
			default.AvailableArtifacts[i].Chance = 1;
		}
		default.Artifacts.length = 0;
		StaticSaveConfig();
	}
}

defaultproperties
{
     ArtifactDelay=30
     MaxArtifacts=0
     AvailableArtifacts(0)=(ArtifactClass=Class'UT2004RPG.ArtifactInvulnerability',Chance=1)
     AvailableArtifacts(1)=(ArtifactClass=Class'UT2004RPG.ArtifactFlight',Chance=1)
     AvailableArtifacts(2)=(ArtifactClass=Class'UT2004RPG.ArtifactTripleDamage',Chance=1)
     AvailableArtifacts(3)=(ArtifactClass=Class'UT2004RPG.ArtifactLightningRod',Chance=1)
     AvailableArtifacts(4)=(ArtifactClass=Class'UT2004RPG.ArtifactTeleport',Chance=1)
     AvailableArtifacts(5)=(ArtifactClass=Class'UT2004RPG.ArtifactMonsterSummon',Chance=1)
     PropsDisplayText(0)="Max Artifacts"
     PropsDisplayText(1)="Artifact Spawn Delay"
     PropsDisplayText(2)="Max Artifacts a Player Can Hold"
     PropsDescText(0)="Maximum number of artifacts in the level at once."
     PropsDescText(1)="Spawn an artifact every this many seconds."
     PropsDescText(2)="The maximum number of artifacts a player can carry at once (0 for infinity)"
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
