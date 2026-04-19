//================================================================================
// LuciferMonster.
//================================================================================

class LuciferMonster extends Monster
  Placeable
  Config(Monsters2009);

#EXEC AUDIO IMPORT FILE="Sounds\LuciferStep.wav" NAME="LuciferStep" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferHit.wav" NAME="LuciferHit" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferDeath.wav" NAME="LuciferDeath" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferLaugh.wav" NAME="LuciferLaugh" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferAttack.wav" NAME="LuciferAttack" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferBigAttack.wav" NAME="LuciferBigAttack" GROUP="None"
#EXEC AUDIO IMPORT FILE="Sounds\LuciferProjExplode.wav" NAME="LuciferProjExplode" GROUP="None"

var Class<Projectile> ProjectileClass;
var int aimerror;
var name DeathAnims[4];
var name HitAnims[4];
var config bool UseConfigs;
var config float LuciferHealth;
var config bool FixDeathAnim;
var name RangedAttacks[4];
var Sound Footstep[4];
var bool bFixHeight;
var bool bFixDeathL;
var bool bFixDeathR;
var Emitter EyeGlow[2];
var Emitter LuciferBodyFlame;
var LuciferHand LuciferHandFlame[2];

replication
{
  unreliable if ( Role == 4 )
    FixDeathAnim;
}

simulated function PostBeginPlay ()
{
  EyeGlow[0] = Spawn(Class'LuciferEyes',self,);
  AttachToBone(EyeGlow[0],'REye');
  EyeGlow[1] = Spawn(Class'LuciferEyes',self,);
  AttachToBone(EyeGlow[1],'LEye');
  LuciferBodyFlame = Spawn(Class'LuciferBody',self,);
  AttachToBone(LuciferBodyFlame,'FireOrigin');
  LuciferHandFlame[0] = Spawn(Class'LuciferHand',self,);
  AttachToBone(LuciferHandFlame[0],'FireMainTwo');
  LuciferHandFlame[1] = Spawn(Class'LuciferHand',self,);
  AttachToBone(LuciferHandFlame[1],'FireMain');
  if ( UseConfigs )
  {
    Health = int(LuciferHealth);
  }
  Super.PostBeginPlay();
}

simulated function Tick (float DeltaTime)
{
  Super.Tick(DeltaTime);
  if ( FixDeathAnim && bFixHeight )
  {
    if ( bFixDeathL )
    {
      PrePivot.Z = -90.0;
    } else {
      if ( bFixDeathR )
      {
        PrePivot.Z = -40.0;
      }
    }
  }
}

function RangedAttack (Actor A)
{
  if ( bShotAnim )
  {
    return;
  }
  if ( Physics == 3 )
  {
    SetAnimAction(IdleSwimAnim);
  } else {
    SetAnimAction(RangedAttacks[Rand(4)]);
    Controller.bPreparingMove = True;
    Acceleration = vect(0.00,0.00,0.00);
    bShotAnim = True;
  }
}

simulated function RainOfFire ()
{
  local Vector X;
  local Vector Y;
  local Vector Z;
  local Vector A;
  local Vector B;
  local Vector C;
  local Vector SpawnOffSet;
  local Vector FireStart;
  local int i;

  if ( Controller != None )
  {
    GetAxes(Rotation,X,Y,Z);
    SpawnOffSet = X;
    FireStart = GetFireStart(A,B,C);
    i = 0;
    while ( i < 6 )
    {
      if ( Rand(2) == 1 )
      {
        Y *= -1;
      }
      Spawn(Class'LuciferSmallProj',self,,Location + vect(0.00,0.00,180.00) + 100 * SpawnOffSet + 10 * Rand(10) * Y + 10 * Rand(10) * Z,Controller.AdjustAim(SavedFireProperties,FireStart,aimerror));
      PlaySound(Sound'LuciferBigAttack',SLOT_Pain,100.0);
      i++;
    }
  }
}

