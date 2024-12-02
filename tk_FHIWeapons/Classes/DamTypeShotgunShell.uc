class DamTypeShotgunShell extends WeaponDamageType
	abstract;

var sound FlakMonkey;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if (xPRI != None)
	{
		xPRI.flakcount++;
		if ((xPRI.flakcount == 15) && (UnrealPlayer(Killer) != None))
			UnrealPlayer(Killer).ClientDelayedAnnouncement(default.FlakMonkey, 15);
	}
}		

defaultproperties
{
     FlakMonkey=Sound'AnnouncerMain.FlackMonkey'
     WeaponClass=Class'tk_FHIWeapons.Shotgun'
     DeathString="%o was blown away by %k's Shotgun"
     FemaleSuicide="%o blew herself away with the Shotgun"
     MaleSuicide="%o blew himself away with the Shotgun"
     bDelayedDamage=True
     GibPerterbation=2.750000
     KDamageImpulse=4000.000000
     VehicleMomentumScaling=0.500000
}