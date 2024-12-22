class MM_Monster extends tk_Monster
    config(tk_Monsters);

#EXEC OBJ LOAD FILE="Resources/tk_MarioMonsters_rc.u" PACKAGE="tk_MarioMonsters"

var() Name MeleeAnims[4];
var() Name HitAnims[4];
var() Name DeathAnims[4];
var() Name RangedAttackAnims[4];

var() bool bLunging;
var() bool bCanLunge;
var() int MeleeDamage;
var() config int NewMeleeDamage;
var() class<Projectile> ProjectileClass[4];

var() float MinTimeBetweenPainAnims;
var() float LastPainAnimTime;
var() float LastRangedAttackTime;
var() float TeleportRadius;
var() float LastTeleportTime;

var() int AimError;

var() Sound MeleeAttackSounds[4];
var() sound FootStep[4];
var() sound RangedAttackSounds[4];
var() config float RangedAttackIntervalTime;
var() config bool bUseHealthConfig;
var() config bool bUseDamageConfig;
var() config float ProjectileDamage;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if(bUseHealthConfig)
	{
		Health = HP;
	}

	if(bUseDamageConfig)
	{
		MeleeDamage = NewMeleeDamage;
	}
}

function MeleeAttack()
{
	if(Controller != None && Controller.Target != None)
	{
		if (MeleeDamageTarget(MeleeDamage, (30000 * Normal(Controller.Target.Location - Location))) )
		{
			bCanLunge = true;
			PlaySound(MeleeAttackSounds[Rand(4)], SLOT_Interact);
		}
	}
}

function RangedAttack(Actor A)
{
	if(bShotAnim || A == None || Controller == None)
	{
		return;
	}
}

function PlayMoverHitSound()
{
	PlaySound(HitSound[0], SLOT_Interact);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( (Monster(P) != None) && Monster(P).Controller != None && (!Monster(P).Controller.IsA('FriendlyMonsterController')));
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
 	PlayAnim(HitAnims[Rand(4)],, 0.1);
}

function Sound GetSound(xPawnSoundGroup.ESoundType soundType)
{
    return None;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if( Level.TimeSeconds - LastPainAnimTime < MinTimeBetweenPainAnims )
	{
		LastPainAnimTime = Level.TimeSeconds;
		PlayDirectionalHit(HitLocation);
	}

	if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
	{
		return;
	}

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[Rand(4)], SLOT_Pain,2*TransientSoundVolume,,400);
}

simulated function RunStep()
{
   PlaySound(FootStep[Rand(4)], SLOT_Interact, FootStepVolume);
}

function AddVelocity( vector NewVelocity)
{
	if((Velocity.Z > 350) && (NewVelocity.Z > 1000))
        NewVelocity.Z *= 0.5;
    Velocity += NewVelocity;
}

simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	return;
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	PlayAnim(DeathAnims[Rand(4)],, 0.1);
}

function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
    local Vector HitNormal;
    local Vector HitRay;
    local Name HitBone;
    local float HitBoneDist;
    local PlayerController PC;
    local bool bShowEffects, bRecentHit;

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.5;
    Super(Pawn).PlayHit(Damage,InstigatedBy,HitLocation,DamageType,Momentum);
    if ( Damage <= 0 )
        return;

    PC = PlayerController(Controller);
    bShowEffects = ( (Level.NetMode != NM_Standalone) || (Level.TimeSeconds - LastRenderTime < 2.5)
                    || ((InstigatedBy != None) && (PlayerController(InstigatedBy.Controller) != None))
                    || (PC != None) );
    if ( !bShowEffects )
        return;

    HitRay = vect(0,0,0);
    if( InstigatedBy != None )
        HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));

    if( DamageType.default.bLocationalHit )
        CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );
    else
    {
        HitLocation = Location;
        HitBone = 'None';
        HitBoneDist = 0.0f;
    }

    if( DamageType.default.bAlwaysSevers && DamageType.default.bSpecial )
        HitBone = 'head';

    if( InstigatedBy != None )
        HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
    else
        HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );


    // hack for flak cannon gibbing
    if ( (DamageType.name == 'DamTypeFlakChunk') && (Health < 0) && (InstigatedBy != None) && (VSize(InstigatedBy.Location - Location) < 350) )
        DoDamageFX( HitBone, 8*Damage, DamageType, Rotator(HitNormal) );
    else
        DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );

    if (DamageType.default.DamageOverlayMaterial != None && Damage > 0 ) // additional check in case shield absorbed
                SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false );
}

simulated function ProcessHitFX()
{
    local Coords boneCoords;
    local int j;

    if( (Level.NetMode == NM_DedicatedServer) || bSkeletized || (Mesh == SkeletonMesh) )
    {
        SimHitFxTicker = HitFxTicker;
        return;
    }

    for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )
    {
        j++;
        if ( j > 30 )
        {
            SimHitFxTicker = HitFxTicker;
            return;
        }

        if( (HitFX[SimHitFxTicker].damtype == None) || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime > 3) && !IsHumanControlled()) )
            continue;

        boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );

        HitFX[SimHitFxTicker].bSever = false;
    }
}

event GainedChild(Actor Other)
{
	Super.GainedChild(Other);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    Super.PlayDying(DamageType, HitLoc);
    SetCollision(false,false);
    RemoveEffects();
}

simulated function RemoveEffects();

function bool HasRangedAttack()
{
	return false;
}

defaultproperties
{
     bCanLunge=True
     MeleeDamage=8
     NewMeleeDamage=8
     MinTimeBetweenPainAnims=3.000000
     RangedAttackIntervalTime=3.000000
     bUseHealthConfig=True
     HP=100
     bUseDamageConfig=True
     ProjectileDamage=20.000000
     DodgeSkillAdjust=1.000000
     FootstepVolume=0.500000
     DeResTime=2.000000
     DeResGravScale=10.000000
}
