class WeaponFireMode extends Actor;

struct IconLocationStruct {
	var float X, Y, Width, Height;
};

var Material Icon;

var IconLocationStruct IconLocation;

var WeaponFireMode NextFireMode;

var WeaponFire FireMode;

var WeaponOfPower Weapon;

var int ModeNum;

var bool Enabled;

var int FireModeLevel;

var float OldSeekCheckTime;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		Weapon, ModeNum, Enabled, FireMode, NextFireMode;
}

////////////////////////////////////////////////////////////////////////////////

function WeaponFire CreateFireMode(
	class<WeaponFire> FireModeClass
) {
	local WeaponFire NewFireMode;

	NewFireMode = new FireModeClass;

	NewFireMode.Instigator  = Weapon.Instigator;
	NewFireMode.ThisModeNum = ModeNum;
	NewFireMode.Owner       = Weapon;
	NewFireMode.Weapon      = Weapon.ModifiedWeapon;
	NewFireMode.Instigator  = Instigator;
	NewFireMode.Level       = Weapon.Level;

	NewFireMode.PreBeginPlay();
	NewFireMode.BeginPlay();
	NewFireMode.PostBeginPlay();
	NewFireMode.SetInitialState();
	NewFireMode.PostNetBeginPlay();

	return NewFireMode;
}

////////////////////////////////////////////////////////////////////////////////

function Initialize() {
	if (FireMode != None) {
		Enabled = true;
	}
}

////////////////////////////////////////////////////////////////////////////////

function Deinitialize() {
	if (FireMode != None) {
		FireMode.DestroyEffects();
		FireMode.FlashEmitter = None;
		FireMode.SmokeEmitter = None;
		FireMode.Owner        = None;
		FireMode.Weapon       = None;
		FireMode              = None;
	}
}

////////////////////////////////////////////////////////////////////////////////

function Activate() { }

////////////////////////////////////////////////////////////////////////////////

function Deactivate() { }

////////////////////////////////////////////////////////////////////////////////

function SetLevel(
	Int iNewLevel
) {
	FireModeLevel = iNewLevel;
}

////////////////////////////////////////////////////////////////////////////////

function ModeTick(
	float fDeltaTime
) { }

////////////////////////////////////////////////////////////////////////////////

simulated function DrawIcon(
	Canvas canvas,
	Float  fPosX,
	Float  fPosY
) {
	local float fScaleX;
	local float fScaleY;

	fScaleX = canvas.ClipX / 1280.0f;
	fScaleY = canvas.ClipY / 1024.0f;

	canvas.SetPos(
		fPosX + fScaleX * (24.5 - IconLocation.Width  * 0.5),
		fPosY + fScaleY * (23.5 - IconLocation.Height * 0.5)
	);

	canvas.DrawTile(
		Icon,
		IconLocation.Width  * fScaleX,
		IconLocation.Height * fScaleY,
		IconLocation.X,
		IconLocation.Y,
		IconLocation.Width,
		IconLocation.Height
	);
}

////////////////////////////////////////////////////////////////////////////////

simulated function RenderOverlays(
	Canvas canvas
) {
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    FireModeLevel=1
    DrawType=0
    bOnlyRelevantToOwner=True
    bReplicateInstigator=True
    bReplicateMovement=False
    RemoteRole=2
    bClientAnim=True
}
