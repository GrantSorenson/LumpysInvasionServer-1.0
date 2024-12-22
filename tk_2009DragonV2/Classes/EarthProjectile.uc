class EarthProjectile extends DragonProjectile placeable;


simulated function SetVelocity()
{
	RandSpin(25000);
	Super.SetVelocity();
}

defaultproperties
{
     TrailClass=Class'tk_2009Dragonv2.EarthProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.EarthProjExplode'
     DamageRadius=175.000000
     MyDamageType=Class'tk_2009Dragonv2.DamTypeEarth'
     ImpactSound=Sound'tk_2009Dragonv2.EarthDragonProjBlast'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_2009Dragonv2.EarthRock'
     Texture=Shader'tk_2009Dragonv2.SFX.EarthRockTex'
     DrawScale=0.600000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
}
