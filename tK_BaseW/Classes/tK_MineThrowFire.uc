//-----------------------------------------------------------
//
//-----------------------------------------------------------
class tK_MineThrowFire extends tK_BioFire;

var class<Projectile> RedMineClass;
var class<Projectile> BlueMineClass;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
    local int x;

    if (Weapon.Instigator.GetTeamNum() == 0)
        ProjectileClass = RedMineClass;

    if (Weapon.Instigator.GetTeamNum() == 1)
        ProjectileClass = BlueMineClass;

    if( ProjectileClass != None )
        p = Weapon.Spawn(ProjectileClass, Weapon,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    if (tK_MineLayer(Weapon) != None)
    {
        if (tK_MineLayer(Weapon).CurrentMines >= tK_MineLayer(Weapon).MaxMines)
    {
        for (x = 0; x < tK_MineLayer(Weapon).Mines.length; x++)
        {
            if (tK_MineLayer(Weapon).Mines[x] == None)
            {
                tK_MineLayer(Weapon).Mines.Remove(x, 1);
                x--;
            }
            else
            {
                tK_MineLayer(Weapon).Mines[x].Destroy();
                tK_MineLayer(Weapon).Mines.Remove(x, 1);
                break;
            }
        }
    }
    tK_MineLayer(Weapon).Mines[tK_MineLayer(Weapon).Mines.length] = p;
        tK_MineLayer(Weapon).CurrentMines++;
    }

    return p;
}

function PlayFiring()
{
    Super.PlayFiring();
    tK_MineLayer(Weapon).PlayFiring(true);
}

defaultproperties
{
     RedMineClass=Class'tK_MineProjectileRED'
     BlueMineClass=Class'tK_MineProjectileBLUE'
     FireSound=Sound'ONSVehicleSounds-S.SpiderMines.SpiderMineFire01'
     FireRate=1.100000
     AmmoClass=Class'Onslaught.ONSMineAmmo'
     ProjectileClass=Class'Onslaught.ONSMineProjectile'
}
