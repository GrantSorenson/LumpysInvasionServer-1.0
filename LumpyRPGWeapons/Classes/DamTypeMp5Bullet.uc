class DamTypeMP5Bullet extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
    WeaponClass=Class'mp5Gun'
    DeathString="%o was ventilated by %k's MP5."
    FemaleSuicide="%o assaulted herself."
    MaleSuicide="%o assaulted himself."
    bAlwaysSevers=True
    bDetonatesGoop=True
    KDamageImpulse=2000.00
}
