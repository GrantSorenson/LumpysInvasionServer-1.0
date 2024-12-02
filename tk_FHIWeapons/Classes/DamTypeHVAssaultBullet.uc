class DamTypeHVAssaultBullet extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'tk_FHIWeapons.HVAssaultRifle'
     DeathString="%o was turned into Swiss cheese by %k's HV Assault Rifle"
     FemaleSuicide="%o killed her own dumb self"
     MaleSuicide="%o killed his own dumb self"
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=2000.000000
     VehicleDamageScaling=0.700000
}