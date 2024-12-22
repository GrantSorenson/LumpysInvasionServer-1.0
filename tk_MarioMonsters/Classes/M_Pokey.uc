class M_Pokey extends MM_Monster;

var() config int PokeyBallDamage;
var() config int SectionHealth;
var() config bool bSectionsCanBeDestroyed;
var() config bool bUseRegularDeathAnimations;
var() int Spine1Health;
var() int Spine2Health;
var() int Spine3Health;
var() int NumSectionsDestroyed;
var() name SectionBoneNames[3];
var() Rotator LastSectionHitRotation;
var() bool bServerControl;
var() bool bSection1Destroyed;
var() bool bSection2Destroyed;
var() bool bSection3Destroyed;

//spawning more pieces online, client copies, also sections not being hidden

replication
{
	reliable if(Role==ROLE_Authority)
		NumSectionsDestroyed;

	reliable if(Role==ROLE_Authority && bNetInitial)
		bSectionsCanBeDestroyed, bUseRegularDeathAnimations;
}

event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == class'Pokey_Section' || Other.Class == class'Pokey_Head')
		{
			Projectile(Other).Damage = PokeyBallDamage;
		}
	}

	Super.GainedChild(Other);
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if(Role == Role_Authority)
    {
    	Spine1Health = SectionHealth;
		Spine2Health = SectionHealth;
		Spine3Health = SectionHealth;
	}
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	if(NumSectionsDestroyed >= 2 && AmbientGlow < 60)
	{
		AmbientGlow += 1;
	}

	if(bSectionsCanBeDestroyed)
	{
		if(NumSectionsDestroyed == 1 && !bSection1Destroyed)
		{
			HideSection(0, 'spine1');
			bSection1Destroyed = true;
		}

		if(NumSectionsDestroyed == 2 && !bSection2Destroyed)
		{
			HideSection(1, 'spine2');
			bSection2Destroyed = true;
		}

		if(NumSectionsDestroyed == 3 && !bSection3Destroyed)
		{
			HideSection(2, 'spine3');
			bSection3Destroyed = true;
		}
	}
}

function RangedAttack(Actor A)
{
    local float Dist;

    Super.RangedAttack(A);

    Dist = VSize(A.Location - Location);

    if(Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
		if(NumSectionsDestroyed == 2)
		{
			SetAnimAction(MeleeAnims[3]);
		}
		else if(NumSectionsDestroyed >= 3)
		{
			SetAnimAction(MeleeAnims[2]);
		}
		else
		{
        	SetAnimAction(MeleeAnims[Rand(3)]);
		}
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        bShotAnim = true;
    }
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	local int i;
	local vector SpawnLocation;

	if(bUseRegularDeathAnimations)
	{
		if(NumSectionsDestroyed == 1)
		{
			PlayAnim(DeathAnims[3],, 0.1);
		}
		else if(NumSectionsDestroyed == 2)
		{
			PlayAnim(DeathAnims[2],, 0.1);
		}
		else if(NumSectionsDestroyed >= 3)
		{
			PlayAnim(DeathAnims[1],, 0.1);
		}
		else
		{
			PlayAnim(DeathAnims[0],, 0.1);
		}

		return;
	}

	if(Role == Role_Authority && bServerControl)
	{
		for(i=NumSectionsDestroyed;i<3;i++)
		{
			//SectionBoneNames
			SpawnLocation = GetBoneCoords(SectionBoneNames[i]).origin;
			Spawn(class'Pokey_Section',self,,SpawnLocation, Rotation);
			Spawn(class'Pokey_HitEffect',self,,SpawnLocation,Rotation);
		}

		//spawn head
		SpawnLocation = GetBoneCoords('s_head').origin;
		Spawn(class'Pokey_Head',self,,SpawnLocation, Rotation);
	}

	SetDrawScale(0);
	SetCollision(false,false,false);
}

event TornOff()
{
	bServerControl = false;
}

function CalcHitLoc( Vector hitLoc, Vector hitRay, out Name boneName, out float dist )
{
    boneName = GetClosestBone( hitLoc, hitRay, dist, 'origin', 200 );
}

simulated function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
    local Vector HitNormal;
    local Vector HitRay;
    local Name HitBone;
    local float HitBoneDist;
    local PlayerController PC;
    local bool bShowEffects, bRecentHit;

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.5;
    Super(Pawn).PlayHit(Damage,InstigatedBy,HitLocation,DamageType,Momentum);
    if ( Damage <= 0 )
        return;

    PC = PlayerController(Controller);
    bShowEffects = ( (Level.NetMode != NM_Standalone) || (Level.TimeSeconds - LastRenderTime < 2.5)
                    || ((InstigatedBy != None) && (PlayerController(InstigatedBy.Controller) != None))
                    || (PC != None) );
    if ( !bShowEffects )
        return;

   HitRay = vect(0,0,0);
   if( InstigatedBy != None )
   {
        HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));
        LastSectionHitRotation = Rotator(HitRay);
	}
	else
	{
		LastSectionHitRotation = Rotator(Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) ));
	}

    if( DamageType.default.bLocationalHit )
    {
        CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );
	}
    else
    {
        HitLocation = Location;
        HitBone = 'None';
        HitBoneDist = 0.0f;
    }

    if( DamageType.default.bAlwaysSevers && DamageType.default.bSpecial )
        HitBone = 'head';

    if( InstigatedBy != None )
        HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
    else
        HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );


    // hack for flak cannon gibbing
    if ( (DamageType.name == 'DamTypeFlakChunk') && (Health < 0) && (InstigatedBy != None) && (VSize(InstigatedBy.Location - Location) < 350) )
        DoDamageFX( HitBone, 8*Damage, DamageType, Rotator(HitNormal) );
    else
        DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );

    if (DamageType.default.DamageOverlayMaterial != None && Damage > 0 ) // additional check in case shield absorbed
                SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false );
}

