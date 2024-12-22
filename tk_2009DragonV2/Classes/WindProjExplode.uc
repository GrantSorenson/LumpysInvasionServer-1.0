class WindProjExplode extends DragonProjExplode;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseVelocityScale=True
         ColorMultiplierRange=(X=(Max=0.900000))
         Opacity=0.200000
         StartLocationShape=PTLS_All
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Smoke.SparkCloud_01aw'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         VelocityScale(0)=(RelativeVelocity=(X=15.000000,Y=15.000000,Z=15.000000))
         VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=-15.000000,Y=-15.000000,Z=-15.000000))
         VelocityScale(2)=(RelativeTime=0.600000,RelativeVelocity=(X=15.000000,Y=15.000000,Z=15.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.WindProjExplode.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=20.000000)
         Opacity=0.500000
         FadeOutStartTime=-2.000000
         MaxParticles=5
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=6.000000)
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
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.WindProjExplode.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=100.000000)
         ColorMultiplierRange=(X=(Max=0.990000))
         Opacity=0.050000
         MaxParticles=50
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=0.200000,Max=0.200000)
         StartVelocityRadialRange=(Min=-1000.000000,Max=-1000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(1)=(RelativeTime=0.050000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=0.100000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(3)=(RelativeTime=0.500000,RelativeVelocity=(X=0.010000,Y=0.010000,Z=0.010000))
         VelocityScale(4)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=5.000000))
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.WindProjExplode.SpriteEmitter12'

}
