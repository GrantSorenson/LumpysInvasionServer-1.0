class WeaponArtifactChanceConfiguration extends Info config(WeaponsOfPower);

var config bool OverrideIni;

var config int PowerUpChance0;
var config int PowerUpChance1;
var config int PowerUpChance2;
var config int PowerUpChance3;
var config int PowerUpChance4;
var config int PowerUpChance5;
var config int PowerUpChance6;
var config int PowerUpChance7;
var config int PowerUpChance8;
var config int PowerUpChance9;
var config int PowerUpChance10;
var config int PowerUpChance11;
var config int PowerUpChance12;
var config int PowerUpChance13;
var config int PowerUpChance14;
var config int PowerUpChance15;
var config int PowerUpChance16;
var config int PowerUpChance17;
var config int PowerUpChance18;
var config int PowerUpChance19;
var config int PowerUpChance20;
var config int PowerUpChance21;
var config int PowerUpChance22;
var config int PowerUpChance23;
var config int PowerUpChance24;
var config int PowerUpChance25;
var config int PowerUpChance26;
var config int PowerUpChance27;
var config int PowerUpChance28;
var config int PowerUpChance29;
var config int PowerUpChance30;
var config int PowerUpChance31;
var config int PowerUpChance32;
var config int PowerUpChance33;
var config int PowerUpChance34;
var config int PowerUpChance35;
var config int PowerUpChance36;
var config int PowerUpChance37;
var config int PowerUpChance38;
var config int PowerUpChance39;
var config int PowerUpChance40;
var config int PowerUpChance41;
var config int PowerUpChance42;
var config int PowerUpChance43;
var config int PowerUpChance44;
var config int PowerUpChance45;
var config int PowerUpChance46;
var config int PowerUpChance47;
var config int PowerUpChance48;
var config int PowerUpChance49;
var config int PowerUpChance50;
var config int PowerUpChance51;
var config int PowerUpChance52;
var config int PowerUpChance53;
var config int PowerUpChance54;
var config int PowerUpChance55;
var config int PowerUpChance56;
var config int PowerUpChance57;
var config int PowerUpChance58;
var config int PowerUpChance59;
var config int PowerUpChance60;
var config int PowerUpChance61;
var config int PowerUpChance62;
var config int PowerUpChance63;
var config int PowerUpChance64;
var config int PowerUpChance65;
var config int PowerUpChance66;
var config int PowerUpChance67;
var config int PowerUpChance68;
var config int PowerUpChance69;
var config int PowerUpChance70;
var config int PowerUpChance71;
var config int PowerUpChance72;
var config int PowerUpChance73;
var config int PowerUpChance74;
var config int PowerUpChance75;
var config int PowerUpChance76;
var config int PowerUpChance77;
var config int PowerUpChance78;
var config int PowerUpChance79;
var config int PowerUpChance80;
var config int PowerUpChance81;
var config int PowerUpChance82;
var config int PowerUpChance83;
var config int PowerUpChance84;
var config int PowerUpChance85;
var config int PowerUpChance86;
var config int PowerUpChance87;
var config int PowerUpChance88;
var config int PowerUpChance89;
var config int PowerUpChance90;
var config int PowerUpChance91;
var config int PowerUpChance92;
var config int PowerUpChance93;
var config int PowerUpChance94;
var config int PowerUpChance95;
var config int PowerUpChance96;
var config int PowerUpChance97;
var config int PowerUpChance98;
var config int PowerUpChance99;

var localized string PropertyGroupName;

var localized string PropertyText[2];

var localized string PropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	local int ModifierCount;
	local int i;

	ModifierCount = class'WeaponModifierArtifactManager'.default.WeaponModifiers.length;

	Super.FillPlayInfo(PlayInfo);

	if (ModifierCount > 99) {
		ModifierCount = 99;
	}

	PlayInfo.AddSetting(default.PropertyGroupName, "OverrideIni", default.PropertyText[0],  1, 10, "Check");

	for (i = 0; i < ModifierCount; ++i) {
		PlayInfo.AddSetting(default.PropertyGroupName, "PowerUpChance" $ i, class'WeaponModifierArtifactManager'.default.WeaponModifiers[i].Artifact.default.ModifierClass.default.Configuration.default.ModifierName $ " Power-Up Chance",  1, 10, "Text", "4;0:9999");
	}

	PlayInfo.PopClass();
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	local int PowerUpIndex;

	switch (PropName) {
		case "OverrideIni": return default.PropertyDesc[0];
	}

	if (Left(PropName, 13) ~= "PowerUpChance") {
		PowerUpIndex = Int(Right(PropName, Len(PropName) - 13));

		return "The chance of a " $ class'WeaponModifierArtifactManager'.default.WeaponModifiers[PowerUpIndex].Artifact.default.ModifierClass.default.Configuration.default.ModifierName $ " power-up being generated.";
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    PropertyGroupName="WOP: Chances"
    PropertyText="Override ini settings"
    PropertyDesc="If enabled, the chance settings override the chances specified in the ini file."
}
