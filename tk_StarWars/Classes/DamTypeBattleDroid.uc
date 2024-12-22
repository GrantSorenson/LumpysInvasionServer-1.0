class DamTypeBattleDroid extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     DeathString="%o rode a Battle Droid's plasma."
     FemaleSuicide="A Battle Droid destroyed themselves."
     MaleSuicide="A Battle Droid destroyed themselves."
     bDetonatesGoop=True
     bCauseConvulsions=True
     GibPerterbation=0.250000
     VehicleDamageScaling=0.850000
}
