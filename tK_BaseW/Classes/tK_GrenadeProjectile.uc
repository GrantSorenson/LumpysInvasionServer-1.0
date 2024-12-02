class tK_GrenadeProjectile extends ONSGrenadeProjectile;

simulated function Destroyed()
{
    Super.Destroyed();
    if ( tK_GrenadeLauncher(Owner) != None)
        tK_GrenadeLauncher(Owner).CurrentGrenades--;
}

defaultproperties
{
}
