class LumpysInvasionWaveMessage extends CriticalEventPlus;

var() string DefaultWaveName;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    if (LumpysInvasionWaveHandler(OptionalObject) != None)
    {
            //default.DrawColor = default.WaveNames[Switch].WaveColor;
            default.DrawColor = LumpysInvasionWaveHandler(OptionalObject).WaveColor;
            return (LumpysInvasionWaveHandler(OptionalObject).WaveNames[switch]);
    }
}

defaultproperties
{
     bIsConsoleMessage=False
     DrawColor=(R=255,G=0,B=0,A=255),
     Lifetime=3
     StackMode=SM_Down
     PosY=0.100000
     FontSize=5
}