class M_Blooper extends MM_Monster;

var() config bool bCanBlindPlayers;
var() config float InkDuration;
var() config float InkFadeStart;

simulated function PostBeginPlay()
{
	local BlooperReplicationInfo BRI;
	local bool bFoundInfo;

    Super.PostBeginPlay();
    PlayAnim('Move2');

	if(Role == Role_Authority)
	{
		foreach DynamicActors( class'BlooperReplicationInfo', BRI, 'BlooperInfo' )
		{
			if(BRI != None)
			{
				bFoundInfo = true;
				break;
			}
		}

		if(!bFoundInfo)
		{
			BRI = Spawn(class'BlooperReplicationInfo');
			if(BRI != None)
			{
				BRI.InkDuration = InkDuration;
			}
		}
	}
}

function RangedAttack(Actor A)
{
	local float Dist;

	Super.RangedAttack(A);

	Dist = VSize(A.Location - Location);

	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction(MeleeAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
	else if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	{
		return;
	}
	else if( Level.TimeSeconds - LastRangedAttackTime > RangedAttackIntervalTime)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttackTime = Level.TimeSeconds;
		bShotAnim = true;
	}
}

function InkJet()
{
    local Coords BoneLocation;
    local Projectile Proj;

    if ( Role == Role_Authority && Controller != None )
    {
        BoneLocation = GetBoneCoords('InkProj');
        Proj = Spawn(ProjectileClass[Rand(4)],self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,BoneLocation.Origin,AimError));
        if(Proj != None)
        {
            PlaySound(RangedAttackSounds[Rand(4)],SLOT_Interact);
        }
    }
}

simulated function AnimEnd(int Channel)
{
	//local name Anim;
    //local float frame,rate;

    if ( bShotAnim )
    {
        bShotAnim = false;
	}

   /* GetAnimParams(0, Anim,frame,rate);
    if ( Anim == 'ScaredStart' )
        TweenAnim('ScaredLoop',1,0.05);
    else*/
        LoopAnim('Move2',1,0.05);
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
    PlayAnim('Move2');
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
    PlayAnim('Move2');
}

event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == ProjectileClass[0])
		{
			Blooper_Projectile(Other).Damage = ProjectileDamage;
			Blooper_Projectile(Other).InkDuration = InkDuration;
			Blooper_Projectile(Other).bCanBlindPlayers = bCanBlindPlayers;
		}
	}

	Super.GainedChild(Other);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if(FastTrace(Location+vect(0,0,-200),Location))
	{
		//floating above ground so play random deathanim
		PlayAnim(DeathAnims[Rand(4)],, 0.1);
	}
	else
	{
		//hit worldgeometry
		PlayAnim(DeathAnims[0],, 0.1);
		AddVelocity(Velocity+vect(0,0,200));
	}
}

defaultproperties
{
     bCanBlindPlayers=True
     Inkduration=5.000000
     InkFadeStart=3.000000
     MeleeAnims(0)="Spin2"
     MeleeAnims(1)="Spin2"
     MeleeAnims(2)="Spin2"
     MeleeAnims(3)="Spin2"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death3"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death3"
     RangedAttackAnims(0)="Attack"
     RangedAttackAnims(1)="Attack"
     RangedAttackAnims(2)="Attack"
     RangedAttackAnims(3)="Attack"
     MeleeDamage=18
     NewMeleeDamage=18
     ProjectileClass(0)=Class'tk_MarioMonsters.Blooper_Projectile'
     ProjectileClass(1)=Class'tk_MarioMonsters.Blooper_Projectile'
     ProjectileClass(2)=Class'tk_MarioMonsters.Blooper_Projectile'
     ProjectileClass(3)=Class'tk_MarioMonsters.Blooper_Projectile'
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound14'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound14'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound15'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound16'
     RangedAttackSounds(0)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound4'
     RangedAttackSounds(1)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound4'
     RangedAttackSounds(2)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound4'
     RangedAttackSounds(3)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound4'
     RangedAttackIntervalTime=4.000000
     HP=130
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound3'
     HitSound(1)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound6'
     HitSound(2)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound8'
     HitSound(3)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound9'
     DeathSound(0)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound7'
     DeathSound(1)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound10'
     DeathSound(2)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound7'
     DeathSound(3)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound10'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound1'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound11'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound1'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Blooper.Blooper_Sound1'
     ScoringValue=5
     WallDodgeAnims(0)="Move2"
     WallDodgeAnims(1)="Move2"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Move2"
     FireHeavyBurstAnim="Move2"
     FireRifleRapidAnim="Move2"
     FireRifleBurstAnim="Move2"
     bBlobShadow=True
     bCanFly=True
     bCanStrafe=False
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=80.000000
     AirSpeed=260.000000
     JumpZ=200.000000
     Health=130
     MovementAnims(0)="Move2"
     MovementAnims(1)="Move2"
     MovementAnims(2)="Move2"
     MovementAnims(3)="Move2"
     TurnLeftAnim="Move2"
     TurnRightAnim="Move2"
     SwimAnims(0)="Move2"
     SwimAnims(1)="Move2"
     SwimAnims(2)="Move2"
     SwimAnims(3)="Move2"
     CrouchAnims(0)="Move2"
     CrouchAnims(1)="Move2"
     CrouchAnims(2)="Move2"
     CrouchAnims(3)="Move2"
     WalkAnims(0)="Move2"
     WalkAnims(1)="Move2"
     WalkAnims(2)="Move2"
     WalkAnims(3)="Move2"
     AirAnims(0)="Move2"
     AirAnims(1)="Move2"
     AirAnims(2)="Move2"
     AirAnims(3)="Move2"
     TakeoffAnims(0)="Move2"
     TakeoffAnims(1)="Move2"
     TakeoffAnims(2)="Move2"
     TakeoffAnims(3)="Move2"
     LandAnims(0)="Move2"
     LandAnims(1)="Move2"
     LandAnims(2)="Move2"
     LandAnims(3)="Move2"
     DoubleJumpAnims(0)="Move2"
     DoubleJumpAnims(1)="Move2"
     DoubleJumpAnims(2)="Move2"
     DoubleJumpAnims(3)="Move2"
     DodgeAnims(0)="Move2"
     DodgeAnims(1)="Move2"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Move2"
     TakeoffStillAnim="Move2"
     CrouchTurnRightAnim="Move2"
     CrouchTurnLeftAnim="Move2"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'MarioMonstersAnims.Blooper_Mesh'
     PrePivot=(Z=5.000000)
     Skins(0)=FinalBlend'MarioMonstersTextures.Skins.blooper_fb'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.blooper_skin2'
     AmbientGlow=10
     CollisionHeight=40.000000
}
