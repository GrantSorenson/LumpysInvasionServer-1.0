class DragonProjTrail extends DragonEmitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_PointLife
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         PointLifeTime=0.800000
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=13,G=170,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
         Opacity=0.500000
         MaxParticles=1
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Weapons.TrailBlur'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=500.000000,Max=500.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_2009Dragonv2.DragonProjTrail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(RelativeTime=1.000000,Color=(R=128))
         ColorMultiplierRange=(X=(Min=0.500000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SpinsPerSecondRange=(X=(Min=3.000000,Max=3.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         SizeScaleRepeats=0.500000
         Texture=Texture'AW-2004Particles.Energy.ElecPanels'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=10.000000,Max=10.000000)
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.DragonProjTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(RelativeTime=1.000000,Color=(B=61,G=156,R=203))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=2.000000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=2.000000,RelativeSize=4.000000)
         Texture=Texture'AW-2004Particles.Fire.GrenadeTest'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=5.000000,Max=5.000000)
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.DragonProjTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(RelativeTime=1.000000,Color=(G=50,R=155))
         MaxParticles=15
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Smoke.Smokepuff'
         LifetimeRange=(Min=1.000000,Max=2.000000)
     End Object
     Emitters(3)=SpriteEmitter'tk_2009Dragonv2.DragonProjTrail.SpriteEmitter2'

}
