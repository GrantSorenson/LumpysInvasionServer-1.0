class DragonBreathTrail extends DragonEmitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.6,false);
}

simulated function Timer()
{
	Super.Timer();
	Emitters[0].RespawnDeadParticles = false;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=2.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.500000)
         StartVelocityRange=(X=(Min=600.000000,Max=600.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_2009Dragonv2.DragonBreathTrail.SpriteEmitter0'

     LifeSpan=1.000000
}