simulated function DoDamageFX( Name boneName, int Damage, class<DamageType> DamageType, Rotator r )
{
	Super.DoDamageFx(boneName,Damage, DamageType, r);

	if(bTearOff || !bSectionsCanBeDestroyed)
	{
		return;
	}

	if( Health > 0 )
	{
		switch( boneName )
		{
			case 's_spine1':
				boneName = 'spine1';
				Spine1Health -= Damage;
				if(Spine1Health <= 0)
				{
					DestroySection(boneName, r);
					Spine1Health = SectionHealth;
				}
				break;

			case 's_spine2':
			    boneName = 'spine2';
				Spine2Health -= Damage;
				if(Spine2Health <= 0)
				{
					DestroySection(boneName, r);
					Spine2Health = SectionHealth;
				}
				break;

			case 's_spine3':
				boneName = 'spine3';
				Spine3Health -= Damage;
				if(Spine3Health <= 0)
				{
					DestroySection(boneName, r);
					Spine3Health = SectionHealth;
				}
				break;

			case 'origin':
				boneName = 'spine3';
				Spine3Health -= Damage;
				if(Spine3Health <= 0)
				{
					DestroySection(boneName, r);
					Spine3Health = SectionHealth;
				}
				break;
		}
	}
}

simulated function DestroySection(Name boneName, Rotator r)
{
	local float NewCollisionHeight, NewPrePivotZ, TempCollisionHeight;
	local vector SpawnLocation;

	NumSectionsDestroyed++;
	if(NumSectionsDestroyed >= 4)
	{
		return;
	}

	if(NumSectionsDestroyed >= 3)
	{
		bCanDodge = false;
		DodgeSkillAdjust = 0;
		bSectionsCanBeDestroyed = false;
		MeleeRange = 50;
	}
	else if(NumSectionsDestroyed >= 2)
	{
		MeleeRange = 120;
	}

	if(boneName == 'spine1')
	{
		bSection1Destroyed = true;
	}
	else if(boneName == 'spine2')
	{
		bSection2Destroyed = true;
	}
	else if(boneName == 'spine3')
	{
		bSection3Destroyed = true;
	}

	SpawnLocation = GetBoneCoords(boneName).origin;
	if(Role == Role_Authority)
	{
		Spawn(class'Pokey_Section',self,,SpawnLocation, Rotation);
		Spawn(class'Pokey_HitEffect',self,,SpawnLocation,Rotation);
	}
	//log("SetBoneScale" @ NumSectionsDestroyed-1 @ " " @ SectionBoneNames[NumSectionsDestroyed-1]);
	//SetBoneScale(NumSectionsDestroyed-1, 0, SectionBoneNames[NumSectionsDestroyed-1]);
	HideSection(NumSectionsDestroyed-1, SectionBoneNames[NumSectionsDestroyed-1]);
	TempCollisionHeight = default.CollisionHeight / 4;
	NewCollisionHeight = (TempCollisionHeight * 4) - (TempCollisionHeight * NumSectionsDestroyed);
	SetCollisionSize(CollisionRadius,NewCollisionHeight);
	NewPrePivotZ = default.PrePivot.Z - (TempCollisionHeight * NumSectionsDestroyed);
	PrePivot.Z = NewPrePivotZ;
	SetAnimAction(HitAnims[Rand(4)]);
	bShotAnim = true;
}

simulated event HideSection(int BoneScaleSlot, name boneName)
{
	SetBoneScale(BoneScaleSlot, 0, boneName);
}

defaultproperties
{
     PokeyBallDamage=10
     SectionHealth=50
     bSectionsCanBeDestroyed=True
     SectionBoneNames(0)="spine1"
     SectionBoneNames(1)="spine2"
     SectionBoneNames(2)="spine3"
     bServerControl=True
     MeleeAnims(0)="Attack"
     MeleeAnims(1)="Attack"
     MeleeAnims(2)="Attack_stage1"
     MeleeAnims(3)="Attack_stage2"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death_stage1"
     DeathAnims(2)="Death_stage2"
     DeathAnims(3)="Death_stage3"
     MeleeDamage=25
     NewMeleeDamage=25
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantAttack'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantAttack'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantAttack'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantAttack'
     HP=500
     bCanDodge=False
     DodgeSkillAdjust=0.000000
     ScoringValue=20
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
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=200.000000
     GroundSpeed=220.000000
     JumpZ=300.000000
     Health=500
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
     IdleCrouchAnim="Move"
     IdleSwimAnim="Move"
     IdleWeaponAnim="Move"
     IdleRestAnim="Move"
     IdleChatAnim="Move"
     Mesh=SkeletalMesh'MarioMonstersAnims.Pokey_Mesh'
     DrawScale=1.750000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Pokey_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Pokey_skin'
     AmbientGlow=10
     CollisionRadius=30.000000
     CollisionHeight=110.000000
}
