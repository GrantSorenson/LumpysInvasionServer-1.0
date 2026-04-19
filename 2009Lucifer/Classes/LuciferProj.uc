//================================================================================
// LuciferProj.
//================================================================================

class LuciferProj extends Projectile
  Placeable;

var LuciferProjTrail NewTrail;
var Actor Seeking;
var Vector InitialDir;
var int LockTime;

replication
{
  unreliable if ( Role == 4 )
    Seeking,InitialDir;
}

simulated function PostBeginPlay ()
{
  if ( bDeleteMe || IsInState('Dying') )
  {
    return;
  }
  Super.PostBeginPlay();
  if ( Level.NetMode != 1 )
  {
    NewTrail = Spawn(Class'LuciferProjTrail',self,,,Rotation);
    NewTrail.SetBase(self);
  }
  Velocity = vector(Rotation) * Speed;
  SetTimer(0.1,True);
}

simulated function Timer ()
{
  local Vector ForceDir;
  local float VelMag;

  if ( InitialDir == vect(0.00,0.00,0.00) )
  {
    InitialDir = Normal(Velocity);
  }
  LockTime++;
  Acceleration = vect(0.00,0.00,0.00);
  Super.Timer();
  if ( (Seeking != None) && (LockTime < 8) )
  {
    ForceDir = Normal(Seeking.Location + vect(0.00,0.00,20.00) - Location);
    VelMag = 1.01999998 * VSize(Velocity);
    ForceDir = Normal(ForceDir * 1.12 * VelMag + Velocity);
    Velocity = VelMag * ForceDir;
    SetRotation(rotator(Velocity));
  } else {
    SetTimer(0.0,False);
  }
}

simulated function Destroyed ()
{
  if ( NewTrail != None )
  {
    NewTrail.Destroy();
  }
  Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
  if ( (Other != Instigator) && ( !Other.IsA('Projectile') || Other.bProjTarget) )
  {
    Explode(HitLocation,vect(0.00,0.00,1.00));
  }
}

simulated function Explode (Vector HitLocation, Vector HitNormal)
{
  if ( Role == 4 )
  {
    HurtRadius(Damage,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
  }
  PlaySound(Sound'LuciferProjExplode',SLOT_Ambient,100.0);
  Spawn(Class'LuciferProjExplode',,);
  SetCollisionSize(0.0,0.0);
  Destroy();
}

defaultproperties
{
    Speed=900.00

    MaxSpeed=1000.00

    Damage=30.00

    DamageRadius=75.00

    MyDamageType=Class'LuciferDamType'

    LightType=1

    LightHue=28

    LightSaturation=127

    LightBrightness=255.00

    LightRadius=5.00

    DrawType=1

    CullDistance=50000.00

    bDynamicLight=True

    bNetTemporary=False

    AmbientSound=Sound'GeneralAmbience.firefx11'

    LifeSpan=10.00

    Texture=None

    DrawScale=0.50

    AmbientGlow=96

    SoundPitch=20

    CollisionRadius=20.00

    CollisionHeight=20.00

}
