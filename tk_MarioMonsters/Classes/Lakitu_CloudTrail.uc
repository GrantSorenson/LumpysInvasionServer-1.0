class Lakitu_CloudTrail extends MM_Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.500000
         FadeOutStartTime=0.800000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=50.000000,Max=70.000000),Z=(Min=50.000000,Max=70.000000))
         ScaleSizeByVelocityMultiplier=(X=0.150000,Y=0.100000,Z=0.100000)
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=1.500000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_MarioMonsters.Lakitu_CloudTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.200000
         MaxParticles=25
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000))
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         LifetimeRange=(Min=0.200000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'tk_MarioMonsters.Lakitu_CloudTrail.SpriteEmitter2'

}
