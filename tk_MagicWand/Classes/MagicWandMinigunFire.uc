class MagicWandMinigunFire extends tK_MinigunFire;

var() class<ShockBeamEffect> BeamEffectClass;

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X;

	X = vector(Dir);
	TracePart(Start,Start+X*TraceRange,X,Dir,Instigator);
}

function TracePart(Vector Start, Vector End, Vector X, Rotator Dir, Pawn Ignored)
{
    local Vector HitLocation, HitNormal;
    local Actor Other;

    Other = Ignored.Trace(HitLocation, HitNormal, End, Start, true);

    if ( (Other != None) && (Other != Ignored) )
    {
        if ( !Other.bWorldGeometry )
        {
            Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
            HitNormal = Vect(0,0,0);
            if ( (Pawn(Other) != None) && (HitLocation != Start) && Weapon.IsA('ZoomSuperShockRifle') )
				TracePart(HitLocation,End,X,Dir,Pawn(Other));
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

    if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
		Beam = Spawn(class'BlueSuperShockBeam',,, Start, Dir);
	else
		Beam = Spawn(BeamEffectClass,,, Start, Dir);
    if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
    Beam.AimAt(HitLocation, HitNormal);
}

defaultproperties
{
     BeamEffectClass=Class'tk_MagicWand.MagicWandBeamEffect'
     BarrelRotationsPerSec=2.000000
     RoundsPerRotation=3
     FiringSound=Sound'tk_MagicWand.MagicWand.WandMiniFire'
     WindUpTime=0.250000
     DamageType=Class'tk_MagicWand.DamTypeMagicWandMinigun'
     DamageMin=2000
     DamageMax=2000
     Momentum=100000.000000
     bReflective=True
     PreFireTime=0.250000
     FireLoopAnimRate=1.000000
     FireRate=1.100000
     AmmoClass=Class'tk_MagicWand.MagicWandMinigunAmmo'
     AmmoPerFire=1
     Spread=0.150000
}
