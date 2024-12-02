class DamTypeMiniRocket extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.MiniRocketLauncher'
     DeathString="%o was blown sky high by %k's mini-rockets"
     FemaleSuicide="%o blew herself up with a mini-rocket"
     MaleSuicide="%o blew himself up with a mini-rocket"
     bDetonatesGoop=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bFlaming=True
     GibPerterbation=0.150000
     KDamageImpulse=20000.000000
     VehicleMomentumScaling=1.300000
}