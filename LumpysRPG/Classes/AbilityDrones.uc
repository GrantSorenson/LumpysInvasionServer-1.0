class AbilityDrones extends RPGAbility
    abstract;


static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static function AddDrones(Pawn Other, int AbilityLevel)
{
    local Inventory Inv;

    if (Other.Role != ROLE_Authority)
        return;

    Inv = Other.FindInventoryType(class'RPGStatsInv');

    if (RPGStatsInv(Inv) != None)
    {
        RPGStatsInv(Inv).RegDrones = AbilityLevel;
        RPGStatsInv(Inv).SetMaxDrones(0);
        RPGStatsInv(Inv).RPGMut.SpawnDrone(class'LumpyDrone', AbilityLevel, Other);
    }
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
    Super.ModifyPawn(Other, AbilityLevel);
    AddDrones(Other, AbilityLevel);
}

static simulated function UnModifyPawn(Pawn Other, int AbilityLevel)
{
    local RPGStatsInv StatsInv;

    if (Other.Role != ROLE_Authority)
        return;

    StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
    if (StatsInv == None)
        return;

    StatsInv.RegDrones = 0;
    StatsInv.SetMaxDrones(0);
    StatsInv.RPGMut.SpawnDrone(class'LumpyDrone', 0, Other);
}


defaultproperties
{
  AbilityName="Drones"
  Description="This ability grants the player Drones"
  StartingCost=1
  CostAddPerLevel=1
  MaxLevel=5
}
