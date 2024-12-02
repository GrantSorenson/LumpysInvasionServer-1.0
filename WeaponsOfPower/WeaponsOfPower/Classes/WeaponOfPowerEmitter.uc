class WeaponOfPowerEmitter extends Emitter;

var color EmitterColor;

var bool bFading;

var color StartColor;

var float fFade;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (RemoteRole == ROLE_SimulatedProxy)
		EmitterColor;
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetEmitterColor(
	Color newColor
) {
	EmitterColor = newColor;
}

////////////////////////////////////////////////////////////////////////////////

simulated function SetActive(
	bool bState
) {
	if (bState == !Emitters[0].Disabled) {
		return;
	}

	if (bState == True) {
		Emitters[0].Trigger();
		Emitters[0].Disabled = false;
	} else {
		Emitters[0].Reset();
		Emitters[0].Disabled = true;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function FadeEmitterColor(
	float fDeltaTime
) {
	if (EmitterColor == Emitters[0].ColorScale[0].Color) {
		return;
	}

	// Initial rate variables so the fade is constant speed.
	if (bFading == false) {
		bFading = true;

		StartColor = Emitters[0].ColorScale[0].Color;
		fFade      = 0.0f;
	}

	fFade += fDeltaTime;

	if (fFade > 1.0f) {
		fFade = 1.0f;
	} else if (fFade < 0.0f) {
		fFade = 0.0f;
	}

	Emitters[0].ColorScale[0].Color.R = (StartColor.R * (1.0f - fFade)) + (EmitterColor.R * fFade);
	Emitters[0].ColorScale[0].Color.G = (StartColor.G * (1.0f - fFade)) + (EmitterColor.G * fFade);
	Emitters[0].ColorScale[0].Color.B = (StartColor.B * (1.0f - fFade)) + (EmitterColor.B * fFade);
	Emitters[0].ColorScale[0].Color.A = (StartColor.A * (1.0f - fFade)) + (EmitterColor.A * fFade);

	if (fFade == 1.0f) {
		bFading = false;
	}

	if (Emitters[0].ColorScale[0].Color.A == 0) {
		SetActive(False);
	} else {
		SetActive(true);
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function Tick(
	Float fDeltaTime
) {
	super.Tick(fDeltaTime);

	// Perform a gradual fade of the color so that the emitter doesn't just seem
	// to change colors or dissapear instantaneously.
	FadeEmitterColor(fDeltaTime);
}

////////////////////////////////////////////////////////////////////////////////

function Reset();

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Emitters=
    bNoDelete=False
    bTrailerSameRotation=True
    bReplicateMovement=False
    Physics=10
    RemoteRole=2
    bBlockZeroExtentTraces=False
    bBlockNonZeroExtentTraces=False
    bNetNotify=True
}
