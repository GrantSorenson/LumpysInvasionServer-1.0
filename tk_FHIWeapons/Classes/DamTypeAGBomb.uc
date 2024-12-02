class DamTypeAGBomb extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.HVAssaultRifle'
     DeathString="%o was blown to bits by %k's AG Bomb"
     FemaleSuicide="%o blew herself up with an AG Bomb!"
     MaleSuicide="%o blew himself up with an AG Bomb!"
     bArmorStops=False
     bDetonatesGoop=True
     bKUseOwnDeathVel=True
     bDelayedDamage=True
     bFlaming=True
     GibPerterbation=0.950000
     KDeathVel=800.000000
     KDeathUpKick=800.000000
     VehicleDamageScaling=1.250000
     VehicleMomentumScaling=1.250000
}