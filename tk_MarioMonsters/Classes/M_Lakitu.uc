class M_Lakitu extends MM_Monster;

var() config bool bCanSpawnSpinys;
var() config int MaxSpinys;
var() Emitter CloudTrail;
//else projectiles just explode on impact

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if(Level.NetMode != NM_DedicatedServer)
    {
		if(CloudTrail == None)
		{
			CloudTrail = Spawn(class'Lakitu_CloudTrail',self);
			if(CloudTrail != None)
			{
				AttachToBone(CloudTrail,'cloud');
			}
		}
	}

    PlayAnim('Move');
}

function RangedAttack(Actor A)
{
	local float Dist;
	local vector adjust;

	Super.RangedAttack(A);

	Dist = VSize(A.Location - Location);

	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction(MeleeAnims[Rand(4)]);
        adjust = vect(0,0,0);
        adjust.Z = Controller.Target.CollisionHeight+100;
        Acceleration = AccelRate * Normal(Controller.Target.Location - Location + adjust);
		bShotAnim = true;
	}
	else if( Level.TimeSeconds - LastRangedAttackTime > RangedAttackIntervalTime)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
		LastRangedAttackTime = Level.TimeSeconds;
		bShotAnim = true;
	}
	 else if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	 {
        return;
	 }
	 else
	 {
        Controller.Destination = A.Location;
        Controller.Destination.Z = A.Location.Z + 150;
        Velocity = AirSpeed * normal(Controller.Destination - Location);
        Controller.GotoState('TacticalMove', 'DoMove');
        bShotAnim = true; //stops it freaking out
	 }
}

function FireProjectile()
{
    local Coords BoneLocation;
    local Projectile Proj;

    if ( Role == Role_Authority && Controller != None )
    {
        BoneLocation = GetBoneCoords('projbone');
        Proj = Spawn(ProjectileClass[Rand(4)],self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,BoneLocation.Origin,AimError));
        if(Proj != None)
        {
            PlaySound(RangedAttackSounds[Rand(4)],SLOT_Interact);
        }
    }
}

simulated function AnimEnd(int Channel)
{
    if ( bShotAnim )
    {
        bShotAnim = false;
	}

    LoopAnim('Move',1,0.05);
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
    local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
    if (DoubleClickMove == DCLICK_Forward)
        duckdir = X;
    else if (DoubleClickMove == DCLICK_Back)
        duckdir = -1*X;
    else if (DoubleClickMove == DCLICK_Left)
        duckdir = Y;
    else if (DoubleClickMove == DCLICK_Right)
        duckdir = -1*Y;

    Controller.Destination = Location + 200 * duckDir;
    Velocity = AirSpeed * duckDir;
    Controller.GotoState('TacticalMove', 'DoMove');
    return true;
}

function SetMovementPhysics()
{
    SetPhysics(PHYS_Flying);
    PlayAnim('Move');
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
    PlayAnim('Move');
}

function bool CanSpawnSpiny()
{
	if(bCanSpawnSpinys && NumMinions() < MaxSpinys)
	{
		return true;
	}

	return false;
}

function int NumMinions()
{
	local Inventory Inv;
	local int i;

	i = 0;

	foreach DynamicActors(class'Inventory',Inv)
	{
		if(Lakitu_Inv(Inv) != None && Lakitu_Inv(Inv).PawnMaster == Self)
		{
			i++;
		}
	}

	return i;
}


event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == ProjectileClass[0])
		{
			Lakitu_Projectile(Other).Damage = ProjectileDamage;
			Lakitu_Projectile(Other).PawnMaster = Self;
		}
	}

	Super.GainedChild(Other);
}

simulated function DetachCloud()
{
	local vector SpawnLocation;

	if(CloudTrail != None)
	{
		CloudTrail.Kill();
	}

	SpawnLocation = GetBoneCoords('cloud').origin;
	Spawn(class'Lakitu_CloudEffect',self,,SpawnLocation,Rotation);
	SetBoneScale(0, 0, 'cloud');
	PlaySound(Sound'tk_MarioMonsters.Lakitu.CloudEnemyDefeated', SLOT_Misc);
}


