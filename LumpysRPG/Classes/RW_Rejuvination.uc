class RW_Rejuvination extends RPGWeapon
  HideDropDown
  CacheExempt;

  var() int newFireRate[4];

  simulated function SetWeaponInfo()
  {
    local int x;

    Super.SetWeaponInfo();

    for (x = 0; x < NUM_FIRE_MODES; x++)
    {
      FireMode[x] = ModifiedWeapon.FireMode[x];
      FireMode[x].default.FireRate = ModifiedWeapon.FireMode[x].FireRate/2;
      Log("Fire Rate: "$ModifiedWeapon.FireMode[x].FireRate$" New Fire Rate: "$FireMode[x].FireRate);
      newFireRate[x] = FireMode[x].FireRate - 0.1;
      Ammo[x] = ModifiedWeapon.Ammo[x];
      AmmoClass[x] = ModifiedWeapon.AmmoClass[x];
      //someone explain to me why people had to create their own versions of the dummy WeaponFire for zooming
      if ( FireMode[x].IsA('SniperZoom') || FireMode[x].IsA('PainterZoom') || FireMode[x].IsA('CUTSRZoom')
          || FireMode[x].IsA('HeliosZoom') || FireMode[x].IsA('LongrifleZoom') || FireMode[x].IsA('PICZoom') )
        SniperZoomMode = x;
    }

    Log("Weapon Info Set",'LumpysInvasion');
  }

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
  Role=Role_Authority
}
