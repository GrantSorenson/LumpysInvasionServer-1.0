class Pistol extends tk_Weapon
	config(TKWeaponsClient);

var float DualPickupTime;
var PistolAttachment OffhandActor;
var bool bDualMode;
var bool bWasDualMode;
var bool bFireLeft;

replication
{
	reliable if (Role == ROLE_Authority)
		bDualMode;
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

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    RealHand = Hand;
    if ( bDualMode && (Hand == 0) )
    {
		Instigator.Controller.Handedness = -1;
		Hand = -1;
	}

    if ( bDualMode && (FireMode[1].FlashEmitter != None) )
    {
		bRealHidden = FireMode[1].FlashEmitter.bHidden;
		if ( bFireLeft )
			FireMode[1].FlashEmitter.bHidden = true;
		Super.RenderOverlays(Canvas);
		FireMode[1].FlashEmitter.bHidden = bRealHidden;
	}
	else
		Super.RenderOverlays(Canvas);

	if ( bDualMode )
		RenderDualOverlay(Canvas);
	if ( Instigator.Controller != None )
		Instigator.Controller.Handedness = RealHand;
}

simulated function RenderDualOverlay(Canvas Canvas)
{
	local vector NewScale3D;
	local rotator WeaponRotation;
	local bool bRealHidden;

	Hand *= -1;
	newScale3D = Default.DrawScale3D;
	newScale3D.Y *= Hand;
	SetDrawScale3D(newScale3D);
	PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
	PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
	RenderedHand = Hand;

	if ( class'PlayerController'.Default.bSmallWeapons )
		PlayerViewOffset = SmallViewOffset;
	else
		PlayerViewOffset = Default.PlayerViewOffset;

	PlayerViewOffset.Y *= Hand;

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    WeaponRotation = Instigator.GetViewRotation();

    if ( bDualMode != bWasDualMode )
    {
		bWasDualMode = true;
		DualPickupTime = Level.Timeseconds;
	}
    if ( DualPickupTime > Level.TimeSeconds - 0.5 )
		WeaponRotation.Pitch = WeaponRotation.Pitch - 16384 - 32768 * (DualPickupTime - Level.TimeSeconds);

    SetRotation( WeaponRotation );

    bDrawingFirstPerson = true;
    if ( bDualMode && (FireMode[1].FlashEmitter != None) )
    {
		bRealHidden = FireMode[1].FlashEmitter.bHidden;
		if ( !bFireLeft )
			FireMode[1].FlashEmitter.bHidden = true;
	    Canvas.DrawActor(self, false, false, DisplayFOV);
		FireMode[1].FlashEmitter.bHidden = bRealHidden;
	}
	else
	   Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
    Hand *= -1;
}

simulated function DetachFromPawn(Pawn P)
{
	bFireLeft = false;
	Super.DetachFromPawn(P);
	if ( OffhandActor != None )
	{
		OffhandActor.Destroy();
		OffhandActor = None;
	}
}

function AttachToPawn(Pawn P)
{
	local name BoneName;

	if ( ThirdPersonActor == None )
	{
		ThirdPersonActor = Spawn(AttachmentClass,Owner);
		InventoryAttachment(ThirdPersonActor).InitFor(self);
	}
	BoneName = P.GetWeaponBoneFor(self);
	if ( BoneName == '' )
	{
		ThirdPersonActor.SetLocation(P.Location);
		ThirdPersonActor.SetBase(P);
	}
	else
		P.AttachToBone(ThirdPersonActor,BoneName);

	if ( bDualMode )
	{
		BoneName = P.GetOffHandBoneFor(self);
		if ( BoneName == '' )
			return;
		if ( OffhandActor == None )
		{
			OffhandActor = PistolAttachment(Spawn(AttachmentClass,Owner));
			OffhandActor.InitFor(self);
		}
		P.AttachToBone(OffhandActor,BoneName);
		if ( OffhandActor.AttachmentBone == '' )
			OffhandActor.Destroy();
		else
		{
			ThirdPersonActor.SetDrawScale(0.6);
			OffhandActor.SetDrawScale(0.6);
			OffhandActor.bDualGun = true;
			OffhandActor.TwinGun = PistolAttachment(ThirdPersonActor);

			if ( Mesh == OldMesh )
			{
			    OffhandActor.SetRelativeRotation(rot(0,32768,0));
			    OffhandActor.SetRelativeLocation(vect(20,-10,-5));
			}
			else
			{
			    OffhandActor.SetRelativeRotation(rot(0,32768,0));
			    OffhandActor.SetRelativeLocation(vect(10,-2,-6));
			}

			PistolAttachment(ThirdPersonActor).TwinGun = OffhandActor;
		}
	}
}

