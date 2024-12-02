class DamTypeRailDart extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
	HitEffects[0] = class'XEffects.HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.Railgun'
     DeathString="%o went over %k's particle limit"
     FemaleSuicide="%o went over her own particle limit"
     MaleSuicide="%o went over his own particle limit"
     bDetonatesGoop=True
     bDelayedDamage=True
     bRagdollBullet=True
     bBulletHit=True
     KDamageImpulse=2500.000000
     VehicleDamageScaling=1.200000
}