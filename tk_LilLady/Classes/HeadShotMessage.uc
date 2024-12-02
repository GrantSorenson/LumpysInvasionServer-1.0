class HeadShotMessage extends LocalMessage;

var(Messages) localized string DecapitationString;
var sound HeadShotSound;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	return Default.DecapitationString;
}

static simulated function ClientReceive( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	P.PlayOwnedSound(Default.HeadShotSound,SLOT_Misc,255,True,5000,,False);
}

defaultproperties
{
     DecapitationString="Yeeeee Haw!!"
     HeadShotSound=Sound'tk_LilLady.LilLady.yehaw'
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=0,G=0)
     StackMode=SM_Down
     PosY=0.100000
}
