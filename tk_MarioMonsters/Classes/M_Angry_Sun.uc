class M_Angry_Sun extends MM_Monster;

var() config int HeatDamagePerSecond;
var() config float HeatRadius;
var() config bool bScaleHeatWithDistance;
var() config float BlastRadius;
var() config int BlastDamage;
var() Emitter Trail;
var() float AngrySunTime;
//this monster has no animations so can't control behaviour with bShotAnim,
//RangedAttackTimeInterval is a config variable that can break this monster
//(as it has no ranged attack) so this is just a placeholder variable to control the movement

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if(Level.NetMode != NM_DedicatedServer)
    {
		if(Trail == None)
		{
			Trail = Spawn(class'Angry_Sun_Trail',self);
			if(Trail != None)
			{
				Trail.SetBase(Self);
			}
		}
	}

    PlayAnim('Idle');

    if(Role == Role_Authority)
    {
		SetTimer(1, true);
	}
}
function Timer()
{
	if ( Health > 0 && Role == ROLE_Authority )
	{
		HurtRadius(HeatDamagePerSecond, HeatRadius, class'DamType_Angry_Sun', 0, Location );
	}
}

function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local Pawn Victims;
    local float damageScale, dist;
    local vector dir;

    if(Controller == None)
    {
		return;
	}

    foreach VisibleCollidingActors( class 'Pawn', Victims, DamageRadius, HitLocation )
    {
        if( (Victims != Self) && (Victims.Role == ROLE_Authority) &&
        (Monster(Victims) == None || ( MonsterController(Monster(Victims).Controller) == None || Monster(Victims).Controller.IsA('FriendlyMonsterController'))) )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;

            if(bScaleHeatWithDistance)
            {
            	damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			}
			else
			{
				damageScale = 1;
			}

            if ( Instigator == None || Instigator.Controller == None )
            {
                Victims.SetDelayedDamageInstigatorController( Controller );
			}

            Victims.TakeDamage(
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Controller, DamageType, Momentum, HitLocation);

        }
    }

    bHurtEntry = false;
}

function RangedAttack(Actor A)
{
	local float Dist;

	Super.RangedAttack(A);

	Dist = VSize(A.Location - Location);

	 if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	 {
		return;
	 }
	 else if( Level.TimeSeconds - LastRangedAttackTime > AngrySunTime)
	 {
		LastRangedAttackTime = Level.TimeSeconds;
		Controller.Destination = A.Location;
		Controller.Destination.Z = A.Location.Z + 150;
		Velocity = AirSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
	 }
}

simulated function AnimEnd(int Channel)
{
    if ( bShotAnim )
    {
        bShotAnim = false;
	}

    LoopAnim('Idle',1,0.05);
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
    PlayAnim('Idle');
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
    PlayAnim('Idle');
}

simulated function RemoveEffects()
{
	if(Trail != None)
	{
		Trail.Kill();
	}
}

simulated function Destroyed()
{
	RemoveEffects();
	Super.Destroyed();
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if(Role == Role_Authority)
	{
		Spawn(class'Angry_Sun_ExplosionActor',Instigator);
	}

	if(Level.NetMode != NM_DedicatedServer)
	{

		Spawn(class'Angry_Sun_Explosion',self,,GetBoneCoords('Origin').Origin);
		bHidden = true;
		SetDrawScale(0);
		SetCollision(false,false,false);
		DeResTime = -5;
		//PlaySound
	}
}

event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == ProjectileClass[0])
		{
			Angry_Sun_ExplosionActor(Other).Damage = BlastDamage;
			Angry_Sun_ExplosionActor(Other).DamageRadius = BlastRadius;
		}
	}

	Super.GainedChild(Other);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    if(Role == Role_Authority)
    {
		//HurtRadius(BlastDamage, BlastRadius, class'DamType_Angry_Sun', 100000, Location );
	}

	Super.PlayDying(DamageType, HitLoc);
    SetCollision(false,false);
    RemoveEffects();
}

