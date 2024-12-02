class TurboLaserFire extends tk_InstantFire;

var() class<TurboBeamEffect>	TLBeamEffectClass;

function DoFireEffect()
{
    local Vector StartTrace,X,Y,Z;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    if ( PlayerController(Instigator.Controller) != None )
    {
		// for combos
	   Weapon.GetViewAxes(X,Y,Z);
		StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;
		if ( !Weapon.WeaponCentered() )
			StartTrace = StartTrace + Weapon.Hand * Y*class'TurboLaserProjFire'.Default.ProjSpawnOffset.Y + Z*class'TurboLaserProjFire'.Default.ProjSpawnOffset.Z;
	}

    Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

// used for bot combos
function Rotator AdjustAim(Vector Start, float InAimError)
{
	if ( (TurboLaser(Weapon) != None) && (TurboLaser(Weapon).TLComboTarget != None) )
		return Rotator(TurboLaser(Weapon).TLComboTarget.Location - Start);

	return Super.AdjustAim(Start, InAimError);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local TurboBeamEffect Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(TLBeamEffectClass,,, Start, Dir);
        if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
            Beam.AimAt(HitLocation, HitNormal);
    }
}

defaultproperties
{
     TLBeamEffectClass=Class'tk_FHIWeapons.TurboBeamEffect'
     DamageType=Class'tk_FHIWeapons.DamTypeTurboBeam'
     DamageMin=45
     DamageMax=45
     TraceRange=17000.000000
     Momentum=10000.000000
     bReflective=True
     TransientSoundVolume=1.000000
     FireSound=Sound'tk_FHIWeapons.FHISnd.TurboLaser_Fire'
     FireForce="ShockRifleFire"
     FireRate=0.300000
     AmmoClass=Class'tk_FHIWeapons.TurboLaserAmmo'
     AmmoPerFire=1
     BotRefireRate=0.700000
     FlashEmitterClass=Class'tk_FHIWeapons.TurboLaserBeamMuzFlash'
     aimerror=100.000000
}
