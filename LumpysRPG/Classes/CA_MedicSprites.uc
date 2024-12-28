class CA_MedicSprites extends RPGAbility
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
        RPGStatsInv(Inv).MedicDrones = AbilityLevel;
        Log("AbilityLevel: "$AbilityLevel,'LumpysRPG');
        RPGStatsInv(Inv).SetMaxDrones(1);
        RPGStatsInv(Inv).RPGMut.SpawnDrone(Other.Location + vect(0, -32, 64), Other.Rotation,1,Other);
        
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
  AbilityName="Medic Sprites"
  Description="This ability grants the player Magic Sprites that heal the player.|Increases in this abilities level increases the range and number of sprites.|Sprites can be gives additional abilities"
  StartingCost=1
  CostAddPerLevel=0
  MaxLevel=5
  bClassAbility=true;
  MasterClass="MM"
}
