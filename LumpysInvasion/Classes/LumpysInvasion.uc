class LumpysInvasion extends Invasion
  config(LumpysInvasion);

var() int MonsterPlayerMulti;
var() LumpysInvasionWaveHandler WaveHandler;
var() const localized string LumpysInvasionGroup; //new in game menu group
var() config string MonsterConfigMenu; //the ingame monster stats menu
var() config string LumpyWaveConfigMenu;//Ingame wave config menu
var() config string BossConfigMenu;

var() config Object MonsterConfig;
var() config Object LWaveConfig;
var() config Object BossConfig;
var() config int Test;

var() int WaveMaxMonsters;
//var() int WaveMonsters; //how many monsters have been spawned on the wave so far
var() int NumKilledMonsters; //how many monsters have died on the wave so far
var() class<Monster> WaveMonsterClass[30];
var() NavigationPoint OldNode;
var() config int MonsterSpawnDistance;
var() config bool bSpawnAtBases;
var() Actor CollisionTestActor;
var() array<NavigationPoint> PlayerStartNavList;  //list of start locations for players
var() array<NavigationPoint> MonsterStartNavList; //list of start locations for monsters
var() config String MonsterStartTag;
var() config String PlayerStartTag;
var() bool bUseMonsterStartTag;
var() bool bUsePlayerStartTag;
var() string CurrentMapPrefix;
var() config string CustomGameTypePrefix;
var() config bool bWaveTimeLimit;
var() config bool bWaveMonsterLimit;





//Settings Variables
const LUMPPROPNUM = 5;
var localized string LumpPropText[LUMPPROPNUM];
var localized string LumpDescText[LUMPPROPNUM];

// struct WaveInfo
// {
//     var() int   WaveMask;   // bit fields for which monsterclasses
//     var() byte  WaveMaxMonsters;
//     var() byte  WaveDuration;
//     var() float WaveDifficulty;
// };
//
// var() config WaveInfo Waves[16];

function UpdateGRI()
{
     LumpysInvasionGameReplicationInfo(GameReplicationInfo).CurrentMonstersNum = NumHostileMonsters();
     LumpysInvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;

}

event InitGame( string Options, out string Error )
{
	if(CustomGameTypePrefix != "" && CustomGameTypePrefix != "None")
	{
		MapPrefix = "DM,BR,CTF,AS,DOM,ONS,VCTF,"$CustomGameTypePrefix;
	}

	//TotalGames++;
    Super(xTeamGame).InitGame(Options, Error);
	bForceRespawn = true;
}

function int NumHostileMonsters()
{
    local Monster M;
    local int i;

    foreach DynamicActors(class'Monster', M)
    {
        if(M != None && M.Health > 0 && M.Controller != None && !M.Controller.isA('FriendlyMonsterController'))
        {
            i++;
        }
    }

    NumMonsters = i;
    return i;
}

function PostBeginPlay()
{
    local int i;

    WaveHandler = spawn(class'LumpysInvasionWaveHandler');

    for(i=0;i<class'IPConfigs'.default.Waves.length;i++)
	{
		WaveHandler.WaveNames[i] = class'IPConfigs'.default.Waves[i].WaveName;
	}

    Super(xTeamGame).PostBeginPlay();

}

event PreBeginPlay()
{
    Super.PreBeginPlay();
    WaveNum = InitialWave;
    LumpysInvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
    LumpysInvasionGameReplicationInfo(GameReplicationInfo).BaseDifficulty = int(GameDifficulty);
    GameReplicationInfo.bNoTeamSkins = true;
    GameReplicationInfo.bForceNoPlayerLights = true;
    GameReplicationInfo.bNoTeamChanges = true;
}

