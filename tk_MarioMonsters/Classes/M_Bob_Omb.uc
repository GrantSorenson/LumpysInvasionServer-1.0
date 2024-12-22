class M_Bob_Omb extends MM_Monster;

var() config int ExplodeDamage;
var() config float ExplodeRadius;
var() config float ExplodeRange;
var() bool bExploding;
var() bool bCountDown;
var() config float ExplodeTimer;
var() float ExplodeStartTime;
var() Emitter ExplodeEmitter;
var() Emitter TrailEmitter;
var() float CrankRotationSpeed;
var() bool bExploded;
var() float CrankRotation;
var() config bool bCanDamageMonsters;

//warning emitter not working

replication
{
	reliable if(Role==Role_Authority)
		bExploding;
}

simulated function PostBeginPlay()
{
 	if ( Level.NetMode != NM_DedicatedServer )
	{
		if(TrailEmitter == None)
		{
			TrailEmitter = Spawn(class'Bob_Omb_TrailEffect', self);
			AttachToBone(TrailEmitter, 'fuse_tip');
		}
    }

	SetTimer(0.1,true);
	Super.PostBeginPlay();
}

simulated function Tick(float DeltaTime)
{
	local Rotator R;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if(bExploding && !bCountDown)
		{
			if(ExplodeEmitter == None)
			{
				ExplodeEmitter = Spawn(class'Bob_Omb_WarningEffect', self);
				AttachToBone(ExplodeEmitter, 'Origin');
				bCountDown=true;
			}
		}

		R = Rot(0,0,0);
		CrankRotation = CrankRotation + CrankRotationSpeed;
		R.Roll += CrankRotation;
		SetBoneRotation ('crank', R, 0, 1.f);
	}

	Super.Tick(DeltaTime);
}

function Timer()
{
	if(bExploding)
	{
		if(Role == Role_Authority && !bExploded && Level.TimeSeconds - ExplodeStartTime > ExplodeTimer)
		{
			//boom
			PlaySound(DeathSound[Rand(4)]);
			Spawn(class'Bob_Omb_Explosion',self,,Location + vect(0,0,0),Rotation);
			bExploded = true;
			BlowUpDamage();
			Died(None, Class'Bob_Omb_DamageType', Location);
			SetTimer(0,false);
		}
	}
}

function RangedAttack(Actor A)
{
	local float Dist;

	Super.RangedAttack(A);

	if(bExploding)
	{
		return;
	}

	Dist = VSize(A.Location - Location);

	if(!bExploding && Dist < ExplodeRange + CollisionRadius + A.CollisionRadius )
	{
		ExplodeStartTime = Level.TimeSeconds;
		bExploding = true;
	}
}

