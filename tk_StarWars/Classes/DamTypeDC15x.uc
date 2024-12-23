class DamTypeDC15x extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     DeathString="%o was blasted by a DC-15x Sniper Rifle"
     bDetonatesGoop=True
     bCauseConvulsions=True
     GibPerterbation=0.250000
     VehicleDamageScaling=0.850000
}
