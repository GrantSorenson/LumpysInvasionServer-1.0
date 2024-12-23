//================================================
//keeps track of monster controller, assigns targets, handles teleporting
//================================================
class IPMonsterIDInv extends Inventory;

var() int MonsterHealth;
var() int MonsterHealthMax;
var() int NewMonsterHealthMax;
var() Monster MyMonster;
var() bool bBoss;
var() int VisibleEnemyTimer;
var() float LastVisibleEnemyTime;
var() bool bFriendly;
var() string MonsterName;
var() bool bSummoned;
var() int AuraID;
//var() int MyIdNum;

replication
{
    reliable if(Role==ROLE_Authority)
        MyMonster, bBoss, bFriendly, MonsterHealth, MonsterHealthMax, MonsterName, bSummoned, AuraID;
}

function Destroyed()
{
	// if(bBoss)
	// {
	// 	LumpysInvasion(Level.Game).BossKilled();
	// }

	Super.Destroyed();
}

function PostBeginPlay()
{
	SetTimer(0.25, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if( Monster(Other) != None)
	{
		MyMonster = Monster(Other);
		Super.GiveTo(Other);
	}
}

function Timer()
{
	local NavigationPoint N;

	if(MyMonster != None)
	{
		MonsterHealth = MyMonster.Health;
		MonsterHealthMax = MyMonster.HealthMax;
		if(MonsterHealth > MyMonster.HealthMax)
		{
			NewMonsterHealthMax = MonsterHealth;
		}

		if(NewMonsterHealthMax > 0)
		{
			MonsterHealthMax = NewMonsterHealthMax;
		}

		if(bBoss)
		{
			if(MyMonster.Health <= 0)
			{
				Destroy();
				SetTimer(0.0,false);
				return;
			}
		}

		if(MyMonster.Controller != None && !MyMonster.Controller.IsA('FriendlyMonsterController'))
		{
			if(MyMonster.Controller.Target != None)
			{
				if(!MyMonster.Controller.LineOfSightTo(MyMonster.Controller.Target))
				{
					VisibleEnemyTimer++;
				}
				else
				{
					VisibleEnemyTimer = 0;
				}

				if(!LumpysInvasion(Level.Game).ShouldMonsterAttack(MyMonster.Controller.Target, MyMonster.Controller) )
				{
					MyMonster.Controller.Target = LumpysInvasion(Level.Game).GetMonsterTarget();
				}
			}
			else if(LumpysInvasion(Level.Game).CheckMaxLives(None))
			{
				MyMonster.Controller.Target = LumpysInvasion(Level.Game).GetMonsterTarget();
			}

			if(VisibleEnemyTimer >= 90) //if havnt seen enemy for 45 seconds then attempt to teleport near enemy
			{
				N = Level.Game.FindPlayerStart(MyMonster.Controller,0,"Stuck");
				if(N != None)
				{
					if(MyMonster.SetLocation(N.Location+(MyMonster.CollisionHeight - N.CollisionHeight) * vect(0,0,1)))
					{
						VisibleEnemyTimer = 0;
					}
				}
			}
		}

		if(LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo) != None)
		{
			bBoss = false;
			bFriendly = true;
			LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo).MonsterHealth = MyMonster.Health;
			LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo).MonsterHealthMax = MyMonster.SuperHealthMax;
			LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo).MyMonster = MyMonster;
			LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo).UpdatePRI();
			MonsterName = LumpysInvasionFriendlyMonsterReplicationInfo(MyMonster.PlayerReplicationInfo).PlayerName;
		}
		else
		{
			if(!bBoss)
			{
				bFriendly = false;
				MonsterName = "";
			}
		}

		MyMonster.bBoss = bBoss;
	}
}

defaultproperties
{
    ItemName="MonsterTag"
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bReplicateInstigator=True
}
