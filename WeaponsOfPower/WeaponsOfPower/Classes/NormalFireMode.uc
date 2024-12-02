class NormalFireMode extends WeaponFireMode;

var IconLocationStruct NormalLinkIconLocation;

var IconLocationStruct NormalRocketIconLocation;

var IconLocationStruct NormalRedeemerIconLocation;

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	FireMode = Weapon.ModifiedWeapon.GetFireMode(ModeNum);

	Enabled = true;

	// We don't call this becuase we're just wrapping an existing mode that already
	// exist and is set up.
	//super.Initialize();
}

////////////////////////////////////////////////////////////////////////////////

function Deinitialize() {
	Weapon.SetFireMode(self);

	FireMode = None;

	// Same reason we don't call super.Initialize
	//super.Deinitialize();
}

////////////////////////////////////////////////////////////////////////////////

simulated function DrawIcon(
	Canvas canvas,
	Float  fPosX,
	Float  fPosY
) {
	if (LinkGun(Weapon.ModifiedWeapon) != None) {
		IconLocation = NormalLinkIconLocation;
	} else if (RocketLauncher(Weapon.ModifiedWeapon) != None) {
		IconLocation = NormalRocketIconLocation;
	} else if (Redeemer(Weapon.ModifiedWeapon) != None) {
		IconLocation = NormalRedeemerIconLocation;
	} else {
		return;
	}

	super.DrawIcon(canvas, fPosX, fPosY);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    NormalLinkIconLocation=(X=0.00,Y=0.00,Width=227.00,Height=0.00),
    NormalRocketIconLocation=(X=0.00,Y=0.00,Width=253.00,Height=0.00),
    NormalRedeemerIconLocation=(X=0.00,Y=0.00,Width=225.00,Height=0.00),
    Icon=Texture'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud'
    IconLocation=(X=0.00,Y=0.00,Width=223.00,Height=0.00),
}
