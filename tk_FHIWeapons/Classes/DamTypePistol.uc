class DamTypePistol extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
	HitEffects[0] = class'XEffects.HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.Pistol'
     DeathString="%o was airated by %k's Pistol"
     FemaleSuicide="%o shot herself"
     MaleSuicide="%o shot himself"
     bDetonatesGoop=True
     bCauseConvulsions=True
     bNeverSevers=True
     bBulletHit=True
     GibPerterbation=0.550000
     VehicleDamageScaling=0.650000
}