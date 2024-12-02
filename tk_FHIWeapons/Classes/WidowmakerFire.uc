class WidowmakerFire extends tk_InstantFire;

var() class<xEmitter> HitEmitterClass;
var() class<xEmitter> SecHitEmitterClass;
var() int NumArcs;
var() float SecDamageMult;
var() float SecTraceDist;
var() float HeadShotDamageMult;
var() float HeadShotRadius;
var() class<DamageType> DamageTypeHeadShot;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function FlashMuzzleFlash()
{
    local rotator r;
    r.Roll = Rand(65536);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
    Super.FlashMuzzleFlash();
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int Damage, ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<Actor> tmpHitEmitClass;
    local float tmpTraceRange, dist;
    local vector arcEnd, mainArcHit;

    Weapon.GetViewAxes(X, Y, Z);
    if ( Weapon.WeaponCentered() )
        arcEnd = (Instigator.Location + 
			Weapon.EffectOffset.X * X + 
			1.5 * Weapon.EffectOffset.Z * Z); 
	else
        arcEnd = (Instigator.Location + 
			Instigator.CalcDrawOffset(Weapon) + 
			Weapon.EffectOffset.X * X + 
			Weapon.Hand * Weapon.EffectOffset.Y * Y + 
			Weapon.EffectOffset.Z * Z); 
	
    arcsRemaining = NumArcs;

    tmpHitEmitClass = HitEmitterClass;
    tmpTraceRange = TraceRange;
    
    ReflectNum = 0;
    while (true)
    {
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin)) * DamageAtten;
					if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs) 
						&& Other.GetClosestBone( HitLocation, X, dist, 'head', HeadShotRadius ) == 'head' )
                        Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
                    else
                    {
						if ( arcsRemaining < NumArcs )
							Damage *= SecDamageMult;
                        Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
					}
                }
                else
					HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }
        hitEmitter = xEmitter(Spawn(tmpHitEmitClass,,, arcEnd, Rotator(HitNormal)));
        if ( hitEmitter != None )
			hitEmitter.mSpawnVecA = HitLocation;

        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }
        
        if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            // done parent arc, now move trace point to arc trace hit location and try child arcs from there
            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }
    }
}

defaultproperties
{
     HitEmitterClass=Class'tk_FHIWeapons.WidowmakerTracer'
     SecHitEmitterClass=Class'tk_FHIWeapons.WidowmakerSparks'
     NumArcs=4
     SecDamageMult=1.500000
     SecTraceDist=500.000000
     HeadShotDamageMult=2.000000
     HeadShotRadius=16.000000
     DamageTypeHeadShot=Class'tk_FHIWeapons.DamTypeWidowmakerHeadShot'
     DamageType=Class'tk_FHIWeapons.DamTypeWidowmaker'
     DamageMin=120
     DamageMax=120
     TraceRange=20000.000000
     TransientSoundVolume=1.000000
     FireSound=Sound'tk_FHIWeapons.FHISnd.SniperRifle_Fire'
     FireForce="LightningGunFire"
     FireRate=1.000000
     AmmoClass=Class'tk_FHIWeapons.WidowmakerAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-15.000000,Z=10.000000)
     ShakeOffsetRate=(X=-4000.000000,Z=4000.000000)
     ShakeOffsetTime=1.600000
     BotRefireRate=0.800000
     FlashEmitterClass=Class'tk_FHIWeapons.WidowmakerMuzFlash'
     aimerror=850.000000
}
