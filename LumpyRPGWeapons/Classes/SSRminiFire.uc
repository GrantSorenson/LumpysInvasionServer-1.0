//==========================================================================
//SSRminiBeamFire
//==========================================================================

////////////////////////////////////////////////////////////////
class SSRminiFire extends MinigunFire;

var() class<SSRminiBeamEffect> BeamEffectClass;

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
    local SSRminiBeamEffect Beam;

    if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
		Beam = Spawn(class'SSRminiBeamEffect',,, Start, Dir);
	else
		Beam = Spawn(BeamEffectClass,,, Start, Dir);
    if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
    Beam.AimAt(HitLocation, HitNormal);
}

defaultproperties
{
     BeamEffectClass=Class'SSRminiBeamEffect'
     DamageType=Class'XWeapons.DamTypeSuperShockBeam'
     DamageMin=1000
     DamageMax=1000
     Momentum=100000.000000
     FireSound=Sound'WeaponSounds.Misc.instagib_rifleshot'
     AmmoClass=Class'XWeapons.SuperShockAmmo'
     AmmoPerFire=0
}


