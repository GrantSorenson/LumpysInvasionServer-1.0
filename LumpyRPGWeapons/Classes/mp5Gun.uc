//=============================================================================
// MP5.
//=============================================================================
class MP5Gun extends Weapon config(user);

#EXEC OBJ LOAD FILE=ZenWIcons.utx

var int clientInventoryGroup;
var (FirstPerson) float CenteredOffsetZ;
var (FirstPerson) float CenteredOffsetX;
var int  IconOffsetY[9];  // Icon offsetY in HudCDeathmatch class for each inventorygroup
var() config bool bOverPowered;
var bool bOverPoweredRep;

replication
{
reliable if (role == role_Authority)
	clientInventoryGroup, bOverPoweredRep;
}

simulated function PostNetBeginPlay()
{
	if(Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
	{
		clientInventoryGroup = InventoryGroup;
		bOverPoweredRep = bOverPowered;
	}
	else if(Level.NetMode == NM_client)
	{
		InventoryGroup=clientInventoryGroup;
		bOverPowered=bOverPoweredRep;
	}

	// +8 because based on the AssaultRifle Inventorygroup IconOffsetY=-8
	IconCoords.Y2 = default.IconCoords.Y2 + (IconOffsetY[InventoryGroup-1]+8);

    if (bOverPowered)
    {
        FireMode[0].default.DamageAtten=1.2;
        class'MP5GunGrenade'.default.Damage=200;
    }
    else
    {
        FireMode[0].default.DamageAtten=1.0;
        class'MP5GunGrenade'.default.Damage=100;
    }
	if ( (Role < ROLE_Authority) && (Instigator != None) && (Instigator.Controller != None) && (Instigator.Weapon != self) && (Instigator.PendingWeapon != self) )
		Instigator.Controller.ClientSwitchToBestWeapon();

	super.PostNetBeginPlay();
}

//For Server play
simulated function DetachFromPawn(Pawn P)
{
    Mp5AltFire(FireMode[1]).ReturnToIdle();
    Super.DetachFromPawn(P);
}

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
    for( i=0; i<Count; i++ )
    {
		Canvas.SetPos(Canvas.ClipX - (0.5*i+1) * ScaleFactor, YPos);
		Canvas.DrawTile( Material'HudContent.Generic.HUD', ScaleFactor, ScaleFactor, 174, 259, 46, 45);
	}
	if ( AmmoAmount(1) > 8 )
	{
		Count = Min(16,AmmoAmount(1));
		for( i=8; i<Count; i++ )
		{
			Canvas.SetPos(Canvas.ClipX - (0.5*(i-8)+1) * ScaleFactor, YPos - ScaleFactor);
			Canvas.DrawTile( Material'HudContent.Generic.HUD', ScaleFactor, ScaleFactor, 174, 259, 46, 45);
		}
	}
}

simulated function float ChargeBar()
{
	if (FireMode[1].bIsFiring)
		return FMin(1,FireMode[1].HoldTime/MP5AltFire(FireMode[1]).mHoldClampMax);
	return 0;
}

simulated event RenderOverlays( Canvas Canvas )
{
    local int m;
	local vector NewScale3D;
	local rotator CenteredRotation;

    CheckOutOfAmmo();
    if (Instigator == None)
        return;

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(None, false, true); // amb: Clear the z-buffer here

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }
    if ( Hand != RenderedHand )
    {
		newScale3D = Default.DrawScale3D;
		if ( Hand != 0 )
			newScale3D.Y *= Hand;
		SetDrawScale3D(newScale3D);
		if ( Hand == 0 )
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw;
		}
		else
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
		}
		RenderedHand = Hand;
	}
	if ( class'PlayerController'.Default.bSmallWeapons || Level.bClassicView )
		PlayerViewOffset = SmallViewOffset;
	else
		PlayerViewOffset = Default.PlayerViewOffset;

	if ( Hand == 0 )
	{
		PlayerViewOffset.Y = CenteredOffsetY;
		PlayerViewOffset.Z = CenteredOffsetZ;
		PlayerViewOffset.X = CenteredOffsetX;
	}
	else
		PlayerViewOffset.Y *= Hand;

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    if ( Hand == 0 )
    {
		CenteredRotation = Instigator.GetViewRotation();
		CenteredRotation.Yaw += CenteredYaw;
		CenteredRotation.Roll = CenteredRoll;
	    SetRotation(CenteredRotation);
    }
    else
	    SetRotation( Instigator.GetViewRotation() );

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
	if ( Hand == 0 )
		PlayerViewOffset.Y = 0;
}

function bool HandlePickupQuery( pickup Item )
{
	local WeaponPickup wpu;

	if ( item.inventorytype == AmmoClass[1] )
	{
		if (AmmoMaxed(0) && AmmoMaxed(1))
			return true;

		item.AnnouncePickup(Pawn(Owner));
		AddAmmo(Ammo[0].PickupAmmo, 0);
		AddAmmo(Ammo[1].PickupAmmo, 1);
		item.SetRespawn();
		return true;

	}
	if (class == Item.InventoryType)
    	{
        	wpu = WeaponPickup(Item);
        	if (wpu != None)
           	 	return !wpu.AllowRepeatPickup();
        	else
            		return false;
    	}
        if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}
simulated function int MaxAmmo(int mode)
{
		return FireMode[mode].AmmoClass.Default.MaxAmmo;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

defaultproperties
{
    CenteredOffsetZ=-5.50
    CenteredOffsetX=9.00
    IconOffsetY(0)=-12
    IconOffsetY(1)=-8
    IconOffsetY(3)=-12
    IconOffsetY(4)=-4
    IconOffsetY(5)=-18
    IconOffsetY(6)=-10
    IconOffsetY(7)=-13
    IconOffsetY(8)=-15
    bOverPowered=True
    FireModeClass(0)=Class'mp5GunFire'
    FireModeClass(1)=Class'MP5AltFire'
    SelectAnim=AltFire
    PutDownAnim=PutDown
    IdleAnimRate=0.00
    SelectSound=Sound'WeaponSounds.AssaultRifle.SwitchToAssaultRifle'
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.70
    CurrentRating=0.40
    bShowChargingBar=True
    bNoAmmoInstances=False
    EffectOffset=(X=100.00,Y=25.00,Z=-10.00),
    MessageNoAmmo=" is out of ammunition"
    DisplayFOV=70.00
    Priority=22
    HudColor=(R=192,G=128,B=255,A=255),
    SmallViewOffset=(X=10.00,Y=10.00,Z=-6.00),
    CenteredOffsetY=2.00
    CenteredYaw=-200
    CustomCrosshair=7
    InventoryGroup=2
    PickupClass=Class'mp5Gunpickup'
    PlayerViewOffset=(X=7.00,Y=7.00,Z=-3.00),
    PlayerViewPivot=(Pitch=400,Yaw=0,Roll=0),
    bDrawingFirstPerson=True
    BobDamping=1.70
    AttachmentClass=Class'MP5GunAttachment'
    IconMaterial=Texture'ZenWIcons.ZWicons'
		IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="MP5"
    LightType=2
    LightEffect=13
    LightHue=30
    LightSaturation=150
    LightBrightness=150.00
    LightRadius=4.00
    LightPeriod=3
    Mesh=SkeletalMesh'ZWeaponsAnim2.mp5'
    UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}
