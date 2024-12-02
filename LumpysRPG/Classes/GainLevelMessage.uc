//
// Message for gaining a level
//
//	RelatedPRI_1 is the one who gained a level.
//	Switch is that player's new level.
//

class GainLevelMessage extends LocalMessage;

var(Message) localized string LevelString, SomeoneString;
var(Message)  array<color> LevelColors;
var(Message)  array<color> NameColors;
var(Message)  array<color> GreenColors;
var(Message)  array<color> BlueColors;


static function color GetConsoleColor( PlayerReplicationInfo RelatedPRI_1 )
{
    return class'HUD'.Default.WhiteColor;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local string Name, ilvl;
  local int colInd;

  colInd = Rand(3);

	if (RelatedPRI_1 == None)
		Name = Default.SomeoneString;
	else
		Name = formatName(RelatedPRI_1.PlayerName);

  if(colInd==0)
    ilvl = MakeColorCode(default.LevelColors[0])$" is "$MakeColorCode(default.LevelColors[1])$"now "$MakeColorCode(default.LevelColors[2])$"Level ";
  if(colInd==1)
    ilvl = MakeColorCode(default.GreenColors[0])$" is "$MakeColorCode(default.GreenColors[1])$"now "$MakeColorCode(default.GreenColors[2])$"Level ";
  if(colInd==2)
    ilvl = MakeColorCode(default.BlueColors[0])$" is "$MakeColorCode(default.BlueColors[1])$"now "$MakeColorCode(default.BlueColors[2])$"Level ";

	return Name$ilvl$Switch$".";
}

static function string formatName(string playerName)
{
  local string first,second;
  local int nameLen;//mid

  nameLen = Len(playerName);
  if(nameLen > 2)
  {
    first = Left(playerName,nameLen/2);
    second = Right(playerName,nameLen/2+1);

    //return MakeColorCode(default.NameColors[0])$first$MakeColorCode(default.NameColors[1])$second$MakeColorCode(default.NameColors[1]);
  }
  return playerName;
}

static function string MakeColorCode(color NewColor)
{
	if (NewColor.R == 0)
		NewColor.R = 1;

	if (NewColor.G == 0)
		NewColor.G = 1;

	if (NewColor.B == 0)
		NewColor.B = 1;

	return Chr(0x1B)$Chr(NewColor.R)$Chr(NewColor.G)$Chr(NewColor.B);
}

defaultproperties
{
     LevelString=" is now level "
     NameColors(0)=(R=255,G=255,B=255,A=255)//white
     NameColors(1)=(R=0,G=255,B=0,A=255)//Green
     LevelColors(0)=(R=255,G=128,B=0,A=255)//R3
     LevelColors(1)=(R=255,G=170,B=0,A=255)//01
     LevelColors(2)=(R=255,G=213,B=0,A=255)//02
     GreenColors(0)=(R=0,G=255,B=85,A=255)
     GreenColors(1)=(R=0,G=255,B=128,A=255)
     GreenColors(2)=(R=0,G=255,B=170,A=255)
     BlueColors(0)=(R=0,G=25,B=255,A=255)
     BlueColors(1)=(R=25,G=25,B=255,A=255)
     BlueColors(2)=(R=25,G=0,B=255,A=255)
     SomeoneString=" someone "
     bIsSpecial=False
     DrawColor=(B=0,G=0)
}
