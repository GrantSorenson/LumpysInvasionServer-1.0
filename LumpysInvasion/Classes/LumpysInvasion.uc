class LumpysInvasion extends Invasion
  config(LumpysInvasion);

var() int MonsterPlayerMulti;
var() LumpysInvasionWaveHandler WaveHandler;
var() const localized string LumpysInvasionGroup; //new in game menu group
var() config string MonsterConfigMenu; //the ingame monster stats menu
var() config string LumpyWaveConfigMenu;//Ingame wave config menu
var() config string BossConfigMenu;

var() config Object MonsterConfig;
var() config Object WaveConfig;
var() config Object BossConfig;
var() config int Test;

//Settings Variables
const LUMPPROPNUM = 4;
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

    WaveHandler = spawn(class'LumpysInvasionWaveHandler');

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
    local int i,j;
    local float NewMaxMonsters;

    if ( WaveNum > 15 )
    {
        SetupRandomWave();
        return;
    }
    WaveMonsters = 0;
    WaveNumClasses = 0;
    NewMaxMonsters = Waves[WaveNum].WaveMaxMonsters;
    MaxMonsters = NewMaxMonsters;
    WaveEndTime = Level.TimeSeconds + Waves[WaveNum].WaveDuration;
    AdjustedDifficulty = GameDifficulty + Waves[WaveNum].WaveDifficulty;

    j = 1;

    for ( i=0; i<16; i++ )
    {
        if ( (j & Waves[WaveNum].WaveMask) != 0 )
        {
            WaveMonsterClass[WaveNumClasses] = MonsterClass[i];
            WaveNumClasses++;
        }
        j *= 2;
    }
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
        local bool bOneMessage;
        local Bot B;
        local int PlayerCount,count;


        Super(xTeamGame).Timer();
        UpdateGRI();

        if ( bWaveInProgress )
        {
            if ( (WaveEndTime - Level.TimeSeconds < 30) && (MaxMonsters < Waves[WaveNum].WaveMaxMonsters) )
            {
                for ( C = Level.ControllerList; C != None; C = C.NextController )
                    if ( C.bIsPlayer && (C.Pawn != None) )
                        PlayerCount++;
                if ( PlayerCount > 1 )
                    MaxMonsters = Waves[WaveNum].WaveMaxMonsters;
            }
            if ( (Level.TimeSeconds > WaveEndTime) && (WaveMonsters >= 2*MaxMonsters+(default.MonsterPlayerMulti*NumPlayers)) )// more players more monsters longer games more xp
            {//cull monsters after player has killed at least 2*maxmonsters per wave
                // if ( Level.TimeSeconds > WaveEndTime + 90 )
                // {
                //     for ( C = Level.ControllerList; C != None; C = C.NextController )
                //         if ( (MonsterController(C) != None) && (Level.TimeSeconds - MonsterController(C).LastSeenTime > 30)
                //             && !MonsterController(C).Pawn.PlayerCanSeeMe() )
                //         {
                //             C.Pawn.KilledBy( C.Pawn );
                //             return;
                //         }
                // }
                if ( NumMonsters <= 0 )
                {
                    bWaveInProgress = false;
                    WaveCountDown = 15;
                    WaveNum++;
                }
            }
            else if ( (Level.TimeSeconds > NextMonsterTime) && (NumMonsters < MaxMonsters) )
            {
              count = Rand(3);
              switch(count){
                case 1:
                AddMonster();
                case 2:
                AddMonster();
                AddMonster();
                case 3:
                AddMonster();
                AddMonster();
                AddMonster();
                default:
                AddMonster();
              }

                if ( NumMonsters <  20  )
                    NextMonsterTime = Level.TimeSeconds + 1;
                else
                    NextMonsterTime = Level.TimeSeconds + 1;
            }
        }
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
                for ( C = Level.ControllerList; C != None; C = C.NextController )
                    if ( Bot(C) != None )
                    {
                        B = Bot(C);
                        InvasionBot(B).bDamagedMessage = false;
                        B.bInitLifeMessage = false;
                        if ( !bOneMessage && (FRand() < 0.65) )
                        {
                            bOneMessage = true;
                            if ( (B.Squad.SquadLeader != None) && B.Squad.CloseToLeader(C.Pawn) )
                            {
                                B.SendMessage(B.Squad.SquadLeader.PlayerReplicationInfo, 'OTHER', B.GetMessageIndex('INPOSITION'), 20, 'TEAM');
                                B.bInitLifeMessage = false;
                            }
                        }
                    }
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

