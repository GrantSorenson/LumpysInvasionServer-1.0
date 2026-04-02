class CA_MedicSprites extends RPGAbility
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

    StatsInv.MedicDrones = AbilityLevel;
    Log("CA_MedicSprites: MedicDrones="$AbilityLevel, 'LumpysRPG');
    StatsInv.SetMaxDrones(1);
    StatsInv.RPGMut.SpawnDrone(class'MedicDrone', AbilityLevel, Other);
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

    StatsInv.MedicDrones = 0;
    StatsInv.SetMaxDrones(1);
    // Count=0 destroys existing MedicDrones without spawning any new ones.
    // Regular LumpyDrones owned by AbilityDrones are unaffected.
    StatsInv.RPGMut.SpawnDrone(class'MedicDrone', 0, Other);
}


defaultproperties
{
  AbilityName="Medic Sprites"
  Description="This ability grants the player Magic Sprites that heal the player.|Increases in this abilities level increases the range and number of sprites.|Sprites can be gives additional abilities"
  StartingCost=1
  CostAddPerLevel=0
  MaxLevel=5
  bClassAbility=true;
  MasterClass="MM"
}
