class LilLadyAltProj extends Projectile;

var class<DamageType> DamageTypeHead;
var xEmitter AltSmokeTrail;

simulated function Destroyed()
{
	if (AltSmokeTrail != None)
		AltSmokeTrail.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
		AltSmokeTrail = Spawn(class'tk_LilLady.LilLadyAltTrail',self);

	Velocity = Vector(Rotation);
	Acceleration = Velocity * 3000.0;
	Velocity *= Speed;

	if (Level.bDropDetail)
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
} 

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (EffectIsRelevant(Location,false))
		Spawn(class'tk_LilLady.LilLadyAltBlows',,, HitLocation, rotator(HitNormal));

	BlowUp(HitLocation);

	Destroyed();
	Destroy();
}

simulated function BlowUp(vector HitLocation)
{
	HurtRadius(Damage/6, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	PlaySound(Sound'WeaponSounds.BLinkedFire');
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation)
{
	if (Other == Instigator)
		return;
	if (Other == Owner)
		return;

	Other.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local Vector X;
	local float dist;

	if (Other == Instigator)
		return;
	if (Other == Owner)
		return;

	X = Normal(Velocity+vect(0,0,0.5));
	if (!Other.bWorldGeometry)
	{
		if ((Pawn(Other) != None) && (Other.GetClosestBone(HitLocation,X,dist,'head',10) == 'head'))
			Other.TakeDamage(Damage*2, Instigator, HitLocation, 1*X, DamageTypeHead);
		else
			Other.TakeDamage(Damage, Instigator, HitLocation, 1*X, MyDamageType);
	}

	Explode(HitLocation,Normal(HitLocation-Other.Location));
}

defaultproperties
{
     DamageTypeHead=Class'tk_LilLady.DamTypeHeadShot'
     Speed=15000.000000
     MaxSpeed=16000.000000
     Damage=120.000000
     DamageRadius=10.000000
     MomentumTransfer=100.000000
     MyDamageType=Class'tk_LilLady.DamTypeAltLilLady'
     ExplosionDecal=Class'XEffects.LinkScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=5.333000
     AmbientGlow=96
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=200.000000
     ForceScale=35.000000
}
