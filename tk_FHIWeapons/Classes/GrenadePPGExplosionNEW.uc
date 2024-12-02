class GrenadePPGExplosionNEW extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter97
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=174,G=61,R=17))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=236,G=201,R=157))
         FadeOutStartTime=0.300000
         MaxParticles=5
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Min=0.050000,Max=0.100000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=450.000000,Max=450.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
         LifetimeRange=(Min=2.500000,Max=3.000000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter97'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=240,G=177,R=94))
         ColorScale(1)=(RelativeTime=0.400000,Color=(B=233,G=140,R=65))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=236,G=15,R=75))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=75
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=400.000000,Max=400.000000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=7.000000,Max=7.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
         LifetimeRange=(Min=1.250000,Max=1.250000)
         StartVelocityRadialRange=(Min=300.000000,Max=300.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter4'

     Begin Object Class=BeamEmitter Name=BeamEmitter7
         BeamDistanceRange=(Min=1000.000000,Max=1000.000000)
         BeamEndPoints(0)=(offset=(X=(Min=-1000.000000,Max=1000.000000),Y=(Min=-1000.000000,Max=1000.000000),Z=(Min=-1000.000000,Max=1000.000000)),Weight=1.000000)
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         LowFrequencyNoiseRange=(Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         HighFrequencyNoiseRange=(Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         HighFrequencyPoints=15
         NoiseDeterminesEndPoint=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=243,G=190,R=137))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=223,G=132,R=49))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=254,G=180,R=192))
         StartMassRange=(Min=0.000000,Max=0.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.500000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=75.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'EpicParticles.Beams.HotBolt04aw'
         LifetimeRange=(Min=2.000000,Max=2.500000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(2)=BeamEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.BeamEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         ProjectionNormal=(Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=245,G=231,R=101))
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=192,G=96))
         ColorScale(2)=(RelativeTime=0.750000,Color=(B=248,G=73,R=69))
         ColorScale(3)=(RelativeTime=1.000000)
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Max=175.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'tk_FHIWeapons.FHITex.Flare_E'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         ProjectionNormal=(Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=172,R=117))
         ColorScale(1)=(RelativeTime=0.400000,Color=(B=255,G=128))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=245,G=33,R=75))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.800000
         MaxParticles=3
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=1.000000,Max=3.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=200.000000,Max=250.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=3.000000,Max=3.000000)
     End Object
     Emitters(4)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-500.000000)
         DampingFactorRange=(X=(Min=0.300000,Max=0.550000),Y=(Min=0.300000,Max=0.550000),Z=(Min=0.100000,Max=0.250000))
         ColorScale(0)=(Color=(B=250,G=201,R=169))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=245,G=128,R=103))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=243,G=12,R=70))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=175
         DetailMode=DM_High
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=75.000000,Max=75.000000)
         StartLocationPolarRange=(Y=(Max=65536.000000),Z=(Min=8.000000,Max=16.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=16384)
         SpinsPerSecondRange=(X=(Min=0.150000,Max=0.250000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=5.500000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'tk_FHIWeapons.FHITex.Flare_E'
         LifetimeRange=(Min=3.000000,Max=3.500000)
         InitialDelayRange=(Min=1.150000,Max=1.150000)
         StartVelocityRange=(Y=(Min=50.000000,Max=150.000000))
         StartVelocityRadialRange=(Min=-450.000000,Max=-600.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(5)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=128))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=122,G=5,R=55))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=5
         StartLocationOffset=(X=-4.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'EpicParticles.Flares.BurnFlare1'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(6)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter89
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(RelativeTime=1.000000,Color=(B=245,G=145,R=101,A=150))
         FadeOutStartTime=0.200000
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=2.500000,Max=2.500000)
         InitialDelayRange=(Min=0.700000,Max=0.700000)
     End Object
     Emitters(7)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter89'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter90
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(RelativeTime=1.000000,Color=(B=245,G=145,R=101,A=150))
         FadeOutStartTime=0.200000
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=2.500000,Max=2.500000)
         InitialDelayRange=(Min=1.100000,Max=1.100000)
     End Object
     Emitters(8)=SpriteEmitter'tk_FHIWeapons.GrenadePPGExplosionNEW.SpriteEmitter90'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     AmbientSound=Sound'IndoorAmbience.electricity2'
     Style=STY_Masked
     SoundVolume=255
     SoundRadius=200.000000
     bDirectional=True
}