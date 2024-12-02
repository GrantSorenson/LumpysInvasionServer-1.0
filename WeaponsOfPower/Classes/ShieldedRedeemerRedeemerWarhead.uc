class ShieldedRedeemerRedeemerWarhead extends RedeemerWarhead;

////////////////////////////////////////////////////////////////////////////////

function TakeDamage(
	int               Damage,
	Pawn              instigatedBy,
	Vector            hitlocation,
	Vector            momentum,
	class<DamageType> damageType)
{
	// Can't destroy. Suffer!
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Damage=200.00
    DamageRadius=1750.00
}
