class HVBombExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=15.000000)
         ColorScale(0)=(Color=(B=51,G=152,R=200))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=48,G=91,R=222))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=40
         StartLocationRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000),Z=(Min=-32.000000,Max=32.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=48.000000,Max=48.000000)
         MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleBomb'
         MeshScaleRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.700000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.HVBombExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=150.000000)
         ColorScale(0)=(Color=(G=255,R=255,A=128))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=47,G=80,R=179,A=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(A=80))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=20
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=48.000000,Max=48.000000)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.700000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000))
         InitialParticlesPerSecond=80.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Smoke.Smokepuff'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.700000,Max=0.700000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.HVBombExplosion.SpriteEmitter2'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingB'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=255,R=255,A=128))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=47,G=80,R=179,A=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(A=80))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.850000
         FadeInEndTime=0.200000
         MaxParticles=1
         DetailMode=DM_High
         StartLocationRange=(Z=(Min=20.000000,Max=20.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.100000,Max=1.100000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=MeshEmitter'tk_FHIWeapons.HVBombExplosion.MeshEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingC'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=255,R=255,A=128))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=47,G=80,R=179,A=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(A=80))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.850000
         FadeInEndTime=0.200000
         MaxParticles=1
         DetailMode=DM_High
         StartLocationRange=(Z=(Min=-20.000000,Max=-20.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.100000,Max=1.100000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(3)=MeshEmitter'tk_FHIWeapons.HVBombExplosion.MeshEmitter1'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     bHardAttach=True
}