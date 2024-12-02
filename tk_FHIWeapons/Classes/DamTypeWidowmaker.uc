class DamTypeWidowmaker extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
	HitEffects[0] = class'XEffects.HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.Widowmaker'
     DeathString="%o took a bullet from %k."
     FemaleSuicide="%o shot herself."
     MaleSuicide="%o shot himself."
     bDetonatesGoop=True
     bCauseConvulsions=True
     bNeverSevers=True
     bBulletHit=True
     GibPerterbation=0.550000
     VehicleDamageScaling=0.650000
}