function FireProjectile ()
{
  local Vector FireStart;
  local Vector X;
  local Vector Y;
  local Vector Z;
  local Coords BoneLocation;

  if ( Controller != None )
  {
    BoneLocation = GetBoneCoords('LeftFire');
    FireStart = GetFireStart(X,Y,Z);
    Spawn(ProjectileClass,self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,aimerror));
    PlaySound(FireSound,SLOT_Pain,255.0);
  }
}

simulated function RespawnHandFlames ()
{
  LuciferHandFlame[0] = Spawn(Class'LuciferHand',self,);
  AttachToBone(LuciferHandFlame[0],'FireMainTwo');
  LuciferHandFlame[1] = Spawn(Class'LuciferHand',self,);
  AttachToBone(LuciferHandFlame[1],'FireMain');
}

simulated function PauseFlames ()
{
  local int i;

  i = 0;
  while ( i < 2 )
  {
    if ( LuciferHandFlame[i] != None )
    {
      LuciferHandFlame[i].Kill();
    }
    i++;
  }
}

function FireBigProjectile ()
{
  local Vector FireStart;
  local Vector X;
  local Vector Y;
  local Vector Z;
  local Coords BoneLocation;

  if ( Controller != None )
  {
    BoneLocation = GetBoneCoords('FireBig');
    FireStart = GetFireStart(X,Y,Z);
    Spawn(ProjectileClass,self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,aimerror));
    PlaySound(FireSound,SLOT_Pain,255.0);
  }
}

simulated function Destroyed ()
{
  local int i;

  if ( LuciferBodyFlame != None )
  {
    LuciferBodyFlame.Destroy();
  }
  i = 0;
  while ( i < 2 )
  {
    if ( LuciferHandFlame[i] != None )
    {
      LuciferHandFlame[i].Destroy();
    }
    if ( EyeGlow[i] != None )
    {
      EyeGlow[i].Destroy();
    }
    i++;
  }
  Super.Destroyed();
}

simulated function KillEffects ()
{
  local int i;

  if ( LuciferBodyFlame != None )
  {
    LuciferBodyFlame.Kill();
  }
  i = 0;
  while ( i < 2 )
  {
    if ( LuciferHandFlame[i] != None )
    {
      LuciferHandFlame[i].Kill();
    }
    if ( EyeGlow[i] != None )
    {
      EyeGlow[i].Kill();
    }
    i++;
  }
}

simulated function PlayDirectionalDeath (Vector HitLoc)
{
  KillEffects();
  if ( FixDeathAnim )
  {
    bFixHeight = True;
    SetCollisionSize(CollisionRadius,30.0);
    if ( FRand() > 0.663 )
    {
      PlayAnim(DeathAnims[3],,0.1);
    } else {
      if ( FRand() > 0.331 )
      {
        bFixDeathL = True;
        PlayAnim(DeathAnims[2],,0.1);
      } else {
        bFixDeathR = True;
        PlayAnim(DeathAnims[0],,0.1);
      }
    }
  } else {
    Super.PlayDirectionalDeath(HitLoc);
  }
}

simulated function PlayDirectionalHit (Vector HitLoc)
{
  PlayAnim(HitAnims[Rand(4)],,0.1);
}

function PlayMoverHitSound ()
{
  PlaySound(HitSound[0],SLOT_Pain);
}

function bool SameSpeciesAs (Pawn P)
{
  return Monster(P) != None;
}

simulated function RunStep ()
{
  PlaySound(Footstep[Rand(4)],SLOT_Pain,8.0);
}

event GainedChild (Actor Other)
{
  if ( Other.Class == Class'LuciferProj' )
  {
    if ( (Controller != None) && (Controller.Target != None) )
    {
      LuciferProj(Other).Seeking = Controller.Target;
    }
  }
  if ( Other.Class == Class'LuciferSmallProj' )
  {
    if ( (Controller != None) && (Controller.Target != None) )
    {
      LuciferSmallProj(Other).Seeking = Controller.Target;
    }
  }
  Super.GainedChild(Other);
}

