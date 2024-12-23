class CA_MedicArtifacts extends RPGAbility
abstract;

var() config Array< class<RPGArtifact> > Artifacts;


static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
  local int x;


  if(Monster(Other) != None)
        return;

  for (x=0;x<default.Artifacts.length;x++)
  {
    giveArtifact(other, default.Artifacts[x]);
  }
}

static function giveArtifact(Pawn other, class<RPGArtifact> ArtifactClass)
{
    local RPGArtifact Artifact;

    if(Other.IsA('Monster'))
        return;
    if(Other.findInventoryType(ArtifactClass) != None)
        return; //they already have one
        
    Artifact = Other.spawn(ArtifactClass, Other,,, rot(0,0,0));
    if(Artifact != None)
    {
        Artifact.giveTo(Other);
    }
}



defaultproperties
{
  Artifacts(0)=Class'LumpysRPG.ArtifactMedicWeaponMaker'
  Artifacts(1)=Class'LumpysRPG.ArtifactSuperMedicWeaponMaker'
  //Artifacts(1)=Class'LumpysRPG.ArtifactMagicWeaponMaker'
  AbilityName="Medic Artifacts"
  Description="This ability grants the player Medic artifacts that are necessary for survival. |Level 1 gives the Medic Weapon Maker |Level 2 gives... |Level 3 gives... |Level 4 gives... |Level 5 gives the Super Medic Weapon Maker"
  StartingCost=1
  CostAddPerLevel=0
  MaxLevel=5
  bClassAbility=true;
	MasterClass="MM"
}