function bool HandlePickupQuery( pickup Item )
{
	if ( class == Item.InventoryType )
    {
		if ( bDualMode )
			return super.HandlePickupQuery(Item);
		bDualMode = true;
		if ( Instigator.Weapon == self )
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

	if ( item.inventorytype == AmmoClass[0] )
	{
		if ( (AmmoCharge[1] >= MaxAmmo(1)) && (AmmoCharge[0] >= MaxAmmo(0)) )
			return true;
		item.AnnouncePickup(Pawn(Owner));
		AddAmmo(50, 0);
		AddAmmo(Ammo(item).AmmoAmount, 1);
		item.SetRespawn();
		return true;
	}

    if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

simulated function int MaxAmmo(int mode)
{
	if ( bDualMode )
		return 2 * FireMode[mode].AmmoClass.Default.MaxAmmo;
	else
		return FireMode[mode].AmmoClass.Default.MaxAmmo;
}

// AI Interface
function float SuggestAttackStyle()
{
    return 0.4;
}

function float SuggestDefenseStyle()
{
    return 0.2;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Enemy != None) )
	{
	    if ( ((FRand() < 0.1) || !B.EnemyVisible()) && (AmmoAmount(1) >= FireMode[1].AmmoPerFire) )
		    return 1;
	}
    if ( AmmoAmount(0) >= FireMode[0].AmmoPerFire )
		return 0;
	return 1;
}

function float GetAIRating()
{
	local Bot B;
	local float ZDiff, dist, Result;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
	if ( B.IsShootingObjective() )
		return AIRating - 0.15;
	if ( B.Enemy == None )
		return AIRating;

	if ( B.Stopped() )
		result = AIRating + 0.1;
	else
		result = AIRating - 0.1;
	if ( Vehicle(B.Enemy) != None )
		result -= 0.2;
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff < -200 )
		result += 0.1;
	dist = VSize(B.Enemy.Location - Instigator.Location);
	if ( dist > 2000 )
	{
		if ( !B.EnemyVisible() )
			result = result - 0.15;
		return ( FMin(2.0,result + (dist - 2000) * 0.0002) );
	}
	if ( !B.EnemyVisible() )
		return AIRating - 0.1;

	return result;
}


function bool RecommendRangedAttack()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return true;

	return ( VSize(B.Enemy.Location - Instigator.Location) > 2000 * (1 + FRand()) );
}
// end AI Interface

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.PistolFire'
     FireModeClass(1)=Class'tk_FHIWeapons.PistolProjFire'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectAnimRate=0.750000
     PutDownAnimRate=0.780000
     PutDownTime=0.580000
     BringUpTime=0.600000
     SelectSound=Sound'tk_FHIWeapons.FHISnd.Pistol_Select'
     SelectForce="NewSniperLoad"
     AIRating=0.690000
     CurrentRating=0.690000
     bSniping=True
     Description="This high muzzle velocity pistol is a lethal weapon at short to medium range, especially if you can land a head shot."
     EffectOffset=(X=100.000000,Y=28.000000,Z=-19.000000)
     DisplayFOV=60.000000
     Priority=21
     HudColor=(B=255,G=170,R=185)
     SmallViewOffset=(X=30.900002,Y=15.000000,Z=-14.000000)
     CenteredOffsetY=0.000000
     CenteredYaw=-500
     CustomCrosshair=7
     CustomCrossHairColor=(G=170,R=185)
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross1"
     InventoryGroup=5
     GroupOffset=22
     PickupClass=Class'tk_FHIWeapons.PistolPickup'
     PlayerViewOffset=(X=20.000000,Y=9.300000,Z=-11.000000)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.PistolAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=51,Y1=108,X2=121,Y2=147)
     ItemName="Pistol"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=170
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     CullDistance=5000.000000
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.Pistol_1st'
     DrawScale=0.810000
}