function SetupWave()
{
    local int i,h;
	local class<Monster> CurrentMonsterClass; //current monster class being loaded
	local string FallBackMonsterName; //short hand fallbackmonster, will be made into a full class in order to load

    WaveMonsters = 0;
    WaveNumClasses = 0;
    NumKilledMonsters = 0;

    //Max Monsters and WaveMaxMonster setup
    MaxMonsters = class'IPConfigs'.default.Waves[WaveNum].MaxMonsters;
    WaveMaxMonsters = class'IPConfigs'.default.Waves[WaveNum].WaveMaxMonsters;

    WaveEndTime = Level.TimeSeconds + class'IPConfigs'.default.Waves[WaveNum].WaveDuration;
    AdjustedDifficulty = GameDifficulty + class'IPConfigs'.default.Waves[WaveNum].WaveDifficulty;

    	//set up monster list
	for(i=0;i<30;i++)
	{
		//set to None each time, so we don't add the same monster when we shouldn't
		CurrentMonsterClass = None;

		for(h=0;h<class'IPMonsterTable'.default.MonsterTable.Length;h++)
		{
			//search for matching monster classes
			if(class'IPConfigs'.default.Waves[WaveNum].Monsters[i] != "None" && class'IPConfigs'.default.Waves[WaveNum].Monsters[i] ~= class'IPMonsterTable'.default.MonsterTable[h].MonsterName)
			{
				CurrentMonsterClass = class<Monster>(DynamicLoadObject(class'IPMonsterTable'.default.MonsterTable[h].MonsterClassName, class'Class',true));
			}
		}

		if(CurrentMonsterClass != None)
		{
			WaveMonsterClass[WaveNumClasses] = CurrentMonsterClass;
			WaveNumClasses++;
		}
	}
    //Fallback Monster 
    FallBackMonsterName = class'IPConfigs'.default.Waves[WaveNum].WaveFallbackMonster; //get fall back monster name
	if(FallBackMonsterName != "None")
	{
		for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
		{
			//search for matching fall back monster class
			if(FallBackMonsterName ~= class'IPMonsterTable'.default.MonsterTable[i].MonsterName)
			{
				FallBackMonster = class<Monster>(DynamicLoadObject(class'IPMonsterTable'.default.MonsterTable[i].MonsterClassName, class'Class',true));
			}
		}
	}
	else
	{
		FallBackMonster = default.FallBackMonster;
	}

	//set up current boss information
	// if(class'InvasionProConfigs'.default.Waves[WaveNum].bBossWave)//is this a boss wave
	// {
	// 	BossTimeLimit = class'InvasionProConfigs'.default.Waves[WaveNum].BossTimeLimit;
	// 	bInfiniteBossTime = (BossTimeLimit <= 0);
	// 	InvasionProGameReplicationInfo(GameReplicationInfo).bInfiniteBossTime = bInfiniteBossTime;
	// 	OverTimeDamage = class'InvasionProConfigs'.default.Waves[WaveNum].BossOverTimeDamage;
	// 	bBossWave = true;
	// 	SetUpBosses();
	// }
}

function SetupRandomWave()
{
    local int i,j, Mask;
    local float NewMaxMonsters;

    NewMaxMonsters = 15;
    if ( NumPlayers > 4 )
        NewMaxMonsters *= FMin(NumPlayers/4,2);
    else
        NewMaxMonsters = NewMaxMonsters * (FMin(GameDifficulty,7) + 3)/10;
    MaxMonsters = NewMaxMonsters + 1;
    WaveEndTime = Level.TimeSeconds + 180;
    AdjustedDifficulty = GameDifficulty + 3;
    GameDifficulty += 0.5;

    WaveNumClasses = 0;
    Mask = 2048 + Rand(2047);
    j = 1;

    for ( i=0; i<16; i++ )
    {
        if ( (j & Mask) != 0 )
        {
            WaveMonsterClass[WaveNumClasses] = MonsterClass[i];
            WaveNumClasses++;
        }
        j *= 2;
    }
}

