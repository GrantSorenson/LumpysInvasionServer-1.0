class FriendlyMonsterController extends MonsterController;

var() Controller Master;
var() TeamInfo Team;
var() string StandingOrder; //Defend = defend master, DefendAll = defend all players, Attack = free roam, Stay = hold position
//var() InvasionProPetStatsItem MyStats;
var() int TeleportSkill;
var() float TeleportRange;
var() float TeleportCooldown;
var() float LastTeleportTime;
var() Actor CollisionTestActor;
var() float LastFollowTime;
var() Actor Anchor;
var() bool bCompanionPet;
var() bool bPetCanTeleport;
var() String PetName;
var() bool bMinion;

//make minions stay at masters anchor point not at masters location
function SetOrder(string NewOrder)
{
	local Controller C;

	StandingOrder = NewOrder;
	if(!bMinion)
	{
		if(NewOrder ~= "Stay" && Master != None && Master.Pawn != None)
		{
			if(Anchor == None)
			{
				Anchor = Spawn(class'IPPetAnchor',Master.Pawn,,Master.Pawn.Location);
			}

			if(Anchor != None)
			{
				Anchor.SetLocation(Master.Pawn.Location);
				Anchor.SetPhysics(PHYS_Falling);
			}

			for ( C=Level.ControllerList; C != None; C = C.NextController )
			{
				if(FriendlyMonsterController(C) != None && FriendlyMonsterController(C).bMinion && FriendlyMonsterController(C).Master == Self)
				{
					//these are my minions
					if(FriendlyMonsterController(C).Anchor == None)
					{
						FriendlyMonsterController(C).Anchor = Spawn(class'IPPetAnchor',Master.Pawn,,Master.Pawn.Location);
					}

					if(FriendlyMonsterController(C).Anchor != None)
					{
						FriendlyMonsterController(C).Anchor.SetLocation(Master.Pawn.Location);
						FriendlyMonsterController(C).Anchor.SetPhysics(PHYS_Falling);
					}
				}
			}
		}
	}
}

function vector GetClosestTeleportLocation(Actor A)
{
	local NavigationPoint N, BestNode;

	BestNode = None;
	if(CollisionTestActor == None)
	{
		CollisionTestActor = Spawn(class'IPCollisionTestActor');
	}

	CollisionTestActor.SetCollisionSize(Pawn.CollisionRadius,Pawn.CollisionHeight);
	CollisionTestActor.SetCollision(true,true,true);

	foreach RadiusActors(class'NavigationPoint',N,200,A.Location)
	{
		if(FastTrace(N.Location, A.Location))//if the node can see the enemy
		{
			if(CollisionTestActor.SetLocation(N.Location+(A.CollisionHeight - N.CollisionHeight) * vect(0,0,1)) )
			{
				BestNode = N;
				break;
			}
		}
	}

	CollisionTestActor.SetCollision(false,false,false);

	if(BestNode != None)
	{
		return BestNode.Location;
	}

	return vect(0,0,0);
}

function ReceiveWarning(Pawn shooter, float projSpeed, vector FireDir)
{
    local float enemyDist, DodgeSkill;
    local vector X,Y,Z, enemyDir;

    // AI controlled creatures may duck if not falling
    DodgeSkill = Skill + Monster(Pawn).DodgeSkillAdjust;
    if ( (Pawn.health <= 0) || (Enemy == None) || !Monster(Pawn).bCanDodge || (Pawn.Physics == PHYS_Falling) || (Pawn.Physics == PHYS_Swimming))
    {
        return;
	}

    //dodge probability
    // if( (fRand() * class'LumpysInvasionGameReplicationInfo'.default.Ability_Dodge.DodgeMax) > (DodgeSkill) )
    // {
	// 	return;
	// }
    // and projectile time is long enough
    enemyDist = VSize(shooter.Location - Pawn.Location);
    if (enemyDist/projSpeed < 0.11 + 0.15 * FRand())
    {
        return;
	}
    // only if tight FOV
    GetAxes(Pawn.Rotation,X,Y,Z);
    enemyDir = (shooter.Location - Pawn.Location)/enemyDist;
    if ((enemyDir Dot X) < 0.6)
    {
        return;
	}

    if ( (FireDir Dot Y) > 0 )
    {
        Y *= -1;
        TryToDuck(Y, true);
    }
    else
    {
        TryToDuck(Y, false);
	}
}

function bool FindBestPathToward(Actor A, bool bCheckedReach, bool bAllowDetour)
{
    if ( !bCheckedReach && ActorReachable(A) )
        MoveTarget = A;
    else
        MoveTarget = FindPathToward(A,false);

    if ( MoveTarget != None )
        return true;
    else
    {
        if ( (A == Enemy) && (A != None) )
        {
            FailedHuntTime = Level.TimeSeconds;
            FailedHuntEnemy = Enemy;
        }
        if ( bSoaking && (Physics != PHYS_Falling) )
            SoakStop("COULDN'T FIND BEST PATH TO "$A);
    }
    return false;
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if(Enemy != None)
	{
		if(Enemy == Pawn || (Master != None && Master.Pawn != None && Enemy == Master.Pawn) || (Enemy.Controller != None && IsFriend(Enemy.Controller)) )
		{
			Enemy = None;
		}
	}
}

function bool IsFriend(Controller C)
{
	if(TeamGame(Level.Game) != None)
	{
		if(C.SameTeamAs(Self))
		{
			return true;
		}
	}

	if(FriendlyMonsterController(C) != None && FriendlyMonsterController(C).Master != None && (FriendlyMonsterController(C).Master == Master || FriendlyMonsterController(C).Master == Self))
	{
		return true;
	}

	return false;
}

