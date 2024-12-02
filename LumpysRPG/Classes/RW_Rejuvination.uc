class RW_Rejuvination extends RPGWeapon
  HideDropDown
  CacheExempt;

  static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
  {
    if(ClassIsChildOf(Weapon, class'TransLauncher'))
      return true;

  	return false;
  }

defaultproperties
{
  ModifierOverlay=Shader'XGameTextures.SuperPickups.MHInnerS'
  MinModifier=1
  MaxModifier=10
  AIRatingBonus=0.020000
  PostfixPos=" of Rejuvination"
}
