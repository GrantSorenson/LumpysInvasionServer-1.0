class ElectricProjectile extends DragonProjectile placeable;

var class<xEmitter> ElectricArcClass;

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local Actor A;
	local xEmitter xArc;

	if(Role == ROLE_Authority)
	{
		Foreach VisibleCollidingActors(class'Actor' ,A ,500 ,HitLocation)
		{
			if(A != None && A != Self && A != Owner && fRand() > 0.5)
			{
				xArc = Spawn(ElectricArcClass,self);
				xArc.SetBase(self);
				xArc.mSpawnVecA = A.Location;
				A.TakeDamage(Damage / 3, Pawn(Owner), A.Location, vect(0,0,0), MyDamageType);
			}
		}
	}

	Super.Explode(HitLocation,HitNormal);
}

defaultproperties
{
     ElectricArcClass=Class'XEffects.LightningBolt'
     TrailClass=Class'tk_2009Dragonv2.ElectricProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.ElectricProjExplode'
     Speed=1200.000000
     MaxSpeed=1500.000000
     MomentumTransfer=0.000000
     MyDamageType=Class'tk_2009Dragonv2.DamTypeElectric'
     ImpactSound=Sound'tk_2009Dragonv2.ElectricDragonProjBlast'
}