function AssignToPlayerTeam( int TeamIndex )
{
	local	TeamInfo	T, FoundTeam;

	forEach DynamicActors( class'TeamInfo', T )
	{
		if ( T.TeamIndex == TeamIndex )
		{
			FoundTeam = T;
			break;
		}
	}

	if ( FoundTeam == None || UnrealTeamInfo( FoundTeam ) == None )
	{
		log("No Team found for friendly monster!");
		return;
	}

	if ( PlayerReplicationInfo != None )
	{
		if ( PlayerReplicationInfo.Team == FoundTeam )
		{
			return;
		}
		else
		{
			UnrealTeamInfo( PlayerReplicationInfo.Team ).RemoveFromTeam( self );
		}
	}

	UnrealTeamInfo( FoundTeam ).AddToTeam( self );
	Team = FoundTeam;
	SetPlayerTeamAssignment( FoundTeam );
}

function SetPlayerTeamAssignment( TeamInfo PlayerTeam )
{
	local Controller C;

	MoveTimer = 1.0;
	MoveTarget = None;

	// Find Team Leader and send this creature to follow.
	if ( UnrealTeamInfo( PlayerTeam ).AI.AttackSquad != None )
		MoveTarget = UnrealTeamInfo( PlayerTeam ).AI.AttackSquad.SquadLeader.Pawn;
	else if ( UnrealTeamInfo( PlayerTeam ).AI.FreelanceSquad != None )
		MoveTarget = UnrealTeamInfo( PlayerTeam ).AI.FreelanceSquad.SquadLeader.Pawn;
	else
	{
		// Find first Pawn on this Team and assume that's the human player.  If Pawn is visible, that would be best.
		for ( C=Level.ControllerList; C != None; C = C.NextController )
		{
			if ( C.IsA('PlayerController') && C.Pawn != None && UnrealTeamInfo( PlayerTeam ).AI.FriendlyToward( C.Pawn ) )
			{
				if ( LineOfSightTo( C.Pawn ) )
				{
					MoveTarget = C.Pawn;
					break;
				}
				if ( MoveTarget == None )
					MoveTarget = C.Pawn;
			}
		}
	}
}

function Possess(Pawn aPawn)
{
	local Inventory Inv;

	Super(ScriptedController).Possess(aPawn);

	if(Pawn == None)
	{
		return;
	}

		//InvasionProMutator(BaseMutator).ModifyMonster(NewMonster,false,false);
	Inv = Pawn.FindInventoryType(class'IPMonsterIDInv');
	if(IPMonsterIDInv(Inv) != None)
	{
		IPMonsterIDInv(Inv).bSummoned = false;
		IPMonsterIDInv(Inv).bBoss = false;
		IPMonsterIDInv(Inv).bFriendly = true;
	}
	//InvasionProMutator(InvasionPro(Level.Game).BaseMutator).ModifyMonster(Pawn,true,false);
	InitializeSkill(DeathMatch(Level.Game).AdjustedDifficulty);
	Pawn.MaxFallSpeed = 1.1 * Pawn.default.MaxFallSpeed; // so bots will accept a little falling damage for shorter routes
	Pawn.SetMovementPhysics();
	if (Pawn.Physics == PHYS_Walking)
	{
		Pawn.SetPhysics(PHYS_Falling);
	}

	enable('NotifyBump');
}

function SetMaster(Controller NewMaster)
{
	Master = NewMaster;
	if(Master == None)
	{
		// if(MyStats != None)
		// {
		// 	MyStats.RecallPet(bCompanionPet);
		// }
		//recall if master is dead/none
	}
}
//for monsters summoned by pets
function CreateFriendlyMonsterReplicationInfo()
{
	local LumpysInvasionFriendlyMonsterReplicationInfo TempPRI;

	if(Monster(Pawn) == None)
	{
		log("Friendly Monster Replication could not be created. The Monster does not exist.",'InvasionPro');
		return;
	}

	TempPRI = Spawn(class'LumpysInvasionFriendlyMonsterReplicationInfo',Pawn);
	if(TempPRI != None)
	{
		if(PlayerReplicationInfo != None)
		{
			PlayerReplicationInfo.Destroy();
		}

		PlayerReplicationInfo = TempPRI;
		if(Pawn.PlayerReplicationInfo != None)
		{
			Pawn.PlayerReplicationInfo.Destroy();
		}

		Pawn.PlayerReplicationInfo = PlayerReplicationInfo;

		if(Master != None && Master.PlayerReplicationInfo != None)
		{
			if(Master.PlayerReplicationInfo.Team != None)
			{
				PlayerReplicationInfo.Team = Master.PlayerReplicationInfo.Team;
				AssignToPlayerTeam(Master.PlayerReplicationInfo.Team.TeamIndex);
			}
		}

		LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo).bMinion = true;
		LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo).SetPRI();
		LumpysInvasion(Level.Game).UpdatePlayerGRI();
		if(LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo) != None)
		{
			LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo).AddFriendlyMonster(Monster(Pawn));
		}
	}

	bMinion = true;
	if(FriendlyMonsterController(Master) != None)
	{
		SetOrder(FriendlyMonsterController(Master).StandingOrder);
	}

	UpdateMinion();
}

function UpdateMinion()
{
	local string MonsterName;

	if(FriendlyMonsterController(Master) != None)
	{
		if(FriendlyMonsterController(Master).PetName != "")
		{
			MonsterName = FriendlyMonsterController(Master).PetName$"'s Minion";
		}
	}
	else
	{
		MonsterName = "";
	}

	if(LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo) != None)
	{
		PlayerReplicationInfo.SetPlayerName(MonsterName);
		LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo).UpdatePRI();
	}
}

