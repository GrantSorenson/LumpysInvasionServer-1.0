class tK_ZoomSuperShockBeamFire extends tK_SuperShockBeamFire;

var config bool bAllowMultiHit;

function bool AllowMultiHit()
{
    return bAllowMultiHit;
}

defaultproperties
{
     bAllowMultiHit=True
     DamageType=Class'XWeapons.ZoomSuperShockBeamDamage'
}
