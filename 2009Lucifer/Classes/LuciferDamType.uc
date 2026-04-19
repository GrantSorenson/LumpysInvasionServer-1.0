//================================================================================
// LuciferDamType.
//================================================================================

class LuciferDamType extends WeaponDamageType
  Abstract;

static function GetHitEffects (out Class<xEmitter> HitEffects[4], int VictemHealth)
{
  HitEffects[0] = Class'HitSmoke';
}

defaultproperties
{
    DeathString="%o was sent to Hell by Lucifer."

    FemaleSuicide="Lucifer destroyed herself."

    MaleSuicide="Lucifer destroyed himself."

    bDetonatesGoop=True

    bCauseConvulsions=True

    GibPerterbation=0.25

    VehicleDamageScaling=0.85

}
