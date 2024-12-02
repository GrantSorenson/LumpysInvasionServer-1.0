class DamTypePistolAlt extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
	HitEffects[0] = class'XEffects.HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.Pistol'
     DeathString="%k blew a chunk out of %o with an explosive bullet"
     FemaleSuicide="%o blew a chunk out of herself"
     MaleSuicide="%o blew a chunk out of himself"
     bArmorStops=False
     bDetonatesGoop=True
     bDelayedDamage=True
     bRagdollBullet=True
     bBulletHit=True
     KDamageImpulse=3500.000000
}