class HowitzerBombExplosion extends Emitter;

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
			Emitters[1].Disabled = true;
	}
	else if (Level.bDropDetail)
	{
		LightRadius = 7;
	}

	Emitters[2].Texture = ExplosionTextures[Rand(2)];
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
         StartSizeRange=(X=(Min=400.000000,Max=400.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EmitterTextures.Flares.EFlareOY'
         LifetimeRange=(Min=0.650000,Max=0.650000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.HowitzerBombExplosion.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=64,G=64,R=64,A=255))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=32,G=32,R=32,A=255))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=2
         DetailMode=DM_High
         AddLocationFromOtherEmitter=1
         StartLocationShape=PTLS_Sphere
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Weapons.DustSmoke'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.HowitzerBombExplosion.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
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
         StartSizeRange=(X=(Min=70.000000,Max=90.000000),Y=(Min=70.000000,Max=90.000000),Z=(Min=70.000000,Max=90.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.600000)
     End Object
     Emitters(2)=SpriteEmitter'tk_FHIWeapons.HowitzerBombExplosion.SpriteEmitter10'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-600.000000)
         ColorScale(0)=(Color=(B=133,G=205,R=243))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=41,G=136,R=222))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=25
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=32.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=30.000000,Max=30.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRadialRange=(Min=-100.000000,Max=-500.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.HowitzerBombExplosion.SpriteEmitter11'

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