State MatchInProgress
{
    function Timer()
    {
        local Controller C;
        local int PlayerCount,count;


        Super(xTeamGame).Timer();
        UpdateGRI();

        Log("Wave Max Monsters:"$WaveMaxMonsters$", WaveMonsters:"$WaveMonsters,'LumpysInvasion');

        if ( bWaveInProgress )
        {
            if(!ShouldAdvanceWave())
            {
                if(ShouldSpawnAnotherMonster() && Level.TimeSeconds > NextMonsterTime)
                {
                    AddMonster();
                    UpdateMonsterTimer();
                }
            }
            else
            {
                if(NumHostileMonsters() <= 0)
                {
                    bWaveInProgress = false;
                    WaveCountDown = 15;
                    WaveNum++;
                }
            }

            //else if ( (Level.TimeSeconds > NextMonsterTime) && (NumMonsters < MaxMonsters) )
            // else
            // {
            // //   count = Rand(3);
            // //   switch(count){
            // //     case 1:
            // //     AddMonster();
            // //     case 2:
            // //     AddMonster();
            // //     AddMonster();
            // //     case 3:
            // //     AddMonster();
            // //     AddMonster();
            // //     AddMonster();
            // //     default:
            //     AddMonster();
            //   }

            // if ( NumMonsters <  20  )
            //     NextMonsterTime = Level.TimeSeconds + 1;
            // else
            //     NextMonsterTime = Level.TimeSeconds + 1;
        }
        //}
        else if ( NumMonsters <= 0 )
        {
            if ( WaveNum == FinalWave )
            {
                EndGame(None,"TimeLimit");
                return;
            }
            WaveCountDown--;
            if ( WaveCountDown == 14 )
            {
                LumpysInvasionGameReplicationInfo(GameReplicationInfo).WaveDrawColour = class'IPConfigs'.default.Waves[WaveNum].WaveDrawColour;
                WaveHandler.WaveColor = class'IPConfigs'.default.Waves[WaveNum].WaveDrawColour;
                for ( C = Level.ControllerList; C != None; C = C.NextController )
                {
                    if ( C.PlayerReplicationInfo != None )
                    {
                        C.PlayerReplicationInfo.bOutOfLives = false;
                        C.PlayerReplicationInfo.NumLives = 0;
                        if ( C.Pawn != None )
                            ReplenishWeapons(C.Pawn);
                        else if ( !C.PlayerReplicationInfo.bOnlySpectator && (PlayerController(C) != None) )
                            C.GotoState('PlayerWaiting');
                    }
                }
            }
            if ( WaveCountDown == 13 )
            {
                LumpysInvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
                for ( C = Level.ControllerList; C != None; C = C.NextController )
                {
                    if ( PlayerController(C) != None )
                    {
                        PlayerController(C).PlayStatusAnnouncement('Next_wave_in',1,true);
                        if ( (C.Pawn == None) && !C.PlayerReplicationInfo.bOnlySpectator )
                            PlayerController(C).SetViewTarget(C);
                    }
                    if ( C.PlayerReplicationInfo != None )
                    {
                        C.PlayerReplicationInfo.bOutOfLives = false;
                        C.PlayerReplicationInfo.NumLives = 0;
                        if ( (C.Pawn == None) && !C.PlayerReplicationInfo.bOnlySpectator )
                            C.ServerReStartPlayer();
                    }
                }
            }
            else if ( (WaveCountDown > 1) && (WaveCountDown < 12) )
                BroadcastLocalizedMessage(class'TimerMessage', WaveCountDown-1);
            else if ( WaveCountDown <= 1 )
            {
                bWaveInProgress = true;
                NotifyNextWave();
                SetupWave();
                for ( C = Level.ControllerList; C != None; C = C.NextController )
                    if ( PlayerController(C) != None )
                        PlayerController(C).LastPlaySpeech = 0;
            }
        }
    }


    function BeginState()
    {
        Super.BeginState();
        WaveNum = InitialWave;
        LumpysInvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
    }
}

function bool ShouldAdvanceWave()
{
	// if(bBossWave)
	// {
	// 	return ShouldEndBossWave();
	// }
        Log("Wave End Time: "$WaveEndTime$" bWaveMonsterLimit: "$bWaveMonsterLimit,'LumpysInvasion');
	if(bWaveTimeLimit && Level.TimeSeconds > WaveEndTime)
	{
        Log("Wave End Time: "$WaveEndTime,'LumpysInvasion');
		return true;
	}

	if(bWaveMonsterLimit && WaveMonsters >= WaveMaxMonsters )//&& NumHostileMonsters() <= 0)
	{
		return true;
	}

	return false;
}

function bool ShouldSpawnAnotherMonster()
{
	if(bWaveTimeLimit && Level.TimeSeconds > WaveEndTime)
	{
		return false;
	}

	if(bWaveMonsterLimit && WaveMonsters >= WaveMaxMonsters)
	{
		return false;
	}

	if(NumHostileMonsters() < MaxMonsters)
	{
		return true;
	}

	return false;
}

