class MiniSeekingRocketProj extends MiniRocketProj;

var Actor Seeking;
var vector InitialDir;

replication
{
	reliable if (bNetInitial && (Role == ROLE_Authority))
		Seeking, InitialDir;
}

simulated function Timer()
{
	local vector ForceDir;
	local float VelMag;

	if (InitialDir == vect(0,0,0))
		InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	Super.Timer();
	if ((Seeking != None) && (Seeking != Instigator)) 
	{
		ForceDir = Normal(Seeking.Location - Location);
		if ((ForceDir Dot InitialDir) > -1.5)
		{
			VelMag = VSize(Velocity);

			ForceDir = Normal((ForceDir * 0.5 * VelMag) + (0.4 * Velocity));
			Velocity =  VelMag * ForceDir;
			Acceleration += 5 * ForceDir; 
		}

		SetRotation(rotator(Velocity));
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.1, true);
}

defaultproperties
{
     MyDamageType=Class'tk_FHIWeapons.DamTypeMiniRocketHoming'
     LifeSpan=15.000000
}