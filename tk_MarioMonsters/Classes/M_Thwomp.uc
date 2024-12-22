class M_Thwomp extends MM_Monster;

var() float OriginalAirSpeed;
var() bool bStinging;
var() config float ChargeSpeed;
var() float LastBumpSound;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    OriginalAirSpeed = AirSpeed;
    PlayAnim('Move');
}

simulated function Tick(float DeltaTime)
{
	Local Rotator R;

	Super.Tick(DeltaTime);

	if(bStinging)
	{
		R = Rotation;
		R.Pitch = 0;
		R.Roll = 0;
		SetRotation(R);
	}
}

function RangedAttack(Actor A)
{
	 local float Dist;

	 Super.RangedAttack(A);

	 Dist = VSize(A.Location - Location);

	 if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	 {
		/*if(bStinging)
		{
			AirSpeed = 3000;
		}*/

		return;
	 }
	 else if(Level.TimeSeconds - LastRangedAttackTime > RangedAttackIntervalTime)
	 {
		 PlaySound(ChallengeSound[Rand(4)],SLOT_Interact);
		 LastRangedAttackTime = Level.TimeSeconds;
		 AirSpeed = ChargeSpeed;
		 //bShotAnim = true;
		 //SetAnimAction('Attack1')
         Controller.Destination = A.Location;
         Controller.Destination.Z = A.Location.Z + 50;
         Velocity = AirSpeed * normal(Controller.Destination - Location);
         Controller.GotoState('TacticalMove', 'DoMove');
         Acceleration = AccelRate * Normal(A.Location - Location + vect(0,0,0.8) * A.CollisionHeight);
         bStinging=true;
	 }
	 else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius)
	 {
		 /*if(AirSpeed > default.AirSpeed)
		 	AirSpeed -= 100;*/
		 AirSpeed = OriginalAirSpeed;
		 //Controller.bPreparingMove = true;
		 //Acceleration = vect(0,0,150);
         Controller.Destination = A.Location;
         Controller.Destination.Z = A.Location.Z + 200;
         Velocity = AirSpeed * normal(Controller.Destination - Location);
         Controller.GotoState('TacticalMove', 'DoMove');
		 bStinging=true;
	 }
	 else
	 {
		 AirSpeed = OriginalAirSpeed;
		 Controller.bPreparingMove = true;
		 Acceleration = vect(0,0,0);
		 bStinging=false;
	 }
}

/*function RangedAttack(Actor A)
{
	 local float Dist;

	 Super.RangedAttack(A);

	 Dist = VSize(A.Location - Location);

	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius)
	{
		 SetAnimAction(MeleeAnims[Rand(4)]);
		 Controller.bPreparingMove = true;
		 Velocity = vect(0,0,-500);
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
	 }
}*/

simulated function Landed( vector HitNormal )
{
	PlaySound(Sound'tk_MarioMonsters.Thwomp.Thwomp1', SLOT_Misc);
	Super.Landed(HitNormal);
}

singular function Bump(actor Other)
{
	if(Level.TimeSeconds - LastBumpSound > 1 + fRand())
	{
		LastBumpSound = Level.TimeSeconds;
		PlaySound(ChallengeSound[Rand(4)],SLOT_Interact);
	}
    if (bStinging )
    {
        bStinging = false;
        MeleeDamageTarget(MeleeDamage, (20000.0 * Normal(Controller.Target.Location - Location)));
        Velocity *= -0.5;
        Acceleration *= -1;
        if (Acceleration.Z < 0)
            Acceleration.Z *= -1;
    }
    Super.Bump(Other);
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

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
    local vector HitLocation, HitNormal;
    local actor HitActor;

    // check if still in melee range
    If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
        && ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
            <= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
    {
        HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
        if ( HitActor != None )
            return false;
        Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, class'DamType_Thwomp');
        return true;
    }
    return false;
}

defaultproperties
{
     ChargeSpeed=3000.000000
     MeleeAnims(0)="Attack"
     MeleeAnims(1)="Attack"
     MeleeAnims(2)="Attack"
     MeleeAnims(3)="Attack"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death2"
     MeleeDamage=100
     NewMeleeDamage=100
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Thwomp.Thwomp1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Thwomp.Thwomp1'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Thwomp.Thwomp1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Thwomp.Thwomp1'
     RangedAttackIntervalTime=4.000000
     HP=300
     bCanDodge=False
     DodgeSkillAdjust=0.000000
     HitSound(0)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     HitSound(1)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     HitSound(2)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     HitSound(3)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     DeathSound(0)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     DeathSound(1)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     DeathSound(2)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     DeathSound(3)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Thwomp.Thwomp_Sound1'
     ScoringValue=15
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
     MeleeRange=100.000000
     AirSpeed=400.000000
     JumpZ=200.000000
     Health=300
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
     LandAnims(0)="Down"
     LandAnims(1)="Down"
     LandAnims(2)="Down"
     LandAnims(3)="Down"
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Thwomp_Mesh'
     DrawScale=2.000000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Thwomp_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Thwomp_skin'
     AmbientGlow=10
     CollisionRadius=70.000000
     CollisionHeight=80.000000
}
