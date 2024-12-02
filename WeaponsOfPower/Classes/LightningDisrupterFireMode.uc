class LightningDisrupterFireMode extends WeaponFireMode;

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = new (self) class'DisrupterFire';

	super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=221.00,Height=0.00),
}
