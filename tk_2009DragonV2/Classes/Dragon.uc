//-------------------------------------------------------------------------------
//Dragon, parent class of all dragons, most defaults are of a typical fire dragon
//-------------------------------------------------------------------------------
class Dragon extends tk_Monster config(Monsters2009);

var bool bLurveDragon;

//Special Effects
var() class<Emitter> TrailEffectClass;
var() class<Emitter>  ExplodeClass;
var Emitter TrailEffect[4];
var class<Emitter> FireBreathClass;
var Emitter FireBreathFX;

var() class<Emitter> LurveTrailEffectClass;

//Projectiles
var() class<Projectile> ProjectileClass;

//Resources
var Sound DragonSounds[10];
var Sound DragonProjectileSounds[2];
var Sound DragonBreathSound;

var Name MeleeAttacks[3];
var Name HitAnims[2];
var Name RangedAttacks[3];

var Material LurveSkins[2];

//Various Variables
var int AimError;
var int FireBreathDamage;
var float LastAttackTime;
var float AttackInterval;
var DragonGameReplicationInfo DRI, MyDRI;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		TrailEffect[0] = Spawn(TrailEffectClass,self);
			AttachToBone(TrailEffect[0], 'LTip01');
		TrailEffect[1] = Spawn(TrailEffectClass,self);
			AttachToBone(TrailEffect[1], 'LTip02');
		TrailEffect[2] = Spawn(TrailEffectClass,self);
			AttachToBone(TrailEffect[2], 'RTip01');
		TrailEffect[3] = Spawn(TrailEffectClass,self);
			AttachToBone(TrailEffect[3], 'RTip02');
	}

	FlyUp(500);
	PlayDragonSound(7);
	Super.PostBeginPlay();
}

function PlayDragonSound(int SoundNum)
{
	PlaySound(DragonSounds[SoundNum],SLOT_Interact,255);
}

simulated function Destroyed()
{
	RemoveEffects();
	Super.Destroyed();
}

simulated function RemoveEffects()
{
	local int i;

	for(i=0;i<4;i++)
	{
		if(TrailEffect[i] != None)
		{
			TrailEffect[i].Destroy();
		}
	}

	if(FireBreathFX != None)
	{
		FireBreathFX.Kill();
	}
}

simulated function Explode()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		Spawn(ExplodeClass,self);
	}
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	PlaySound(DragonSounds[Rand(3)], SLOT_Pain);
	RemoveEffects();
	if(!bGibbed)
	{
		bHidden = true;
		Explode();
	}
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if(FireBreathFX != None)
	{
		FireBreathFX.Kill();
	}

	PlayAnim(HitAnims[Rand(2)],, 0.1);
	PlaySound(DragonSounds[9], SLOT_Pain);
}

function PlayMoverHitSound()
{
	return;
}

function bool SameSpeciesAs(Pawn P)
{
	return (Monster(P) != None);
}

function RangedAttack(Actor A)
{
	local float EnemyDistance;

	if ( bShotAnim )
	{
		return;
	}

	EnemyDistance = VSize(A.Location - Location);

	if(EnemyDistance < 450 && Level.TimeSeconds - LastAttackTime > AttackInterval)
	{
		LastAttackTime = Level.TimeSeconds;
		SetAnimAction(RangedAttacks[2]);
		bShotAnim = true;
	}
	else if(Level.TimeSeconds - LastAttackTime > AttackInterval)
	{
		LastAttackTime = Level.TimeSeconds;

		if(fRand() > 0.5)
		{
			SetAnimAction(RangedAttacks[0]);
		}
		else
		{
			SetAnimAction(RangedAttacks[1]);
			FlyUp(500);
		}
		bShotAnim = true;
	}
}

function Flyup(int Boost)
{
	local vector NewVelocity;

	if(Controller != None)
	{
		Controller.bPreparingMove = true;
	}

	Acceleration = vect(0,0,0);
	NewVelocity = vect(0,0,1);
	NewVelocity.Z *= Boost;
	Velocity += NewVelocity;
}

function SetMovementPhysics()
{
    SetPhysics(PHYS_Flying);
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
}

simulated function IonWarning();

simulated function SpawnHandBolts();

