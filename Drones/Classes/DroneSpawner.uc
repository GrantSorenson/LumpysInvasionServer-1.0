class DroneSpawner extends Actor;

var int ProjDamage;
var int HealPerSec;
var int ShotDelay;
var int TargetDelay;
var int spawnProb;

var bool droneTaken;

replication
{
	reliable if(bNetInitial && Role==ROLE_Authority)
		ProjDamage,HealPerSec,ShotDelay,TargetDelay,spawnProb;
	unreliable if(Role==ROLE_Authority)
		droneTaken;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(30,true);
	Timer();
}

simulated function Timer()
{
	local Drone drone;
	if(droneTaken && FRand() * 100 < spawnProb)
	{
		if(Level.NetMode != NM_DedicatedServer)
			Spawn(class'PlayerSpawnEffect');
		drone = Spawn(class'Drone',self,,Location,Rotation);
		drone.ProjDamage = ProjDamage;
		drone.HealPerSec = HealPerSec;
		drone.ShotDelay = ShotDelay;
		drone.TargetDelay = TargetDelay;
		drone.spawner = self;
		droneTaken = false;
	}
}

defaultproperties
{
    droneTaken=True
    DrawType=0
    RemoteRole=0
}
