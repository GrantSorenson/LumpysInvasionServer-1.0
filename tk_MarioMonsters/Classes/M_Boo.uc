class M_Boo extends MM_Monster;

var() bool bInvisible;
var() float LastInvisTime;
var() float InvisTime;
var() float LastChallengeSoundTime;
var() config bool bCanBeInvisible;
var() config float InvisDuration;
var() config float InvisIntervalTime;
var() config bool bCanBeDamagedWhileInvis;
var() config bool bInvisAllowedWhenAttacking;

//not going invis

replication
{
	reliable if(Role == Role_Authority)
		bInvisible;
}

simulated function PostBeginPlay()
{
    PlayAnim('Move');
    SetTimer(0.1,true);
    Super.PostBeginPlay();
}

simulated function Timer()
{
	if(Role == Role_Authority)
	{
		if(bCanBeInvisible && !bInvisible && Level.TimeSeconds-LastInvisTime > (InvisIntervalTime+fRand()))
		{
			//going invisible
			LastInvisTime = Level.TimeSeconds;
			Spawn(class'Boo_InvisEffect',self,,Location + vect(0,0,0),Rotation);
			LastChallengeSoundTime = Level.TimeSeconds;
			PlaySound(ChallengeSound[Rand(4)], SLOT_Misc);
			bInvisible=true;
			InvisTime=0.0;
		}

		if(InvisTime >= InvisDuration)
		{
			InvisTime=-999999.0;
			LastInvisTime = Level.TimeSeconds;
			bInvisible = false;
		}

		InvisTime+=0.1;
	}

	if(bInvisible)
	{
		RepSkin = Texture'tk_MarioMonsters.MarioMonsters.MM_Invis';
		Skins[0] = Texture'tk_MarioMonsters.MarioMonsters.MM_Invis';
	}
	else
	{
		RepSkin = default.Skins[0];
		Skins[0] = default.Skins[0];
	}
}

function RangedAttack(Actor A)
{
	 local float Dist;

	 Super.RangedAttack(A);

	 Dist = VSize(A.Location - Location);

	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		 if(!bInvisAllowedWhenAttacking)
		 {
			 InvisTime = InvisDuration;
		 }
		 SetAnimAction(MeleeAnims[Rand(4)]);
		 Controller.bPreparingMove = true;
		 Acceleration = vect(0,0,0);
		 bShotAnim = true;
	 }
	 else if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	 {
		if(bInvisible && Level.TimeSeconds - LastChallengeSoundTime > 4)
		{
			LastChallengeSoundTime = Level.TimeSeconds;
			PlaySound(ChallengeSound[Rand(4)], SLOT_Misc);
		}

        return;
	 }
	 else if( Dist > 1000 && Level.TimeSeconds - LastRangedAttackTime > RangedAttackIntervalTime && fRand() > 0.95)
	 {
		SetAnimAction('Scared');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttackTime = Level.TimeSeconds;
		bShotAnim = true;
		PlaySound(Sound'tk_MarioMonsters.Boo.Boo_Sound18',SLOT_Interact);
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
		AddVelocity(Velocity+vect(0,0,300));
	}

	SetTimer(0.05,true);
}

simulated function Tick(float DeltaTime)
{
	local float NewDS;

	Super.Tick(DeltaTime);
	if(Health <= 0 && DrawScale > 0)
	{
		NewDS = DrawScale - 0.005;
		SetDrawScale(NewDS);
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if(bInvisible && !bCanBeDamagedWhileInvis)
	{
		Damage = 0;
	}

	Super.TakeDamage(Damage, instigatedBy,hitlocation, momentum, damageType);
}

defaultproperties
{
     bCanBeInvisible=True
     InvisDuration=10.000000
     InvisIntervalTime=4.000000
     bInvisAllowedWhenAttacking=True
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeAnims(3)="Attack1"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death3"
     DeathAnims(1)="Death3"
     DeathAnims(2)="Death1"
     DeathAnims(3)="Death1"
     MeleeDamage=18
     NewMeleeDamage=18
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Boo.Boo_Sound14'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Boo.Boo_Sound10'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Boo.Boo_Sound14'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Boo.Boo_Sound10'
     RangedAttackIntervalTime=20.000000
     HP=130
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Boo.Boo_Sound8'
     HitSound(1)=Sound'tk_MarioMonsters.Boo.Boo_Sound6'
     HitSound(2)=Sound'tk_MarioMonsters.Boo.Boo_Sound9'
     HitSound(3)=Sound'tk_MarioMonsters.Boo.Boo_Sound9'
     DeathSound(0)=Sound'tk_MarioMonsters.Boo.Boo_Sound2'
     DeathSound(1)=Sound'tk_MarioMonsters.Boo.Boo_Sound7'
     DeathSound(2)=Sound'tk_MarioMonsters.Boo.Boo_Sound1'
     DeathSound(3)=Sound'tk_MarioMonsters.Boo.Boo_Sound2'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Boo.Boo_Sound3'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Boo.Boo_Sound1'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Boo.Boo_Sound11'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Boo.Boo_Sound15'
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
     AirSpeed=200.000000
     JumpZ=200.000000
     Health=130
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Boo_Mesh'
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.boo_skin1'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.boo_skin1'
     AmbientGlow=10
     CollisionRadius=44.000000
     CollisionHeight=40.000000
}
