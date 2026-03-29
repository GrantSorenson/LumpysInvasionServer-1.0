class ExperiencePickup extends TournamentPickUp;

var() int Levels;//The amount of levels we want this pickup to grant
var MutLumpysRPG RPGMut;
var RPGPlayerDataObject PendingDataObject; // held for deferred SaveConfig after level-up

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

// Fires 0.5s after a pickup to write player data to disk outside the pickup frame.
function Timer()
{
	if (PendingDataObject != None)
	{
		PendingDataObject.SaveConfig();
		PendingDataObject = None;
	}
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
		local Mutator m;
		local int i, levelsLeft, totalXP, simulLevel;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
				return;

			for (m = Other.Level.Game.BaseMutator; m != None; m = m.NextMutator)
			{
				RPGMut = MutLumpysRPG(m);
				if (RPGMut != None)
					break;
			}
			if (RPGMut == None)
				return;

			// Compute the exact XP needed for Levels level-ups from the player's
			// current position, then add it all at once and call CheckLevelUp once.
			// The old approach called CheckLevelUp (and SaveConfig) up to 20 times
			// in a single frame — once inside AddExperienceFraction and once
			// explicitly per loop iteration — causing a visible lag spike.
			levelsLeft  = Levels;
			simulLevel  = StatsInv.DataObject.Level;

			// If the player is mid-level, account for the partial level first.
			if (StatsInv.DataObject.Experience > 0)
			{
				totalXP    += StatsInv.DataObject.NeededExp - StatsInv.DataObject.Experience;
				simulLevel++;
				levelsLeft--;
			}

			// Look up the XP requirement for each subsequent level and sum them.
			// GetNeededXP is a config array lookup — negligible cost.
			for (i = 0; i < levelsLeft; i++)
				totalXP += RPGMut.GetNeededXP(simulLevel + i);

			StatsInv.DataObject.Experience += totalXP;

			// bDeferSave=true skips both SaveConfig() calls inside CheckLevelUp,
			// moving the disk write out of this frame entirely.
			RPGMut.CheckLevelUp(StatsInv.DataObject, P.PlayerReplicationInfo, true);

			// Schedule the save 0.5s from now — well outside the pickup frame.
			PendingDataObject = StatsInv.DataObject;
			SetTimer(0.5, false);

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
