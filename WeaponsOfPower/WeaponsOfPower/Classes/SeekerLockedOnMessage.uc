// Taken from DRUIDS RPG
class SeekerLockedOnMEssage extends LocalMessage;

var localized string LockedOnMessage;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
) {
	if (RelatedPRI_1 == None) {
		return "";
	}

	return (default.LockedOnMessage);
}

defaultproperties
{
    LockedOnMessage="Rocket locked on!"
    bIsUnique=True
    bIsConsoleMessage=False
    bFadeMessage=True
    DrawColor=(R=0,G=0,B=255,A=255),
    PosY=0.75
}
