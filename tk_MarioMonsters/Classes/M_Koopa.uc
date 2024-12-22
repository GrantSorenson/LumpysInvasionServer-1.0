class M_Koopa extends MM_Monster;

var() Material ClosedEyesMat;
var() config bool bCanBeShell;
var() config float ShellDamage;
var() config bool bCanBeStomped;

function RangedAttack(Actor A)
{
    local float Dist;

    Super.RangedAttack(A);

    Dist = VSize(A.Location - Location);

    if(Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        SetAnimAction(MeleeAnims[Rand(4)]);
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        bShotAnim = true;
    }
}

simulated function CloseEyes()
{
	Skins[1] = ClosedEyesMat;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Controller Killer;

	if(Health > 0 && bCanBeStomped && damageType == class'Crushed' && instigatedBy != None && Monster(instigatedBy) == None)
	{
        // pawn died
        Health = 0;

        if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
            Killer = LastHitBy;
        else if ( instigatedBy != None )
            Killer = instigatedBy.GetKillerController();
        if ( Killer == None && DamageType.Default.bDelayedDamage )
            Killer = DelayedDamageInstigatorController;
        if ( bPhysicsAnimUpdate )
            TearOffMomentum = momentum;
        //Shellify();
        Died(Killer, damageType, HitLocation);

		return;
	}

	Super.TakeDamage(Damage, instigatedBy,hitlocation, momentum, damageType);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Super.Died(Killer, damageType, HitLocation);

	if(Health <= 0 && bCanBeShell)
	{
		Shellify();
	}
}

function Shellify()
{
	SetCollision(false,false,false);
	if(Role == Role_Authority)
	{
		Spawn(class'Koopa_Shell',self,,,Rotation);
		PlaySound(Sound'tk_MarioMonsters.Koopa.Koopa_Sound4');
		Spawn(class'Koopa_HitEffect',self,,Location + vect(0,0,0),Rotation);
	}
	SetDrawScale(0);
	DeResTime = -5;
}

event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == ProjectileClass[0])
		{
			Projectile(Other).Damage = ShellDamage;
		}
	}

	Super.GainedChild(Other);
}

defaultproperties
{
     ClosedEyesMat=Texture'tk_MarioMonsters.MarioMonsters.Koopa_eyes'
     ShellDamage=30.000000
     bCanBeStomped=True
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
     MeleeDamage=20
     NewMeleeDamage=20
     ProjectileClass(0)=Class'tk_MarioMonsters.Koopa_Shell'
     ProjectileClass(1)=Class'tk_MarioMonsters.Koopa_Shell'
     ProjectileClass(2)=Class'tk_MarioMonsters.Koopa_Shell'
     ProjectileClass(3)=Class'tk_MarioMonsters.Koopa_Shell'
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound2'
     HitSound(1)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound2'
     HitSound(2)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound2'
     HitSound(3)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound2'
     DeathSound(0)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound3'
     DeathSound(1)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound3'
     DeathSound(2)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound3'
     DeathSound(3)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound3'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Koopa.Koopa_Sound1'
     ScoringValue=6
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bBlobShadow=True
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=50.000000
     GroundSpeed=220.000000
     JumpZ=200.000000
     MovementAnims(0)="Walk"
     MovementAnims(1)="Walk"
     MovementAnims(2)="Walk"
     MovementAnims(3)="Walk"
     TurnLeftAnim="Walk"
     TurnRightAnim="Walk"
     SwimAnims(0)="Walk"
     SwimAnims(1)="Walk"
     SwimAnims(2)="Walk"
     SwimAnims(3)="Walk"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Walk"
     AirAnims(1)="Walk"
     AirAnims(2)="Walk"
     AirAnims(3)="Walk"
     TakeoffAnims(0)="Walk"
     TakeoffAnims(1)="Walk"
     TakeoffAnims(2)="Walk"
     TakeoffAnims(3)="Walk"
     LandAnims(0)="Walk"
     LandAnims(1)="Walk"
     LandAnims(2)="Walk"
     LandAnims(3)="Walk"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="Walk"
     DodgeAnims(1)="Walk"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'MarioMonstersAnims.Koopa_Mesh'
     DrawScale=1.250000
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Koopa_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     AmbientGlow=10
     CollisionHeight=45.000000
}