function Pawn GetMonsterTarget(Pawn EnemyMonster)
{
	if(EnemyMonster.Controller != None && EnemyMonster.Controller.Enemy != None)
	{
		return EnemyMonster.Controller.Enemy;
	}

	return None;
}

function DamageAttitudeTo(Pawn Other, float Damage)
{
	if(Pawn != None && Pawn.Health > 0 && Other != None && Other.Health > 0 && Other.Controller != None && !IsFriend(Other.Controller))
	{
		if(StandingOrder ~= "Defend" && Enemy == None)
		{
			ChangeEnemy(Other,true);
		}
		else if( SetEnemy(Other,true))
		{
			WhatToDoNext(5);
		}
	}
}

function bool FindNewEnemy()
{
	local Pawn BestEnemy, HatedBestEnemy, MonsterTarget;
	local float BestDist, Dist;
	local Controller C;
	local string OldOrder;
	local int BestHealth;

	BestDist = 50000.f;
	BestHealth = 999999;

	OldOrder = StandingOrder;
	if(Master == None)
	{
		StandingOrder = "Attack";
	}
	else if(Master.Pawn == None && StandingOrder ~= "Defend")
	{
		StandingOrder = "DefendAll";
	}

	if(StandingOrder ~= "Stay" && Anchor == None)
	{
		StandingOrder = "DefendAll";
	}

	if(StandingOrder ~= "Stay")
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if ( C != Master && C != Self && C.Pawn != None && !IsFriend(C)
				 && FastTrace(C.Pawn.Location,Anchor.Location) )//Master.Pawn.Location+Master.Pawn.BaseEyeHeight*Vect(0,0,0.5)) )// && CanSee(C.Pawn) )
			{
				Dist = VSize(C.Pawn.Location - Anchor.Location);
				if(Dist < BestDist)
				{
					BestEnemy = C.Pawn;
					BestDist = Dist;
				}
			}
		}
	}
	else if(StandingOrder ~= "DefendAll")
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if ( C != Master && C != Self && C.Pawn != None && !IsFriend(C)	)
			{
				Dist = VSize(C.Pawn.Location - Pawn.Location);
				if(Dist < BestDist)
				{
					MonsterTarget = GetMonsterTarget(C.Pawn);
					if(MonsterTarget != None && PlayerController(MonsterTarget.Controller) != None && MonsterTarget.Health < BestHealth)
					{
						HatedBestEnemy = C.Pawn;
						BestHealth = MonsterTarget.Health;
					}

					BestEnemy = C.Pawn;
					BestDist = Dist;
				}
			}
		}
	}
	else if(StandingOrder ~= "Attack")
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if ( C != Master && C != Self && C.Pawn != None && !IsFriend(C)	)
			{
				Dist = VSize(C.Pawn.Location - Pawn.Location);
				if(Dist < BestDist)
				{
					BestEnemy = C.Pawn;
					BestDist = Dist;
				}
			}
		}
	}

	StandingOrder = OldOrder;

	if(HatedBestEnemy != None)
	{
		ChangeEnemy(HatedBestEnemy, true);
		return true;
	}

	if ( BestEnemy == Enemy )
	{
		return false;
	}

	if ( BestEnemy != None )
	{
		ChangeEnemy(BestEnemy, true);
		return true;
	}

	return false;
}

function bool SetEnemy( Pawn P, optional bool bHateEnemy )
{
	local float EnemyDist, NewEnemyDist;

	if( P == None || P.Health <= 0 || Enemy == P || StandingOrder ~= "Defend")
	{
		return false;
	}

	if( Master != None)
	{
		if(Master.Pawn != None)
		{
			if( P == Master.Pawn || (P.Controller != None && P.Controller.SameTeamAs(Master)) )
			{
				return false;
			}
		}
	}

	if(Enemy != None)
	{
		EnemyDist = VSize(Pawn.Location - Enemy.Location);
		NewEnemyDist = VSize(Pawn.Location - P.Location);

		if(EnemyDist < NewEnemyDist)
		{
			return false;
		}
	}

	ChangeEnemy(P, false);
	return True;
}

function SeePlayer( Pawn Seen )
{
	if( SetEnemy(Seen,False) )
	{
		GoToState('Hunting');
	}
}

//tell other monster to fight this monster
function ChangeEnemy(Pawn NewEnemy, bool bCanSeeNewEnemy)
{
	if(NewEnemy != None && Pawn != None && MonsterController(NewEnemy.Controller) != None)
	{
		if(MonsterController(NewEnemy.Controller).Enemy == None || MonsterController(NewEnemy.Controller).Enemy != Pawn)
		{
			//MonsterController(Pawn.Controller).ChangeEnemy(Pawn, bCanSeeNewEnemy);
			MonsterController(NewEnemy.Controller).OldEnemy = MonsterController(NewEnemy.Controller).Enemy;
			MonsterController(NewEnemy.Controller).Enemy = Pawn;
			MonsterController(NewEnemy.Controller).EnemyChanged(bCanSeeNewEnemy);
		}
	}

    OldEnemy = Enemy;
    Enemy = NewEnemy;
    EnemyChanged(bCanSeeNewEnemy);
}

function EnemyChanged(bool bNewEnemyVisible)
{
    bEnemyAcquired = false;
    SetEnemyInfo(bNewEnemyVisible);
	if ( Level.timeseconds - ChallengeTime > 7 )
    {
    	ChallengeTime = Level.TimeSeconds;
    	Monster(Pawn).PlayChallengeSound();
    }
}

function HearNoise(float Loudness, Actor NoiseMaker)
{
}

