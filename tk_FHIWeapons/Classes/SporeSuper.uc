class SporeSuper extends BioGlob;

var actor seeking;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        seeking;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	seeking=None;
	Velocity = Speed * vector(Rotation);
	SetTimer(0.15,true);
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority && Physics == PHYS_None)
    {
        Landed(Vector(Rotation));
    }
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'tk_FHIWeapons.SporeSuperSmoke');
        Spawn(class'tk_FHIWeapons.SporeSuperSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super.Destroyed();
}

simulated function MergeWithGlob(int AdditionalGoopLevel)
{
}

simulated function timer()
{
	local vector x,y,z;
	local vector SeekingDir;
	local float MagnitudeVel;

	If (Seeking != None  && Seeking != Instigator) 
	{
		SeekingDir = Normal(Seeking.Location - Location);
			MagnitudeVel = VSize(Velocity);
			Velocity =  MagnitudeVel * Normal(SeekingDir * 0.5 * MagnitudeVel + Velocity);		
			SetRotation(rotator(Velocity));
	}

	GetAxes(rotation,x,y,z);
	x.x+=1.0*(0.5-frand());
	x.y+=1.0*(0.5-frand());
	x.z+=1.0*(0.5-frand());
	SetRotation(rotator(x));
	Velocity = Speed * vector(Rotation);
}

simulated function bool Immune( Pawn P )
{
	if( P == Instigator )
		return true;
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
            // explosion effects
        }

        SurfaceNormal = HitNormal;

        // spawn globlings
        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
		spawn(class'tk_FHIWeapons.SporeDecal',,,, rotator(-HitNormal));

        bCollideWorld = false;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = true;

	    NewRot = Rotator(HitNormal);
	    NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = false;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);
        if (Mover(Wall) != None)
        {
            bOnMover = true;
            SetBase(Wall);
            if (Base == None)
                BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        local SporeSuper Spore;

        Spore = SporeSuper(Other);

        if ( Spore != None )
        {
            if (Spore.Owner == None || (Spore.Owner != Owner && Spore.Owner != self))
            {
                if (bMergeGlobs)
                {
                    Spore.MergeWithGlob(GoopLevel); // balancing on the brink of infinite recursion
                    bNoFX = true;
                    Destroy();
                }
                else
                {
                    BlowUp(Location);
                }
            }
        }
        else if (Other != Instigator && Other.IsA('Pawn'))
            BlowUp(Location);
    }
}

state OnGround
{
    simulated function BeginState()
    {
        PlayAnim('hit');
        SetTimer(RestTime, false);
    }

    simulated function Timer()
    {
        if (bDrip)
        {
            bDrip = false;
            SetCollisionSize(default.CollisionHeight, default.CollisionRadius);
            Velocity = PhysicsVolume.Gravity * 0.2;
            SetPhysics(PHYS_Falling);
            bCollideWorld = true;
            bCheckedsurface = false;
            bProjTarget = false;
            LoopAnim('flying', 1.0);
            GotoState('Flying');
        }
        else
        {
            BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        if (Other.IsA('Pawn'))
        {
            bDrip = false;
            SetTimer(TouchDetonationDelay, false);
        }
    }

    function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType )
    {
        if (DamageType.default.bDetonatesGoop)
        {
            bDrip = false;
            SetTimer(0.1, false);
        }
    }

    simulated function AnimEnd(int Channel)
    {
        local float DotProduct;

        if (!bCheckedSurface)
        {
            DotProduct = SurfaceNormal dot Vect(0,0,-1);
            if (DotProduct > 0.7)
            {
                PlayAnim('Drip', 0.66);
                bDrip = true;
                SetTimer(DripTime, false);
                if (bOnMover)
                    BlowUp(Location);
            }
            else if (DotProduct > -0.5) 
            {
                PlayAnim('Slide', 1.0);
                if (bOnMover)
                    BlowUp(Location);
            }
            bCheckedSurface = true;
        }
    }

    simulated function MergeWithGlob(int AdditionalGoopLevel)
    {
        local int NewGoopLevel, ExtraSplash;
        NewGoopLevel = AdditionalGoopLevel + GoopLevel;
        if (NewGoopLevel > MaxGoopLevel)
        {
            Rand3 = (Rand3 + 1) % 3;
            ExtraSplash = Rand3;
            if (Role == ROLE_Authority)
                SplashGlobs(NewGoopLevel - MaxGoopLevel + ExtraSplash);
            NewGoopLevel = MaxGoopLevel - ExtraSplash;
        }
        SetGoopLevel(NewGoopLevel);
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        PlaySound(ImpactSound, SLOT_Misc);
        PlayAnim('hit');
        bCheckedSurface = false;
        SetTimer(RestTime, false);
    }

}

function BlowUp(Vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        Damage = BaseDamage + Damage * GoopLevel;
        DamageRadius = DamageRadius * GoopVolume;
        MomentumTransfer = MomentumTransfer * GoopVolume;
        if (Physics == PHYS_Flying) MomentumTransfer *= 0.5;
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }

    PlaySound(ExplodeSound, SLOT_Misc);

    Destroy();
    //GotoState('shriveling');
}

function SplashGlobs(int NumGloblings)
{
    local int g;
    local SporeSuper NewSpore;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewSpore = Spawn(Class, self,, Location+GoopVolume*(CollisionHeight+4.0)*SurfaceNormal);
        if (NewSpore != None)
        {
            NewSpore.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewSpore.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
        }
        //else log("unable to spawn globling");
    }
}

state Shriveling
{
    simulated function BeginState()
    {
        bProjTarget = false;
        PlayAnim('shrivel', 1.0);
    }

    simulated function AnimEnd(int Channel)
    {
        Destroy();
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
    }
}

simulated function SetGoopLevel( int NewGoopLevel )
{
    GoopLevel = NewGoopLevel;
    GoopVolume = sqrt(float(GoopLevel));
    SetDrawScale(GoopVolume*default.DrawScale);
    LightBrightness = Min(100 + 15*GoopLevel, 255);
    LightRadius = 1.7 + 0.2*GoopLevel;
}

defaultproperties
{
     BaseDamage=520
     GloblingSpeed=100.000000
     RestTime=0.500000
     DripTime=0.800000
     Speed=300.000000
     Damage=354.000000
     DamageRadius=512.000000
     MomentumTransfer=840000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeSporeB'
     LightHue=15
     LightBrightness=250.000000
     LightRadius=2.600000
     DrawType=DT_Sprite
     Texture=Texture'XceptTwo.Particles.PollenA'
     DrawScale=0.800000
     CollisionRadius=1.000000
     CollisionHeight=1.000000
}
