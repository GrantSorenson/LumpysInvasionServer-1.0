class M_Spiny extends MM_Monster;

var() config int SpikeDamage;

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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Vector PushDir;

	if(Health > 0 && damageType == class'Crushed' && instigatedBy != None && Monster(instigatedBy) == None)
	{
		//spikes damage player that jumped on me
		PushDir = (30000 * Normal(instigatedBy.Location - Location));
		instigatedBy.TakeDamage(SpikeDamage, Self, hitLocation, PushDir, class'DamType_Spiny_Shell');
	}

	Super.TakeDamage(Damage, instigatedBy,hitlocation, momentum, damageType);
}

defaultproperties
{
     SpikeDamage=50
     MeleeAnims(0)="Attack"
     MeleeAnims(1)="Attack"
     MeleeAnims(2)="Attack"
     MeleeAnims(3)="Attack"
     HitAnims(0)="Pain"
     HitAnims(1)="Pain"
     HitAnims(2)="Pain"
     HitAnims(3)="Pain"
     DeathAnims(0)="Death1"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death1"
     DeathAnims(3)="Death2"
     MeleeDamage=15
     NewMeleeDamage=15
     MeleeAttackSounds(0)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     MeleeAttackSounds(1)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     MeleeAttackSounds(2)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     MeleeAttackSounds(3)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     Footstep(0)=Sound'tk_MarioMonsters.FootSteps.MMFootStepIce1'
     Footstep(1)=Sound'tk_MarioMonsters.FootSteps.MMFootStepIce2'
     Footstep(2)=Sound'tk_MarioMonsters.FootSteps.MMFootStepIce1'
     Footstep(3)=Sound'tk_MarioMonsters.FootSteps.MMFootStepIce2'
     HitSound(0)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     HitSound(1)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     HitSound(2)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     HitSound(3)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     DeathSound(0)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     DeathSound(1)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     DeathSound(2)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     DeathSound(3)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Spiny.Spiny1'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Spiny.Spiny1'
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
     MeleeRange=50.000000
     GroundSpeed=180.000000
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Spiny_Mesh'
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Spiny_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Spiny_skin'
     AmbientGlow=10
     CollisionRadius=30.000000
     CollisionHeight=20.000000
}