function SetPetName(String NewPetName, String ReplicationName)
{
	local Controller C;

	PetName = NewPetName;

	if(LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo) != None)
	{
		PlayerReplicationInfo.SetPlayerName(ReplicationName);
		LumpysInvasionFriendlyMonsterReplicationInfo(PlayerReplicationInfo).UpdatePRI();
	}

	for ( C=Level.ControllerList; C != None; C = C.NextController )
	{
		if(FriendlyMonsterController(C) != None && FriendlyMonsterController(C).bMinion && FriendlyMonsterController(C).Master == Self)
		{
			//update minion names
			FriendlyMonsterController(C).UpdateMinion();
		}
	}
}

function DestroyPRI()
{
	local Inventory Inv;

	if(Pawn.PlayerReplicationInfo != None)
	{
		Pawn.PlayerReplicationInfo.Destroy();
	}

	if(PlayerReplicationInfo != None)
	{
		PlayerReplicationInfo.Destroy();
	}

	LumpysInvasion(Level.Game).UpdatePlayerGRI();
	if(LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo) != None)
	{
		LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo).RemoveFriendlyMonster(Monster(Pawn));
	}

	Inv = Pawn.FindInventoryType(class'IPMonsterIDInv');
	if(IPMonsterIDInv(Inv) != None)
	{
		IPMonsterIDInv(Inv).bFriendly = false;
		IPMonsterIDInv(Inv).MonsterName = "";
		IPMonsterIDInv(Inv).MyMonster.bBoss = false;
	}
}

function ExecuteWhatToDoNext()
{
	local Controller MC;
	local vector SpawnLocation;
	local rotator SpawnRotation;

	bHasFired = false;
	GoalString = "WhatToDoNext at "$Level.TimeSeconds;
	if ( Pawn == None )
	{
		return;
	}

	if(Master == None)
	{
		Pawn.Controller.Destroy();
		MC = Spawn(Monster(Pawn).default.ControllerClass,,, SpawnLocation, SpawnRotation);
		MC.Possess(Pawn);
		DestroyPRI();
	}
	else
	{
		if ( bPreparingMove && Monster(Pawn).bShotAnim )
		{
			Pawn.Acceleration = vect(0,0,0);
			GotoState('WaitForAnim');
			return;
		}
		if (Pawn.Physics == PHYS_None)
			Pawn.SetMovementPhysics();
		if ( (Pawn.Physics == PHYS_Falling) && DoWaitForLanding() )
			return;
		if ( (Enemy != None) && ((Enemy.Health <= 0) || (Enemy.Controller == None)) )
		{
			Enemy = None;
		}

		if ( StandingOrder != "Defend" && (Enemy == None) || !EnemyVisible() )
		{
			FindNewEnemy();
		}

		if ( Enemy != None )
		{
			ChooseAttackMode();
		}
		else if (StandingOrder ~= "Stay" && Anchor != None)
		{
			if(FindBestPathToward(Anchor, false, Pawn.bCanPickupInventory))
			{
				GotoState('Roaming');
			}
		}
		else if(Master.Pawn != None)
		{
			Destination = Master.Pawn.Location;
			MoveTarget = Master.Pawn;
			FollowMaster();
		}
		else
		{
			GoalString = "WhatToDoNext Wander or Camp at "$Level.TimeSeconds;
			WanderOrCamp(true);
		}
	}
}

function FollowMaster()
{
	local NavigationPoint N, BestNode;
	local Actor FollowTarget;
	local float Dist, BestDist;

	if ( VSize(Master.Pawn.Location - Pawn.Location) > 1000 || VSize(Master.Pawn.Velocity) > Master.Pawn.WalkingPct * Master.Pawn.GroundSpeed
	     || !LineOfSightTo(Master.Pawn) )
	{
		GoalString = "Follow Master "$Master.PlayerReplicationInfo.PlayerName;
		if(!TryTeleport(Master.Pawn))
		{
			FollowTarget = Master.Pawn;
			BestDist = 999999.f;

			if(Master.Pawn.Physics == PHYS_Flying)
			{
				for ( N=Level.NavigationPointList; N!=None && FlyingPathNode(N) == None; N=N.NextNavigationPoint )
				{
					Dist = VSize(N.Location - Master.Pawn.Location);
					if(Dist < BestDist)
					{
						BestDist = Dist;
						BestNode = N;
					}
				}

				if(BestNode != None)
				{
					FollowTarget = BestNode;
				}
			}

			if (FindBestPathToward(FollowTarget, false, Pawn.bCanPickupInventory))
			{
				if ( Enemy != None )
					GotoState('Fallback');
				else
					GotoState('Roaming');

				return;
			}
		}
	}

	GoalString = "Wander or Camp at "$Level.TimeSeconds;
	WanderOrCamp(true);
}

function bool TryTeleport(Actor TeleportTarget)
{
	local Rotator TeleRotation;
	local vector TeleSpot, OldSpot;
	local float Dist;

	if(!bPetCanTeleport)
	{
		return false;
	}

	if(TeleportSkill > 0 && Level.TimeSeconds - LastTeleportTime > TeleportCooldown)
	{
		Dist = VSize(TeleportTarget.Location - Pawn.Location);
		if( (Dist > (100+Pawn.CollisionRadius+TeleportTarget.CollisionRadius)) && Dist <= TeleportRange)
		{
			TeleSpot = GetClosestTeleportLocation(TeleportTarget);
			if(TeleSpot == vect(0,0,0))
			{
				TeleSpot = TeleportTarget.Location + (TeleportTarget.CollisionHeight * vect(0,0,1)) + vect(0,0,10);
			}

			OldSpot = Pawn.Location;
			TeleRotation =  Rotator(TeleSpot - Pawn.Location);
			if(Pawn.SetLocation(TeleSpot+vect(0,0,20)))
			{
				Pawn.Velocity = vect(0,0,0);
				Pawn.Acceleration = vect(0,0,0);
				//Pawn.PlaySound(Sound'Pet_SkillMax',Slot_Misc);
				//Spawn(class'InvasionProPetTeleportFXIn',Pawn,,Pawn.Location);
				//Spawn(class'InvasionProPetTeleportFXOut',Pawn,,OldSpot,TeleRotation);
				LastTeleportTime = Level.TimeSeconds;
				return true;
			}
		}
	}

	return false;
}

