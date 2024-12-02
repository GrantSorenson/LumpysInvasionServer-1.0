class GrenadeConcExplosionNEW extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=15.000000)
         ColorScale(0)=(Color=(B=219,G=216,R=195))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=219,G=196,R=195))
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
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.SpriteEmitter15'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter19
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-200.000000)
         ColorScale(0)=(Color=(B=255,G=234,R=248))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=255,G=242,R=251))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=75
         DetailMode=DM_High
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=-25.000000,Max=25.000000)
         StartLocationPolarRange=(Z=(Min=8.000000,Max=16.000000))
         RotationOffset=(Yaw=16384)
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=5.000000,Max=15.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=50.000000,Max=100.000000))
         StartVelocityRadialRange=(Min=-100.000000,Max=-200.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.SpriteEmitter19'

     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingB'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=115,G=115,R=115))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=141,G=141,R=141))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=219,G=196,R=195))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.750000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         MaxParticles=1
         StartLocationRange=(Z=(Max=64.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=MeshEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.MeshEmitter7'

     Begin Object Class=MeshEmitter Name=MeshEmitter8
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingC'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=96,G=96,R=96))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=144,G=144,R=144))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=219,G=196,R=195))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         MaxParticles=1
         StartLocationRange=(Z=(Max=64.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(3)=MeshEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.MeshEmitter8'

     Begin Object Class=MeshEmitter Name=MeshEmitter9
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingB'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=95,G=95,R=95))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=131,G=131,R=131))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=219,G=196,R=195))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         MaxParticles=1
         StartLocationRange=(Z=(Max=64.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(4)=MeshEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.MeshEmitter9'

     Begin Object Class=MeshEmitter Name=MeshEmitter10
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.ExplodeRingC'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=91,G=91,R=91))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=136,G=136,R=136))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=219,G=196,R=195))
         ColorScale(3)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         MaxParticles=1
         StartLocationRange=(Z=(Max=64.000000))
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.600000,Max=0.600000)
     End Object
     Emitters(5)=MeshEmitter'tk_FHIWeapons.GrenadeConcExplosionNEW.MeshEmitter10'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Style=STY_Masked
     bDirectional=True
}