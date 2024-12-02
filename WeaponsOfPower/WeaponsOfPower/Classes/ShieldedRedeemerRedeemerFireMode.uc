class ShieldedRedeemerRedeemerFireMode extends WeaponFireMode;

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = CreateFireMode(class'WeaponsOfPower.ShieldedRedeemerRedeemerFire');

	super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=221.00,Height=0.00),
}
