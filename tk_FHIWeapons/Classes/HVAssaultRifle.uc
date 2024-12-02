class HVAssaultRifle extends tk_Weapon
	config(TKWeaponsClient);

var float DualPickupTime;
var HVAssaultAttachment OffhandActor;
var bool bDualMode, bWasDualMode, bFireLeft;

replication
{
	reliable if (Role == ROLE_Authority)
		bDualMode;
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if ((Role < ROLE_Authority) && (Instigator != None) && (Instigator.Controller != None) && (Instigator.Weapon != self) && (Instigator.PendingWeapon != self))
		Instigator.Controller.ClientSwitchToBestWeapon();
}

simulated function bool WeaponCentered()
{
	return !bDualMode && Super.WeaponCentered();
}

simulated event RenderOverlays( Canvas Canvas )
{
	local bool bRealHidden;
	local int RealHand;

	if (Instigator == None)
		return;

	if (Instigator.Controller != None)
		Hand = Instigator.Controller.Handedness;

	if ((Hand < -1.0) || (Hand > 1.0))
		return;

	RealHand = Hand;
	if (bDualMode && (Hand == 0))
	{
		Instigator.Controller.Handedness = -1;
		Hand = -1;
	}

	if (bDualMode && (FireMode[1].FlashEmitter != None))
	{
		bRealHidden = FireMode[1].FlashEmitter.bHidden;
		if (bFireLeft)
			FireMode[1].FlashEmitter.bHidden = true;
		Super.RenderOverlays(Canvas);
		FireMode[1].FlashEmitter.bHidden = bRealHidden;
	}
	else
	{
		Super.RenderOverlays(Canvas);
	}

	if (bDualMode)
		RenderDualOverlay(Canvas);

	if (Instigator.Controller != None)
		Instigator.Controller.Handedness = RealHand;
}

simulated function RenderDualOverlay(Canvas Canvas)
{
	local vector NewScale3D;
	local rotator WeaponRotation;
	local bool bRealHidden;

	Hand *= -1;
	newScale3D = default.DrawScale3D;
	newScale3D.Y *= Hand;
	SetDrawScale3D(newScale3D);
	PlayerViewPivot.Roll = default.PlayerViewPivot.Roll * Hand;
	PlayerViewPivot.Yaw = default.PlayerViewPivot.Yaw * Hand;
	RenderedHand = Hand;

	if (class'PlayerController'.default.bSmallWeapons)
		PlayerViewOffset = SmallViewOffset;
	else
		PlayerViewOffset = default.PlayerViewOffset;

	PlayerViewOffset.Y *= Hand;

	SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
	WeaponRotation = Instigator.GetViewRotation();

	if (bDualMode != bWasDualMode)
	{
		bWasDualMode = true;
		DualPickupTime = Level.Timeseconds;
	}

	if (DualPickupTime > Level.TimeSeconds - 0.5)
		WeaponRotation.Pitch = WeaponRotation.Pitch - 16384 - 32768 * (DualPickupTime - Level.TimeSeconds);

	SetRotation(WeaponRotation);

	bDrawingFirstPerson = true;
	if (bDualMode && (FireMode[1].FlashEmitter != None))
	{
		bRealHidden = FireMode[1].FlashEmitter.bHidden;
		if (!bFireLeft)
			FireMode[1].FlashEmitter.bHidden = true;
		Canvas.DrawActor(self, false, false, DisplayFOV);
		FireMode[1].FlashEmitter.bHidden = bRealHidden;
	}
	else
	{
		Canvas.DrawActor(self, false, false, DisplayFOV);
	}
	bDrawingFirstPerson = false;
	Hand *= -1;
}

simulated function DetachFromPawn(Pawn P)
{
	bFireLeft = false;
	HVBombFire(FireMode[1]).ReturnToIdle();
	Super.DetachFromPawn(P);
	if (OffhandActor != None)
	{
		OffhandActor.Destroy();
		OffhandActor = None;
	}
}

function AttachToPawn(Pawn P)
{
	local name BoneName;

	if (ThirdPersonActor == None)
	{
		ThirdPersonActor = Spawn(AttachmentClass,Owner);
		InventoryAttachment(ThirdPersonActor).InitFor(self);
	}

	BoneName = P.GetWeaponBoneFor(self);
	if (BoneName == '')
	{
		ThirdPersonActor.SetLocation(P.Location);
		ThirdPersonActor.SetBase(P);
	}
	else
	{
		P.AttachToBone(ThirdPersonActor, BoneName);
	}

	if (bDualMode)
	{
		BoneName = P.GetOffHandBoneFor(self);
		if (BoneName == '')
			return;

		if (OffhandActor == None)
		{
			OffhandActor = HVAssaultAttachment(Spawn(AttachmentClass, Owner));
			OffhandActor.InitFor(self);
		}

		P.AttachToBone(OffhandActor,BoneName);
		if (OffhandActor.AttachmentBone == '')
		{
			OffhandActor.Destroy();
		}
		else
		{
			ThirdPersonActor.SetDrawScale(0.3);
			OffhandActor.SetDrawScale(0.3);
			OffhandActor.bDualGun = true;
			OffhandActor.TwinGun = HVAssaultAttachment(ThirdPersonActor);

			OffhandActor.SetRelativeRotation(rot(0,0,32768));
			OffhandActor.SetRelativeLocation(vect(40,-3,-7));

			HVAssaultAttachment(ThirdPersonActor).TwinGun = OffhandActor;
		}
	}
}

