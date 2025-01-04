class IPMessage extends CriticalEventPlus;

var(Message) localized string OutMessage;
var() string FriendlyOutMessage;

static function string GetString(optional int Switch,optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2,optional Object OptionalObject)
{
	local string FinalName;
	local array<String> MonsterName;

    switch (Switch)
    {
        case 1:

        	if(RelatedPRI_1 != None)
        	{
            	return RelatedPRI_1.PlayerName@default.OutMessage;
			}
			else if(Monster(OptionalObject) != None)
			{
				Split(String(Monster(OptionalObject).Class), ".", MonsterName);
				if(MonsterName.Length > 1 && MonsterName[1] != "" && MonsterName[1] != "None")
				{
					FinalName = MonsterName[1];
					FinalName = Repl( FinalName, "SMP", "", false);
				}
				else
				{
					FinalName = "Monster";
				}

				return FinalName@default.OutMessage;
			}
			else
			{
				return default.FriendlyOutMessage;
			}

            break;
    }
}

defaultproperties
{
    OutMessage="is OUT!"
    FriendlyOutMessage="Friendly Monster is OUT!"
    StackMode=2
    PosY=0.65
}
