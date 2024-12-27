class MedicDrone extends LumpyDrone;

#exec obj load file="LumpysTextures.utx"

simulated function PostBeginPlay()
{

	// randomize everything so drones behave a little bit differently
	if(Role==ROLE_Authority)
	{
		curOsc = FRand()*3.14159;
		shootCounter = FRand()*ShotDelay;
		targetCounter = FRand()*TargetDelay;
		orbitHeight = FRand()*95 - 40;
	}

	bActive = true;
	// if we were created as a pickup then we'd damn well better stay that way
	if(Level.NetMode != NM_DedicatedServer && !bTrailActive)
	{
        Trail.SetSkin(1);
        Trail = Spawn(class'ColoredTrail',self,,Location,Rotation);
		Trail.SetBase(self);
		Trail.LifeSpan = 9999;
        bTrailActive = true;
	}


	if(bActive)
	{
		Velocity = vector(Rotation)*Speed;
		SetTimer(0.1,true);
	}
	else
	{
		SetPhysics(PHYS_Rotating);
	}

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


defaultproperties
{
    Skins[0]=Texture'DroneTexBlue'
}