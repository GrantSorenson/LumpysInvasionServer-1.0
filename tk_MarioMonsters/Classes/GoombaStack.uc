class GoombaStack extends Actor placeable;

var() int Health;

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                            Vector momentum, class<DamageType> damageType)
{
	Health-=Damage;
	if(Health <= 0)
	{
		//goomba died
		//detach dead goomba and award points
		SetCollision(false,false,false);
		SetDrawScale(0);
		Destroy();
	}
}

defaultproperties
{
     Health=100
     DrawType=DT_Mesh
     bAlwaysRelevant=True
     bReplicateInstigator=True
     bNetInitialRotation=True
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=2.500000
     bGameRelevant=True
     bCanBeDamaged=True
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bCollideActors=True
     bProjTarget=True
     bUseCylinderCollision=True
}
