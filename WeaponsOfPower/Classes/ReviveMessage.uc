class ReviveMessage extends Localmessage;

var(Message) localized string ReviveMessage;

////////////////////////////////////////////////////////////////////////////////

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo PRI1,
	optional PlayerReplicationInfo PRI2,
	optional Object OptionalObject
) {
	if (Switch == 0) {
		return PRI2.PlayerName @ default.ReviveMessage @ PRI1.PlayerName;
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ReviveMessage="was resurrected by"
    bIsUnique=True
    bIsPartiallyUnique=True
    bFadeMessage=True
    Lifetime=7
    DrawColor=(R=255,G=128,B=32,A=255),
    PosY=0.15
}
