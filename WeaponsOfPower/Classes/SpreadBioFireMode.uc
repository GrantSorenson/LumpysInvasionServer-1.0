class SpreadBioFireMode extends WeaponFireMode;

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = CreateFireMode(class'SpreadBioFire');

	super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

function Activate() {
	SpreadBioFire(FireMode).StartSpread();
}

////////////////////////////////////////////////////////////////////////////////

function SetLevel(
	int iNewLevel
) {
	super.SetLevel(iNewLevel);

	SpreadBioFire(FireMode).SetLevel(iNewLevel);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=223.00,Height=0.00),
}
