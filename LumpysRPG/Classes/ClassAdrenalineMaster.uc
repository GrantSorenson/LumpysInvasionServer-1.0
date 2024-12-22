class ClassAdrenalineMaster extends RPGClass config(LumpyRPG)
  abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

defaultproperties
{
  AbilityName="Adrenaline Master"
	Description="This is the Ability for the Adrenaline Master Class"
	StartingCost=1
	CostAddPerLevel=0
	MaxLevel=20
  bMasterAbility=true;
  MasterClass="AM"
}
