class Boo_InvisEffect extends MM_Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=100.000000)
         Opacity=0.400000
         MaxParticles=5
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=20.000000)
         StartLocationPolarRange=(X=(Min=-32768.000000,Max=32768.000000),Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=-10.000000,Max=10.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=50.000000),Y=(Min=50.000000,Max=70.000000),Z=(Min=50.000000,Max=70.000000))
         ScaleSizeByVelocityMultiplier=(X=0.150000,Y=0.100000,Z=0.100000)
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=1.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         StartVelocityRadialRange=(Min=50.000000,Max=50.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_MarioMonsters.Boo_InvisEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=113))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         ColorMultiplierRange=(X=(Max=0.950000))
         Opacity=0.500000
         MaxParticles=25
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=20.000000,Max=50.000000)
         StartLocationPolarRange=(X=(Min=-16384.000000,Max=16384.000000),Y=(Min=-16384.000000,Max=16384.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=8.000000,Max=15.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.200000,Max=0.750000)
         StartVelocityRadialRange=(Min=20.000000,Max=50.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=SpriteEmitter'tk_MarioMonsters.Boo_InvisEffect.SpriteEmitter2'

}