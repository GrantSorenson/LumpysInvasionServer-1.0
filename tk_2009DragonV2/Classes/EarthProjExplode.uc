class EarthProjExplode extends DragonProjExplode;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseVelocityScale=True
         ColorMultiplierRange=(Y=(Min=0.950000,Max=0.950000),Z=(Min=0.900000,Max=0.900000))
         Opacity=0.300000
         FadeOutStartTime=-0.700000
         StartLocationShape=PTLS_All
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Smoke.StellarFog1aw'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         VelocityScale(0)=(RelativeVelocity=(X=15.000000,Y=15.000000,Z=15.000000))
         VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=-15.000000,Y=-15.000000,Z=-15.000000))
         VelocityScale(2)=(RelativeTime=0.600000,RelativeVelocity=(X=15.000000,Y=15.000000,Z=15.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.EarthProjExplode.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Opacity=0.500000
         FadeOutStartTime=-2.000000
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         VelocityScale(0)=(RelativeVelocity=(X=3.000000,Y=3.000000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=4.000000,Y=4.000000,Z=3.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=3.000000,Y=3.000000,Z=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.EarthProjExplode.SpriteEmitter5'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'tk_2009Dragonv2.EarthRock'
         UseCollision=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-20.000000,Max=20.000000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.800000,RelativeSize=1.000000)
         SizeScale(3)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.100000,Max=0.200000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.800000,Max=2.000000)
         StartVelocityRadialRange=(Min=-500.000000,Max=-500.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=MeshEmitter'tk_2009Dragonv2.EarthProjExplode.MeshEmitter0'

}
