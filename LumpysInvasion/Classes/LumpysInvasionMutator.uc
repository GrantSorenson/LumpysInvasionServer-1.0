class LumpysInvasionMutator extends DMMutator hidedropdown CacheExempt;

var() int WaveNameDuration;

replication
{
	reliable if(bNetInitial && Role==Role_Authority)
		WaveNameDuration;
}

simulated function PostBeginPlay()
{

	if(Role == Role_Authority)
	{
		WaveNameDuration = LumpysInvasion(Level.Game).WaveNameDuration;
	}

	SetTimer(0.5,true);
    Super.PostBeginPlay();
}

simulated function Timer()
{
	local IPMonsterReplicationInfo MI;
	local int i;
	local Class<Monster> MonsterClass;
	local string MonsterName;

	foreach DynamicActors(class'IPMonsterReplicationInfo', MI)
	{
		for(i=0;i<MI.GetLength();i++)
		{
			MonsterName = MI.GetMonsterClassName(i);
			if(MonsterName != "None")
			{
				MonsterClass = class<Monster>(DynamicLoadObject(MonsterName,class'class',true));
				if(MonsterClass != None)
				{
					if(MonsterClass.default.Mesh == vertmesh'SkaarjPack_rc.GasbagM')
					{
						MonsterClass.default.WalkAnims[0] = 'Float';
						MonsterClass.default.WalkAnims[1] = 'Float';
						MonsterClass.default.WalkAnims[2] = 'Float';
						MonsterClass.default.WalkAnims[3] = 'Float';
					}
					else if(MonsterClass.default.Mesh == vertmesh'SkaarjPack_rc.Skaarjw')
					{
						MonsterClass.default.DodgeAnims[1] = 'DodgeF';
					}
				}
			}
		}

		class'LumpysInvasionWaveMessage'.default.LifeTime = WaveNameDuration;
		SetTimer(0.0,false);
	}
}
function UpdateMonster(Monster M, int ID)
{
	local int RandValue;
	local int fRandValue;

    //Give enemy custom inv
	// if(M.IsA('SMPNaliCow') )
	// {
	// 	InvClass = class<Inventory>(DynamicLoadObject("InvasionProv1_7.InvasionProNaliCowInv",class'class',true));
	// 	Inv = spawn(InvClass, M,,,);
	// 	Inv.GiveTo(M);
	// }

	if( class'IPMonsterTable'.default.MonsterTable[ID].bRandomHealth )
	{
		RandValue = Max(100,Rand(1000));

		M.Health = RandValue;
		M.HealthMax = RandValue;
	}
	else
	{
		M.Health = class'IPMonsterTable'.default.MonsterTable[ID].NewHealth;
		M.HealthMax = class'IPMonsterTable'.default.MonsterTable[ID].NewMaxHealth;
		Log("M.Health is now: "$class'IPMonsterTable'.default.MonsterTable[ID].NewHealth$" M.HealthMax is now: "$class'IPMonsterTable'.default.MonsterTable[ID].NewMaxHealth,'LumpysInvasion');
	}

	if( class'IPMonsterTable'.default.MonsterTable[ID].bRandomSpeed )
	{
		RandValue = Max(200,Rand(1000));

		M.GroundSpeed = RandValue;
		M.AirSpeed = RandValue;
		M.WaterSpeed = RandValue;
		M.JumpZ = RandValue;
	}
	else
	{
		M.GroundSpeed = class'IPMonsterTable'.default.MonsterTable[ID].NewGroundSpeed;
		M.AirSpeed = class'IPMonsterTable'.default.MonsterTable[ID].NewAirSpeed;
		M.WaterSpeed = class'IPMonsterTable'.default.MonsterTable[ID].NewWaterSpeed;
		M.JumpZ =class'IPMonsterTable'.default.MonsterTable[ID].NewJumpZ;
	}

	if( class'IPMonsterTable'.default.MonsterTable[ID].bRandomSize )
	{
		fRandValue = Rand( (5.0 * 1000) - (0.2 * 1000) ) ;
		fRandValue /= 1000;
		fRandValue += 0.2;

		if(fRandValue < 1)
		{
			fRandValue = 1;
		}
		M.SetLocation( M.Location + vect(0,0,1) * ( M.CollisionHeight * fRandValue) );
		M.SetDrawScale(M.Drawscale * fRandValue);
     	M.SetCollisionSize( M.CollisionRadius * fRandValue, M.CollisionHeight * fRandValue );
     	M.Prepivot.X = M.Prepivot.X * fRandValue;
     	M.Prepivot.Y = M.Prepivot.Y * fRandValue;
     	M.Prepivot.Z = M.Prepivot.Z * fRandValue;
	}
	else
	{
		M.SetLocation( M.Location + vect(0,0,1) * ( M.CollisionHeight * class'IPMonsterTable'.default.MonsterTable[ID].NewDrawScale) );
		M.SetDrawScale(class'IPMonsterTable'.default.MonsterTable[ID].NewDrawScale);
		M.SetCollisionSize(class'IPMonsterTable'.default.MonsterTable[ID].NewCollisionRadius,class'IPMonsterTable'.default.MonsterTable[ID].NewCollisionHeight);
		M.Prepivot = class'IPMonsterTable'.default.MonsterTable[ID].NewPrepivot;
	}

	/*
	M.GibCountCalf *= class'IPMonsterTable'.default.MonsterTable[ID].NewGibMultiplier;
	M.GibCountForearm *= class'IPMonsterTable'.default.MonsterTable[ID].NewGibMultiplier;
	M.GibCountHead *= class'IPMonsterTable'.default.MonsterTable[ID].NewGibMultiplier;
	M.GibCountTorso *= class'IPMonsterTable'.default.MonsterTable[ID].NewGibMultiplier;
	M.GibCountUpperArm *= class'IPMonsterTable'.default.MonsterTable[ID].NewGibMultiplier;
	*/

	M.ScoringValue = class'IPMonsterTable'.default.MonsterTable[ID].NewScoreAward;
}

