class AbilityDrones extends RPGAbility
    abstract;


static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static function AddDrones(Pawn Other, int AbilityLevel)
{
    local RPGStatsInv StatsInv;

    if (Other.Role != ROLE_Authority)
        return;

    StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
    if (StatsInv == None)
        return;

    StatsInv.RegDrones = AbilityLevel;
    StatsInv.SetMaxDrones();
    StatsInv.RPGMut.SpawnDrone(class'LumpyDrone', AbilityLevel, Other);
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
    StatsInv.SetMaxDrones();
    // Count=0 destroys existing LumpyDrones without spawning any new ones.
    // MedicDrones owned by CA_MedicSprites are unaffected.
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
