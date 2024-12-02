class DisrupterInv extends Inventory;

var float fEffectTime;

var float fStartTime;

////////////////////////////////////////////////////////////////////////////////

function PostBeginPlay() {
	SetTimer(1.0, true);

	Super.PostBeginPlay();

	fStartTime = Level.TimeSeconds;
}

////////////////////////////////////////////////////////////////////////////////

function Timer() {
	//local RPGStatsInv StatsInv;

	if (Instigator == None || Instigator.Health <= 0) {
		Destroy();
		return;
	}

	if (Level.TimeSeconds - fStartTime > fEffectTime) {
		Destroy();
		return;
	}

	//StatsInv = Pawn.FindInventoryType(class'RPGStatsInv');
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
