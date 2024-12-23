class IPPetAnchor extends Actor;

event Landed ( vector HitNormal )
{
	SetPhysics(PHYS_None);
}

defaultproperties
{
    bHidden=True
    CollisionRadius=10.00
    CollisionHeight=10.00
    bCollideWorld=True
    Mass=2000.00
}
