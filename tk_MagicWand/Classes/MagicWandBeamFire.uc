class MagicWandBeamFire extends tK_ShockBeamFire;

function DoFireEffect()
{                    
	local Vector StartTrace;
	local Rotator R, Aim;

	Instigator.MakeNoise(1.0);

	StartTrace = Instigator.Location + Instigator.EyePosition();
	Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
	DoTrace(StartTrace, R);
}

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X;
	
	X = vector(Dir);
	TracePart(Start, Start+X*TraceRange, X, Dir, Instigator);
}	

function bool AllowMultiHit()
{
	return false;
}

function TracePart(Vector Start, Vector End, Vector X, Rotator Dir, Pawn Ignored)
{
	local Vector HitLocation, HitNormal;
	local Actor Other;

	Other = Ignored.Trace(HitLocation, HitNormal, End, Start, true);
	if ((Other != None) && (Other != Ignored))
	{
        	if (!Other.bWorldGeometry)
		{
			Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
			HitNormal = Vect(0,0,0);
			if ((Pawn(Other) != None) && (HitLocation != Start) && AllowMultiHit())
				TracePart(HitLocation, End, X, Dir, Pawn(Other));
		}
	}
	else
	{
		HitLocation = End;
		HitNormal = Vect(0,0,0);
	}
	SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, 0);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	local ShockBeamEffect Beam;
    
	if ((Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1))
		Beam = Weapon.Spawn(class'BlueSuperShockBeam',,, Start, Dir);
	else
		Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);

	if (ReflectNum != 0)
		Beam.Instigator = None;

	Beam.AimAt(HitLocation, HitNormal);
}

defaultproperties
{
     BeamEffectClass=Class'tk_MagicWand.MagicWandBeamEffect'
     DamageType=Class'tk_MagicWand.DamTypeMagicWand'
     DamageMin=90
     DamageMax=90
     Momentum=100000.000000
     FireSound=Sound'tk_MagicWand.MagicWand.MWFire'
     FireRate=0.500000
     AmmoClass=Class'tk_MagicWand.MagicWandAmmo'
     AmmoPerFire=1
}