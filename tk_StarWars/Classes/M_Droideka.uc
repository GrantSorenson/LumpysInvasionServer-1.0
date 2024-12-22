class M_Droideka extends tk_Monster 
	config(tk_Monsters);

#EXEC OBJ LOAD FILE="Resources/tk_StarWars_rc.u" PACKAGE="tk_StarWars"

var class<Projectile> ProjectileClass;
var int AimError;
var Name DeathAnims[4];
var Name HitAnims[4];
var config bool UseConfigs;
var config float MaxShieldPower;
var config bool bCanUsePowerShield;
var config float ShieldChargeRate;
var float ShieldPower;
var bool bShieldIsActive;
var DroidekaEyes EyeGlow[2];
var Name RangedAttacks[3];
var DroidekaShield DroidShield;
var Sound FootStep[4];

replication
{
	reliable if(ROLE == Role_Authority)
	bCanUsePowerShield, ShieldPower, bShieldIsActive, UpdateShield, MaxShieldPower, DroidShield;
}

simulated function PostBeginPlay()
{
	EyeGlow[0] = Spawn(class'DroidekaEyes',self,,);
	AttachToBone(EyeGlow[0],'REye');
	EyeGlow[1] = Spawn(class'DroidekaEyes',self,,);
	AttachToBone(EyeGlow[1],'LEye');

	if(UseConfigs)
	{
		Health = HP;
	}

	if(bCanUsePowerShield)
	{
		bShieldIsActive = true;
		DroidShield = Spawn(class'DroidekaShield',self,,);
		AttachToBone(DroidShield,'ShieldBone');
		ShieldPower = MaxShieldPower;
	}
	else
	{
		Disable('Tick');
	}

	Super.PostBeginPlay();
}

simulated function UpdateShield(int Status)
{
	if(DroidShield != None)
	{
		if(Status == 1)
		{
			DroidShield.TurnOn();
		}
		else
		{
			DroidShield.TurnOff();
		}
	}
}

function RechargeShield(float Power)
{
	if(ShieldPower < MaxShieldPower)
	{
		ShieldPower = FMin(ShieldPower + Power, MaxShieldPower);
	}
}

simulated function WeaponFlashOn()
{
	bDynamicLight = True;
	LightType = LT_Steady;
}

