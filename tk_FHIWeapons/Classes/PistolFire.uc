class PistolFire extends tk_ClassicSniperFire;

function InitEffects()
{
    Super(InstantFire).InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function FlashMuzzleFlash()
{
    local rotator r;

    r.Yaw = 0;
    Weapon.SetBoneRotation('tip', r, 0, 1.f);
    Super.FlashMuzzleFlash();
}

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

function StartSuperBerserk()
{
    FireRate = default.FireRate * 1.5/Level.GRI.WeaponBerserk;
    FireAnimRate = default.FireAnimRate * 0.667 * Level.GRI.WeaponBerserk;
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    if (Pistol(Weapon) != None && Pistol(Weapon).bDualMode)
    	FireRate *= 0.55;
}

defaultproperties
{
     HeadShotDamageMult=3.000000
     DamageTypeHeadShot=Class'tk_FHIWeapons.DamTypePistolHeadShot'
     DamageType=Class'tk_FHIWeapons.DamTypePistol'
     DamageMin=65
     DamageMax=65
     TraceRange=19000.000000
     TransientSoundVolume=1.000000
     FireAnimRate=0.950000
     FireSound=Sound'tk_FHIWeapons.FHISnd.Pistol_Fire'
     FireRate=0.500000
     AmmoClass=Class'tk_FHIWeapons.PistolAmmo'
     BotRefireRate=0.800000
}