function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn)
{
	if (Killer == Self)
	{
		Celebrate();
	}

	if (KilledPawn == Enemy)
	{
		Enemy = None;
		FindNewEnemy();
	}
}

function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();

	Super.Destroyed();
}

state RestFormation
{
	function BeginState()
	{
		Enemy = None;
		Pawn.bCanJump = false;
		Pawn.bAvoidLedges = true;
		Pawn.bStopAtLedges = true;
		Pawn.SetWalking(true);
		MinHitWall += 0.15;
		if (Master != None && Master.Pawn != None)
			StartMonitoring(Master.Pawn, 1000);
	}
}

state Fallback extends MoveToGoalWithEnemy
{
	function MayFall()
	{
		Pawn.bCanJump = ( (MoveTarget != None)
					&& ((MoveTarget.Physics != PHYS_Falling) || !MoveTarget.IsA('Pickup')) );
	}

Begin:
	SwitchToBestWeapon();
	WaitForLanding();

Moving:
	if (InventorySpot(MoveTarget) != None)
		MoveTarget = InventorySpot(MoveTarget).GetMoveTargetFor(self,0);
	MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
	WhatToDoNext(14);
	if ( bSoaking )
		SoakStop("STUCK IN FALLBACK!");
	goalstring = goalstring$" STUCK IN FALLBACK!";
}

state WaitingToAttack
{

Begin:
	Sleep(2.0);
	GotoState('RangedAttack');
}

state Charging
{
ignores SeePlayer, HearNoise;

    /* MayFall() called by engine physics if walking and bCanJump, and
        is about to go off a ledge.  Pawn has opportunity (by setting
        bCanJump to false) to avoid fall
    */
    function MayFall()
    {
        if ( MoveTarget != Enemy )
            return;
		if(Enemy != None)
		{
        	Pawn.bCanJump = ActorReachable(Enemy);
		}
		else
		{
			return;
		}
        if ( !Pawn.bCanJump )
            MoveTimer = -1.0;
    }

    function bool TryToDuck(vector duckDir, bool bReversed)
    {
        if ( FRand() < 0.6 )
            return Global.TryToDuck(duckDir, bReversed);
        if ( Enemy != None && MoveTarget == Enemy )
            return TryStrafe(duckDir);
    }

    function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
    {
        local vector sideDir;

        if ( FRand() * Damage < 0.15 * CombatStyle * Pawn.Health )
            return false;

        if ( !bFindDest )
            return true;

		if(Enemy != None)
		{
        	sideDir = Normal( Normal(Enemy.Location - Pawn.Location) Cross vect(0,0,1) );
		}
		else
		{
			sideDir = vect(0,0,0);
		}
        if ( (Pawn.Velocity Dot sidedir) > 0 )
            sidedir *= -1;

        return TryStrafe(sideDir);
    }

    function bool TryStrafe(vector sideDir)
    {
        local vector extent, HitLocation, HitNormal;
        local actor HitActor;

        Extent = Pawn.GetCollisionExtent();
        HitActor = Trace(HitLocation, HitNormal, Pawn.Location + MINSTRAFEDIST * sideDir, Pawn.Location, false, Extent);
        if (HitActor != None)
        {
            sideDir *= -1;
            HitActor = Trace(HitLocation, HitNormal, Pawn.Location + MINSTRAFEDIST * sideDir, Pawn.Location, false, Extent);
        }
        if (HitActor != None)
            return false;

        if ( Pawn.Physics == PHYS_Walking )
        {
            HitActor = Trace(HitLocation, HitNormal, Pawn.Location + MINSTRAFEDIST * sideDir - MAXSTEPHEIGHT * vect(0,0,1), Pawn.Location + MINSTRAFEDIST * sideDir, false, Extent);
            if ( HitActor == None )
                return false;
        }
        Destination = Pawn.Location + 2 * MINSTRAFEDIST * sideDir;
        GotoState('TacticalMove', 'DoStrafeMove');
        return true;
    }

    function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
    {
        local float pick;
        local vector sideDir;
        local bool bWasOnGround;

        Super.NotifyTakeHit(InstigatedBy,HitLocation, Damage,DamageType,Momentum);

        bWasOnGround = (Pawn.Physics == PHYS_Walking);
        if ( Pawn.health <= 0 )
            return;
        if ( StrafeFromDamage(damage, damageType, true) )
            return;
        else if ( Enemy != None && bWasOnGround && (MoveTarget == Enemy) &&
                    (Pawn.Physics == PHYS_Falling) ) //weave
        {
            pick = 1.0;
            if ( bStrafeDir )
                pick = -1.0;
            sideDir = Normal( Normal(Enemy.Location - Pawn.Location) Cross vect(0,0,1) );
            sideDir.Z = 0;
            Pawn.Velocity += pick * Pawn.GroundSpeed * 0.7 * sideDir;
            if ( FRand() < 0.2 )
                bStrafeDir = !bStrafeDir;
        }
    }

    event bool NotifyBump(actor Other)
    {
        if ( Enemy != None && Other == Enemy )
        {
            DoRangedAttackOn(Enemy);
            return false;
        }

        return Global.NotifyBump(Other);
    }

    function Timer()
    {
        enable('NotifyBump');
        if ( Enemy != None)
        {
        	Target = Enemy;
        	TimedFireWeaponAtEnemy();
		}
    }

    function EnemyNotVisible()
    {
        WhatToDoNext(15);
    }

    function EndState()
    {
        if ( (Pawn != None) && Pawn.JumpZ > 0 )
            Pawn.bCanJump = true;
    }

Begin:
    if (Pawn.Physics == PHYS_Falling)
    {
		if ( Enemy != None)
		{
        	Focus = Enemy;
        	Destination = Enemy.Location;
		}

        WaitForLanding();
    }
    if ( Enemy == None )
        WhatToDoNext(16);
WaitForAnim:
    if ( Monster(Pawn).bShotAnim )
    {
        Sleep(0.35);
        Goto('WaitForAnim');
    }
    if ( Enemy != None && !FindBestPathToward(Enemy, false,true) )
    {
        GotoState('TacticalMove');
	}
Moving:
    MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
    WhatToDoNext(17);
    if ( bSoaking )
        SoakStop("STUCK IN CHARGING!");
}

