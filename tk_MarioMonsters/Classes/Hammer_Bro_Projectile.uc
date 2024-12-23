class Hammer_Bro_Projectile extends MM_Projectile placeable;

var() float SpinRate;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer && TrailClass != None )
    {
        Trail = Spawn(TrailClass, self);
        Trail.SetBase(self);
    }

    Velocity = Vector(Rotation) * Speed;
    Velocity.z += TossZ;
    initialDir = Velocity;
    RotationRate.Pitch = SpinRate;

	if(bSeeking)
	{
		SetTimer(0.1,true);
	}

}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(ExplosionClass,,, Location);
	}
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector RefNormal;

    if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        Explode(HitLocation, RefNormal);
    }
    else if ( Other.bProjTarget )
    {
        if ( Role == ROLE_Authority )
            Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
        Explode(HitLocation, vect(0,0,1));
    }
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;

    if ( InitialDir == vect(0,0,0) )
    {
        InitialDir = Normal(Velocity);
	}

    Acceleration = vect(0,0,0);
    Super(Projectile).Timer();
    if(Seeking != None)
    {
		ForceDir = Normal(Seeking.Location - Location);

        if( (ForceDir Dot InitialDir) > 0 )
        {
            VelMag = VSize(Velocity);

            if ( Seeking.Physics == PHYS_Karma )
                ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
            else
                ForceDir = Normal(ForceDir * 10 * VelMag + Velocity);
            Velocity =  VelMag * ForceDir;
            //Acceleration += 5 * ForceDir;
        }

        SetTimer(0,false);
        //SetRotation(rotator(Velocity));
    }
}

defaultproperties
{
     spinRate=-150000.000000
     ExplosionClass=Class'tk_MarioMonsters.Hammer_Bro_ProjectileExplosion'
     bSeeking=True
     Speed=1000.000000
     MaxSpeed=1500.000000
     TossZ=0.000000
     Damage=30.000000
     DamageRadius=0.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Hammer_Bro_Projectile'
     ImpactSound=Sound'SkaarjPack_rc.Gibs.Thump'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightRadius=4.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_MarioMonsters.MarioMonsters.hammer'
     CullDistance=4000.000000
     bNetTemporary=False
     LifeSpan=5.000000
     Texture=Texture'tk_MarioMonsters.MarioMonsters.Hammer_Bro_skin'
     DrawScale=1.750000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bProjTarget=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000)
}
