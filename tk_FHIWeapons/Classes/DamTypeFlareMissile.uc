class DamTypeFlareMissile extends DamTypeRocket
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';

	if (VictimHealth <= 0 && FRand() < 0.2)
		HitEffects[1] = class'FlareHitFlameBlueBig';
	else if (FRand() < 0.8)
		HitEffects[1] = class'FlareHitFlameBlue';
}

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.FlareLauncher'
     DeathString="%o failed to notice %k's flare missile"
     FemaleSuicide="%o munched on her own flare missile"
     MaleSuicide="%o munched on his own flare missile"
}