simulated function DrawWeaponInfo(Canvas Canvas)
{
	NewDrawWeaponInfo(Canvas, 0.705*Canvas.ClipY);
}

simulated function NewDrawWeaponInfo(Canvas Canvas, float YPos)
{
	local int i,Count;
	local float ScaleFactor;

	ScaleFactor = 99 * Canvas.ClipX/3200;
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = class'HUD'.Default.WhiteColor;
	Count = Min(8,AmmoAmount(1));
	for(i = 0; i < Count; i++)
	{
		Canvas.SetPos(Canvas.ClipX - (0.5*i+1) * ScaleFactor, YPos);
		Canvas.DrawTile( Material'tk_FHIWeapons.FHIHud.HUDIcons', ScaleFactor, ScaleFactor, 283, 199, 356, 269);
	}

	if (AmmoAmount(1) > 8)
	{
		Count = Min(16,AmmoAmount(1));
		for(i = 8; i < Count; i++)
		{
			Canvas.SetPos(Canvas.ClipX - (0.5*(i-8)+1) * ScaleFactor, YPos - ScaleFactor);
			Canvas.DrawTile( Material'tk_FHIWeapons.FHIHud.HUDIcons', ScaleFactor, ScaleFactor, 283, 199, 356, 269);
		}
	}
}

function byte BestMode()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ((B != None) && (B.Enemy != None))
	{
		if (((FRand() < 0.1) || !B.EnemyVisible()) && (AmmoAmount(1) >= FireMode[1].AmmoPerFire))
			return 1;
	}

	if (AmmoAmount(0) >= FireMode[0].AmmoPerFire)
		return 0;

	return 1;
}

function bool HandlePickupQuery( pickup Item )
{
	if (class == Item.InventoryType)
	{
		if (bDualMode)
			return super.HandlePickupQuery(Item);

		bDualMode = true;
		if (Instigator.Weapon == self)
		{
			PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
			AttachToPawn(Instigator);
		}

		if (Level.GRI.WeaponBerserk > 1.0)
			CheckSuperBerserk();
		else
			FireMode[0].FireRate = FireMode[0].Default.FireRate *  0.55;

		FireMode[0].Spread = FireMode[0].Default.Spread * 1.5;
		if (xPawn(Instigator) != None && xPawn(Instigator).bBerserk)
			StartBerserk();

		return false;
	}

	if (item.inventorytype == AmmoClass[1])
	{
		if ((AmmoCharge[1] >= MaxAmmo(1)) && (AmmoCharge[0] >= MaxAmmo(0)))
			return true;
		item.AnnouncePickup(Pawn(Owner));
		AddAmmo(50, 0);
		AddAmmo(Ammo(item).AmmoAmount, 1);
		item.SetRespawn();
		return true;
	}

	if (Inventory == None)
		return false;

	return Inventory.HandlePickupQuery(Item);
}

simulated function int MaxAmmo(int mode)
{
	if (bDualMode)
		return 2 * FireMode[mode].AmmoClass.Default.MaxAmmo;
	else
		return FireMode[mode].AmmoClass.Default.MaxAmmo;
}

function float GetAIRating()
{
	local Bot B;

	if (!bDualMode)
		return AIRating;

	B = Bot(Instigator.Controller);
	if ((B == None) || (B.Enemy == None))
		return AIRating;

	return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location), 0, 1000));
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.HVAssaultFire'
     FireModeClass(1)=Class'tk_FHIWeapons.HVBombFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.AssaultRifle.SwitchToAssaultRifle'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     Description="MkII upgraded Assault Rifle. Fires hyper velocity bullets at an extreme rate of fire with less spread than the original model. Secondary grenades have been replaced with deadly anti-gravity (AG) bombs that pack considerable punch and ignore armor."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=20
     HudColor=(B=255,G=0)
     SmallViewOffset=(X=13.000000,Y=12.000000,Z=-10.000000)
     CenteredOffsetY=-5.000000
     CenteredRoll=3000
     CenteredYaw=-1500
     CustomCrosshair=11
     CustomCrossHairScale=0.666700
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=2
     GroupOffset=10
     PickupClass=Class'tk_FHIWeapons.HVAssaultRiflePickup'
     PlayerViewOffset=(X=4.000000,Y=5.500000,Z=-6.000000)
     PlayerViewPivot=(Pitch=400)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.HVAssaultAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="HV Assault Rifle"
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.AssaultRifle'
     DrawScale=0.800000
}