function FireDragonBall()
{
	local vector FireStart,X,Y,Z;
	local coords BoneLocation;

	if(Controller != None && Controller.Target != None)
	{
		BoneLocation = GetBoneCoords('ProjBone');
		FireStart = GetFireStart(X,Y,Z);
		Spawn(ProjectileClass,self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
		PlaySound(DragonProjectileSounds[Rand(2)],SLOT_Interact,200);
	}
}

function FireBreath()
{
	local coords BoneLocation;
	local Actor A;

	BoneLocation = GetBoneCoords('ProjBone');

	foreach VisibleCollidingActors ( class'Actor', A, 150, BoneLocation.Origin )
	{
		if(A != None && A != Self)
		{
			A.TakeDamage(FireBreathDamage, Self, A.Location, vect(0,0,0), ProjectileClass.default.MyDamageType);
		}
	}
}

function PlayFireBreathSound()
{
	PlaySound(DragonBreathSound,SLOT_Interact,255);
}

function FlapWing()
{
	PlaySound(DragonSounds[6], SLOT_Talk);
}

event EncroachedBy( actor Other )
{
    if(Pawn(Other) != None)
    {
		return;
	}

	Super.EncroachedBy(Other);
}

simulated function ActivateFireBreath()
{
	local coords BoneLocation;
	local vector FireLocation;
	local Rotator FireDirection;
	local Rotator NewRot;

	if ( Level.NetMode != NM_DedicatedServer)
	{
		NewRot.Pitch = 6000;

		FireDirection = GetBoneRotation('FireBreathBone',);
		BoneLocation = GetBoneCoords('FireBreathBone');
		FireLocation = BoneLocation.Origin;

		FireBreathFX = Spawn(FireBreathClass,self,,FireLocation,FireDirection);
		AttachToBone(FireBreathFX, 'FireBreathBone');
	}
}

simulated function DeactivateFireBreath()
{
	if(FireBreathFX != None)
	{
		FireBreathFX.Kill();
	}
	FlyUp(500);
}

defaultproperties
{
	 MonsterName="Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.DragonWing'
     ExplodeClass=Class'tk_2009Dragonv2.DragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.FireBreathTrail'
     LurveTrailEffectClass=Class'tk_2009Dragonv2.LurveWing'
     ProjectileClass=Class'tk_2009Dragonv2.DragonProjectile'
     DragonSounds(0)=Sound'tk_2009Dragonv2.DragonRoar01'
     DragonSounds(1)=Sound'tk_2009Dragonv2.DragonRoar02'
     DragonSounds(2)=Sound'tk_2009Dragonv2.DragonGrowl01'
     DragonSounds(3)=Sound'tk_2009Dragonv2.DragonTailSwipe01'
     DragonSounds(4)=Sound'tk_2009Dragonv2.DragonSniff01'
     DragonSounds(5)=Sound'tk_2009Dragonv2.DragonSnort01'
     DragonSounds(6)=Sound'tk_2009Dragonv2.DragonWings01'
     DragonSounds(7)=Sound'tk_2009Dragonv2.DragonCall01'
     DragonSounds(8)=Sound'tk_2009Dragonv2.DragonLongRoar01'
     DragonSounds(9)=Sound'tk_2009Dragonv2.DragonWhine01'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.DragonFireBlast01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.DragonFireBlast01'
     DragonBreathSound=Sound'tk_2009Dragonv2.DragonFireBreath01'
     MeleeAttacks(0)="Attack_punch_L"
     MeleeAttacks(1)="Attack_Slap_R"
     MeleeAttacks(2)="Attack_Tail_L"
     HitAnims(0)="Fly_Pain_L"
     HitAnims(1)="Fly_Pain_R"
     RangedAttacks(0)="Fly_spit_1"
     RangedAttacks(1)="Fly_Idle"
     RangedAttacks(2)="Fly_spit_2"
     LurveSkins(0)=Shader'tk_2009Dragonv2.Skins.PinkBodyShader'
     LurveSkins(1)=Texture'tk_2009Dragonv2.Skins.PinkHead'
     aimerror=100
     FireBreathDamage=4
     AttackInterval=1.800000
     HitSound(0)=Sound'tk_2009Dragonv2.DragonWhine01'
     HitSound(1)=Sound'tk_2009Dragonv2.DragonWhine01'
     HitSound(2)=Sound'tk_2009Dragonv2.DragonWhine01'
     HitSound(3)=Sound'tk_2009Dragonv2.DragonWhine01'
     DeathSound(0)=Sound'tk_2009Dragonv2.DragonGrowl01'
     DeathSound(1)=Sound'tk_2009Dragonv2.DragonRoar02'
     DeathSound(2)=Sound'tk_2009Dragonv2.DragonRoar01'
     DeathSound(3)=Sound'tk_2009Dragonv2.DragonGrowl01'
     ChallengeSound(0)=Sound'tk_2009Dragonv2.DragonCall01'
     ChallengeSound(1)=Sound'tk_2009Dragonv2.DragonGrowl01'
     ChallengeSound(2)=Sound'tk_2009Dragonv2.DragonCall01'
     ChallengeSound(3)=Sound'tk_2009Dragonv2.DragonLongRoar01'
     ScoringValue=5
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="idle2"
     IdleRifleAnim="idle2"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanFly=True
     bCanWalkOffLedges=True
     AirSpeed=400.000000
     MovementAnims(0)="Fly"
     MovementAnims(1)="Fly"
     MovementAnims(2)="Fly"
     MovementAnims(3)="Glide"
     TurnLeftAnim="Fly"
     TurnRightAnim="Fly"
     SwimAnims(0)="Fly"
     SwimAnims(1)="Fly"
     SwimAnims(2)="Fly"
     SwimAnims(3)="Fly"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Fly"
     AirAnims(1)="Fly"
     AirAnims(2)="Fly"
     AirAnims(3)="Fly"
     TakeoffAnims(0)="Fly"
     TakeoffAnims(1)="Fly"
     TakeoffAnims(2)="Fly"
     TakeoffAnims(3)="Fly"
     LandAnims(0)="Fly"
     LandAnims(1)="Fly"
     LandAnims(2)="Fly"
     LandAnims(3)="Fly"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="Fly"
     DodgeAnims(1)="Fly"
     DodgeAnims(2)="Fly"
     DodgeAnims(3)="Fly"
     AirStillAnim="Fly_Idle"
     TakeoffStillAnim="Fly"
     CrouchTurnRightAnim="Walk_Turn_R"
     CrouchTurnLeftAnim="Walk_Turn_L"
     IdleCrouchAnim="idle2"
     IdleSwimAnim="idle2"
     IdleWeaponAnim="idle2"
     IdleRestAnim="idle2"
     IdleChatAnim="idle2"
     Mesh=SkeletalMesh'tk_2009Dragonv2.DragonMesh'
     DrawScale=0.300000
     PrePivot=(X=50.000000,Z=-10.000000)
     Skins(0)=Shader'tk_2009Dragonv2.Skins.RedBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.RedHead'
     CollisionRadius=40.000000
     CollisionHeight=50.000000
     bUseCylinderCollision=False
}
