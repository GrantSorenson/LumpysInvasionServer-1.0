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
        RPGStatsInv(Inv).RPGMut.SpawnDrone(Other.Location + vect(0, -32, 64), Other.Rotation,0,Other);
        
    }
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{

    local int x;

    Super.ModifyPawn(Other,AbilityLevel);

    AddDrones(Other,AbilityLevel);

}


defaultproperties
{
  AbilityName="Drones"
  Description="This ability grants the player Drones"
  StartingCost=1
  CostAddPerLevel=1
  MaxLevel=5
}
