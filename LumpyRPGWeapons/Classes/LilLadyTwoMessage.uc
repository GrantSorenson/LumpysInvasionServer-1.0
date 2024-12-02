//lil lady overheat message
class LilLadyTwoMessage extends LocalMessage;

var localized string PoisonMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (Switch == 0)
		return Default.PoisonMessage;
}

defaultproperties
{
     PoisonMessage="Your 'Lady' is too hot to handle!"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0,G=51,R=204)
     PosY=0.500000
}
