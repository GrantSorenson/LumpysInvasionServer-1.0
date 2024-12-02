class ShotgunParticleIncendiary extends Projectile;

var float ExplodeTimer;
var	xEmitter TrailFlames;
var Actor Seeking;
var vector InitialDir;
var vector InitialLocation;
var bool bTimerSet;
var() float DampenFactor, DampenFactorParallel;

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        Seeking, InitialDir, ExplodeTimer;
}

simulated function Destroyed() 
{
	if ( TrailFlames != None )
		TrailFlames.mRegen = False;
	Super.Destroyed();
}

simulated function timer()
{
	local vector x,y,z;
	local vector SeekingDir;
	local float MagnitudeVel;

	if ( InitialDir == vect(0,0,0) )
		InitialDir = Normal(Velocity);

	If (Seeking != None  && Seeking != Instigator) 
	{
		SeekingDir = Normal(Seeking.Location - Location);
			MagnitudeVel = VSize(Velocity);
			Velocity =  MagnitudeVel * Normal(SeekingDir * 1.5 * MagnitudeVel + Velocity);		
			SetRotation(rotator(Velocity));
	}

	GetAxes(rotation,x,y,z);
	x.x+=1.0*(0.5-frand());
	x.y+=1.0*(0.5-frand());
	x.z+=1.0*(0.5-frand());
	SetRotation(rotator(x));
	Velocity = Speed * vector(Rotation);

    Explode(Location, vect(0,0,1));
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		TrailFlames = Spawn(class'ShotgunTrailIncendiary',self,, InitialLocation);
	}

	Super.PostBeginPlay();
	seeking=None;
	Velocity = Speed * vector(Rotation);
	SetTimer(0.30,true);
}

simulated function PostNetBeginPlay()
{
	if ( Physics == PHYS_None )
    {
        SetTimer(ExplodeTimer, false); 
        bTimerSet = true;
    }
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;

    if (!bTimerSet)
    {
        SetTimer(ExplodeTimer, false); 
        bTimerSet = true;
    }

    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

//    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed < 20 ) 
    {
        bBounce = False;
        SetPhysics(PHYS_None);
        if ( TrailFlames != None )
            TrailFlames.mRegen = false; // stop the emitter from regenerating
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
			PlaySound(ImpactSound, SLOT_Misc );
    }
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	PlaySound(Sound'tk_FHIWeapons.FHISnd.Explode_Generic13',,1.0*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'tk_FHIWeapons.ShotgunExplodeIncendiary',,,HitLocation + HitNormal*16,rotator(HitNormal));	
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
	
	BlowUp(HitLocation);
	Destroy(); 
}

defaultproperties
{
     ExplodeTimer=1.500000
     Speed=300.000000
     MaxSpeed=400.000000
     Damage=65.000000
     DamageRadius=195.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeShotgunIncendiary'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     LifeSpan=2.700000
     DrawScale=8.000000
     AmbientGlow=254
     Style=STY_Alpha
     SoundVolume=200
     SoundRadius=125.000000
     TransientSoundVolume=0.550000
     TransientSoundRadius=50.000000
     bBounce=True
}
