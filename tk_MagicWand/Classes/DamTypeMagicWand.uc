class DamTypeMagicWand extends WeaponDamageType
     abstract;

defaultproperties
{
     WeaponClass=Class'tk_MagicWand.MagicWand'
     DeathString="%k has unleashed the Magic Wand on %o."
     FemaleSuicide="%o could not control the Magic Wand."
     MaleSuicide="%o could not control the Magic Wand."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
     GibPerterbation=0.750000
     VehicleDamageScaling=0.850000
     VehicleMomentumScaling=0.500000
}