function UpdateMonsterTimer()
{
	if ( NumHostileMonsters() < (1.5 * GetNumPlayers() ) )
	{
		NextMonsterTime = Level.TimeSeconds + 0.2;
	}
	else
	{
		NextMonsterTime = Level.TimeSeconds + 2;
	}
}

function AddMonster()
{
    local NavigationPoint StartSpot; //spawn location
    local Monster NewMonster; //the newly spawned monster
    local class<Monster> NewMonsterClass; //current monster to spawn

    log("We Should have Added A Monster",'LumpysInvasion');
	//if(!bBossWave)
	//{
		NewMonsterClass = WaveMonsterClass[Rand(WaveNumClasses)];
		if(NewMonsterClass != None)
		{
		    StartSpot = FindPlayerStart(None,0, string(NewMonsterClass));
			//if can't find a playerstart then stop.
			if ( StartSpot == None )
			{
				log("Cannot find valid Navigation Point to spawn Monster",'InvasionPro');
				return;
			}

			NewMonster = Spawn(NewMonsterClass,,,StartSpot.Location+(NewMonsterClass.Default.CollisionHeight - StartSpot.CollisionHeight) * vect(0,0,1),StartSpot.Rotation);
		}

		if ( NewMonster ==  None )
		{
			StartSpot = FindPlayerStart(None,0, string(FallBackMonster));
			//else spawn the fall back using an average monsters size specifications
			NewMonster = Spawn(FallBackMonster,,,StartSpot.Location+(FallBackMonster.Default.CollisionHeight - StartSpot.CollisionHeight) * vect(0,0,1),StartSpot.Rotation);
		}

		if ( NewMonster != None )
		{
			//TotalSpawned++;
			WaveMonsters++;
			//UpdateMonsterTypeStats(NewMonster.Class, 1, 0, 0);
			//InvasionProMutator(BaseMutator).ModifyMonster(NewMonster,false,false);
			// Inv = NewMonster.FindInventoryType(class'InvasionProMonsterIDInv');
			// if(InvasionProMonsterIDInv(Inv) != None)
			// {
			// 	InvasionProMonsterIDInv(Inv).bSummoned = false;
			// 	InvasionProMonsterIDInv(Inv).bBoss = false;
			// 	InvasionProMonsterIDInv(Inv).bFriendly = false;
			// }
		}

        NumHostileMonsters();
}

//over writing all inTeam and settings 1 for players and 0 for monsters
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string IncomingName )
{
    local NavigationPoint N, BestStart;
    local float BestRating, NewRating;

      // always pick StartSpot at start of match
    if ( (Player != None) && (Player.StartSpot != None) && (Level.NetMode == NM_Standalone)
        && (bWaitingToStartMatch || ((Player.PlayerReplicationInfo != None) && Player.PlayerReplicationInfo.bWaitingPlayer))  )
    {
        return Player.StartSpot;
    }

    //first assign correct team
	if( (Player != None && Player.PlayerReplicationInfo != None) || bWaitingToStartMatch || IncomingName ~= "Friendly") //should catch most players and possible friendly monsters
	{
		//players
		InTeam = 1;
	}
	else //monsters
	{
		InTeam = 0;
	}

	//just let game rules overwrite if they wish
    if ( GameRulesModifiers != None )
    {
        BestStart = GameRulesModifiers.FindPlayerStart(Player,InTeam,IncomingName);
        if(BestStart != None)
        {
			return BestStart;
		}
    }

	//best place to teleport stuck monsters to
    if(IncomingName ~= "Stuck")
    {
		if(Player != None && Player.Pawn != None)
		{
			IncomingName = string(Player.Pawn.Class);
		}

		BestStart = GetCollisionPlayerStart(Player,inTeam, IncomingName,2);
	}

	 // start for monsters
	if( BestStart == None && InTeam == 0 && MonsterStartNavList.Length > 0)
	{
		if(Player != None && Player.Pawn != None && (IncomingName ~= "" || IncomingName ~= "None") )
		{
			IncomingName = string(Player.Pawn.Class);
		}

		//if start tags found use them, else if spawn at bases and base is found use it
		if( bUseMonsterStartTag || bSpawnAtBases && LevelIsTeamMap())
		{
			BestStart = GetCollisionPlayerStart(Player,inTeam, IncomingName,1);
		}
	}

	//start for players
	if( BestStart == None && InTeam == 1 && PlayerStartNavList.Length > 0)
	{
		BestStart = GetPlayerStart(Player, InTeam, IncomingName);
	}

	if(BestStart == None)
	{
		//fallback to default spawning
		BestStart = Super.FindPlayerStart(Player,InTeam,IncomingName);
	}
	//no team spawn point found
    if ( BestStart == None)
    {
        BestRating = -100000000;
        foreach AllActors( class 'NavigationPoint', N )
        {
			if(Door(N) == None && Teleporter(N) == None && N.Region.Zone.LocationName != "In space")
			{
				NewRating = RatePlayerStart(N,0,Player);
				if ( InventorySpot(N) != None )
					NewRating -= 50;
				NewRating += 20 * FRand();
				if ( NewRating > BestRating )
				{
					BestRating = NewRating;
					BestStart = N;
				}
			}
        }
    }

    return BestStart;
}

