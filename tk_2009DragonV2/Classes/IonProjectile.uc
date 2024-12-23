class IonProjectile extends DragonProjectile placeable;

simulated function Explode(vector HitLocation,vector HitNormal)
{
	SetPhysics(PHYS_None);
	PlaySound(ImpactSound,,255);
	SpawnFX(HitLocation, HitStart);
    SetCollision(false,false,false);
    Destroyed();
	if(Role == ROLE_Authority)
	{
		if(GetStateName() != 'Dying')
		{
			GoToState('Dying');
		}
	}
}

State Dying
{

Begin:

	Spawn(ExplodeClass,,,);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	Sleep(0.5);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	Sleep(0.2);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	Destroy();
}

defaultproperties
{
     TrailClass=Class'tk_2009Dragonv2.IonProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.IonProjExplode'
     Speed=1300.000000
     MaxSpeed=2000.000000
     DamageRadius=450.000000
     MyDamageType=Class'tk_2009Dragonv2.DamTypeIon'
     ImpactSound=Sound'tk_2009Dragonv2.IonDragonProjBlast'
}
