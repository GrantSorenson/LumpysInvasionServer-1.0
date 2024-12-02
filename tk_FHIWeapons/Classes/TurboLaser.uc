class TurboLaser extends tk_Weapon
	config(TKWeaponsClient);

var TurboLaserProjectile	TLComboTarget;	// Used by AI for combos
var bool			bRegisterTLTarget;
var bool			bWaitForTLCombo;
var vector			TLComboStart;

simulated function vector GetEffectStart()
{
	local Coords C;

    if ( Instigator.IsFirstPerson() )
    {
		if ( WeaponCentered() )
			return CenteredEffectStart();
	    C = GetBoneCoords('tip');
		return C.Origin - 15 * C.XAxis;
	}
	return Super.GetEffectStart();
}

simulated function bool WeaponCentered()
{
	return ( bSpectated || (Hand > 1) );
}

// AI interface
function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	if ( bWaitForTLCombo )
		return 1.5;
	if ( !B.ProficientWithWeapon() )
		return AIRating;
	if ( B.Stopped() )
	{
		if ( !B.EnemyVisible() && (VSize(B.Enemy.Location - Instigator.Location) < 5000) )
			return (AIRating + 0.5);
		return (AIRating + 0.3);
	}
	else if ( VSize(B.Enemy.Location - Instigator.Location) > 1600 )
		return (AIRating + 0.1);
	else if ( B.Enemy.Location.Z > B.Location.Z + 200 )
		return (AIRating + 0.15);

	return AIRating;
}

function SetTLComboTarget(TurboLaserProjectile T)
{
	if ( !bRegisterTLTarget || (bot(Instigator.Controller) == None) || (Instigator.Controller.Enemy == None) )
		return;
	
	bRegisterTLTarget = false;
	TLComboStart = Instigator.Location;
	TLComboTarget = T;
	TLComboTarget.Monitor(Bot(Instigator.Controller).Enemy);
}

function float RangedAttackTime()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( B.CanComboMoving() )
		return 0;

	return FMin(2,0.3 + VSize(B.Enemy.Location - Instigator.Location)/class'TurboLaserProjectile'.default.Speed);
}

simulated function bool StartFire(int mode)
{
	if ( bWaitForTLCombo && (Bot(Instigator.Controller) != None) )
	{
		if ( (TLComboTarget == None) || TLComboTarget.bDeleteMe )
			bWaitForTLCombo = false;
		else
			return false;
	}
	return Super.StartFire(mode);
}

function DoCombo()
{
	if ( bWaitForTLCombo )
	{
		bWaitForTLCombo = false;
		if ( (Instigator != None) && (Instigator.Weapon == self) )
			StartFire(0);
	}
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local float EnemyDist, MaxDist;
	local bot B;

	bWaitForTLCombo = false;
	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( B.Skill > 5 )
		MaxDist = 3 * class'TurboLaserProjectile'.default.Speed;
	else
		MaxDist = 2 * class'TurboLaserProjectile'.default.Speed;
	if ( (EnemyDist > MaxDist) || (EnemyDist < 150) )
	{
		TLComboTarget = None;
		return 0;
	}

	if ( (TLComboTarget != None) && !TLComboTarget.bDeleteMe && B.CanCombo() )
	{
		bWaitForTLCombo = true;
		return 0;
	}

	TLComboTarget = None;

	if ( (EnemyDist > 2000) && (FRand() < 0.5) )
		return 0;

	if ( B.CanCombo() && B.ProficientWithWeapon() )
	{
		bRegisterTLTarget = true;
		return 1;
	}
	if ( FRand() < 0.7 )
		return 0;
	return 1;
}

// end AI Interface

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.TurboLaserFire'
     FireModeClass(1)=Class'tk_FHIWeapons.TurboLaserProjFire'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.ShockRifle.SwitchToShockRifle'
     SelectForce="SwitchToShockRifle"
     AIRating=0.630000
     CurrentRating=0.630000
     Description="The P960 Turbo Laser is the next step in evolution as far as energy weaponry is concerned. The ability to fire non-stop for excessive periods of time, combined with it's patented 'Multi-Combo' technology make this the energy weapon of choice for many Tournament combatants."
     EffectOffset=(X=65.000000,Y=14.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=22
     HudColor=(B=1,G=204)
     SmallViewOffset=(X=11.000000,Y=11.500000,Z=-4.000000)
     CenteredOffsetY=1.000000
     CenteredRoll=1000
     CenteredYaw=-1000
     CustomCrosshair=8
     CustomCrossHairColor=(B=0,G=204,R=0)
     CustomCrossHairScale=1.333000
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross2"
     InventoryGroup=4
     GroupOffset=10
     PickupClass=Class'tk_FHIWeapons.TurboLaserPickup'
     PlayerViewOffset=(X=4.000000,Y=8.000000,Z=-2.000000)
     PlayerViewPivot=(Pitch=-1000)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.TurboLaserAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=250,Y1=110,X2=330,Y2=145)
     ItemName="Turbo Laser"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=32
     LightSaturation=70
     LightBrightness=150.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.ShockRifle'
     DrawScale=0.700000
     Skins(0)=Texture'UT2004Weapons.NewWeaps.ShockRifleTex0'
     Skins(1)=FinalBlend'tk_FHIWeapons.FHIMat.TurboLaserAmmoFB'
}