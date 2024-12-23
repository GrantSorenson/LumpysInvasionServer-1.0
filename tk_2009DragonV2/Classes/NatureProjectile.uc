class NatureProjectile extends DragonProjectile placeable;

var int NatureAmountMax;

replication
{
    reliable if(Role==ROLE_Authority)
    	NatureAmountMax;
}

simulated function SpawnFX(vector HitLocation, vector HitStart)
{
	local float RandomNumber;
	local int i;
	local vector Offset;
	local vector SpawnLocation;

	Super.SpawnFX(HitLocation, HitStart);

	if(NatureAmountMax <= 0)
	{
		return;
	}

	if ( Level.NetMode != NM_DedicatedServer)
	{
		RandomNumber = 1 + Rand(NatureAmountMax);
		SpawnLocation = HitLocation + ((Normal(HitLocation - HitStart)) * -10);

		for(i=0; i<RandomNumber; i++)
		{
			Offset.X = fRand() * ( Rand(-250)-250 + Rand(250)+250 );
			Offset.Y = fRand() * ( Rand(-250)-250 + Rand(250)+250 );
			Offset.Z = 20;

			Spawn(Class'NatureDragonGrass',,, SpawnLocation + Offset);
		}
	}
}

defaultproperties
{
     NatureAmountMax=5
     TrailClass=Class'tk_2009Dragonv2.NatureProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.NatureProjExplode'
     MyDamageType=Class'tk_2009Dragonv2.DamTypeNature'
     ImpactSound=Sound'tk_2009Dragonv2.NatureDragonProjBlast'
}
