class CreditsPickup extends TournamentPickUp;

var() int Credits;

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.PickupMessage $ Default.Credits $ " Credits!";
}

auto state Pickup
{
	function Touch(Actor Other)
	{
		local Pawn P;
		local RPGStatsInv StatsInv;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			StatsInv = RPGStatsInv(P.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
				return;

			StatsInv.DataObject.Credits += Credits;
			StatsInv.Data.Credits = StatsInv.DataObject.Credits;
			StatsInv.DataObject.SaveConfig();

			AnnouncePickup(P);
			SetRespawn();
		}
	}
}

defaultproperties
{
     Credits=1000
     MaxDesireability=0.300000
     RespawnTime=30.000000
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