function float GetGibSize(Monster M)
{
	local int i;
	local string MonsterName;
	local float GibSize;

	GibSize = 1.0;
	MonsterName = "None";

	for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++ )
	{
		if( class'IPMonsterTable'.default.MonsterTable[i].MonsterClassName ~= string(M.Class) )
		{
			MonsterName = class'IPMonsterTable'.default.MonsterTable[i].MonsterName;
			break;
		}
	}
    //BOSS GIBS
	// if(MonsterName != "None")
	// {
	// 	for(i=0;i<class'IPConfigs'.default.Bosses.Length;i++ )
	// 	{
	// 		if( class'IPConfigs'.default.Bosses[i].BossMonsterName ~= MonsterName )
	// 		{
	// 			GibSize = class'IPConfigs'.default.Bosses[i].BossGibSizeMultiplier;
	// 			break;
	// 		}
	// 	}
	// }

	return GibSize;
}

function ModifyMonster(Pawn P, bool bFriendly, bool bBoss)
{
	local class<IPMonsterIDInv> MInv;
	local IPMonsterIDInv NewInv;
	local Inventory Inv;

	if(P != None)
	{
		Inv = P.FindInventoryType(class'IPMonsterIDInv');
		if(Inv != None)
		{
			return;
		}

		MInv = class<IPMonsterIDInv>(DynamicLoadObject("LumpysInvasion.IPMonsterIDInv",class'class',true));

		if(MInv != None)
		{
			NewInv = Spawn(MInv, P,,,);
			if(NewInv != None)
			{
				NewInv.GiveTo(P);
				NewInv.bBoss = bBoss;
				NewInv.bFriendly = bFriendly;
				NewInv.bSummoned = true;
			}
		}
	}
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local int i;
	local FriendlyMonsterController FMC;

    bSuperRelevant = 0;

    if(Controller(Other) != None && Other.iSA('ProxyController'))
    {
		Controller(Other).PlayerReplicationInfo = None;
		Controller(Other).PlayerReplicationInfo = Spawn(Class'IPProxyReplicationInfo',Other,,vect(0.00,0.00,0.00),rot(0,0,0));
	}

    if(Monster(Other) != None)
    {
		ModifyMonster(Monster(Other),false,false);
		//log(Other@Other.Instigator);
		for( i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++ )
		{
			if( class'IPMonsterTable'.default.MonsterTable[i].MonsterClassName ~= string(Other.Class) )
			{
				UpdateMonster(Monster(Other), i);
				break;
			}
		}

		if(GasBag(Other) != None)
		{
			GasBag(Other).AddVelocity(vect(0,0,50));
		}

		if(Other.Instigator != None && Monster(Other.Instigator) != None)
		{
			if(FriendlyMonsterController(Monster(Other.Instigator).Controller) != None && FriendlyMonsterController(Monster(Other.Instigator).Controller).Master != None)
			{
				//friendly monster summoned another monster? give it a friendly controller
				if(Monster(Other).Controller != None)
				{
					Monster(Other).Controller.Destroy();
				}

				FMC = Spawn(class'LumpysInvasion.FriendlyMonsterController');
				if(FMC  != None)
				{
					FMC.Possess(Monster(Other));
					FMC.SetMaster(FriendlyMonsterController(Monster(Other.Instigator).Controller));
					FMC.CreateFriendlyMonsterReplicationInfo();
				}
			}
		}
	}

    if ( Pawn(Other) != None )
    {
        Pawn(Other).bAutoActivate = true;
    }
    else if ( GameObjective(Other) != None )
    {
        Other.bHidden = true;
        GameObjective(Other).bDisabled = true;
        Other.SetCollision(false,false,false);
    }
	else if (GameObject(Other) != None)
	{
		if(CTFFlag(Other) != None)
		{
			Other.bHidden = true;
			Other.SetCollision(false,false,false);
			CTFFlag(Other).bDisabled = true;
		}
		else
		{
			return false;
		}
	}
	else if(xBombDeliveryHole(Other) != None)//it's this that kills players who jump in bombing run holes
	{
		return false;
	}

    return true;
}
//might not work with petcontroller just yet
function Tick(float DeltaTime)
{
	local Actor A;
	local LumpysInvasionFriendlyMonsterReplicationInfo PRI;
	local Inventory Inv;

	foreach DynamicActors(class'Actor',A)
	{
		if(Vehicle(A) != None)
		{
			Vehicle(A).bTeamLocked = false;
			Vehicle(A).bNoFriendlyFire = true;
			Vehicle(A).Team = 0;
		}
		else if(Monster(A) != None && Monster(A).Controller != None && Monster(A).PlayerReplicationInfo != None && LumpysInvasionFriendlyMonsterReplicationInfo(Monster(A).PlayerReplicationInfo) == None)
		{
			PRI = Spawn(class'LumpysInvasionFriendlyMonsterReplicationInfo');
			if(PRI != None)
			{
				PRI.PlayerName = Monster(A).PlayerReplicationInfo.PlayerName;
				PRI.Team = Monster(A).PlayerReplicationInfo.Team;
				PRI.SetPRI();
				Monster(A).PlayerReplicationInfo.Destroy();
				Monster(A).PlayerReplicationInfo = PRI;
				Monster(A).Controller.PlayerReplicationInfo = PRI;
				LumpysInvasion(Level.Game).UpdatePlayerGRI();
				if(LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo) != None)
				{
					LumpysInvasionGameReplicationInfo(Level.Game.GameReplicationInfo).AddFriendlyMonster(Monster(A));
				}
			}

			Inv = Monster(A).FindInventoryType(class'IPMonsterIDInv');

			if(IPMonsterIDInv(Inv) != None)
			{
				IPMonsterIDInv(Inv).bFriendly = true;
			}
		}
	}
}

simulated function Mutate(string MutateString, PlayerController Sender)
{
	if (MutateString ~= "nextwave" && (Level.Netmode == NM_Standalone || Sender.PlayerReplicationInfo.bAdmin))
	{
		LumpysInvasion(Level.Game).ForceNextWave();
		Broadcast("Admin Forcing Next Wave");
	}

	Super.Mutate(MutateString, Sender);
}

function Broadcast(string Message)
{
	local Pawn P;

	foreach DynamicActors(class'Pawn', P)
	{
		if (Monster(P) == None)
		{
			P.ClientMessage(Message);
		}
	}
}


defaultproperties
{
    WaveNameDuration=3
    bAlwaysRelevant=True
    RemoteRole=2
}