defaultproperties
{
    ProjectileClass=Class'LuciferProj'

    aimerror=100

    DeathAnims(0)=DeathR

    DeathAnims(1)=DeathB

    DeathAnims(2)=DeathL

    DeathAnims(3)=DeathF

    HitAnims(0)=HitF

    HitAnims(1)=HitB

    HitAnims(2)=HitL

    HitAnims(3)=HitR

    RangedAttacks(0)=gesture_halt

    RangedAttacks(1)=Weapon_Switch

    RangedAttacks(2)=gesture_cheer

    RangedAttacks(3)=gesture_halt

    Footstep(0)=Sound'LuciferStep'

    Footstep(1)=Sound'LuciferStep'

    Footstep(2)=Sound'LuciferStep'

    Footstep(3)=Sound'LuciferStep'

    bMeleeFighter=False

    bCanDodge=False

    DodgeSkillAdjust=1.00

    HitSound(0)=Sound'LuciferHit'

    HitSound(1)=Sound'LuciferHit'

    HitSound(2)=Sound'LuciferHit'

    HitSound(3)=Sound'LuciferHit'

    DeathSound(0)=Sound'LuciferDeath'

    DeathSound(1)=Sound'LuciferDeath'

    DeathSound(2)=Sound'LuciferDeath'

    DeathSound(3)=Sound'LuciferDeath'

    ChallengeSound(0)=Sound'LuciferLaugh'

    ChallengeSound(1)=Sound'LuciferLaugh'

    ChallengeSound(2)=Sound'LuciferLaugh'

    ChallengeSound(3)=Sound'LuciferLaugh'

    FireSound=Sound'LuciferAttack'

    IdleHeavyAnim=Idle_Rifle

    IdleRifleAnim=Idle_Rifle

    FireHeavyRapidAnim=Biggun_Aimed

    FireHeavyBurstAnim=Biggun_Burst

    FireRifleRapidAnim=Rifle_Aimed

    FireRifleBurstAnim=Rifle_Burst

    Health=600

    MovementAnims(0)=WalkF

    MovementAnims(1)=WalkB

    MovementAnims(2)=WalkL

    MovementAnims(3)=WalkR

    TurnLeftAnim=TurnL

    TurnRightAnim=TurnR

    CrouchAnims(0)=CrouchF

    CrouchAnims(1)=CrouchB

    CrouchAnims(2)=CrouchL

    CrouchAnims(3)=CrouchR

    AirAnims(0)=JumpF_Mid

    AirAnims(1)=JumpB_Mid

    AirAnims(2)=JumpL_Mid

    AirAnims(3)=JumpR_Mid

    TakeoffAnims(0)=JumpF_Takeoff

    TakeoffAnims(1)=JumpB_Takeoff

    TakeoffAnims(2)=JumpL_Takeoff

    TakeoffAnims(3)=JumpR_Takeoff

    LandAnims(0)=JumpF_Land

    LandAnims(1)=JumpB_Land

    LandAnims(2)=JumpL_Land

    LandAnims(3)=JumpR_Land

    DoubleJumpAnims(0)=DoubleJumpF

    DoubleJumpAnims(1)=DoubleJumpB

    DoubleJumpAnims(2)=DoubleJumpL

    DoubleJumpAnims(3)=DoubleJumpR

    DodgeAnims(0)=DodgeF

    DodgeAnims(1)=DodgeB

    DodgeAnims(2)=DodgeL

    DodgeAnims(3)=DodgeR

    AirStillAnim=Jump_Mid

    TakeoffStillAnim=Jump_Takeoff

    CrouchTurnRightAnim=Crouch_TurnR

    CrouchTurnLeftAnim=Crouch_TurnL

    IdleCrouchAnim=Idle_Rifle

    IdleSwimAnim=Idle_Rifle

    IdleWeaponAnim=Idle_Rifle

    IdleRestAnim=Idle_Rifle

    IdleChatAnim=Idle_Rifle

    LightHue=14

    LightSaturation=159

    LightRadius=8.00

    Mesh=SkeletalMesh'2009LuciferAnims.Lucifer'

    DrawScale=2.00

    PrePivot=(X=0.00,Y=0.00,Z=-25.00)

    CollisionRadius=50.00

    CollisionHeight=110.00

    Skins(0)=Texture'2009LuciferAnims.LuciferSkinNew'

}
