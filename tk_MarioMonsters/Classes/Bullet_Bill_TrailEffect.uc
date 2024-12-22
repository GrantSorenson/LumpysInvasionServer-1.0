class Bullet_Bill_TrailEffect extends MM_Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=5.000000)
         ColorMultiplierRange=(Y=(Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=3.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'tk_MarioMonsters.Bullet_Bill_TrailEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.200000
         MaxParticles=15
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000))
         Texture=Texture'AW-2004Explosions.Fire.Fireball3'
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_MarioMonsters.Bullet_Bill_TrailEffect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.350000
         MaxParticles=30
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000))
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'tk_MarioMonsters.Bullet_Bill_TrailEffect.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=200.000000)
         Opacity=0.500000
         MaxParticles=5
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=2.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(3)=SpriteEmitter'tk_MarioMonsters.Bullet_Bill_TrailEffect.SpriteEmitter3'

     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailLocation=PTTL_FollowEmitter
         DistanceThreshold=200.000000
         UseColorScale=True
         FadeOut=True
         ColorScale(0)=(Color=(R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=25.000000)
         StartSizeRange=(X=(Min=1.000000,Max=5.000000))
         Texture=Texture'AW-2004Particles.Weapons.SoftFade'
         LifetimeRange=(Min=0.250000,Max=0.750000)
     End Object
     Emitters(4)=TrailEmitter'tk_MarioMonsters.Bullet_Bill_TrailEffect.TrailEmitter0'

}
