class DamTypeGrenadePPG extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.GrenadeLauncher'
     DeathString="%o was turned into vapor by %k's PPG"
     FemaleSuicide="%o was turned into vapor by her own PPG"
     MaleSuicide="%o was turned into vapor by his own PPG"
     bDetonatesGoop=True
     bKUseOwnDeathVel=True
     bDelayedDamage=True
     bThrowRagdoll=True
     GibModifier=1.100000
     KDamageImpulse=7000.000000
     KDeathVel=400.000000
     KDeathUpKick=400.000000
     VehicleDamageScaling=1.750000
     VehicleMomentumScaling=2.000000
}