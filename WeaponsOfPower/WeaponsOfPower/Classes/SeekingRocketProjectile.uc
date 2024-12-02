class SeekingRocketProjectile extends Projectile;

var Actor Seeking;

var vector InitialDir;

var float NextUpdateTime;

var float UpdateInc;

var bool bHitWater;
var	xEmitter SmokeTrail;
var Effects Corona;

var vector Dir;

var color DefaultTrailColor;

var color TrailColor1;

var color TrailColor2;

var float fFade1, fFade2;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetInitial && Role == ROLE_Authority)
		InitialDir;

	reliable if (Role == ROLE_Authority)
		ClientSetTarget;

	reliable if (Role == ROLE_Authority)
		TrailColor1, TrailColor2;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Destroyed() {
	if (SmokeTrail != None) {
		SmokeTrail.mRegen = False;
	}

	if (Corona != None) {
		Corona.Destroy();
	}

	Super.Destroyed();
}

////////////////////////////////////////////////////////////////////////////////

simulated function PostBeginPlay() {
	local color Black;

	if (Level.NetMode != NM_DedicatedServer) {
		SmokeTrail = Spawn(class'TransTrail',   self);
		Corona     = Spawn(class'RocketCorona', self);

		SetTrailColor(DefaultTrailColor, DefaultTrailColor);

		SmokeTrail.mColorRange[0] = Black;
		SmokeTrail.mColorRange[1] = Black;

		SmokeTrail.mSizeRange[0] = 25.000000;
		SmokeTrail.mSizeRange[1] = 25.000000;
	}

	Dir      = vector(Rotation);
	Velocity = speed * Dir;

	if (PhysicsVolume.bWaterVolume) {
		bHitWater = True;
		Velocity  = 0.6 * Velocity;
	}

	super.PostBeginPlay();

	SetTimer(0.1, true);

	UpdateInc = 0.5f;
	NextUpdateTime = Level.TimeSeconds + UpdateInc;
}

////////////////////////////////////////////////////////////////////////////////

