class ItemDropInv extends Powerups;

var() class<Actor> ItemToDrop;
var() float DropLifeSpan;

function DropFrom(vector StartLocation)
{
	local vector X, Y, Z;
	local vector DropVelocity, SpawnLoc;
	local Actor A;

	if(Pawn(Owner)!=None)
	{
		DropVelocity = Vector(Pawn(Owner).GetViewRotation());
		DropVelocity = DropVelocity * ((Pawn(Owner).Velocity Dot DropVelocity) + 300) + Vect(0,0,200);

		GetAxes(Pawn(Owner).GetViewRotation(), X, Y, Z);
		SpawnLoc = StartLocation + 0.8 * Pawn(Owner).CollisionRadius * X - 0.5 * Pawn(Owner).CollisionRadius * Y;
		A = Spawn(ItemToDrop,Pawn(Owner),,SpawnLoc);
		if ( A != None )
		{
			A.LifeSpan = DropLifeSpan;

			if(Pickup(A) != None)
			{
				Pickup(A).InitDroppedPickupFor(None);
			}
			else
			{
				A.SetPhysics(PHYS_Falling);
				A.bAlwaysRelevant = false;
				A.bUpdateSimulatedPosition = true;
				A.LifeSpan = DropLifeSpan;
				A.bIgnoreEncroachers = false;
				A.NetUpdateFrequency = 8;
			}

			A.Velocity = DropVelocity;
		}
	}
}
defaultproperties
{
}
