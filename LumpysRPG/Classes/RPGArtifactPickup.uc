class RPGArtifactPickup extends TournamentPickup;

var float LifeTime;
var bool bInitialized;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bInitialized=true;
}

function bool CanPickupArtifact(Pawn Other)
{
	local Inventory Inv;
	local int Count, NumArtifacts;

	if (!bInitialized)
	{
		//PostBeginPlay() hasn't been called yet, wait until later
		PendingTouch = Other.PendingTouch;
		Other.PendingTouch = self;
		return false;
	}

	for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		if (RPGArtifact(Inv) != None)
			NumArtifacts++;
		Count++;
		if (Count > 1000)
			break;
	}

	return true;
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	if (CanPickupArtifact(Other))
		return MaxDesireability/PathWeight;
	else
		return 0;
}

function float BotDesireability(Pawn Bot)
{
	if (CanPickupArtifact(Bot))
		return MaxDesireability;
	else
		return 0;
}

auto state Pickup
{
	function bool ValidTouch(Actor Other)
	{
		if (!Super.ValidTouch(Other))
			return false;

		return CanPickupArtifact(Pawn(Other));
	}
}

defaultproperties
{
	RespawnTime=0.0
	MaxDesireability=1.5
	Lifetime=12.0
}
