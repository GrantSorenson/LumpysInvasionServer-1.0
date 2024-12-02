class ClassWeaponMaster extends RPGClass config(LumpyRPG)
  abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

defaultproperties
{
  AbilityName="Weapon Master"
	Description="This is the Ability for the Weapon Master Class"
	StartingCost=1
	CostAddPerLevel=0
	MaxLevel=20
  bMasterAbility=true;
}
