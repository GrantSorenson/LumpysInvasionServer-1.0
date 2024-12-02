class MagicWandMinigunAltFire extends MagicWandMiniGunFire;

function StartSuperBerserk()
{
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    BarrelRotationsPerSec = Default.BarrelRotationsPerSec * 0.667 * Level.GRI.WeaponBerserk;
    FireRate = 0.75;
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
}

function PostBeginPlay()
{
    Super(InstantFire).PostBeginPlay();
    FireRate = 0.75;
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
    Gun = tk_Minigun(Weapon);
}

state FireLoop
{
    function BeginState()
    {
        NextFireTime = Level.TimeSeconds - 0.1; //fire now!
        
	PlayAmbientSound(None);
	//PlayAmbientSound(FiringSound);
        
	ClientPlayForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
        Gun.SpawnShells(RoundsPerRotation*BarrelRotationsPerSec);
    }

}


function PlayFiring()
{
    Weapon.PlayOwnedSound(FiringSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    
}

//// server propagation of firing ////
function ServerPlayFiring()
{
    Weapon.PlayOwnedSound(FiringSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
}
//PlayAmbientSound(FiringSound);

defaultproperties
{
    BarrelRotationsPerSec=0.70
    FiringSound=Sound'tk_MagicWand.MagicWand.WandMiniAltFire'
    WindUpTime=0.15
    FiringForce="minialtfireb"
    PreFireTime=0.15
    FireLoopAnimRate=0.05
    FireRate=1
    Spread=0.03
}