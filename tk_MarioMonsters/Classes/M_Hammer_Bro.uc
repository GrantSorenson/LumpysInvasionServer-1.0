class M_Hammer_Bro extends MM_Monster;

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
		SetAnimAction('Attack1');
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
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     RangedAttackAnims(0)="Attack1"
     RangedAttackAnims(1)="Attack1"
     RangedAttackAnims(2)="Attack1"
     RangedAttackAnims(3)="Attack1"
     MeleeDamage=30
     NewMeleeDamage=30
     ProjectileClass(0)=Class'tk_MarioMonsters.Hammer_Bro_Projectile'
     ProjectileClass(1)=Class'tk_MarioMonsters.Hammer_Bro_Projectile'
     ProjectileClass(2)=Class'tk_MarioMonsters.Hammer_Bro_Projectile'
     ProjectileClass(3)=Class'tk_MarioMonsters.Hammer_Bro_Projectile'
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Hammer_Bro.ThrowHammer'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Hammer_Bro.ThrowHammer'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Hammer_Bro.ThrowHammer'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Hammer_Bro.ThrowHammer'
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepTree1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepTree2'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepTree1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepTree2'
     RangedAttackSounds(0)=Sound'tk_MarioMonsters.Hammer_Bro.HammerThrow'
     RangedAttackSounds(1)=Sound'tk_MarioMonsters.Hammer_Bro.HammerThrow'
     RangedAttackSounds(2)=Sound'tk_MarioMonsters.Hammer_Bro.HammerThrow'
     RangedAttackSounds(3)=Sound'tk_MarioMonsters.Hammer_Bro.HammerThrow'
     HP=180
     ProjectileDamage=30.000000
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound5'
     HitSound(1)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound6'
     HitSound(2)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound5'
     HitSound(3)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound6'
     DeathSound(0)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound7'
     DeathSound(1)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound7'
     DeathSound(2)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound4'
     DeathSound(3)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound10'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound12'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound8'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound9'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Hammer_Bro.Hammer_Bro_Sound11'
     ScoringValue=8
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
     GroundSpeed=270.000000
     JumpZ=250.000000
     Health=180
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Hammer_Bro_Mesh'
     DrawScale=1.750000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Hammer_Bro_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Hammer_Bro_eye'
     Skins(2)=Texture'tk_MarioMonsters.MarioMonsters.Hammer_Bro_skin3'
     AmbientGlow=10
     CollisionRadius=28.000000
     CollisionHeight=55.000000
}
