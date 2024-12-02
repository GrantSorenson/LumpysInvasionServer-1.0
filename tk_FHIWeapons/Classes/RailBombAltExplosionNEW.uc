class RailBombAltExplosionNEW extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RailBombDebris'
         UseParticleColor=True
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-500.000000)
         ExtentMultiplier=(X=0.100000,Y=0.100000,Z=2.000000)
         DampingFactorRange=(X=(Min=0.500000,Max=0.750000),Y=(Min=0.500000,Max=0.750000),Z=(Min=0.250000,Max=0.250000))
         ColorScale(0)=(Color=(B=243,G=118,R=193))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=152,G=63,R=130))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=20
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-8.000000,Max=8.000000)
         SpinsPerSecondRange=(X=(Max=0.200000),Y=(Max=0.200000),Z=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRadialRange=(Min=200.000000,Max=500.000000)
         VelocityLossRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(0)=MeshEmitter'tk_FHIWeapons.RailBombAltExplosionNEW.MeshEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseColorScale=True
         FadeOut=True
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
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=244,G=119,R=201))
         ColorScale(2)=(RelativeTime=0.400000,Color=(B=255,G=53,R=194,A=175))
         ColorScale(3)=(RelativeTime=0.800000,Color=(B=166,R=107,A=255))
         ColorScale(4)=(RelativeTime=1.000000)
         FadeOutStartTime=0.700000
         MaxParticles=25
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=-16384)
         SpinsPerSecondRange=(X=(Max=0.250000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.750000)
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Energy.ElecPanelsP'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRadialRange=(Min=-100.000000,Max=-100.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.500000,Y=0.500000,Z=0.500000))
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.RailBombAltExplosionNEW.SpriteEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=240,G=123,R=188))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=147,G=57,R=116))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         FadeInEndTime=0.050000
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         StartSpinRange=(X=(Min=0.010000,Max=0.030000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.850000)
         StartSizeRange=(X=(Min=120.000000,Max=120.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         LifetimeRange=(Min=2.000000,Max=2.500000)
     End Object
     Emitters(2)=SpriteEmitter'tk_FHIWeapons.RailBombAltExplosionNEW.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-600.000000)
         ColorScale(0)=(Color=(B=245,G=131,R=200))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=157,G=60,R=123))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=15
         DetailMode=DM_High
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=32.000000)
         StartSizeRange=(X=(Min=4.000000,Max=6.000000),Y=(Min=20.000000,Max=25.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         LifetimeRange=(Min=0.650000,Max=0.650000)
         StartVelocityRadialRange=(Min=-200.000000,Max=-500.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.RailBombAltExplosionNEW.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
}