defaultproperties
{
     HeatDamagePerSecond=10
     HeatRadius=1000.000000
     bScaleHeatWithDistance=True
     BlastRadius=1000.000000
     BlastDamage=100
     AngrySunTime=1.500000
     MeleeAnims(0)="Idle"
     MeleeAnims(1)="Idle"
     MeleeAnims(2)="Idle"
     MeleeAnims(3)="Idle"
     HitAnims(0)="Idle"
     HitAnims(1)="Idle"
     HitAnims(2)="Idle"
     HitAnims(3)="Idle"
     DeathAnims(0)="Idle"
     DeathAnims(1)="Idle"
     DeathAnims(2)="Idle"
     DeathAnims(3)="Idle"
     RangedAttackAnims(0)="Idle"
     RangedAttackAnims(1)="Idle"
     RangedAttackAnims(2)="Idle"
     RangedAttackAnims(3)="Idle"
     ProjectileClass(0)=Class'tk_MarioMonsters.Angry_Sun_ExplosionActor'
     ProjectileClass(1)=Class'tk_MarioMonsters.Angry_Sun_ExplosionActor'
     ProjectileClass(2)=Class'tk_MarioMonsters.Angry_Sun_ExplosionActor'
     ProjectileClass(3)=Class'tk_MarioMonsters.Angry_Sun_ExplosionActor'
     MinTimeBetweenPainAnims=10.000000
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     RangedAttackSounds(0)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     RangedAttackSounds(1)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     RangedAttackSounds(2)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     RangedAttackSounds(3)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     HP=280
     bMeleeFighter=False
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     HitSound(1)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     HitSound(2)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     HitSound(3)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound1'
     DeathSound(0)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound3'
     DeathSound(1)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound3'
     DeathSound(2)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound3'
     DeathSound(3)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound3'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound2'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound2'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound2'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Angry_Sun.Angry_Sun_Sound2'
     ScoringValue=5
     MinTimeBetweenPainSounds=10.000000
     WallDodgeAnims(0)="Idle"
     WallDodgeAnims(1)="Idle"
     WallDodgeAnims(2)="Idle"
     WallDodgeAnims(3)="Idle"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     bBlobShadow=True
     bCanFly=True
     bCanStrafe=False
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=200.000000
     AirSpeed=220.000000
     JumpZ=200.000000
     Health=280
     MovementAnims(0)="Idle"
     MovementAnims(1)="Idle"
     MovementAnims(2)="Idle"
     MovementAnims(3)="Idle"
     TurnLeftAnim="Idle"
     TurnRightAnim="Idle"
     SwimAnims(0)="Idle"
     SwimAnims(1)="Idle"
     SwimAnims(2)="Idle"
     SwimAnims(3)="Idle"
     CrouchAnims(0)="Idle"
     CrouchAnims(1)="Idle"
     CrouchAnims(2)="Idle"
     CrouchAnims(3)="Idle"
     WalkAnims(0)="Idle"
     WalkAnims(1)="Idle"
     WalkAnims(2)="Idle"
     WalkAnims(3)="Idle"
     AirAnims(0)="Idle"
     AirAnims(1)="Idle"
     AirAnims(2)="Idle"
     AirAnims(3)="Idle"
     TakeoffAnims(0)="Idle"
     TakeoffAnims(1)="Idle"
     TakeoffAnims(2)="Idle"
     TakeoffAnims(3)="Idle"
     LandAnims(0)="Idle"
     LandAnims(1)="Idle"
     LandAnims(2)="Idle"
     LandAnims(3)="Idle"
     DoubleJumpAnims(0)="Idle"
     DoubleJumpAnims(1)="Idle"
     DoubleJumpAnims(2)="Idle"
     DoubleJumpAnims(3)="Idle"
     DodgeAnims(0)="Idle"
     DodgeAnims(1)="Idle"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Idle"
     TakeoffStillAnim="Idle"
     CrouchTurnRightAnim="Idle"
     CrouchTurnLeftAnim="Idle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=42
     LightSaturation=127
     LightRadius=12.000000
     bDynamicLight=True
     Mesh=SkeletalMesh'MarioMonstersAnims.Angry_Sun_Mesh'
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     Skins(2)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     Skins(3)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     AmbientGlow=0
     CollisionRadius=50.000000
     CollisionHeight=50.000000
}
