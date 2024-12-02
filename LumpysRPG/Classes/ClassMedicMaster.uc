class ClassMedicMaster extends RPGClass config(LumpyRPG)
  abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

// static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
// {
//   local ArtifactMedicWeaponMaker AMedicWM;
//
//
//   if(Monster(Other) != None)
//         return;
//
//   AMedicWM = ArtifactMedicWeaponMaker(Other.FindInventoryType(class'ArtifactMedicWeaponMaker'));
//
//   if (AMedicWM != None)
//   {
//     return;
//   }
//   else
//   {
//     AMedicWM = Other.spawn(class'ArtifactMedicWeaponMaker', Other,,,rot(0,0,0));
//     if(AMedicWM == None)
//     {
//       return;
//     }
//     AMedicWM.GiveTo(Other);
//   }
// }
//OLD DESCRITPION: | At Level 1 you will recieve the medic weapon maker artifact, which allows you to create a weapon of infinite medic healing level 1 for 100 adrenaline. This weapon will heal the target by 100 * modifier level and overheal them depending on the weapon level * 100 to a maximum of 1000 Health Points at level 10"

defaultproperties
{
  AbilityName="Medic Master"
	Description="This is the Ability for the Medic Master Class"
	StartingCost=1
	CostAddPerLevel=0
	MaxLevel=20
  bMasterAbility=true;
  MasterClass="MM"
}