state TacticalMove
{
ignores SeePlayer, HearNoise;

    function bool IsStrafing()
    {
        return true;
    }

    function ReceiveWarning(Pawn shooter, float projSpeed, vector FireDir)
    {
        if ( bCanFire && (FRand() < 0.4) )
            return;

        Super.ReceiveWarning(shooter, projSpeed, FireDir);
    }

    function SetFall()
    {
        Pawn.Acceleration = vect(0,0,0);
        Destination = Pawn.Location;
        Global.SetFall();
    }

    function bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (Pawn.Physics == PHYS_Falling)
            return false;
        if ( Enemy == None )
        {
            WhatToDoNext(18);
            return false;
        }
        if ( bChangeDir || (FRand() < 0.5)
            || (((Enemy.Location - Pawn.Location) Dot HitNormal) < 0) )
        {
            Focus = Enemy;
            WhatToDoNext(19);
        }
        else
        {
            bChangeDir = true;
            Destination = Pawn.Location - HitNormal * FRand() * 500;
        }
        return true;
    }

    function Timer()
    {
        enable('NotifyBump');
        Target = Enemy;
        if ( Enemy != None )
        {
			Target = Enemy;
            TimedFireWeaponAtEnemy();
		}
        else
        {
			Target = None;
            SetCombatTimer();
		}
    }

    function EnemyNotVisible()
    {
        StopFiring();
        if ( FastTrace(Enemy.Location, LastSeeingPos) )
            GotoState('TacticalMove','RecoverEnemy');
        else
            WhatToDoNext(20);
        Disable('EnemyNotVisible');
    }

    function PawnIsInPain(PhysicsVolume PainVolume)
    {
        Destination = Pawn.Location - MINSTRAFEDIST * Normal(Pawn.Velocity);
    }

    /* PickDestination()
    Choose a destination for the tactical move, based on aggressiveness and the tactical
    situation. Make sure destination is reachable
    */
    function PickDestination()
    {
        local vector pickdir, enemydir, enemyPart, Y;
        local float strafeSize;

        if ( Pawn == None )
        {
            //warn(self$" Tactical move pick destination with no pawn");
            return;
        }
        bChangeDir = false;
        if ( Pawn.PhysicsVolume.bWaterVolume && !Pawn.bCanSwim && Pawn.bCanFly)
        {
            Destination = Pawn.Location + 75 * (VRand() + vect(0,0,1));
            Destination.Z += 100;
            return;
        }

		if(Enemy != None)
		{
        	enemydir = Normal(Enemy.Location - Pawn.Location);
		}
		else
		{
			return;
		}
        Y = (enemydir Cross vect(0,0,1));
        if ( Pawn.Physics == PHYS_Walking )
        {
            Y.Z = 0;
            enemydir.Z = 0;
        }
        else
            enemydir.Z = FMax(0,enemydir.Z);

        strafeSize = FClamp((2 * FRand() - 0.65),-0.7,0.7);
        strafeSize = FMax(0.4 * FRand() - 0.2,strafeSize);
        enemyPart = enemydir * strafeSize;
        if ( Pawn.bCanFly )
        {
            if ( Pawn.Location.Z - Enemy.Location.Z < 1000 )
                enemyPart = enemyPart + FRand() * vect(0,0,1);
            else
                enemyPart = enemyPart - FRand() * vect(0,0,0.7);
        }
        strafeSize = FMax(0.0, 1 - Abs(strafeSize));
        pickdir = strafeSize * Y;
        if ( bStrafeDir )
            pickdir *= -1;
        bStrafeDir = !bStrafeDir;

        if ( EngageDirection(enemyPart + pickdir, false) )
            return;

        if ( EngageDirection(enemyPart - pickdir,false) )
            return;

        bForcedDirection = true;
        StartTacticalTime = Level.TimeSeconds;
        EngageDirection(EnemyPart + PickDir, true);
    }

    function bool EngageDirection(vector StrafeDir, bool bForced)
    {
        local actor HitActor;
        local vector HitLocation, collspec, MinDest, HitNormal;

        // successfully engage direction if can trace out and down
        MinDest = Pawn.Location + MINSTRAFEDIST * StrafeDir;
        if ( !bForced )
        {
            collSpec = Pawn.GetCollisionExtent();
            collSpec.Z = FMax(6, Pawn.CollisionHeight - Pawn.CollisionRadius);

            HitActor = Trace(HitLocation, HitNormal, MinDest, Pawn.Location, false, collSpec);
            if ( HitActor != None )
                return false;

            if ( Pawn.Physics == PHYS_Walking )
            {
                collSpec.X = FMin(14, 0.5 * Pawn.CollisionRadius);
                collSpec.Y = collSpec.X;
                HitActor = Trace(HitLocation, HitNormal, minDest - (Pawn.CollisionRadius + MAXSTEPHEIGHT) * vect(0,0,1), minDest, false, collSpec);
                if ( HitActor == None )
                {
                    HitNormal = -1 * StrafeDir;
                    return false;
                }
            }
        }
        if(Enemy != None)
        {
        Destination = MinDest + StrafeDir * (0.5 * MINSTRAFEDIST
                                            + FMin(VSize(Enemy.Location - Pawn.Location), MINSTRAFEDIST * (FRand() + FRand())));
		}
		else
		{
			return false;
		}
        return true;
    }

    function BeginState()
    {
        bForcedDirection = false;
        if ( Skill < 4 )
            Pawn.MaxDesiredSpeed = 0.4 + 0.08 * skill;
        MinHitWall += 0.15;
        Pawn.bAvoidLedges = true;
        Pawn.bStopAtLedges = true;
        Pawn.bCanJump = false;
        bAdjustFromWalls = false;
    }

    function EndState()
    {
        bAdjustFromWalls = true;
        if ( Pawn == None )
            return;
        SetMaxDesiredSpeed();
        Pawn.bAvoidLedges = false;
        Pawn.bStopAtLedges = false;
        MinHitWall -= 0.15;
        if (Pawn.JumpZ > 0)
            Pawn.bCanJump = true;
    }