function BlowUpDamage()
{
	local Pawn P;
	local vector dir;
    local float damageScale, dist, Momentum, Shake;

	if(Role == ROLE_Authority)
	{
		foreach VisibleCollidingActors(class'Pawn', P, ExplodeRadius, Location)
		{
			if(P != None && P.Health > 0 && P.Controller != None && P != Self)
			{
				if( MonsterController(P.Controller) == None || !SameSpeciesAs(P) || bCanDamageMonsters )
				{
					Shake = RandRange(200,800);
					P.Controller.ShakeView( vect(0.0,0.02,0.0)*Shake, vect(0,1000,0),0.003*Shake, vect(0.02,0.02,0.02)*Shake, vect(1000,1000,1000),0.003*Shake);
					Momentum = 100 * P.CollisionRadius;
					dir = P.Location - Location;
					dist = FMax(1,VSize(dir));
					dir = dir/dist;
					P.TakeDamage(ExplodeDamage,None,P.Location - 0.5 * (P.CollisionHeight + P.CollisionRadius) * dir,(damageScale * Momentum * dir), Class'Bob_Omb_DamageType');
				}
			}
		}

		SetDrawScale(0);
		DeResTime = -5;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local int actualDamage;
    local Controller Killer;

    if ( damagetype == None )
    {
        if ( InstigatedBy != None )
            warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
        DamageType = class'DamageType';
    }

    if ( Role < ROLE_Authority )
    {
        log(self$" client damage type "$damageType$" by "$instigatedBy);
        return;
    }

    if ( Health <= 0 )
        return;

    if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
        instigatedBy = DelayedDamageInstigatorController.Pawn;

    if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
        SetMovementPhysics();
    if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
        momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
    if ( instigatedBy == self )
        momentum *= 0.6;
    momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if (DrivenVehicle != None)
            DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
        Damage *= 2;
    actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
    if( DamageType.default.bArmorStops && (actualDamage > 0) )
        actualDamage = ShieldAbsorb(actualDamage);

    Health -= actualDamage;
    if ( HitLocation == vect(0,0,0) )
        HitLocation = Location;

    PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);

    if ( Health <= 0 )
    {
        // pawn died
		BlowUpDamage();

        if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
            Killer = LastHitBy;
        else if ( instigatedBy != None )
            Killer = instigatedBy.GetKillerController();
        if ( Killer == None && DamageType.Default.bDelayedDamage )
            Killer = DelayedDamageInstigatorController;
        if ( bPhysicsAnimUpdate )
            TearOffMomentum = momentum;
        Died(Killer, damageType, HitLocation);
    }
    else
    {
        AddVelocity( momentum );
        if ( Controller != None )
            Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        if ( instigatedBy != None && instigatedBy != self )
            LastHitBy = instigatedBy.Controller;
    }
    MakeNoise(1.0);
}

simulated function Explode()
{
	if(Role == ROLE_Authority)
	{
		PlaySound(DeathSound[Rand(4)]);
		if(Level.NetMode != NM_DedicatedServer)
		{
			Spawn(class'Bob_Omb_Explosion',self,,Location + vect(0,0,0),Rotation);
		}
		SetDrawScale(0);
		DeResTime = -5;
	}
}

simulated function RemovePowerups()
{
	RemoveEffects();
	Super.RemovePowerups();
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	RemoveEffects();
    Super.PlayDying(DamageType, HitLoc);
}

simulated function RemoveEffects()
{
	SetTimer(0,false);
	if(TrailEmitter != None)
	{
		TrailEmitter.Kill();
	}

	if(ExplodeEmitter != None)
	{
		ExplodeEmitter.Kill();
	}
}

defaultproperties
{
     ExplodeDamage=50
     ExplodeRadius=400.000000
     ExplodeRange=250.000000
     ExplodeTimer=3.000000
     CrankRotationSpeed=1000.000000
     bCanDamageMonsters=True
     MeleeAnims(0)="Attack"
     MeleeAnims(1)="Attack"
     MeleeAnims(2)="Attack"
     MeleeAnims(3)="Attack"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death2"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death2"
     DeathAnims(3)="Death2"
     MeleeDamage=12
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     HP=130
     HitSound(0)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound1'
     HitSound(1)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound2'
     HitSound(2)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound3'
     HitSound(3)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound5'
     DeathSound(0)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound8'
     DeathSound(1)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound8'
     DeathSound(2)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound8'
     DeathSound(3)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound8'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound4'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound7'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound4'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Bob_Omb.Bob_omb_Sound7'
     ScoringValue=5
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
     MeleeRange=40.000000
     GroundSpeed=180.000000
     JumpZ=150.000000
     Health=130
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
     AmbientSound=Sound'tk_MarioMonsters.Bob_Omb.BobombFuse3'
     Mesh=SkeletalMesh'MarioMonstersAnims.Bob_Omb_Mesh'
     DrawScale=0.650000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.bobomb_skin1'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.bobomb_skin1'
     AmbientGlow=10
     SoundVolume=100
     CollisionRadius=28.000000
     CollisionHeight=32.000000
}