function NavigationPoint GetPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName, optional int Switch)
{
	local int i, TempNodeCounter;
	local array<NavigationPoint> TempNodes;
	local Actor A;
	local float BestDist, Dist;
	local Monster M;
	local NavigationPoint BestStart;

	TempNodeCounter = 0;
	BestDist = 0;
	TempNodes.Remove(0, TempNodes.Length);

	for(i=0;i<PlayerStartNavList.Length;i++)
	{
		PlayerStartNavList[i].Taken = false;

		foreach VisibleCollidingActors( class'Actor', A, 100, PlayerStartNavList[i].Location, false)
		{
			PlayerStartNavList[i].Taken = true;
		}
	}

	for(i=0;i<PlayerStartNavList.Length;i++)
	{
		if(!PlayerStartNavList[i].Taken)
		{
			TempNodes.Insert(TempNodeCounter,1);
			TempNodes[TempNodeCounter] = PlayerStartNavList[i];
			TempNodeCounter++;

			foreach DynamicActors(class'Monster',M)
			{
				if( M != None && M.Health > 0 )
				{
					Dist = VSize ( PlayerStartNavList[i].Location - M.Location );
					if(Dist > BestDist)
					{
						BestDist = Dist;
						BestStart = PlayerStartNavList[i];
					}
				}
			}
		}
	}

	if(BestStart == None)
	{
		BestStart = TempNodes[Rand(TempNodes.Length)];
	}

	return BestStart;
}


function bool LevelIsTeamMap()
{
	local array<string> CurrentLevelPrefix;

	CurrentLevelPrefix.Remove(0, CurrentLevelPrefix.Length);
	Split(string(Level), "-", CurrentLevelPrefix);
	if(CurrentLevelPrefix[0] != "" && CurrentLevelPrefix[0] != "None")
	{
		CurrentMapPrefix = CurrentLevelPrefix[0];
		if( CurrentMapPrefix ~= "ONS" || CurrentMapPrefix ~= "CTF" || CurrentMapPrefix ~= "DOM" || CurrentMapPrefix ~= "BR" || CurrentMapPrefix ~= "VCTF" || CurrentMapPrefix ~= CustomGameTypePrefix)
		{
			return true;
		}
	}

	return false;
}