simulated function RemoveEffects()
{
	if(CloudTrail != None)
	{
		CloudTrail.Kill();
	}
}

simulated function Destroyed()
{
	RemoveEffects();
	Super.Destroyed();
}

defaultproperties
{
     bCanSpawnSpinys=True
     MaxSpinys=8
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack1"
     MeleeAnims(2)="Attack1"
     MeleeAnims(3)="Attack1"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     RangedAttackAnims(0)="Attack2"
     RangedAttackAnims(1)="Attack2"
     RangedAttackAnims(2)="Attack2"
     RangedAttackAnims(3)="Attack2"
     MeleeDamage=18
     NewMeleeDamage=18
     ProjectileClass(0)=Class'tk_MarioMonsters.Lakitu_Projectile'
     ProjectileClass(1)=Class'tk_MarioMonsters.Lakitu_Projectile'
     ProjectileClass(2)=Class'tk_MarioMonsters.Lakitu_Projectile'
     ProjectileClass(3)=Class'tk_MarioMonsters.Lakitu_Projectile'
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound37'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound51'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound7'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound37'
     RangedAttackSounds(0)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound49'
     RangedAttackSounds(1)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound1'
     RangedAttackSounds(2)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound22'
     RangedAttackSounds(3)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound15'
     RangedAttackIntervalTime=4.000000
     HP=280
     bMeleeFighter=False
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound27'
     HitSound(1)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound39'
     HitSound(2)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound40'
     HitSound(3)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound6'
     DeathSound(0)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound30'
     DeathSound(1)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound36'
     DeathSound(2)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound38'
     DeathSound(3)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound4'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound13'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound32'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound33'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Lakitu.Lakitu_Sound15'
     ScoringValue=5
     WallDodgeAnims(0)="Move"
     WallDodgeAnims(1)="Move"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Move"
     FireHeavyBurstAnim="Move"
     FireRifleRapidAnim="Move"
     FireRifleBurstAnim="Move"
     bBlobShadow=True
     bCanFly=True
     bCanStrafe=False
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=80.000000
     AirSpeed=260.000000
     JumpZ=200.000000
     Health=280
     MovementAnims(0)="Move"
     MovementAnims(1)="Move"
     MovementAnims(2)="Move"
     MovementAnims(3)="Move"
     TurnLeftAnim="Move"
     TurnRightAnim="Move"
     SwimAnims(0)="Move"
     SwimAnims(1)="Move"
     SwimAnims(2)="Move"
     SwimAnims(3)="Move"
     CrouchAnims(0)="Move"
     CrouchAnims(1)="Move"
     CrouchAnims(2)="Move"
     CrouchAnims(3)="Move"
     WalkAnims(0)="Move"
     WalkAnims(1)="Move"
     WalkAnims(2)="Move"
     WalkAnims(3)="Move"
     AirAnims(0)="Move"
     AirAnims(1)="Move"
     AirAnims(2)="Move"
     AirAnims(3)="Move"
     TakeoffAnims(0)="Move"
     TakeoffAnims(1)="Move"
     TakeoffAnims(2)="Move"
     TakeoffAnims(3)="Move"
     LandAnims(0)="Move"
     LandAnims(1)="Move"
     LandAnims(2)="Move"
     LandAnims(3)="Move"
     DoubleJumpAnims(0)="Move"
     DoubleJumpAnims(1)="Move"
     DoubleJumpAnims(2)="Move"
     DoubleJumpAnims(3)="Move"
     DodgeAnims(0)="Move"
     DodgeAnims(1)="Move"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Move"
     TakeoffStillAnim="Move"
     CrouchTurnRightAnim="Move"
     CrouchTurnLeftAnim="Move"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'MarioMonstersAnims.Lakitu_Mesh'
     DrawScale=1.750000
     PrePivot=(Z=5.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Lakitu_skin1'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Lakitu_skin2'
     Skins(2)=FinalBlend'MarioMonstersTextures.Skins.Lakitu_skin3_fb'
     Skins(3)=Texture'MarioMonstersTextures.cloud_skin'
     AmbientGlow=10
     CollisionRadius=35.000000
     CollisionHeight=60.000000
}
