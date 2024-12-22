class CA_AdrenalineArtifacts extends RPGAbility
abstract;

var() config Array< class<RPGArtifact> > Artifacts;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
  local RPGArtifact Arti;
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
  Artifacts(0)=Class'LumpysRPG.ArtifactSuperMagicWeaponMaker'
  AbilityName="Adrenaline Artifacts"
  Description="This ability grants the player Adrenaline Master Artifacts"
  StartingCost=1
  CostAddPerLevel=0
  MaxLevel=1
  bClassAbility=true;
  MasterClass="AM"
}