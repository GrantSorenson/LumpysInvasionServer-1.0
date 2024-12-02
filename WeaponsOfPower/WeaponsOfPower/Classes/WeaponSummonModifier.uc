class WeaponSummonModifier extends LinearUpgradeWeaponModifier;

var int iStartWave;

////////////////////////////////////////////////////////////////////////////////

simulated function Apply() {
	super.Apply();

	ActivateInvasionMode();
}

////////////////////////////////////////////////////////////////////////////////

function HolderDied() {
	local WeaponSummonPlayerModifier SummonInv;

	if (PlayerOwner.Controller == None) {
		return;
	}

	SummonInv = PlayerOwner.spawn(class'WeaponSummonPlayerModifier', PlayerOwner.Controller);
	SummonInv.CurrentLevel = CurrentLevel;

	SummonInv.Inventory = PlayerOwner.Controller.Inventory;

	PlayerOwner.Controller.Inventory = SummonInv;

	// Remove this so when the weapon is tossed the player who picks it up doesn't
	// get this modifier. They only get it if the weapon is tossed.
	AttachedWeapon.RemoveModifier(self);
}

////////////////////////////////////////////////////////////////////////////////

function ActivateInvasionMode() {
	local int  iFinalWave;
	local bool bSetTimer;

	bSetTimer = False;

	if (Invasion(Level.Game) != None) {
		iFinalWave   = Invasion(Level.Game).FinalWave;
		iStartWave   = Invasion(Level.Game).WaveNum;

		bSetTimer = True;
	} else {
		return;
	}

	if (bSetTimer == True) {
		if (iStartWave == iFinalWave - 1) {
			// Do not spawn immediately for the final wave. Make them wait a minute.
			SetTimer(30 * Level.TimeDilation, true);
		} else {
			SetTimer(Level.TimeDilation, true);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function Timer() {
	local int  iCurrentWave;
	local int  iFinalWave;
	local bool bAllowSupers;
	local bool bMaxOutAmmo;

	if (
		(PlayerOwner == None) ||
		(PlayerOwner.Health <= 0) ||
		(AttachedWeapon == None) ||
		(AttachedWeapon.ModifiedWeapon == None)
	) {
		iStartWave = 0;
		SetTimer(0.0, false);
		return;
	}

	iCurrentWave = Invasion(Level.Game).WaveNum;
	iFinalWave   = Invasion(Level.Game).FinalWave;

	if (
		(iCurrentWave - iStartWave > 2) ||
		(iCurrentWave >= iFinalWave - 1)
	) {
		SetTimer(0.0, false);

		if (CurrentLevel >= 2) {
			bAllowSupers = true;
			bMaxOutAmmo  = true;
		} else {
			bAllowSupers = false;
			bMaxOutAmmo  = false;
		}

		class'WeaponSummonPlayerModifier'.static.GiveRandomWeapon(
			PlayerOwner,
			bAllowSupers,
			bMaxOutAmmo
		);

		AttachedWeapon.RemoveModifier(self);
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.WeaponSummonWeaponShader'
    ModifierColor=(R=255,G=156,B=37,A=0),
    configuration=Class'WeaponSummonModifierConfiguration'
    Artifact=Class'WeaponSummonModifierArtifact'
}
