class LumpyDrone extends Actor;

//#EXEC TEXTURE IMPORT NAME=DroneTex FILE=Textures\DroneTex.dds MIPS=ON FLAGS=2
//#EXEC NEW StaticMesh FILE=Models\Drone.ase NAME=DroneMesh

#exec obj load file="Drones.u"
#exec obj load file="LumpysTextures.utx"

// stuff from Projectile that we can't use 'cos it makes it get destroyed by movers
var float Speed;

var Pawn protPawn; // owner pawn
var int OrbitDist; // distance at which drone orbits when pawn's not moving

var ColoredTrail Trail;
var bool bTrailActive;
var DroneHealBeam healBeam;

var int healCounter; // counter to keep track of healing
var int HealDist; // maximum distance at which owner can be healed

var float curOsc; // oscillation counter

var int CircleSpeed; // orbital speed
var int OscHeight; // several times the actual weave height
var float OscInc; // increment of oscillation - rate of weaving

var int shootCounter; // counter to keep track of shots

var int targetCounter; // counter to keep track of targeting
var Pawn targetPawn; // target.. um.. pawn?
var int TargetRadius; // radius in which drone will look for targets

var int HealPerSec; // health given per second
var int ShotDelay; // delay between shots
var int TargetDelay; // delay between retargets
var int ProjDamage; // damage done by projectiles

//var DroneSpawner spawner; // if it started out as a pickup, this is what made it

var DroneReplicationInfo dri; // keeps track of number of drones in pickup mode
var int MaxDrones; // maximum number of drones a player can have

var bool bActive; // in active (following) state or pickup?

var int orbitHeight; // vertical offset from player's center - randomized when player has more than one

/*
	If the drone's distance from the Pawn is greater than [ResetPawnDistance] for
	over [ResetTime] seconds, it is considered stuck and gets Reset. ~pd
*/
var float ResetPawnDistance, ResetTime, LastResetCheckTime, LostTime;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		protPawn,HealPerSec,ShotDelay,TargetDelay,ProjDamage,curOsc,shootCounter,targetCounter,orbitHeight;
	reliable if(Role == ROLE_Authority)
		ClientReset;
	unreliable if(Role==ROLE_Authority)
		bActive,dri;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	// randomize everything so drones behave a little bit differently
	if(Role==ROLE_Authority)
	{
		curOsc = FRand()*3.14159;
		shootCounter = FRand()*ShotDelay;
		targetCounter = FRand()*TargetDelay;
		orbitHeight = FRand()*95 - 40;
		LastResetCheckTime = Level.TimeSeconds;
	}

	bActive = true;
	// if we were created as a pickup then we'd damn well better stay that way
	if(Level.NetMode != NM_DedicatedServer && !bTrailActive)
	{
		Trail = Spawn(class'ColoredTrail',self,,Location,Rotation);
		Trail.SetSkin(0);
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
}

simulated function Tick(float dt)
{
	// if there's a healing beam, update it every tick (timer would have noticeable lag)
	if(healBeam != None && protPawn != None)
	{
		healBeam.mSpawnVecA = protPawn.Location;
		healBeam.SetRotation(rotator(protPawn.Location+vect(0,0,48)-Location));
	}
}

simulated function Timer()
{
	local Pawn cTarget;
	local vector toProt;
	local int protTeam;
	local float dist;
	local DroneProj dp;
	
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
		
		//Server-side stuff
		if(Role==ROLE_Authority)
		{
			//Targeting
			if(targetCounter>=TargetDelay && protPawn.Health>0)
			{
				protTeam = protPawn.GetTeamNum();
				targetPawn = None;
				foreach VisibleCollidingActors(class'Pawn',cTarget,TargetRadius)
				{
					if(cTarget != protPawn && (!Level.Game.bTeamGame || cTarget.GetTeamNum() != protTeam) && cTarget.Health>0)
					{
						if(targetPawn==None)
							targetPawn=cTarget;
						else if(VSize(targetPawn.Location-protPawn.Location)>VSize(cTarget.Location-protPawn.Location))
							targetPawn=cTarget;
					}
				}
				
				targetCounter=0;
			}
			targetCounter++;
			
			//Shooting
			if(shootCounter>=ShotDelay)
			{
				if(targetPawn!=None)
				{
					// omg shoot at it
					dp = Spawn(class'DroneProj',protPawn,,Location + Normal(targetPawn.Location-Location)*32,rotator(targetPawn.Location-Location));
					if(dp != None)
					{
						// set projectile instigator so owner gets kill credit
						dp.Instigator = protPawn;
						dp.Damage = ProjDamage;
						PlaySound(Sound'WeaponSounds.LinkGun.BLinkedFire');
						// we don't heal while we're shooting
						if(healBeam!=None)
							healBeam.Destroy();
					}
				}
				shootCounter=0;
			}
			shootCounter++;
		}
	}
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	// bounce off. this makes for some weirdness with the homing but it's not too bad
	Velocity = -(Velocity dot HitNormal) * HitNormal;
	SetRotation(rotator(Velocity));
}

