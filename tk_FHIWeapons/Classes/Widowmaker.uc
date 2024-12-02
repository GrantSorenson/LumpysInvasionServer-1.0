class Widowmaker extends tk_Weapon
    config(TKWeaponsClient);

var() xEmitter  chargeEmitter;

var(Gfx) vector RechargeOrigin;
var(Gfx) vector RechargeSize;

var transient float LastFOV;
var() bool zoomed;
var color ChargeColor;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
}

simulated function ClientWeaponThrown()
{
    if( (Instigator != None) && (PlayerController(Instigator.Controller) != None) )
        PlayerController(Instigator.Controller).EndZoom();
    Super.ClientWeaponThrown();
}

// compensate for bright fog
simulated function SetZoomBlendColor(Canvas c)
{
    local Byte    val;
    local Color   clr;
    local Color   fog;

    clr.R = 255;
    clr.G = 255;
    clr.B = 255;
    clr.A = 255;

    if( Instigator.Region.Zone.bDistanceFog )
    {
        fog = Instigator.Region.Zone.DistanceFogColor;
        val = 0;
        val = Max( val, fog.R);
        val = Max( val, fog.G);
        val = Max( val, fog.B);

        if( val > 128 )
        {
            val -= 128;
            clr.R -= val;
            clr.G -= val;
            clr.B -= val;
        }
    }
    c.DrawColor = clr;
}

simulated event RenderOverlays( Canvas Canvas )
{
	local float CX,CY,Scale;
	local float chargeBar;
	local float barOrgX, barOrgY;
	local float barSizeX, barSizeY;

	if ( PlayerController(Instigator.Controller) == None )
	{
        Super.RenderOverlays(Canvas);
		zoomed=false;
		return;
	}

    if ( LastFOV > PlayerController(Instigator.Controller).DesiredFOV )
    {
        PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomIn', SLOT_Misc,,,,,false);
    }
    else if ( LastFOV < PlayerController(Instigator.Controller).DesiredFOV )
    {
        PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomOut', SLOT_Misc,,,,,false);
    }
    LastFOV = PlayerController(Instigator.Controller).DesiredFOV;

    if ( PlayerController(Instigator.Controller).DesiredFOV == PlayerController(Instigator.Controller).DefaultFOV )
	{
        Super.RenderOverlays(Canvas);
		zoomed=false;
	}
	else
    {
		if ( FireMode[0].NextFireTime <= Level.TimeSeconds )
		{
			chargeBar = 1.0;
		}
		else
		{
			chargeBar = 1.0 - ((FireMode[0].NextFireTime-Level.TimeSeconds) / FireMode[0].FireRate);
		}

		CX = Canvas.ClipX/2;
		CY = Canvas.ClipY/2;
		Scale = Canvas.ClipX/1024;

		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetDrawColor(0,0,0);

		// Draw the crosshair
		Canvas.SetPos(CX-169*Scale,CY-155*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 164,35, 169,310);
		Canvas.SetPos(CX,CY-155*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 332,345, -169,-310);

		// Draw Cornerbars
		Canvas.SetPos(160*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 0 , 0, 111, 111);

		Canvas.SetPos(Canvas.ClipX-271*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 0, -111, 111);

		Canvas.SetPos(160*Scale,Canvas.ClipY-271*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale, 0 , 111, 111, -111);

		Canvas.SetPos(Canvas.ClipX-271*Scale,Canvas.ClipY-271*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 111, -111, -111);


		// Draw the 4 corners
		Canvas.SetPos(0,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0, 274, 159, -158);

		Canvas.SetPos(Canvas.ClipX-160*Scale,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159,274, -159, -158);

		Canvas.SetPos(0,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0,116, 159, 158);

		Canvas.SetPos(Canvas.ClipX-160*Scale,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159, 116, -159, 158);

		// Draw the Horz Borders
		Canvas.SetPos(160*Scale,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 512, 32, -160);

		Canvas.SetPos(160*Scale,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 352, 32, 160);

		// Draw the Vert Borders
		Canvas.SetPos(0,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 0,308, 160,32);

		Canvas.SetPos(Canvas.ClipX-160*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 160,308, -160,32);

		// Draw the Charging meter
		Canvas.DrawColor = ChargeColor;
        Canvas.DrawColor.A = 255;

		if(chargeBar <1)
		    Canvas.DrawColor.R = 255*chargeBar;
		else
        {
            Canvas.DrawColor.R = 0;
		    Canvas.DrawColor.B = 0;
        }

		if(chargeBar == 1)
		    Canvas.DrawColor.G = 255;
		else
		    Canvas.DrawColor.G = 0;

		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetPos( barOrgX, barOrgY );
		Canvas.DrawTile(Texture'Engine.WhiteTexture',barSizeX,barSizeY*chargeBar, 0.0, 0.0,Texture'Engine.WhiteTexture'.USize,Texture'Engine.WhiteTexture'.VSize*chargeBar);
		zoomed = true;
	}
}

