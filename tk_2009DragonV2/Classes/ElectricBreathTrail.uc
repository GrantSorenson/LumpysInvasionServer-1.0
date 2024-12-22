class ElectricBreathTrail extends DragonBreathTrail;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.900000,Max=0.900000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=2.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'tk_2009Dragonv2.SFX.Electric02'
         LifetimeRange=(Min=0.400000,Max=0.500000)
         StartVelocityRange=(X=(Min=600.000000,Max=600.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.ElectricBreathTrail.SpriteEmitter0'

}
