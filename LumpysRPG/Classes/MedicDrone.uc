class MedicDrone extends LumpyDrone;

#exec obj load file="LumpysTextures.utx"

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer && !bTrailActive)
	{
		Trail = Spawn(class'ColoredTrail', self,, Location, Rotation);
		Trail.SetSkin(1); // blue trail
		Trail.SetBase(self);
		Trail.LifeSpan = 9999;
		bTrailActive = true;
	}

	// Timer must be started client-side here — InitDrone is server-only.
	// Super.PostBeginPlay() would start it again via LumpyDrone, so call it last.
	Super.PostBeginPlay();
}

simulated function Timer()
{
	local vector toProt;
	local float dist;
	
	if(protPawn == None || protPawn.Health<=0)
		Destroy();
	else
	{

        CheckReset();

		//Movement
		curOsc += OscInc;
		toProt = (protPawn.Location+vect(0,0,1)*orbitHeight) - Location;
		dist = VSize(toProt);
		Velocity = 0.1 * Velocity + 0.3 * ((Normal(toProt) cross vect(0,0,1)) * CircleSpeed) + 0.2 * cos(curOsc) * vect(0,0,1) * OscHeight + 0.4 * Normal(toProt) * Speed * (dist - OrbitDist)/OrbitDist;
		SetRotation(rotator(Velocity)+rotator(vect(1,0,0))+rotator(vect(0,1,0)));
		
		//Healing
		healCounter++;
		if(dist < HealDist)
		{
			if(healBeam == None && protPawn.Health < protPawn.HealthMax && protPawn.Health>0 && targetPawn == None && Level.NetMode != NM_DedicatedServer)
			{
				healBeam = Spawn(class'DroneHealBeam',self,,Location,rotator(protPawn.Location-Location));
				healBeam.SetBase(self);
                healBeam.Skins[0] = FinalBlend'XEffectMat.Link.LinkBeamBlueFB';
			}
		}
		if((dist > HealDist + 16 || protPawn.Health >= protPawn.HealthMax) && healBeam != None)
		{
			healBeam.Destroy();
		}
		if(healCounter==2)
		{
			if(dist < HealDist && protPawn.Health>0 && targetPawn == None && Role==ROLE_Authority)
				protPawn.GiveHealth(HealPerSec/5,protPawn.HealthMax);
			healCounter=0;
		}
	}
}


// LumpyDrone.Tick() was emptied to remove healing from combat drones.
// MedicDrone needs it back specifically to keep the heal beam pointed at the player.
// healBeam.SetBase(self) tracks the beam's tail to the drone, but the beam's head
// (mSpawnVecA) and rotation toward the player must be updated every frame here.
simulated function Tick(float dt)
{
	if (healBeam != None && protPawn != None)
	{
		healBeam.mSpawnVecA = protPawn.Location;
		healBeam.SetRotation(rotator(protPawn.Location + vect(0,0,48) - Location));
	}
}

defaultproperties
{
    Skins[0]=Texture'DroneTexBlue'
}