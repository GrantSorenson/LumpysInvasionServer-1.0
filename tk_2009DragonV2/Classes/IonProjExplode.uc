class IonProjExplode extends DragonProjExplode;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Scale
         FadeOut=True
         RespawnDeadParticles=False
         UniformMeshScale=False
         UseRevolution=True
         UseRevolutionScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.800000),Y=(Min=0.000000,Max=0.000000))
         MaxParticles=75
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=20.000000,Max=20.000000)
         MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
         MeshScaleRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         RevolutionsPerSecondRange=(Z=(Min=0.100000,Max=0.100000))
         RevolutionScale(0)=(RelativeRevolution=(Z=10.000000))
         RevolutionScale(1)=(RelativeTime=1.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.800000,RelativeSize=5.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=4000.000000
         Texture=Texture'EpicParticles.Smoke.SparkCloud_01aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
         StartVelocityRadialRange=(Min=-0.800000,Max=-1.000000)
         VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(1)=(RelativeTime=0.500000)
         VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=1000.000000,Y=1000.000000,Z=300.000000))
         VelocityScale(3)=(RelativeTime=1.000000,RelativeVelocity=(X=100.000000,Y=100.000000,Z=50.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.IonProjExplode.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=128,G=30,R=80))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=180,G=50,R=180))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=180,G=50,R=140))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=2
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=200.000000,Max=200.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.IonProjExplode.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=80,R=200))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=40,R=200))
         FadeInEndTime=0.100000
         MaxParticles=2
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.700000,RelativeSize=2.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.Flares.BurnFlare1'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.IonProjExplode.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=242,G=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=209,G=5,R=194))
         FadeOutStartTime=0.600000
         FadeInEndTime=0.200000
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=128.000000,Max=128.000000)
         StartSpinRange=(X=(Min=0.500000,Max=0.500000))
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.800000,Max=0.800000)
         StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'tk_2009Dragonv2.IonProjExplode.SpriteEmitter3'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         MaxParticles=3
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(Z=(Min=0.200000,Max=0.200000))
         InitialParticlesPerSecond=50000.000000
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(4)=MeshEmitter'tk_2009Dragonv2.IonProjExplode.MeshEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SizeScale(1)=(RelativeTime=0.400000,RelativeSize=0.400000)
         SizeScale(2)=(RelativeTime=0.800000,RelativeSize=0.600000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=2.000000)
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(5)=MeshEmitter'tk_2009Dragonv2.IonProjExplode.MeshEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Scale
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-0.000050,Max=0.000050)
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.200000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=25.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRadialRange=(Min=-1000.000000,Max=-1000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(1)=(RelativeTime=0.050000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=0.100000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(3)=(RelativeTime=0.500000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(4)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=5.000000,Z=5.000000))
     End Object
     Emitters(6)=SpriteEmitter'tk_2009Dragonv2.IonProjExplode.SpriteEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'VMStructures.CoreBreachGroup.coreLightning1'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000))
         MaxParticles=5
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.200000),Z=(Min=0.200000))
         StartSpinRange=(Z=(Min=2.000000,Max=5.000000))
         SizeScale(1)=(RelativeTime=0.400000,RelativeSize=0.100000)
         SizeScale(2)=(RelativeTime=0.600000,RelativeSize=0.200000)
         SizeScale(3)=(RelativeTime=0.800000,RelativeSize=2.000000)
         SizeScale(4)=(RelativeTime=1.000000,RelativeSize=2.000000)
         InitialParticlesPerSecond=100.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=0.350000,Max=0.350000)
     End Object
     Emitters(7)=MeshEmitter'tk_2009Dragonv2.IonProjExplode.MeshEmitter2'

}
