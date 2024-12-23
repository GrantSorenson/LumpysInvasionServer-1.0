class WindDragonExplode extends DragonExplode;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter19
         UseDirectionAs=PTDU_Forward
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorMultiplierRange=(X=(Min=0.800000,Max=0.800000),Y=(Max=0.800000))
         Opacity=0.200000
         FadeOutStartTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=100
         StartLocationRange=(Z=(Min=-1.000000,Max=1.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-5.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=30000.000000
         Texture=Texture'EpicParticles.Smoke.Maelstrom01aw'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRadialRange=(Min=-1000.000000,Max=-1000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(1)=(RelativeTime=0.050000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=0.100000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(3)=(RelativeTime=0.500000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(4)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=5.000000,Z=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.WindDragonExplode.SpriteEmitter19'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter20
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=10.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=8.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.800000,Max=0.800000)
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.WindDragonExplode.SpriteEmitter20'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter21
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseVelocityScale=True
         Opacity=0.300000
         CoordinateSystem=PTCS_Relative
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=1.000000)
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.200000))
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=0.800000,RelativeSize=10.000000)
         SizeScale(3)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'tk_2009Dragonv2.SFX.RingFX01'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRadialRange=(Min=-1000.000000,Max=-1000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.020000,Y=0.020000,Z=0.020000))
         VelocityScale(2)=(RelativeTime=0.500000,RelativeVelocity=(X=0.001000,Y=0.001000,Z=0.001000))
         VelocityScale(3)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=5.000000,Z=5.000000))
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.WindDragonExplode.SpriteEmitter21'

}
