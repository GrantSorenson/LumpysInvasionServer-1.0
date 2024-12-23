class BeamProjectile extends DragonProjectile placeable;

simulated function SetVelocity()
{
	Velocity = Vector(Rotation);
	Velocity *= Speed + RandRange(0,500);
}

simulated function Destroyed()
{

	Super.Destroyed();
}

defaultproperties
{
     TrailClass=Class'tk_2009Dragonv2.BeamProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.BeamProjExplode'
     Speed=900.000000
     MaxSpeed=1800.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_2009Dragonv2.DamTypeBeam'
     ImpactSound=Sound'tk_2009Dragonv2.BeamDragonProjBlast'
}
