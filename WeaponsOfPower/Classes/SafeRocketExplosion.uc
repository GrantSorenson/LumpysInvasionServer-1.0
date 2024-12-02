class SafeRocketExplosion extends RocketExplosion;

simulated function PostBeginPlay() {
	local PlayerController PC;

	PC = Level.GetLocalPlayerController();

	if (PC == None) {
		return;
	}

	super.PostBeginPlay();
}

defaultproperties
{
}
