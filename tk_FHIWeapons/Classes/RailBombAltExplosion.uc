class RailBombAltExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RailBombDebris'
         UseMeshBlendMode=False
         UseParticleColor=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         DetailMode=DM_High
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(Y=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=500.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=700.000000,Max=800.000000))
     End Object
     Emitters(0)=MeshEmitter'tk_FHIWeapons.RailBombAltExplosion.MeshEmitter5'

     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RailBombDebris'
         UseParticleColor=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-400.000000)
         MaxParticles=15
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=8.000000,Max=8.000000)
         SpinsPerSecondRange=(X=(Max=0.200000),Y=(Max=0.200000),Z=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRadialRange=(Min=300.000000,Max=800.000000)
         VelocityLossRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=MeshEmitter'tk_FHIWeapons.RailBombAltExplosion.MeshEmitter6'

     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RailBombDebris'
         RenderTwoSided=True
         UseParticleColor=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-800.000000)
         MaxParticles=15
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=8.000000,Max=8.000000)
         SpinsPerSecondRange=(X=(Max=0.200000),Y=(Max=0.200000),Z=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(Z=(Min=100.000000,Max=300.000000))
         StartVelocityRadialRange=(Min=300.000000,Max=800.000000)
         VelocityLossRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=MeshEmitter'tk_FHIWeapons.RailBombAltExplosion.MeshEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
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
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,R=175))
         ColorScale(2)=(RelativeTime=0.330000,Color=(B=235,R=165,A=175))
         ColorScale(3)=(RelativeTime=0.750000,Color=(B=235,R=155,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=235,R=155))
         MaxParticles=15
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
         StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.RailBombAltExplosion.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
}
