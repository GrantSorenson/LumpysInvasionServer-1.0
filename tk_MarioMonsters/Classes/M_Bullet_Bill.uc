class M_Bullet_Bill extends MM_Monster;

var() config int ExplodeDamage;
var() config float ExplodeRadius;
var() config float ExplodeRange;
var() Emitter TrailEmitter;
var() bool bExploding;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
 	if ( Level.NetMode != NM_DedicatedServer )
	{
		if(TrailEmitter == None)
		{
			TrailEmitter = Spawn(class'Bullet_Bill_TrailEffect', self);
			AttachToBone(TrailEmitter, 'exhaust');
		}
    }

    PlayAnim('Move');
}

function RangedAttack(Actor A)
{
	local float Dist;

	Super.RangedAttack(A);

	if(bExploding)
	{
		if(Controller != None)
		{
			Controller.bPreparingMove = true;
			Acceleration = vect(0,0,0);
		}

		return;
	}

	Dist = VSize(A.Location - Location);

	if(!bExploding && Dist < ExplodeRange + CollisionRadius + A.CollisionRadius )
	{
		//SetAnimAction(DeathAnims[Rand(4)]);
		PlaySound(Sound'tk_MarioMonsters.Bullet_Bill.BulletBillExplosion1');
		Spawn(class'Bullet_Bill_Explosion',self,,Location + vect(0,0,0),Rotation);
		BlowUpDamage();
		SetDrawScale(0);
		Died(None, Class'Bullet_Bill_DamageType', Location);
		DeResTime = -5;
		bExploding = true;
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
}

function BlowUpDamage()
{
	local xPawn P;
	local vector dir;
    local float damageScale, dist, Momentum, Shake;

	if(Role == ROLE_Authority)
	{
		foreach VisibleCollidingActors(class'xPawn', P, ExplodeRadius, Location)
		{
			if(P != None && P.Health > 0 && P.Controller != None && !P.Controller.IsA('MonsterController'))
			{
				Shake = RandRange(2000,3000);
				P.Controller.ShakeView( vect(0.0,0.02,0.0)*Shake, vect(0,1000,0),0.003*Shake, vect(0.02,0.02,0.02)*Shake, vect(1000,1000,1000),0.003*Shake);
				Momentum = 100 * P.CollisionRadius;
				dir = P.Location - Location;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				P.TakeDamage(ExplodeDamage,self,P.Location - 0.5 * (P.CollisionHeight + P.CollisionRadius) * dir,(damageScale * Momentum * dir), Class'Bullet_Bill_DamageType');
			}
		}
	}
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

simulated function RemovePowerups()
{
	RemoveEffects();
	Super.RemovePowerups();
}

simulated function RemoveEffects()
{
	if(TrailEmitter != None)
	{
		TrailEmitter.Kill();
	}
}

/*simulated function PlayDirectionalDeath(Vector HitLoc)
{
	SetPhysics(PHYS_Falling);
	RandSpin(25000);
}*/

defaultproperties
{
     ExplodeDamage=75
     ExplodeRadius=600.000000
     ExplodeRange=50.000000
     MeleeAnims(0)="Move"
     MeleeAnims(1)="Move"
     MeleeAnims(2)="Move"
     MeleeAnims(3)="Move"
     HitAnims(0)="Move"
     HitAnims(1)="Move"
     HitAnims(2)="Move"
     HitAnims(3)="Move"
     DeathAnims(0)="Death2"
     DeathAnims(1)="Death2"
     DeathAnims(2)="Death2"
     DeathAnims(3)="Death2"
     HP=130
     DodgeSkillAdjust=2.000000
     DeathSound(0)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBill1'
     DeathSound(1)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBill1'
     DeathSound(2)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBill1'
     DeathSound(3)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBill1'
     ChallengeSound(0)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBillHoming'
     ChallengeSound(1)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBillHoming'
     ChallengeSound(2)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBillHoming'
     ChallengeSound(3)=Sound'tk_MarioMonsters.Bullet_Bill.BulletBillHoming'
     ScoringValue=5
     WallDodgeAnims(0)="Move"
     WallDodgeAnims(1)="Move"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Move"
     IdleRifleAnim="Move"
     FireHeavyRapidAnim="Move"
     FireHeavyBurstAnim="Move"
     FireRifleRapidAnim="Move"
     FireRifleBurstAnim="Move"
     bBlobShadow=True
     bCanFly=True
     bCanStrafe=False
     bCanWalkOffLedges=True
     bNoCoronas=True
     MeleeRange=80.000000
     AirSpeed=350.000000
     JumpZ=200.000000
     Health=130
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
     Mesh=SkeletalMesh'MarioMonstersAnims.Bullet_Bill_Mesh'
     DrawScale=1.750000
     PrePivot=(Z=0.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.bulet_bill_skin1'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.bulet_bill_skin1'
     AmbientGlow=10
     CollisionRadius=65.000000
     CollisionHeight=45.000000
}
