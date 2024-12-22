class BeamBreathTrail extends DragonBreathTrail;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=130,G=192,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255))
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=2.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'EpicParticles.Flares.Rev_Particle1'
         LifetimeRange=(Min=0.400000,Max=0.500000)
         StartVelocityRange=(X=(Min=600.000000,Max=600.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.BeamBreathTrail.SpriteEmitter0'

}
