class ArtifactMedicWeaponMaker extends ArtifactMagicWeaponMaker;


  static function bool ArtifactIsAllowed(GameInfo Game)
  {
  	return true;
  }

  function DropFrom(vector StartLocation)
  {
    return; // The player should not be able to drop this item
  }

  function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other)
  {
  	return RPGMut.WeaponModifiers[3].WeaponClass;
  }

  defaultproperties
  {
    CostPerSec=20
    IconMaterial=Texture'LumpysTextures.ArtifactIcons.tex_MedicWeaponMaker'
    ItemName="Medic Weapon Maker"
  }