function NotifyNextWave()
{
   BroadcastLocalizedMessage(class'LumpysInvasionWaveMessage', WaveNum,,,WaveHandler);
}

static function FillPlayInfo(PlayInfo PI)
{
    Super(xTeamGame).FillPlayInfo(PI);
    PI.AddSetting(default.LumpysInvasionGroup, "MonsterConfig", GetDisplayText("MonsterConfig"), 60, 1, "Custom", ";;"$default.MonsterConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup, "WaveConfig", GetDisplayText("WaveConfig"), 60, 2, "Custom", ";;"$default.LumpyWaveConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup, "BossConfig", GetDisplayText("BossConfig"), 60, 3, "Custom", ";;"$default.BossConfigMenu,,,True);
    PI.AddSetting(default.LumpysInvasionGroup,   "Test",  GetDisplayText("Test"), 50,  4,  "Text", "2;0:"$(0),,False,True);

    PI.PopClass();
}

static event string GetDescriptionText(string PropName)
{
    //Super.GetDescriptionText(PropName);

    switch (PropName)
    {
        case "MonsterConfig":       return default.LumpDescText[0];
        case "Test":                return default.LumpDescText[1];
        case "WaveCofig":           return default.LumpDescText[2];
        case "BossConfig":          return default.LumpDescText[3];
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
        case "WaveConfig":      return default.LumpPropText[2];
        case "BossConfig":      return default.LumpPropText[3];
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
    LumpyWaveConfigMenu=""
    BossConfigMenu=""
    MonsterPlayerMulti = 100
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
    FinalWave=13
    LumpPropText(0)="Monster Config"
    LumpPropText(1)="Test"
    LumpPropText(2)="Wave Config"
    LumpPropText(3)="Boss Config"
    LumpDescText(0)="Adjusts the relative intelligence of the invaders"
    LumpDescText(1)="Test Desc"
    LumpDescText(2)="Create new Waves and adjust Wave Settings"
    LumpDescText(3)="Create new Bosses and adjust boss settings"
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
    Waves(0)=(WaveMask=20491,WaveMaxMonsters=20,WaveDuration=30)
    Waves(1)=(WaveMask=60,WaveMaxMonsters=20,WaveDuration=90)
    Waves(2)=(WaveMask=105,WaveMaxMonsters=20,WaveDuration=90)
    Waves(3)=(WaveMask=186,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    Waves(4)=(WaveMask=225,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    Waves(5)=(WaveMask=966,WaveMaxMonsters=20,WaveDuration=90,WaveDifficulty=0.500000)
    Waves(6)=(WaveMask=4771,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    Waves(7)=(WaveMask=917,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    Waves(8)=(WaveMask=1689,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    Waves(9)=(WaveMask=18260,WaveMaxMonsters=25,WaveDuration=120,WaveDifficulty=1.000000)
    Waves(10)=(WaveMask=14340,WaveMaxMonsters=25,WaveDuration=180,WaveDifficulty=1.500000)
    Waves(11)=(WaveMask=4021,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=1.500000)
    Waves(12)=(WaveMask=3729,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=1.500000)
    Waves(13)=(WaveMask=3972,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=2.000000)
    Waves(14)=(WaveMask=3712,WaveMaxMonsters=31,WaveDuration=180,WaveDifficulty=2.000000)
    Waves(15)=(WaveMask=2048,WaveMaxMonsters=35,WaveDuration=255,WaveDifficulty=2.000000)
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
    GameReplicationInfoClass=Class'LumpysInvasion.LumpysInvasionGameReplicationInfo'
    GameName="Lumpys Invasion"
    Description="Along side the other players, you must hold out as long as possible against the waves of attacking monsters."
    ScreenShotName="UT2004Thumbnails.InvasionShots"
    Acronym="LINV"
    GIPropsDisplayText(0)="Monster Skill"
    GIPropDescText(0)="Set the skill of the invading monsters."
}
