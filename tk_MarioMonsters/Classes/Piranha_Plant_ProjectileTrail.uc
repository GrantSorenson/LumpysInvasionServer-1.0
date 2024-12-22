class Piranha_Plant_ProjectileTrail extends MM_Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=3.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.200000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'tk_MarioMonsters.Piranha_Plant_ProjectileTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.200000
         MaxParticles=30
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=30.000000,Max=40.000000))
         Texture=Texture'AW-2004Explosions.Fire.Fireball3'
         LifetimeRange=(Min=0.200000,Max=0.400000)
     End Object
     Emitters(1)=SpriteEmitter'tk_MarioMonsters.Piranha_Plant_ProjectileTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(G=255,R=255))
         ColorScale(1)=(RelativeTime=0.250000,Color=(R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(R=255))
         Opacity=0.750000
         MaxParticles=30
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=60.000000,Max=60.000000))
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.250000,Max=0.400000)
     End Object
     Emitters(2)=SpriteEmitter'tk_MarioMonsters.Piranha_Plant_ProjectileTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         Acceleration=(Z=-20.000000)
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.700000,Color=(R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(R=255))
         ColorMultiplierRange=(Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         MaxParticles=3
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=25.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=15.000000,Max=20.000000))
         Texture=Texture'AWGlobal.Coronas.FogFlare01aw'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-5.000000,Max=5.000000))
         StartVelocityRadialRange=(Min=100.000000,Max=100.000000)
         VelocityScale(0)=(RelativeVelocity=(X=10.000000,Y=10.000000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=10.000000))
     End Object
     Emitters(3)=SpriteEmitter'tk_MarioMonsters.Piranha_Plant_ProjectileTrail.SpriteEmitter3'

}
