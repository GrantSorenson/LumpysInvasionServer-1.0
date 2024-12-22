class DamTypeDroideka extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     DeathString="%o rode a Droideka's plasma."
     FemaleSuicide="A Droideka destroyed herself."
     MaleSuicide="A Droideka destroyed himself."
     bDetonatesGoop=True
     bCauseConvulsions=True
     GibPerterbation=0.250000
     VehicleDamageScaling=0.850000
}