//for monsters only so far/blue team
function NavigationPoint GetCollisionPlayerStart(Controller Player, byte inTeam, string IncomingName, int Switch)
{
	local array<NavigationPoint> MonsterSpawnLocs;
	local NavigationPoint BestStart;
	local int i, Counter;
	local class<Actor> A;
	local NavigationPoint N;
	local float BestRating, NodeRating;

	BestStart = None;
	MonsterSpawnLocs.Remove(0, MonsterSpawnLocs.Length);
	if(InTeam == 0 && CollisionTestActor != None && IncomingName != "" && IncomingName != "None")
	{
		A = Class<Actor>(DynamicLoadObject(IncomingName,class'class',true));
		if(A != None)
		{
			Counter = 0;
			CollisionTestActor.SetCollisionSize(A.default.CollisionRadius,A.default.CollisionHeight);
			CollisionTestActor.SetCollision(true,true,true);
			if(Switch == 0)
			{
				for ( N=Level.NavigationPointList; N != None; N=N.NextNavigationPoint )
				{
					if(Door(N) == None && FlyingPathNode(N) == None && N.Region.Zone.LocationName != "In space")
					{
						if(CollisionTestActor.SetLocation(N.Location+(A.default.CollisionHeight - N.CollisionHeight) * vect(0,0,1)) )
						{
							MonsterSpawnLocs.Insert(Counter,1);
							MonsterSpawnLocs[Counter] = N;
							Counter++;
						}
					}
				}
			}
			else if(Switch == 1)
			{
				for(i=0;i<MonsterStartNavList.Length;i++)
				{
					if(MonsterStartNavList[i] != None && CollisionTestActor.SetLocation(MonsterStartNavList[i].Location+(A.default.CollisionHeight - MonsterStartNavList[i].CollisionHeight) * vect(0,0,1)) )
					{
						MonsterSpawnLocs.Insert(Counter,1);
						MonsterSpawnLocs[Counter] = MonsterStartNavList[i];
						Counter++;
					}
				}
			}
			else if(Switch == 2)
			{
				for ( N=Level.NavigationPointList; N != None; N=N.NextNavigationPoint )
				{
					if(Door(N) == None && FlyingPathNode(N) == None && N.Region.Zone.LocationName != "In space" && PlayerCanReallySeeMe(N))
					{
						if(CollisionTestActor.SetLocation(N.Location+(A.default.CollisionHeight - N.CollisionHeight) * vect(0,0,1)) )
						{
							MonsterSpawnLocs.Insert(Counter,1);
							MonsterSpawnLocs[Counter] = N;
							Counter++;
						}
					}
				}
			}
		}
	}

	CollisionTestActor.SetCollision(false,false,false);

	if(MonsterSpawnLocs.Length > 0)
	{
		BestRating = 0;
		for(i=0;i<MonsterSpawnLocs.Length;i++)
		{
			NodeRating = GetMonsterStartRating(MonsterSpawnLocs[i]);
			if(NodeRating > BestRating)
			{
				BestRating = NodeRating;
				BestStart = MonsterSpawnLocs[i];
			}
		}
	}

	OldNode = BestStart;
	return BestStart;
}

function float GetMonsterStartRating(NavigationPoint NP)
{
	local float NodeRating;
	local Controller C;
	local float Dist, BestDist;

	NodeRating = 0;

	if(OldNode != None)
	{
		if(NP == OldNode)
		{
			return 0;
		}

		NodeRating = VSize(OldNode.Location - NP.Location);
	}
	else
	{
		NodeRating = 1000;
	}

	BestDist = 999999;
	Dist = 0;

	for ( C = Level.ControllerList; C!=None; C=C.NextController )
	{
		if ( C.Pawn != None && C.PlayerReplicationInfo != None)
		{
			if(!FastTrace(C.Pawn.Location + C.Pawn.BaseEyeHeight*Vect(0,0,0.5),NP.Location))
			{
				Dist = VSize(C.Pawn.Location - NP.Location);
				if(Dist < BestDist && Dist < MonsterSpawnDistance)
				{
					BestDist = Dist;
				}
			}
			else
			{
				NodeRating = 0;
				break;
			}
		}
	}

	//if closest player is further than spawn distance decline this node
	if(!bSpawnAtBases && BestDist > MonsterSpawnDistance)
	{
		NodeRating = 0;
	}

	return NodeRating;
}

function bool PlayerCanReallySeeMe(Actor A)
{
	local Controller C;
	local bool Result;

	Result = false;

	for ( C = Level.ControllerList; C!=None; C=C.NextController )
	{
		if(MonsterController(C) == None && C.Pawn != None && FastTrace( A.Location, C.Pawn.Location ))
		{
			Result = true;
		}
	}

	return Result;
}


function NotifyNextWave()
{
   BroadcastLocalizedMessage(class'LumpysInvasionWaveMessage', WaveNum,,,WaveHandler);
}

