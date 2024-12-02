class ExperiencePickup extends TournamentPickUp;

var() int Levels;//The amount of levels we want this pickup to grant
var MutLumpysRPG RPGMut;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RPGMut = class'MutLumpysRPG'.static.GetRPGMutator(Level.Game);//This doesnt actually grab the correct RPGMut...
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return MaxDesireability;
}

event float BotDesireability(Pawn Bot)
{
	if (Bot.Controller.bHuntPlayer)
		return 0;
	return MaxDesireability;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.PickupMessage$Default.Levels@"Levels!";
}

auto state Pickup
{
	function Touch(Actor Other)
	{
	        local Pawn P;
	        local RPGStatsInv StatsInv;
					local int i;
					local Mutator m;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
				return;

			if (Other.Level != None && Other.Level.Game != None)
			{
					for (m = Other.Level.Game.BaseMutator; m != None; m = m.NextMutator)
					if (MutLumpysRPG(m) != None)
					{
							RPGMut = MutLumpysRPG(m);
							break;
					}
			}

			for(i=0;i<Levels;i++)
			{
				if(StatsInv.Data.Experience != 0)//Control level so we get 0/x experience till level up.
				{
					StatsInv.DataObject.AddExperienceFraction((StatsInv.DataObject.NeededExp-StatsInv.DataObject.Experience),RPGMut,P.PlayerReplicationInfo);
					RPGMut.CheckLevelUp(StatsInv.DataObject, P.PlayerReplicationInfo);
					continue;
				}
				StatsInv.DataObject.AddExperienceFraction(StatsInv.Data.NeededExp,RPGMut,P.PlayerReplicationInfo);
				RPGMut.CheckLevelUp(StatsInv.DataObject, P.PlayerReplicationInfo);
			}
			AnnouncePickup(P);
			SetRespawn();

		}
	}
}

defaultproperties
{
     Levels=10
     MaxDesireability=0.300000
     RespawnTime=0.1
     PickupMessage="You Got "
     PickupSound=Sound'PickupSounds.AdrenelinPickup'
     PickupForce="AdrenelinPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XPickups_rc.AdrenalinePack'
     Physics=PHYS_Rotating
     DrawScale=0.075000
     AmbientGlow=255
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     CollisionRadius=32.000000
     CollisionHeight=23.000000
     Mass=10.000000
     RotationRate=(Yaw=24000)
}
