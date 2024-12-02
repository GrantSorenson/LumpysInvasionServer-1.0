class WeaponSummonMessage extends Localmessage;

var(Message) localized string SummonMessage;

var string WeaponName;

////////////////////////////////////////////////////////////////////////////////

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo PRI1,
	optional PlayerReplicationInfo PRI2,
	optional Object OptionalObject
) {
	if (Switch == 0) {
		return default.SummonMessage @ default.WeaponName;
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SummonMessage="You have summoned a"
    bIsUnique=True
    bIsPartiallyUnique=True
    bFadeMessage=True
    Lifetime=7
    DrawColor=(R=255,G=128,B=32,A=255),
    PosY=0.75
}
