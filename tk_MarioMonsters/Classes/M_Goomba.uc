class M_Goomba extends MM_Monster;

var() config bool bCanBeStomped;
var() config bool bCanStack;
var() bool bCarryingGoomba;
var() bool bBaseGoomba;
var() M_Goomba Passenger;
var() M_Goomba GoombaBase;
var() int MaxGoombaStack;
var() bool bAllowMoreGoombas;
var() bool bStomped;

Replication
{
	reliable if (Role == Role_Authority)
		bStomped;
}

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

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.1,true);
}

function int NumGoombas()
{
	local int TotalGoombas;

	TotalGoombas = 1;

	//how many goombas in total stack
	if(GoombaBase == None)
	{
		//im a base goomba at the bottom of the stack

		if(Passenger != None)
		{
			TotalGoombas++;
			if(Passenger.Passenger != None)
			{
				//3 goombas
				TotalGoombas++;
				if(Passenger.Passenger.Passenger != None)
				{
					//4 goombas
					//return true;
					TotalGoombas++;
					//return 4;
				}
			}
		}

		return TotalGoombas;
	}

	if(GoombaBase != None)
	{
		//2 goombas
		//I am the second goomba, I am allowed 1 passenger and so is my passenger
		TotalGoombas++;
		if(Passenger != None && Passenger.Passenger != None)
		{
			//4 total goombas
			TotalGoombas++;
			TotalGoombas++;
			return TotalGoombas;
		}

		if(GoombaBase.GoombaBase != None)
		{
			//3 goombas
			//I am the 3rd goomba, I am allowed 1 passenger
			TotalGoombas++;
			if(Passenger != None)
			{
				//4 total goombas
				TotalGoombas++;
				//return true;
			}

			if(GoombaBase.GoombaBase.GoombaBase != None)
			{
				//4 goombas
				//I am the 4th goomba, I am allowed 0 passengers
				TotalGoombas++;
				//return true;
			}
		}
	}

	return TotalGoombas;
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if(Role == Role_Authority)
	{
		if(Health > 0)
		{
			if(Passenger != None)
			{
				Passenger.SetPhysics(Phys_None);
				if(Passenger.SetLocation( (Location+(CollisionHeight + Passenger.CollisionHeight) * vect(0,0,1)) + vect(0,0,20) ))
				{
					Passenger.SetRotation(Rotation);
					Passenger.LoopAnim('Idle');
				}
				else
				{
					Passenger.GoombaBase = None;
					Passenger.SetPhysics(Phys_Falling);
					Passenger = None;
				}
			}

			CheckStatus();
		}
		else
		{
			//detach living goombas
			if(Passenger != None)
			{
				Passenger.SetPhysics(Phys_Falling);
				Passenger = None;
			}

			if(GoombaBase != None)
			{
				GoombaBase.Passenger = None;
			}
		}
	}
}

function CheckStatus()
{
	local float Dist;

	if(M_Goomba(Base) == None)
	{
		if(Physics == PHYS_None)
		{
			 SetPhysics(PHYS_Falling);
		}
	}
	else
	{
		//has my base moved away from me, if so detach and fall to the ground
		Dist = VSize(Base.Location - Location);
		if(Dist > 100)
		{
			GoombaBase = None;
			SetBase(None);
			SetPhysics(PHYS_Falling);
		}
	}
}

simulated function Timer()
{
	local M_Goomba G;

	Super.Timer();

	if(Role == Role_Authority && Health > 0)
	{
		if(Passenger != None || !bCanStack || NumGoombas() >= 4)
		{
			return;
		}

		foreach VisibleCollidingActors(class'M_Goomba', G, 100, Location)
		{
			if(G != None && G != Self && G.Health > 0)
			{
				//targeting base goombas or goombas on their own
				if(G.GoombaBase == None && (G.Passenger == None || (G.Passenger != Self && G.NumGoombas() + 1 <= 4)))
				{
					Passenger = G;
					Passenger.GoombaBase = Self;
				}
			}
		}
	}
}

