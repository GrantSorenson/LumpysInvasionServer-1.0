class DamTypePistolHeadShot extends WeaponDamageType
	abstract;

var class<LocalMessage> KillerMessage;
var sound HeadHunter;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	if (PlayerController(Killer) == None)
		return;
		
	PlayerController(Killer).ReceiveLocalizedMessage(default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None);
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if (xPRI != None)
	{
		xPRI.headcount++;
		if ((xPRI.headcount == 15) && (UnrealPlayer(Killer) != None))
			UnrealPlayer(Killer).ClientDelayedAnnouncement(default.HeadHunter, 15);
	}
}		

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth)
{
	HitEffects[0] = class'XEffects.HitSmoke';
	HitEffects[1] = class'XEffects.HitFlameBig';
}

defaultproperties
{
     KillerMessage=Class'XGame.SpecialKillMessage'
     Headhunter=Sound'AnnouncerMain.Headhunter'
     WeaponClass=Class'tk_FHIWeapons.Pistol'
     DeathString="%o was given free brain surgery by %k"
     FemaleSuicide="%o violated the laws of space-time and sniped herself."
     MaleSuicide="%o violated the laws of space-time and sniped himself."
     bAlwaysSevers=True
     bSpecial=True
     bCauseConvulsions=True
     VehicleDamageScaling=0.650000
}