simulated singular function Touch(Actor Other)
{
	if(Other != None && xPawn(Other) != None && bActive)
	{
		// if we don't already have the dri, get an existing one;
		if(dri == None)
			dri = getDroneInfo(Pawn(Other).PlayerReplicationInfo);
		// if we still don't have one, make one
		if(dri == None)
			dri = Spawn(class'DroneReplicationInfo',Other);
		if(dri.numDrones<MaxDrones)
		{
			// player doesn't have maximum, we can attach to them
			// if we were a pickup (which, in this case, we better've been), let the spawner know it's free to make another
			// if(spawner != None)
			// 	spawner.droneTaken=true;
			// if there's no trail (which there should be), make one
			if(Level.NetMode != NM_DedicatedServer && Trail==None)
			{
				Trail = Spawn(class'ColoredTrail',self,,Location,Rotation);
				Trail.SetBase(self);
				Trail.LifeSpan = 9999;
			}
			// set our physics properly
			SetPhysics(PHYS_Projectile);
			RotationRate.Yaw=0;
			// set owner
			protPawn = Pawn(Other);
			// let dri know the player has another drone
			dri.numDrones++;
			// make active (this doesn't do much but it's probably useful somewhere)
			bActive=False;
			// start doing stuff
			SetTimer(0.1,true);
		}
	}
	if(Projectile(Other) != None && protPawn != None)
	{
		// if it's not owner's, make it go boom - but not if we're a pickup, that's just confusin'
		if(Other.Instigator != protPawn)
			Projectile(Other).Explode(Other.Location,-Other.Velocity);
			Log("Drone Killed",'LumpysInvasion');
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{

}

simulated function DroneReplicationInfo getDroneInfo(PlayerReplicationInfo PlayRepInf)
{
	local DroneReplicationInfo dronerepinf;
	foreach DynamicActors(class'DroneReplicationInfo',dronerepinf)
	{
		if(dronerepinf.PRI==PlayRepInf)
		{
			return dronerepinf;
		}
	}
	return None;
}

simulated function Destroyed()
{
	if(Trail != None)
		Trail.Destroy();
		bTrailActive = false;
	if(healBeam != None)
		healBeam.Destroy();
	if(dri != None)
		dri.Destroy();
}

//called every once in a while to check whether this Drone is stuck and should be reset ~pd
function bool CheckReset()
{
	local float PawnDistance, dt;

	dt = Level.TimeSeconds - LastResetCheckTime;
	LastResetCheckTime = Level.TimeSeconds;

	if(protPawn != None)
	{
		PawnDistance = VSize(Location - protPawn.Location);
		if(PawnDistance > ResetPawnDistance)
		{
			LostTime += dt;
			
			if(LostTime > ResetTime)
			{
				//stuck, reset
				SetLocation(protPawn.Location + vect(0, -32, 64));
				SetRotation(protPawn.Rotation);
				Velocity = vector(Rotation) * Speed;
				LostTime = 0.f;
				
				ClientReset(Location, Rotation);
				
				return true;
			}
		}
		else
		{
			LostTime = 0.f;
		}
	}
	
	return false;
}

simulated function ClientReset(vector NewLocation, rotator NewRotation)
{
	if(Role < ROLE_Authority)
	{
		SetLocation(NewLocation);
		SetRotation(NewRotation);
		Velocity = vector(Rotation) * Speed;
	}
}

defaultproperties
{
    Speed=600.00
    OrbitDist=64
    HealDist=400
    CircleSpeed=420
    OscHeight=240
    OscInc=0.50
    TargetRadius=2000
    HealPerSec=10
    ShotDelay=6
    TargetDelay=15
    ProjDamage=9
    MaxDrones=3
	ResetPawnDistance=1000.00
    ResetTime=3.00
    bActive=True
	bTrailActive = false
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DroneMesh'
    bAlwaysRelevant=True
    bReplicateInstigator=True
    Physics=6
    RemoteRole=2
	Role=ROLE_Authority
    AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
    LifeSpan=9999.00
    DrawScale=2.50
    Skins[0]=Texture'DroneTex'
    bUnlit=True
    bDisturbFluidSurface=True
    SoundVolume=255
    SoundRadius=50.00
    CollisionRadius=20.00
    CollisionHeight=20.00
    bCollideActors=True
    bCollideWorld=True
    bUseCylinderCollision=True
    bBounce=True
    bFixedRotationDir=True
    RotationRate=(Pitch=0,Yaw=24000,Roll=0),
    DesiredRotation=(Pitch=0,Yaw=30000,Roll=0),
}