simulated function WeaponFlashOff()
{
	bDynamicLight = False;
	LightType = LT_None;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local int ActualDamage;

	if(bCanUsePowerShield && bShieldIsActive)
	{
		ActualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
		ShieldPower -= ActualDamage;

		if(ShieldPower <= 0)
		{
			ShieldPower = 0;
			bShieldIsActive = false;
		}
		Spawn(class'DroidekaShieldHit',,,HitLocation);
		PlaySound(Sound'DroidShieldHit',SLOT_Interact,100);
		return;
	}

	Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

simulated function Tick(float deltatime)
{
	local int i;

	Super.Tick(deltatime);

	if(!bCanUsePowerShield || Health <= 0)
	{
		return;
	}

	if(bShieldIsActive)
	{
		UpdateShield(1);
		bCanDodge = false;
		for(i=0;i<4;i++)
		{
			MovementAnims[i] = 'WalkF';
		}
	}
	else
	{
		RechargeShield(ShieldChargeRate);
		if(ShieldPower >= MaxShieldPower)
		{
			bShieldIsActive = true;
		}
		else
		{
			UpdateShield(0);
		}

		bCanDodge = true;
		for(i=0;i<4;i++)
		{
			MovementAnims[i] = 'DoubleJumpF';
		}
	}
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
	{
		return;
	}

	WeaponFlashOff();
	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction(IdleSwimAnim);
	}
	else
	{
		SetAnimAction(RangedAttacks[Rand(3)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim=true;
	}
}

function FireProjectileR()
{
	local vector FireStart,X,Y,Z;
	local coords BoneLocation;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('dummy 1');
		FireStart = GetFireStart(X,Y,Z);
		Spawn(ProjectileClass,,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
		PlaySound(sound'DroidFireNew',SLOT_Interact,8);
	}
}

function FireProjectileL()
{
	local vector FireStart,X,Y,Z;
	local coords BoneLocation;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('LeftFire');
		FireStart = GetFireStart(X,Y,Z);
		Spawn(ProjectileClass,,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
		PlaySound(sound'DroidFireNew',SLOT_Interact,8);
	}
}

simulated function Destroyed()
{
	if(EyeGlow[0] != None)
	{
		EyeGlow[0].Kill();
	}

	if(EyeGlow[1] != None)
	{
		EyeGlow[1].Kill();
	}
	if(DroidShield != None)
	{
		if(bShieldIsActive)
		{
			DroidShield.Kill();
		}
		else
		{
			DroidShield.Destroy();
		}
	}
	Super.Destroyed();
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	WeaponFlashOff();
	UpdateShield(0);
	PlayAnim(DeathAnims[Rand(4)],, 0.1);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	PlayAnim(HitAnims[Rand(4)],, 0.1);
}

function PlayMoverHitSound()
{
	return;
}

function bool SameSpeciesAs(Pawn P)
{
	return (Monster(P) != None);
}

simulated function RunStep()
{
   PlaySound(FootStep[Rand(4)], SLOT_Interact, 1);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('gesture_cheer');
	PlaySound(Sound'DroidBeep02',SLOT_Interact);
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

defaultproperties
{
     ProjectileClass=Class'tk_StarWars.DroidekaProj'
     aimerror=100
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathL"
     DeathAnims(3)="DeathR"
     HitAnims(0)="HitF"
     HitAnims(1)="HitB"
     HitAnims(2)="HitL"
     HitAnims(3)="HitR"
     MaxShieldPower=300.000000
     ShieldChargeRate=0.125000
     RangedAttacks(0)="ThroatCut"
     RangedAttacks(1)="Weapon_Switch"
     RangedAttacks(2)="Crouch_Aimed"
     Footstep(0)=Sound'PlayerSounds.BFootsteps.BFootstepMetal1'
     Footstep(1)=Sound'PlayerSounds.BFootsteps.BFootstepMetal2'
     Footstep(2)=Sound'PlayerSounds.BFootsteps.BFootstepMetal3'
     Footstep(3)=Sound'PlayerSounds.BFootsteps.BFootstepMetal4'
     bMeleeFighter=False
     DodgeSkillAdjust=3.000000
     HitSound(0)=Sound'tk_StarWars.Droideka.DroidBeep01'
     HitSound(1)=Sound'tk_StarWars.Droideka.DroidBeep01'
     HitSound(2)=Sound'tk_StarWars.Droideka.DroidBeep01'
     HitSound(3)=Sound'tk_StarWars.Droideka.DroidBeep01'
     DeathSound(0)=Sound'tk_StarWars.Droideka.DroidBeep03'
     DeathSound(1)=Sound'tk_StarWars.Droideka.DroidBeep03'
     DeathSound(2)=Sound'tk_StarWars.Droideka.DroidBeep03'
     DeathSound(3)=Sound'tk_StarWars.Droideka.DroidBeep03'
     ChallengeSound(0)=Sound'tk_StarWars.Droideka.DroidBeep01'
     ChallengeSound(1)=Sound'tk_StarWars.Droideka.DroidBeep01'
     ChallengeSound(2)=Sound'tk_StarWars.Droideka.DroidBeep01'
     ChallengeSound(3)=Sound'tk_StarWars.Droideka.DroidBeep01'
     GibGroupClass=Class'XEffects.xBotGibGroup'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     FireHeavyRapidAnim="Biggun_Aimed"
     FireHeavyBurstAnim="Biggun_Burst"
     FireRifleRapidAnim="Rifle_Aimed"
     FireRifleBurstAnim="Rifle_Burst"
     Health=200
	 HP=200
	 bCanUsePowerShield=True
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     CrouchAnims(0)="CrouchF"
     CrouchAnims(1)="CrouchB"
     CrouchAnims(2)="CrouchL"
     CrouchAnims(3)="CrouchR"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpB_Mid"
     AirAnims(2)="JumpL_Mid"
     AirAnims(3)="JumpR_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpB_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpB_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DoubleJumpAnims(0)="DoubleJumpF"
     DoubleJumpAnims(1)="DoubleJumpB"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="DodgeF"
     DodgeAnims(1)="DodgeB"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     CrouchTurnRightAnim="Crouch_TurnR"
     CrouchTurnLeftAnim="Crouch_TurnL"
     IdleWeaponAnim="Idle_Biggun"
     LightHue=255
     LightSaturation=127
     LightRadius=8.000000
     AmbientSound=Sound'tk_StarWars.Droideka.DroidekaRolling'
     Mesh=SkeletalMesh'tk_StarWars.Droideka'
     DrawScale=1.200000
     DrawScale3D=(X=1.100000)
     PrePivot=(Z=2.000000)
     Skins(0)=Texture'tk_StarWars.Droideka.DroidekaHead'
     Skins(1)=Texture'tk_StarWars.Droideka.DroidekaBody'
     CollisionRadius=40.000000
     CollisionHeight=50.000000
}
