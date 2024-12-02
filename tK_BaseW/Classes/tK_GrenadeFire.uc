//-----------------------------------------------------------
//
//-----------------------------------------------------------
class tK_GrenadeFire extends tK_BioFire;

simulated function bool AllowFire()
{
    if (tK_GrenadeLauncher(Weapon).CurrentGrenades >= tK_GrenadeLauncher(Weapon).MaxGrenades)
        return false;

    return Super.AllowFire();
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local tK_GrenadeProjectile G;

    G = tK_GrenadeProjectile(Super.SpawnProjectile(Start, Dir));
    if (G != None && tK_GrenadeLauncher(Weapon) != None)
    {
        G.SetOwner(Weapon);
        tK_GrenadeLauncher(Weapon).Grenades[tK_GrenadeLauncher(Weapon).Grenades.length] = G;
        tK_GrenadeLauncher(Weapon).CurrentGrenades++;
    }

    return G;
}

defaultproperties
{
     bSplashDamage=False
     bRecommendSplashDamage=False
     FireRate=0.650000
     AmmoClass=Class'Onslaught.ONSGrenadeAmmo'
     ProjectileClass=Class'tK_GrenadeProjectile'
}
