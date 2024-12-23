class ElectricProjTrail extends DragonProjTrail;

var Material ElectricSkins[4];

simulated function PostBeginPlay()
{
	TrailEmitter(Emitters[0]).Texture = Texture(ElectricSkins[Rand(4)]);

	Super.PostBeginPlay();
}

defaultproperties
{
     ElectricSkins(0)=Texture'tk_2009Dragonv2.SFX.LightningBolt01'
     ElectricSkins(1)=Texture'tk_2009Dragonv2.SFX.LightningBolt02'
     ElectricSkins(2)=Texture'tk_2009Dragonv2.SFX.LightningBolt03'
     ElectricSkins(3)=Texture'tk_2009Dragonv2.SFX.LightningBolt04'
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_PointLife
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=10.000000
         UseCrossedSheets=True
         MaxTrailTwistAngle=1684
         PointLifeTime=0.400000
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         MaxParticles=20
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'tk_2009Dragonv2.SFX.LightningBolt04'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=TrailEmitter'tk_2009Dragonv2.ElectricProjTrail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         StartSpinRange=(X=(Min=2.000000,Max=5.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'tk_2009Dragonv2.SFX.Electric02'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.ElectricProjTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'tk_2009Dragonv2.SFX.Electric02'
         LifetimeRange=(Min=1.500000,Max=1.500000)
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.ElectricProjTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectCore2a'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(3)=SpriteEmitter'tk_2009Dragonv2.ElectricProjTrail.SpriteEmitter2'

}
