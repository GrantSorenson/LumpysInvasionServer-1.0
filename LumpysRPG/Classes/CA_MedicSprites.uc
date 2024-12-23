class CA_MedicSprites extends RPGAbility
    abstract;


static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
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