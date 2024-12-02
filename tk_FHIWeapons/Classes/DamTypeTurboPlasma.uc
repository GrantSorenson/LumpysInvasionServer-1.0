class DamTypeTurboPlasma extends DamTypeShockBall
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.TurboLaser'
     DeathString="%o was vaporized by %k's turbo plasma"
     FemaleSuicide="%o went 'POOF!' after turning the turbo plasma on herself"
     MaleSuicide="%o went 'POOF!' after turning the turbo plasma on himself"
     bSkeletize=True
     DamageOverlayMaterial=Shader'tk_FHIWeapons.FHIShaders.TurboLaserHit_Shader'
}