function SetTrailColor(
	color NewTrailColor1,
	color NewTrailColor2
) {
	TrailColor1 = NewTrailColor1;
	TrailColor2 = NewTrailColor2;

	ClientSetTrailColor();
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientSetTrailColor() {
	local color CurrentColor;
	local color White, Black;
	local float fPercent;

	if (SmokeTrail != None) {
		White.R = 255;
		White.G = 255;
		White.B = 255;
		White.A = 255;

//		fFade = fFade + (frand() - 0.5);
//		fFade = Min(2.8, Max(0.2, fFade));

//		fPercent = fFade - float(int(fFade));

		fFade1 = fFade1 + (frand() * 0.6) - 0.3;

		if (fFade1 < 0.0) {
			fFade1 = 0.0;
		}

		if (fFade1 > 1.0) {
			fFade1 = 1.0;
		}

		CurrentColor = class'Colors'.static.MultiplyColor(TrailColor2,  fFade1) + class'Colors'.static.MultiplyColor(TrailColor1, (1.0 - fFade1));

		fFade2 = fFade2 + (frand() * 0.6) - 0.3;

		if (fFade2 < 0.1) {
			fFade2 = 0.1;
		}

		if (fFade1 > 0.7) {
			fFade2 = 0.7;
		}

		// -0.1 to 0.7

		if (fPercent < 0.0) {
			// 0.0 to 0.1
			CurrentColor = class'Colors'.static.MultiplyColor(CurrentColor, (1.0 + fFade2)) + class'Colors'.static.MultiplyColor(Black, -fFade2);
		} else {
			// 0.0 to 7.0
			CurrentColor = class'Colors'.static.MultiplyColor(CurrentColor, (1.0 - fFade2)) + class'Colors'.static.MultiplyColor(White, fFade2);
		}

		CurrentColor.A = 255;

		SmokeTrail.mColorRange[0] = CurrentColor;
		SmokeTrail.mColorRange[1] = CurrentColor;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function PostNetBeginPlay() {
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if (Level.NetMode == NM_DedicatedServer) {
		return;
	}

	if (
		(Level.bDropDetail == true) ||
		(Level.DetailMode == DM_Low)
	) {
		bDynamicLight = false;
		LightType     = LT_None;
	} else {
		PC = Level.GetLocalPlayerController();

		if (
			(Instigator != None) &&
			(PC == Instigator.Controller)
		) {
			return;
		}

		if (
			(PC == None) ||
			(PC.ViewTarget == None) ||
			(VSize(PC.ViewTarget.Location - Location) > 3000)
		)	{
			bDynamicLight = false;
			LightType     = LT_None;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function Landed(
	vector HitNormal
) {
	Explode(Location,HitNormal);
}

////////////////////////////////////////////////////////////////////////////////

simulated function ProcessTouch(
	Actor  Other,
	Vector HitLocation
) {
	if (
		(Other != instigator) &&
		(
			(Other.IsA('Projectile') == false) ||
			(Other.bProjTarget == true)
		)
	) {
		Explode(
			HitLocation,
			vector(rotation) * -1
		);
	}
}

////////////////////////////////////////////////////////////////////////////////

function BlowUp(
	vector HitLocation
) {
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

////////////////////////////////////////////////////////////////////////////////

simulated function Explode(
	vector HitLocation,
	vector HitNormal
) {
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',, 2.5 * TransientSoundVolume);

	if (EffectIsRelevant(Location,false) == true) {
		Spawn(class'NewExplosionA',,, HitLocation + HitNormal * 20, rotator(HitNormal));

		PC = Level.GetLocalPlayerController();

		if (
			(PC.ViewTarget != None) &&
			(VSize(PC.ViewTarget.Location - Location) < 5000)
		) {
			Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
		}
	}

	BlowUp(HitLocation);
	Destroy();
}

////////////////////////////////////////////////////////////////////////////////

simulated function ClientSetTarget(
	Actor Target
) {
	Seeking = Target;
}

////////////////////////////////////////////////////////////////////////////////

function SetTarget(
	Actor Target
) {
	ClientSetTarget(Target);
	Seeking = Target;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Timer() {
	local vector ForceDir;
	local float VelMag;

	Super.Timer();

	if (frand() < 0.6) {
		ClientSetTrailColor();
	}

	if (Role == ROLE_Authority) {
		if (InitialDir == vect(0,0,0)) {
			InitialDir = Normal(Velocity);
		}

		Acceleration = vect(0,0,0);

		if (
			(Seeking != None) &&
			(Seeking != Instigator) &&
			(NextUpdateTime < Level.TimeSeconds)
		) {
			ForceDir = Normal(Seeking.Location - Location);

			VelMag = VSize(Velocity);

			Velocity = VelMag * ForceDir;
			Acceleration += ForceDir;

			SetRotation(rotator(Velocity));

			UpdateInc /= 1.3f;
			NextUpdateTime = Level.TimeSeconds + UpdateInc;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    DefaultTrailColor=(R=0,G=0,B=0,A=255),
    Speed=1250.00
    MaxSpeed=1250.00
    Damage=90.00
    MomentumTransfer=50000.00
    MyDamageType=Class'XWeapons.DamTypeRocketHoming'
    ExplosionDecal=Class'XEffects.RocketMark'
    LightType=1
    LightEffect=21
    LightHue=28
    LightBrightness=255.00
    LightRadius=5.00
    DrawType=8
    StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
    CullDistance=7500.00
    bDynamicLight=True
    bNetTemporary=False
    bAlwaysRelevant=True
    bUpdateSimulatedPosition=True
    AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
    LifeSpan=10.00
    AmbientGlow=96
    FluidSurfaceShootStrengthMod=10.00
    SoundVolume=255
    SoundRadius=100.00
    bFixedRotationDir=True
    RotationRate=(Pitch=0,Yaw=0,Roll=50000),
    DesiredRotation=(Pitch=0,Yaw=0,Roll=30000),
    ForceType=2
    ForceRadius=100.00
    ForceScale=5.00
}