TacticalTick:
    Sleep(0.02);
Begin:
    if (Pawn.Physics == PHYS_Falling)
    {
		if(Enemy != None)
		{
        	Focus = Enemy;
        	Destination = Enemy.Location;
		}

        WaitForLanding();
    }
    PickDestination();

DoMove:
    if ( !Pawn.bCanStrafe )
    {
        StopFiring();
WaitForAnim:
        if ( Monster(Pawn).bShotAnim )
        {
            Sleep(0.5);
            Goto('WaitForAnim');
        }
        MoveTo(Destination);
    }
    else
    {
DoStrafeMove:
        MoveTo(Destination, Enemy);
    }
    if ( bForcedDirection && (Level.TimeSeconds - StartTacticalTime < 0.2) )
    {
        if ( Skill > 2 + 3 * FRand() )
        {
            bMustCharge = true;
            WhatToDoNext(51);
        }
        GoalString = "RangedAttack from failed tactical";
        DoRangedAttackOn(Enemy);
    }
    if ( (Enemy == None) || EnemyVisible() || !FastTrace(Enemy.Location, LastSeeingPos) || Monster(Pawn).PreferMelee() || !Pawn.bCanStrafe )
        Goto('FinishedStrafe');
    //CheckIfShouldCrouch(LastSeeingPos,Enemy.Location, 0.5);

RecoverEnemy:
    GoalString = "Recover Enemy";
    HidingSpot = Pawn.Location;
    StopFiring();
    Sleep(0.1 + 0.2 * FRand());
    Destination = LastSeeingPos + 4 * Pawn.CollisionRadius * Normal(LastSeeingPos - Pawn.Location);
    MoveTo(Destination, Enemy);

    if ( FireWeaponAt(Enemy) )
    {
        Pawn.Acceleration = vect(0,0,0);
        if ( Monster(Pawn).SplashDamage() )
        {
            StopFiring();
            Sleep(0.05);
        }
        else
            Sleep(0.1 + 0.3 * FRand() + 0.06 * (7 - FMin(7,Skill)));
        if ( FRand() > 0.5 )
        {
            Enable('EnemyNotVisible');
            Destination = HidingSpot + 4 * Pawn.CollisionRadius * Normal(HidingSpot - Pawn.Location);
            Goto('DoMove');
        }
    }
FinishedStrafe:
    WhatToDoNext(21);
    if ( bSoaking )
        SoakStop("STUCK IN TACTICAL MOVE!");
}

