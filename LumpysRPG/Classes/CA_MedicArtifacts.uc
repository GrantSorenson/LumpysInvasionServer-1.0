class CA_MedicArtifacts extends RPGAbility
abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
  local ArtifactMedicWeaponMaker AMedicWM;


  if(Monster(Other) != None)
        return;

  AMedicWM = ArtifactMedicWeaponMaker(Other.FindInventoryType(class'ArtifactMedicWeaponMaker'));

  if (AMedicWM != None)
  {
    return;
  }
  else
  {
    AMedicWM = Other.spawn(class'ArtifactMedicWeaponMaker', Other,,,rot(0,0,0));
    if(AMedicWM == None)
    {
      return;
    }
    AMedicWM.GiveTo(Other);
  }
}




defaultproperties
{
  AbilityName="Medic Artifacts"
  Description="This ability grants the player the Medic Weapon Maker"
  StartingCost=1
  CostAddPerLevel=0
  MaxLevel=1
  bClassAbility=true;
	MasterClass="MM"
}