static function FillPlayInfo(PlayInfo PI)
{
    Super(xTeamGame).FillPlayInfo(PI);
    PI.AddSetting(default.LumpysInvasionGroup, "MonsterConfig", GetDisplayText("MonsterConfig"), 60, 1, "Custom", ";;"$default.MonsterConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup, "LWaveConfig", GetDisplayText("LWaveConfig"), 60, 2, "Custom", ";;"$default.LumpyWaveConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup, "BossConfig", GetDisplayText("BossConfig"), 60, 3, "Custom", ";;"$default.BossConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup,   "Test",  GetDisplayText("Test"), 50,  4,  "Text", "2;0:"$(0),,False,True);
    PI.AddSetting(default.LumpysInvasionGroup,   "InitialWave",  GetDisplayText("InitialWave"), 50,  5,  "Text", "2;0:"$(ArrayCount(default.Waves)-1),,False,True);
    PI.AddSetting(default.LumpysInvasionGroup ,"bWaveMonsterLimit","Monster Limit Ends Waves", 0, 6, "Check",,,False,True);
	PI.AddSetting(default.LumpysInvasionGroup ,"bWaveTimeLimit","Time Limit Ends Waves", 0, 7, "Check",,,False,True);

    PI.PopClass();
}

static event string GetDescriptionText(string PropName)
{
    //Super.GetDescriptionText(PropName);

    switch (PropName)
    {
        case "MonsterConfig":       return default.LumpDescText[0];
        case "Test":                return default.LumpDescText[1];
        case "LWaveCofig":          return default.LumpDescText[2];
        case "BossConfig":          return default.LumpDescText[3];
        case "InitialWave":         return default.LumpDescText[4];
        case "bWaveMonsterLimit":   return "If checked the monster limit ends the wave.";
        case "bWaveTimeLimit":      return "If checked, the wave duration ends the wave.";


    }

    return Super(xTeamGame).GetDescriptionText(PropName);
}

static event string GetDisplayText( string PropName )
{
    //Super.GetDisplayText(PropName);

    switch (PropName)
    {
        case "MonsterConfig":   return default.LumpPropText[0];
        case "Test":            return default.LumpPropText[1];
        case "LWaveConfig":     return default.LumpPropText[2];
        case "BossConfig":      return default.LumpPropText[3];
        case "InitialWave":     return default.LumpPropText[4];
        }

    return Super(xTeamGame).GetDisplayText( PropName );
}

static event bool AcceptPlayInfoProperty(string PropName)
{
	if ( (PropName == "bBalanceTeams") || (PropName == "bPlayersBalanceTeams") || (PropName == "GoalScore") || (PropName == "TimeLimit") || (PropName == "SpawnProtectionTime") ||(PropName == "EndTimeDelay") )
	{
		return false;
	}

    return Super(xTeamGame).AcceptPlayInfoProperty(PropName);
}


