class HowitzerExplosionA extends Emitter;

var Texture ExplosionTextures[2];

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	local float dist;

	PC = Level.GetLocalPlayerController();
	if (Level.NetMode == NM_DedicatedServer || PC == None)
		return;

	if (PC.ViewTarget == None)
		dist = 10000;
	else
		dist = VSize(PC.ViewTarget.Location - Location);

	if (dist > 4000)
	{
		LightType = LT_None;
		bDynamicLight = false;
		if (dist > 7000)
			Emitters[2].Disabled = true;
			Emitters[3].Disabled = true;
	}
	else if (Level.bDropDetail)
	{
		LightRadius = 7;
	}

	Emitters[1].Texture = ExplosionTextures[Rand(2)];
}

defaultproperties
{
     ExplosionTextures(0)=Texture'ExplosionTex.Framed.we1_frames'
     ExplosionTextures(1)=Texture'ExplosionTex.Framed.exp2_frames'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AlphaTest=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=122,G=200,R=233))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=57,G=126,R=230))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.100000
         MaxParticles=1
         StartSizeRange=(X=(Min=600.000000,Max=600.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EmitterTextures.Flares.EFlareOY'
         LifetimeRange=(Min=0.650000,Max=0.650000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.HowitzerExplosionA.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=116,G=185,R=231))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=39,G=134,R=228))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=20,G=72,R=192))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=24.000000,Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=150.000000,Max=170.000000),Y=(Min=150.000000,Max=170.000000),Z=(Min=150.000000,Max=170.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.600000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.HowitzerExplosionA.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.330000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=0.750000,Color=(B=128,G=128,R=128,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=64,G=64,R=64))
         MaxParticles=30
         DetailMode=DM_High
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=-16384)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'ExplosionTex.Framed.SmokeReOrdered'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRadialRange=(Min=300.000000,Max=300.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'tk_FHIWeapons.HowitzerExplosionA.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseCollision=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=-400.000000)
         DampingFactorRange=(Z=(Min=0.200000,Max=0.200000))
         MaxParticles=25
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-30.000000,Max=30.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'VMParticleTextures.TankFiringP.tankHitRocks'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.750000,Max=1.750000)
         StartVelocityRadialRange=(Min=-100.000000,Max=-500.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.HowitzerExplosionA.SpriteEmitter7'

     AutoDestroy=True
     LightType=LT_FadeOut
     LightEffect=LE_QuadraticNonIncidence
     LightHue=22
     LightSaturation=50
     LightBrightness=255.000000
     LightRadius=9.000000
     LightPeriod=32
     LightCone=128
     bNoDelete=False
     bDynamicLight=True
}