simulated function ClientStartFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = true;
        if( Instigator.Controller.IsA( 'PlayerController' ) )
            PlayerController(Instigator.Controller).ToggleZoom();
    }
    else
    {
        Super.ClientStartFire(mode);
    }
}

simulated function ClientStopFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = false;
        if( Instigator.Controller.IsA( 'PlayerController' ) )
            PlayerController(Instigator.Controller).StopZoom();
    }
    else
    {
        Super.ClientStopFire(mode);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    if ( PlayerController(Instigator.Controller) != None )
    {
        LastFOV = PlayerController(Instigator.Controller).DesiredFOV;
		if ( Instigator.IsLocallyControlled() )
			GotoState('TickEffects');
	}
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    if( Instigator.Controller.IsA( 'PlayerController' ) )
        PlayerController(Instigator.Controller).EndZoom();
    if ( Super.PutDown() )
    {
		GotoState('');
		return true;
	}
	return false;
}

state TickEffects
{
    simulated function Tick( float t )
    {
        if (chargeEmitter == None)
        {
            chargeEmitter = Spawn(class'xEffects.MinigunMuzzleSmoke',self);
            AttachToBone(chargeEmitter, 'tip' );
        }
        chargeEmitter.mRegenPause = ( FireMode[0].NextFireTime > Level.TimeSeconds || Ammo[0] == None || Ammo[0].AmmoAmount == 0 );
    }
}

// AI Interface
function float SuggestAttackStyle()
{
    return -0.4;
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
	return 0;
}

function float GetAIRating()
{
	local Bot B;
	local float ZDiff, dist, Result;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	result = AIRating;
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff < -200 )
		result += 0.1;
	dist = VSize(B.Enemy.Location - Instigator.Location);
	if ( dist > 2000 )
		return ( FMin(2.0,result + (dist - 2000) * 0.0002) );

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
     RechargeOrigin=(X=600.000000,Y=330.000000)
     RechargeSize=(X=10.000000,Y=-180.000000)
     ChargeColor=(B=255,G=255,R=255,A=255)
     FireModeClass(0)=Class'tk_FHIWeapons.WidowmakerFire'
     FireModeClass(1)=Class'XWeapons.SniperZoom'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectSound=Sound'tk_FHIWeapons.FHISnd.SniperRifle_Select'
     SelectForce="SwitchToLightningGun"
     AIRating=0.690000
     CurrentRating=0.690000
     bSniping=True
     Description="The Widowmaker sniper rifle has been introduced to provide a suitable alternative to the regular sniper rifle currently in service in the tournament."
     EffectOffset=(X=100.000000,Y=28.000000,Z=-19.000000)
     DisplayFOV=60.000000
     Priority=32
     HudColor=(B=255,G=170,R=185)
     SmallViewOffset=(X=6.000000,Y=6.000000,Z=-6.000000)
     CenteredOffsetY=-1.000000
     CenteredYaw=-300
     InventoryGroup=9
     GroupOffset=198
     PickupClass=Class'tk_FHIWeapons.WidowmakerPickup'
     PlayerViewOffset=(X=-1.500000,Y=2.300000,Z=-5.000000)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.WidowmakerAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=29,Y1=437,X2=135,Y2=463)
     ItemName="Widowmaker"
     LightType=LT_Pulse
     LightEffect=LE_QuadraticNonIncidence
     LightHue=165
     LightSaturation=170
     LightBrightness=75.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.Widowmaker_1st'
     DrawScale=0.300000
}
