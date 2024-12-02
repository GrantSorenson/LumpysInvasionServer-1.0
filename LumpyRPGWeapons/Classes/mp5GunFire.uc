//=============================================================================
// mp5Fire.
//=============================================================================
class mp5gunFire extends AssaultFire;


function StartBerserk()
{
    DamageMin = default.DamageMin * 1.33;
    DamageMax = default.DamageMax * 1.33;
}

function StopBerserk()
{
    DamageMin = default.DamageMin;
    DamageMax = default.DamageMax;
}
event ModeDoFire()
{
	if ( Level.TimeSeconds - LastFireTime > 0.5 )
		Spread = Default.Spread;
	else
		Spread = FMin(Spread+0.01,0.04);
	LastFireTime = Level.TimeSeconds;
	Super(InstantFire).ModeDoFire();
}
defaultproperties
{
    DamageType=Class'DamTypeMp5Bullet'
    DamageMin=25
    DamageMax=25
    FireSound=Sound'ZWeaponsSnd.mp5-2'
    AmmoClass=Class'MP5Ammo'
    aimerror=700.00
}
