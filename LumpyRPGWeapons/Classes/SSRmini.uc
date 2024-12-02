//====================================
// SSRmini
// ===================================

class SSRmini extends Weapon;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

var     float           CurrentRoll;
var     float           RollSpeed;
//var     float           FireTime;
var() xEmitter          ShellCaseEmitter;
var() vector            AttachLoc;
var() rotator           AttachRot;
var   int               CurrentMode;
var() float             GearRatio;
var() float             GearOffset;
var() float             Blend;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
        return;

    ShellCaseEmitter = spawn(class'ShellSpewer');
	if ( ShellCaseEmitter != None )
	{
		ShellCaseEmitter.Trigger(Self, Instigator); //turn off
		AttachToBone(ShellCaseEmitter, 'shell');
	}
}

function DropFrom(vector StartLocation)
{
	Super.DropFrom(StartLocation);
}

simulated function OutOfAmmo()
{
    if ( (Instigator == None) || !Instigator.IsLocallyControlled() || HasAmmo() )
        return;

	Instigator.AmbientSound = None;
	Instigator.SoundVolume = Instigator.default.SoundVolume;
    DoAutoSwitch();
}

simulated function Destroyed()
{
    if (ShellCaseEmitter != None)
    {
        ShellCaseEmitter.Destroy();
        ShellCaseEmitter = None;
    }

    Super.Destroyed();
}


simulated function SpawnShells(float amountPerSec)
{
	ShellCaseEmitter.mRegenRange[0] = amountPerSec;
	ShellCaseEmitter.mRegenRange[1] = amountPerSec;
        ShellCaseEmitter.Trigger(self, Instigator);
}

defaultproperties
{
     AttachLoc=(X=-77.000000,Y=6.000000,Z=4.000000)
     AttachRot=(Pitch=22000,Yaw=-16384)
     GearRatio=-2.370000
     Blend=1.000000
     FireModeClass(0)=Class'SSRminiFire'
     FireModeClass(1)=Class'SSRminiAltProjFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'WeaponSounds.Minigun.SwitchToMiniGun'
     SelectForce="SwitchToMiniGun"
     AIRating=0.710000
     CurrentRating=0.710000
     Description="The Schultz-Metzger T23-A 23mm rotary cannon is capable of firing both high-velocity caseless ammunition and cased rounds. With an unloaded weight of only 8 kilograms, the T23 is portable and maneuverable, easily worn across the back when employing the optional carrying strap.|The T23-A is the rotary cannon of choice for the discerning soldier."
     EffectOffset=(X=100.000000,Y=18.000000,Z=-16.000000)
     DisplayFOV=60.000000
     Priority=8
     HudColor=(B=255)
     SmallViewOffset=(X=8.000000,Y=1.000000,Z=-2.000000)
     CenteredOffsetY=-6.000000
     CenteredRoll=0
     CenteredYaw=-500
     CustomCrosshair=2
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Circle1"
     InventoryGroup=6
     PickupClass=Class'SSRminiPickup'
     PlayerViewOffset=(X=2.000000,Y=-1.000000)
     PlayerViewPivot=(Yaw=500)
     BobDamping=2.250000
     AttachmentClass=Class'LumpyRPGWeapons.SSRminiAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=246,Y1=80,X2=332,Y2=106)
     ItemName="SSRmini"
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     Mesh=SkeletalMesh'Weapons.Minigun_1st'
     DrawScale=0.400000
     SoundRadius=400.000000
     HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
}