defaultproperties
{
    LumpysInvasionGroup="Lumpys Invasion"
    MonsterConfigMenu="LumpysInvasion.IPMonsterConfig"
    LumpyWaveConfigMenu="LumpysInvasion.IPWaveConfig"
    BossConfigMenu=""
    MonsterPlayerMulti = 100
    MonsterSpawnDistance=10000
    bWaveTimeLimit=True
    bWaveMonsterLimit=True
    MonsterClass(0)=Class'SkaarjPack.SkaarjPupae'
    MonsterClass(1)=Class'SkaarjPack.Razorfly'
    MonsterClass(2)=Class'SkaarjPack.Manta'
    MonsterClass(3)=Class'SkaarjPack.Krall'
    MonsterClass(4)=Class'SkaarjPack.EliteKrall'
    MonsterClass(5)=Class'SkaarjPack.Gasbag'
    MonsterClass(6)=Class'SkaarjPack.Brute'
    MonsterClass(7)=Class'SkaarjPack.Skaarj'
    MonsterClass(8)=Class'SkaarjPack.Behemoth'
    MonsterClass(9)=Class'SkaarjPack.IceSkaarj'
    MonsterClass(10)=Class'SkaarjPack.FireSkaarj'
    MonsterClass(11)=Class'SkaarjPack.WarLord'
    MonsterClass(12)=Class'SkaarjPack.SkaarjPupae'
    MonsterClass(13)=Class'SkaarjPack.SkaarjPupae'
    MonsterClass(14)=Class'SkaarjPack.Razorfly'
    MonsterClass(15)=Class'SkaarjPack.Razorfly'
    FallbackMonsterClass="SkaarjPack.EliteKrall"
    FinalWave=21
    LumpPropText(0)="Monster Config"
    LumpPropText(1)="Test"
    LumpPropText(2)="Wave Config"
    LumpPropText(3)="Boss Config"
    LumpPropText(4)="Starting Wave"
    LumpDescText(0)="Adjusts the relative intelligence of the invaders"
    LumpDescText(1)="Test Desc"
    LumpDescText(2)="Create new Waves and adjust Wave Settings"
    LumpDescText(3)="Create new Bosses and adjust boss settings"
    LumpDescText(4)="The starting wave number, should be 0"
    WaveCountDown=15
    InvasionBotNames(1)="Gorge"
    InvasionBotNames(2)="Cannonball"
    InvasionBotNames(3)="Annika"
    InvasionBotNames(4)="Riker"
    InvasionBotNames(5)="BlackJack"
    InvasionBotNames(6)="Sapphire"
    InvasionBotNames(7)="Jakob"
    InvasionBotNames(8)="Othello"
    InvasionEnd(0)="SKAARJtermination"
    InvasionEnd(1)="SKAARJslaughter"
    InvasionEnd(2)="SKAARJextermination"
    InvasionEnd(3)="SKAARJerradication"
    InvasionEnd(4)="SKAARJbloodbath"
    InvasionEnd(5)="SKAARJannihilation"
    // Waves(0)=(WaveMask=20491,WaveMaxMonsters=20,WaveDuration=30)
    // Waves(1)=(WaveMask=60,WaveMaxMonsters=20,WaveDuration=90)
    // Waves(2)=(WaveMask=105,WaveMaxMonsters=20,WaveDuration=90)
    // Waves(3)=(WaveMask=186,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    // Waves(4)=(WaveMask=225,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    // Waves(5)=(WaveMask=966,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    // Waves(6)=(WaveMask=4771,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    // Waves(7)=(WaveMask=917,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    // Waves(8)=(WaveMask=1689,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    // Waves(9)=(WaveMask=18260,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    // Waves(10)=(WaveMask=14340,WaveMaxMonsters=25,WaveDuration=180,WaveDifficulty=1.500000)
    // Waves(11)=(WaveMask=4021,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=1.500000)
    // Waves(12)=(WaveMask=3729,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=1.500000)
    // Waves(13)=(WaveMask=3972,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=2.000000)
    // Waves(14)=(WaveMask=3712,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=2.000000)
    // Waves(15)=(WaveMask=2048,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=2.000000)
    TeamAIType(0)=Class'SkaarjPack.InvasionTeamAI'
    TeamAIType(1)=Class'SkaarjPack.InvasionTeamAI'
    bAllowTrans=True
    bForceNoPlayerLights=True
    DefaultMaxLives=1
    InitialBots=2
    EndGameSoundName(0)="You_Have_Won_the_Match"
    EndGameSoundName(1)="You_Have_Lost_the_Match"
    LoginMenuClass="GUI2K4.UT2K4InvasionLoginMenu"
    SPBotDesc="Specify the number of bots (max 2 for invasion) that should join."
    ScoreBoardType="Skaarjpack.ScoreboardInvasion"
    HUDType="LumpysInvasion.LumpysInvasionHUD"
    MapListType="LumpysInvasion.MapListLumpysInvasion"
    GoalScore=60
    MaxLives=1
    DeathMessageClass=Class'SkaarjPack.InvasionDeathMessage'
    MutatorClass="LumpysInvasion.LumpysInvasionMutator"
    GameReplicationInfoClass=Class'LumpysInvasionGameReplicationInfo'
    GameName="Lumpys Invasion"
    Description="Along side the other players, you must hold out as long as possible against the waves of attacking monsters."
    ScreenShotName="UT2004Thumbnails.InvasionShots"
    Acronym="LINV"
    GIPropsDisplayText(0)="Monster Skill"
    GIPropDescText(0)="Set the skill of the invading monsters."
}
