class SpreadLinkFireMode extends WeaponFireMode;

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = CreateFireMode(class'SpreadLinkAltFire');

	super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

function Activate() {
	SpreadLinkAltFire(FireMode).StartSpread();
}

////////////////////////////////////////////////////////////////////////////////

function SetLevel(
	int iNewLevel
) {
	super.SetLevel(iNewLevel);

	SpreadLinkAltFire(FireMode).SetLevel(iNewLevel);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=223.00,Height=0.00),
}