function GoombaBaseNotify()
{
	if(M_Goomba(Base) == None)
	{
		GoombaBase = None;
		if(Physics == PHYS_None)
		{
			 SetPhysics(PHYS_Falling);
		}

		AddVelocity(vect(0,0,10));
	}
	else
	{
		M_Goomba(Base).GoombaBaseNotify();
	}
}

singular event BaseChange()
{
    local float decorMass;

    if ( bInterpolating )
        return;
    if ( (base == None) && (Physics == PHYS_None) )
    {
        SetPhysics(PHYS_Falling);
	}
	else if(M_Goomba(Base) != None)
	{
		return;
	}
    else if ( Pawn(Base) != None && Base != DrivenVehicle )
    {
        if ( !Pawn(Base).bCanBeBaseForPawns )
        {
            Base.TakeDamage( (1-Velocity.Z/400)* Mass/Base.Mass, Self,Location,0.5 * Velocity , class'Crushed');
            JumpOffPawn();
        }
    }
    else if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
    {
        decorMass = FMax(Decoration(Base).Mass, 1);
        Base.TakeDamage((-2* Mass/decorMass * Velocity.Z/400), Self, Location, 0.5 * Velocity, class'Crushed');
    }

    GroundSpeed = default.GroundSpeed;
}

simulated function CloseEyes()
{
	Skins[1] = Skins[0];
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

    if(bCanBeStomped && damageType == class'Crushed' && instigatedBy != None && Monster(instigatedBy) == None)
    {
		damageType = class'DamType_Stomped';
		Health = 0;
		bStomped = true;
	}

    if ( Health <= 0 )
    {
        // pawn died
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

simulated function Stomped()
{
	local vector Stomped3D;

	SetCollision(false,false,false);
	PlaySound(Sound'tk_MarioMonsters.Koopa.Koopa_Sound4');
	Spawn(class'Koopa_HitEffect',self,,Location + vect(0,0,0),Rotation);
	Stomped3D = DrawScale3D;
	Stomped3D.Z = 0.25;
	SetDrawScale3D(Stomped3D);
}

State Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	function beginState()
    {
       SetTimer(1, true);
    }

    function Landed(vector HitNormal)
    {
        SetPhysics(PHYS_None);
        if ( !IsAnimating(0) )
            LandThump();
        Super.Landed(HitNormal);
    }

    simulated function Timer()
    {
        if ( !PlayerCanSeeMe() )
            Destroy();
        else if ( LifeSpan <= DeResTime && bDeRes == false )
        {
            StartDeRes();
		}
        else
            SetTimer(1.0, false);
    }
}


simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if(bStomped)
	{
		PlayAnim(HitAnims[Rand(4)],, 0.1);
		Stomped();
	}
	else
	{
		PlayAnim(DeathAnims[Rand(4)],, 0.1);
	}
}

defaultproperties
{
     bCanBeStomped=True
     bCanStack=True
     MaxGoombaStack=4
     bAllowMoreGoombas=True
     MeleeAnims(0)="Attack"
     MeleeAnims(1)="Attack"
     MeleeAnims(2)="Attack"
     MeleeAnims(3)="Attack"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     MeleeDamage=15
     NewMeleeDamage=15
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepGrass2'
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     HitSound(1)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     HitSound(2)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     HitSound(3)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound1'
     DeathSound(0)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound2'
     DeathSound(1)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound2'
     DeathSound(2)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound2'
     DeathSound(3)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound2'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound3'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound3'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound3'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Goomba.Goomba_Sound3'
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
     RagdollLifeSpan=3.000000
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Goomba_Mesh'
     DrawScale=0.750000
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Goomba_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     AmbientGlow=10
     CollisionRadius=30.000000
     CollisionHeight=30.000000
}
