//-------------------------------
// I think milk borrowed this gun from some other mod, not sure
// (You could probably find the original at filefront)
// Charybdis added the overheat function, to reduce spam :D
// Comments by Charybdis
// Overheating by request from Frag. Please peoples, keep the spam down!!
//-------------------------------

class LilLadyTwo extends ShockRifle;

var float Heat;
var bool OverHeated;
var bool CoolTimeSet;
var float CoolTime;

replication
{
	unreliable if( bNetDirty && Role==ROLE_Authority )
		Heat;
}


function byte BestMode()
{
	return byte(Rand(2)); //why even have bot support?
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

	Heat = 0.01;
}

simulated function float ChargeBar() //return will show percent of charge bar (between 0-1)
{
	return Heat; //if 1 is returned, it will blink at max charge percent, good visual effect for an overheat
}

simulated function bool ReadyToFire(int Mode)
{
    if( OverHeated ) {
		return false;
    }
	return super.ReadyToFire(Mode);
}

simulated function Tick(float dt)
{
	//Level.Game.Broadcast(owner,level.timeseconds);

	if (heat <= 0.0) //if no heat, don't subtract any more
		return;

	else if (heat >= 1.0) //if overheated
	{
		if (CoolTimeSet)
		{
			if (CoolTime < Level.TimeSeconds)
			{
				heat = 0.98; //still make people wait for cooling after overheat is done
				overheated = false;
				CoolTimeSet = false;
					return;
			}
			else
				return;
		}
		if (!CoolTimeSet)
		{
			CoolTime = Level.TimeSeconds + 5.0; //5 seconds to let a spammer reconsider :D
			overheated = true;
			ImmediateStopFire();
			CoolTimeSet = true;

			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'LilLadyTwoMessage', 0);
				return;
		}
	}
	if (!overheated)
	{
		heat -= 0.1 * dt;
			return;
	}
}

defaultproperties
{
     FireModeClass(0)=Class'LumpyRPGWeapons.LilLadyTwoProjFire'
     FireModeClass(1)=Class'LumpyRPGWeapons.LilLadyTwoAltFire'
     SelectSound=Sound'PickupSounds.AssaultRiflePickup'
     bShowChargingBar=True
     PickupClass=None
     AttachmentClass=Class'LumpyRPGWeapons.LilLadyTwoAttachment'
     ItemName="LilLady"
     Skins(0)=Texture'RBTexturesINV.LilLady.LilLadyTwo'
     Skins(1)=FinalBlend'UT2004Weapons.Shaders.RedShockFinal'
}
