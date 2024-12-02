class DamTypeGrenadeConc extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.GrenadeLauncher'
     DeathString="%o was concussed by %k's grenade"
     FemaleSuicide="%o was concussed by her own grenade"
     MaleSuicide="%o was concussed by his own grenade"
     bDetonatesGoop=True
     bDelayedDamage=True
     bThrowRagdoll=True
     GibModifier=1.100000
     KDamageImpulse=7000.000000
     VehicleDamageScaling=0.750000
     VehicleMomentumScaling=2.000000
}