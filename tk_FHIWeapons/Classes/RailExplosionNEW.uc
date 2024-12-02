class RailExplosionNEW extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AlphaTest=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=249,G=106,R=196))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=141,G=41,R=112))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.100000
         MaxParticles=1
         StartSpinRange=(X=(Min=0.010000,Max=0.030000))
         StartSizeRange=(X=(Min=120.000000,Max=120.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.650000,Max=0.650000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.RailExplosionNEW.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=244,G=89,R=171))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=139,G=54,R=122))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.075000
         MaxParticles=1
         SizeScale(0)=(RelativeSize=-0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=1.050000,Max=1.050000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.RailExplosionNEW.SpriteEmitter4'

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
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRadialRange=(Min=-100.000000,Max=-400.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=SpriteEmitter'tk_FHIWeapons.RailExplosionNEW.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
}
