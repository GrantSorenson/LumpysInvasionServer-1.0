class M_Farnsworth extends tk_Monster
    config(tk_Monsters);

#EXEC OBJ LOAD FILE="Resources/tk_Futurama_rc.u" PACKAGE="tk_Futurama"

var ChairEffect	ChairEmitter;

function PostBeginPlay()
{
     Super.PostBeginPlay();
     CreateChairEmitter();
}

simulated function CreateChairEmitter()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		ChairEmitter = Spawn( Class'ChairEffect', Owner,, Location, Rotation );
		if ( ChairEmitter != None )
		{
			ChairEmitter.SetDefaultColor();
			AttachToBone(ChairEmitter, 'EMITTERBone');
		}
	}
}

simulated function Destroyed()
{
	if(ChairEmitter != None)
		ChairEmitter.Kill();
	Super.Destroyed();
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

	SetPhysics(PHYS_Flying);
	if ( !bShotAnim && (FRand() < 0.3) )
	{
		bShotAnim = true;
		SetAnimAction('Jump_Takeoff');
	}
	Controller.Destination = Location + 200 * duckDir;
	Velocity = AirSpeed * duckDir;
	Controller.GotoState('TacticalMove', 'DoMove');
	return true;
}	

function SetMovementPhysics()
{
    SetPhysics(PHYS_Flying);
}

event Landed(vector HitNormal)
{
	SetPhysics(PHYS_Walking);
	Super.Landed(HitNormal);
}

event HitWall( vector HitNormal, actor HitWall )
{
	if ( HitNormal.Z > MINFLOORZ )
		SetPhysics(PHYS_Walking);
	Super.HitWall(HitNormal,HitWall);
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
        PlayAnim('DeathB',, 0.1);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
    if ( FRand() < 0.6 )
        TweenAnim('HitB', 0.05);
    else
        TweenAnim('HitF', 0.05);
}

function PlayVictory()
{
    SetPhysics(PHYS_Falling);
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('gesture_cheer');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	
	if ( Physics == PHYS_Flying )
		SetAnimAction('Biggun_Aimed');
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('gesture_halt');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'TNTpfhahaha', SLOT_Talk); 
	}
	else if ( !Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetPhysics(PHYS_Flying);
		SetAnimAction('Biggun_Aimed');
	}
	else
	{
		SetAnimAction('Biggun_Aimed');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	bShotAnim = true;
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

simulated function Notify_FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local FarnsworthProjectile S;

	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,0);
		S = Spawn(class'tk_Futurama.FarnsworthProjectile',,,FireStart,ProjRot);
		PlaySound(FireSound,SLOT_Interact);
	}
}

defaultproperties
{
     bMeleeFighter=False
     bTryToWalk=True
     DodgeSkillAdjust=4.000000
     Skins(0)=Texture'tk_Futurama.Farnsworth.FarnsworthBody'
     Skins(1)=Texture'tk_Futurama.Farnsworth.FarnsworthChair'
     HitSound(0)=Sound'tk_Futurama.Farnsworth.TNTpfwhee'
     HitSound(1)=Sound'tk_Futurama.Farnsworth.TNTpfwhee'
     HitSound(2)=Sound'tk_Futurama.Farnsworth.TNTpfwhee'
     HitSound(3)=Sound'tk_Futurama.Farnsworth.TNTpfwhee'
     DeathSound(0)=Sound'tk_Futurama.Farnsworth.TNTpfhahaha'
     DeathSound(1)=Sound'tk_Futurama.Farnsworth.pfwha3'
     DeathSound(2)=Sound'tk_Futurama.Farnsworth.OTHpfangrydome'
     DeathSound(3)=Sound'tk_Futurama.Farnsworth.pfwha'
     ChallengeSound(0)=Sound'tk_Futurama.Farnsworth.ORDpfexhibit'
     ChallengeSound(1)=Sound'tk_Futurama.Farnsworth.TNTpffingers'
     ChallengeSound(2)=Sound'tk_Futurama.Farnsworth.TNTpfdisgust'
     ChallengeSound(3)=Sound'tk_Futurama.Farnsworth.ORDpfbored'
	 FireSound(0)=Sound'WeaponSounds.LinkGun.BLinkedFire'
     ScoringValue=20
     MonsterName="Farnsworth"
     Health=100
	 HP=100
     Mesh=SkeletalMesh'tk_Futurama.FarnsworthMesh'
     bCanFly=True
     AirSpeed=330.000000
     GroundSpeed=400.000000
     MeleeRange=80.000000
     CollisionRadius=47.000000
     CollisionHeight=36.000000
     Mass=120.000000
     MovementAnims(0)="RunF"
     MovementAnims(1)="RunB"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
     TurnLeftAnim="RunL"
     TurnRightAnim="RunR"
     CrouchAnims(0)="CrouchF"
     CrouchAnims(1)="CrouchB"
     CrouchAnims(2)="CrouchL"
     CrouchAnims(3)="CrouchR"
     AirAnims(0)="RunF"
     AirAnims(1)="RunB"
     AirAnims(2)="RunL"
     AirAnims(3)="RunR"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DodgeAnims(0)="WallDodgeF"
     DodgeAnims(1)="WallDodgeB"
     DodgeAnims(2)="WallDodgeL"
     DodgeAnims(3)="WallDodgeR"
     AirStillAnim="Idle_Rest"
     TakeoffStillAnim="Jump_Takeoff"
     CrouchTurnRightAnim="Crouch_TurnR"
     CrouchTurnLeftAnim="Crouch_TurnL"
     IdleWeaponAnim="Idle_Biggun"
}