state Hunting
{
ignores EnemyNotVisible;

    /* MayFall() called by] engine physics if walking and bCanJump, and
        is about to go off a ledge.  Pawn has opportunity (by setting
        bCanJump to false) to avoid fall
    */
    function bool IsHunting()
    {
        return true;
    }

    function MayFall()
    {
        Pawn.bCanJump = ( (MoveTarget == None) || (MoveTarget.Physics != PHYS_Falling) || !MoveTarget.IsA('Pickup') );
    }

    function SeePlayer(Pawn SeenPlayer)
    {
        if ( SeenPlayer == Enemy )
        {
            if ( Level.timeseconds - ChallengeTime > 7 )
            {
                ChallengeTime = Level.TimeSeconds;
                Monster(Pawn).PlayChallengeSound();
            }
            VisibleEnemy = Enemy;
            EnemyVisibilityTime = Level.TimeSeconds;
            bEnemyIsVisible = true;
            Focus = Enemy;
            WhatToDoNext(22);
        }
        else
            Global.SeePlayer(SeenPlayer);
    }

    function Timer()
    {
        SetCombatTimer();
        StopFiring();
    }

    function PickDestination()
    {
        local vector nextSpot, ViewSpot,Dir;
        local float posZ;
        local bool bCanSeeLastSeen;

        // If no enemy, or I should see him but don't, then give up
        if ( (Enemy == None) || (Enemy.Health <= 0) )
        {
            Enemy = None;
            WhatToDoNext(23);
            return;
        }

        if ( Pawn.JumpZ > 0 )
            Pawn.bCanJump = true;

		TryTeleport(Enemy);

        if ( ActorReachable(Enemy) )
        {
            Destination = Enemy.Location;
            MoveTarget = None;
            return;
        }

        ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
        bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

        if ( FindBestPathToward(Enemy, true,true) )
            return;

        if ( bSoaking && (Physics != PHYS_Falling) )
            SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

        MoveTarget = None;
        if ( !bEnemyInfoValid )
        {
            Enemy = None;
            WhatToDoNext(26);
            return;
        }

        Destination = LastSeeingPos;
        bEnemyInfoValid = false;
        if ( FastTrace(Enemy.Location, ViewSpot)
            && VSize(Pawn.Location - Destination) > Pawn.CollisionRadius )
            {
                SeePlayer(Enemy);
                return;
            }

        posZ = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
        nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
        nextSpot.Z = posZ;
        if ( FastTrace(nextSpot, ViewSpot) )
            Destination = nextSpot;
        else if ( bCanSeeLastSeen )
        {
            Dir = Pawn.Location - LastSeenPos;
            Dir.Z = 0;
            if ( VSize(Dir) < Pawn.CollisionRadius )
            {
                GoalString = "Stakeout 3 from hunt";
                GotoState('StakeOut');
                return;
            }
            Destination = LastSeenPos;
        }
        else
        {
            Destination = LastSeenPos;
            if ( !FastTrace(LastSeenPos, ViewSpot) )
            {
                // check if could adjust and see it
                if ( PickWallAdjust(Normal(LastSeenPos - ViewSpot)) || FindViewSpot() )
                {
                    if ( Pawn.Physics == PHYS_Falling )
                        SetFall();
                    else
                        GotoState('Hunting', 'AdjustFromWall');
                }
                else
                {
                    GoalString = "Stakeout 2 from hunt";
                    GotoState('StakeOut');
                    return;
                }
            }
        }
    }

    function bool FindViewSpot()
    {
        local vector X,Y,Z;

        GetAxes(Rotation,X,Y,Z);

        // try left and right

        if ( FastTrace(Enemy.Location, Pawn.Location + 2 * Y * Pawn.CollisionRadius) )
        {
            Destination = Pawn.Location + 2.5 * Y * Pawn.CollisionRadius;
            return true;
        }

        if ( FastTrace(Enemy.Location, Pawn.Location - 2 * Y * Pawn.CollisionRadius) )
        {
            Destination = Pawn.Location - 2.5 * Y * Pawn.CollisionRadius;
            return true;
        }
        if ( FRand() < 0.5 )
            Destination = Pawn.Location - 2.5 * Y * Pawn.CollisionRadius;
        else
            Destination = Pawn.Location - 2.5 * Y * Pawn.CollisionRadius;
        return true;
    }

    function EndState()
    {
        if ( (Pawn != None) && (Pawn.JumpZ > 0) )
            Pawn.bCanJump = true;
    }

AdjustFromWall:
    MoveTo(Destination, MoveTarget);

Begin:
    WaitForLanding();
    if ( CanSee(Enemy) )
        SeePlayer(Enemy);
WaitForAnim:
    if ( Monster(Pawn).bShotAnim )
    {
        Sleep(0.35);
        Goto('WaitForAnim');
    }
    PickDestination();
    if ( Level.timeseconds - ChallengeTime > 10 )
    {
        ChallengeTime = Level.TimeSeconds;
        Monster(Pawn).PlayChallengeSound();
    }

SpecialNavig:
    if (MoveTarget == None)
        MoveTo(Destination);
    else
        MoveToward(MoveTarget,FaceActor(10),,(FRand() < 0.75) && ShouldStrafeTo(MoveTarget));

    WhatToDoNext(27);
    if ( bSoaking )
        SoakStop("STUCK IN HUNTING!");
}

state RangedAttack
{
ignores SeePlayer, HearNoise, Bump;

    function bool Stopped()
    {
        return true;
    }

    function CancelCampFor(Controller C)
    {
        DoTacticalMove();
    }

    function StopFiring()
    {
        Global.StopFiring();
        if ( bHasFired )
        {
            bHasFired = false;
            WhatToDoNext(32);
        }
    }

    function EnemyNotVisible()
    {
        //let attack animation complete
        WhatToDoNext(33);
    }

    function Timer()
    {
        if ( Monster(Pawn).PreferMelee() )
        {
            SetCombatTimer();
            StopFiring();
            WhatToDoNext(34);
        }
        else
            TimedFireWeaponAtEnemy();
    }

    function DoRangedAttackOn(Actor A)
    {
        Target = A;
        GotoState('RangedAttack');
    }

    function BeginState()
    {
        StopStartTime = Level.TimeSeconds;
        bHasFired = false;
        Pawn.Acceleration = vect(0,0,0); //stop
        if ( Target == None )
            Target = Enemy;
        //if ( Target == None )
            //log(GetHumanReadableName()$" no target in ranged attack");
    }

Begin:
    bHasFired = false;
    GoalString = "Ranged attack";
    Sleep(0.0);
    if ( Enemy != None )
    {
        CheckIfShouldCrouch(Pawn.Location,Enemy.Location, 1);
	}

    if(Target != None)
    {
		Focus = Target;

		if ( NeedToTurn(Target.Location) )
		{
			Focus = Target;
			FinishRotation();
		}

	}

    bHasFired = true;

    if(Target != None)
    {
		if (Target == Enemy )
		{
			TimedFireWeaponAtEnemy();
		}
		else
		{
			FireWeaponAt(Target);
		}
	}

    Sleep(0.1);
    if ( Monster(Pawn).PreferMelee() || (Target == None) || (Target != Enemy) || Monster(Pawn).bBoss )
        WhatToDoNext(35);
    if ( Enemy != None )
        CheckIfShouldCrouch(Pawn.Location,Enemy.Location, 1);
    Focus = Target;
    Sleep(FMax(Monster(Pawn).RangedAttackTime(),0.2 + (0.5 + 0.5 * FRand()) * 0.4 * (7 - Skill)));
    WhatToDoNext(36);
    if ( bSoaking )
        SoakStop("STUCK IN RANGEDATTACK!");
}

defaultproperties
{
    StandingOrder="Defend"
    TeleportRange=500.00
    TeleportCooldown=90.00
}
