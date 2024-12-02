class AK47AltFire extends tk_ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip2');
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local AK47ProjAlt Rocket;

        Rocket = Spawn(class'AK47ProjAlt',,, Start, Dir);
        if (Rocket == None)
            log("failed spawning rocket!"@Start@" "@Dir);
        return Rocket;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Z=0.000000)
     bSplashDamage=True
     FireSound=Sound'tk_AK47.fire1.bang1'
     FireForce="ShockRifleAltFire"
     FireRate=0.300000
     AmmoClass=Class'tk_AK47.AK47Ammo'
     ShakeRotMag=(X=60.000000,Y=20.000000)
     ShakeRotRate=(X=1000.000000,Y=1000.000000)
     ShakeRotTime=2.000000
     ProjectileClass=Class'tk_AK47.AK47ProjAlt'
     BotRefireRate=0.500000
     FlashEmitterClass=Class'tk_AK47.AK47PMuzFlash'
     aimerror=1400.000000
     Spread=0.100000
     SpreadStyle=SS_Random
}
