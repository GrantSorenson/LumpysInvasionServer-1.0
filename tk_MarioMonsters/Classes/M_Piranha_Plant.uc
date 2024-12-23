class M_Piranha_Plant extends MM_Monster;

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
    else if( (Level.TimeSeconds - LastRangedAttackTime > RangedAttackIntervalTime) && (Velocity == vect(0,0,0) || (!Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD)) ) )
    {
		SetAnimAction(RangedAttackAnims[Rand(4)]);
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        LastRangedAttackTime = Level.TimeSeconds;
        bShotAnim = true;
    }
}

function FireProjectile()
{
    local Coords BoneLocation;
    local Projectile Proj;

    if ( Role == Role_Authority && Controller != None )
    {
        BoneLocation = GetBoneCoords('projbone');
        Proj = Spawn(ProjectileClass[Rand(4)],self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,BoneLocation.Origin,AimError));
        if(Proj != None)
        {
            PlaySound(RangedAttackSounds[Rand(4)],SLOT_Interact);
        }
    }
}

event GainedChild(Actor Other)
{
	if(bUseDamageConfig)
	{
		if(Other.Class == ProjectileClass[0])
		{
			Projectile(Other).Damage = ProjectileDamage;
		}
	}

	Super.GainedChild(Other);
}

defaultproperties
{
     MeleeAnims(0)="Attack2"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack2"
     MeleeAnims(3)="Attack2"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death2"
     RangedAttackAnims(0)="Attack1"
     RangedAttackAnims(1)="Attack1"
     RangedAttackAnims(2)="Attack1"
     RangedAttackAnims(3)="Attack1"
     MeleeDamage=30
     NewMeleeDamage=30
     ProjectileClass(0)=Class'tk_MarioMonsters.Piranha_Plant_Projectile'
     ProjectileClass(1)=Class'tk_MarioMonsters.Piranha_Plant_Projectile'
     ProjectileClass(2)=Class'tk_MarioMonsters.Piranha_Plant_Projectile'
     ProjectileClass(3)=Class'tk_MarioMonsters.Piranha_Plant_Projectile'
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepHotAirBalloon1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepHotAirBalloon1'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepHotAirBalloon1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepHotAirBalloon1'
     RangedAttackSounds(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantFireBall'
     RangedAttackSounds(1)=Sound'tk_MarioMonsters.Piranha_Plant.PirannaFireballSpit'
     RangedAttackSounds(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantFireBall'
     RangedAttackSounds(3)=Sound'tk_MarioMonsters.Piranha_Plant.PirannaFireballSpit'
     RangedAttackIntervalTime=2.100000
     HP=220
     ProjectileDamage=30.000000
     HitSound(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     HitSound(1)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     HitSound(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     HitSound(3)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant2'
     DeathSound(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantDie'
     DeathSound(1)=Sound'tk_MarioMonsters.Piranha_Plant.GiantPiranhaPlantDie'
     DeathSound(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlantDie'
     DeathSound(3)=Sound'tk_MarioMonsters.Piranha_Plant.GiantPiranhaPlantDie'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Piranha_Plant.PiranhaPlant1'
     ScoringValue=10
     FootstepVolume=5.000000
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
     MeleeRange=40.000000
     GroundSpeed=150.000000
     JumpZ=250.000000
     Health=220
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Piranha_Plant_Mesh'
     DrawScale=1.250000
     Skins(0)=FinalBlend'MarioMonstersTextures.Skins.Piranha_Plant_FB'
     Skins(1)=FinalBlend'MarioMonstersTextures.Skins.Piranha_Plant_FB'
     AmbientGlow=10
     CollisionRadius=28.000000
     CollisionHeight=65.000000
}
