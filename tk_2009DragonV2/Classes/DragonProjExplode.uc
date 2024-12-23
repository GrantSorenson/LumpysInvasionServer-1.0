class DragonProjExplode extends DragonEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=2.000000)
         Opacity=0.600000
         MaxParticles=5
         StartSpinRange=(X=(Min=5.000000,Max=2.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Fire.NapalmSpot'
         LifetimeRange=(Min=0.800000,Max=1.000000)
         StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Max=2.000000))
         VelocityScale(0)=(RelativeVelocity=(X=2.500000,Y=2.500000,Z=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=10.000000,Y=10.000000,Z=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.DragonProjExplode.SpriteEmitter15'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter17
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorMultiplierRange=(Y=(Min=0.800000,Max=0.800000),Z=(Min=0.200000,Max=0.200000))
         StartLocationOffset=(Z=-5.000000)
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=-5.000000,Max=5.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=0.800000,Max=1.000000)
         StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
         VelocityScale(0)=(RelativeVelocity=(X=10.000000,Y=10.000000,Z=50.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=20.000000,Y=20.000000,Z=-5.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.DragonProjExplode.SpriteEmitter17'

}
