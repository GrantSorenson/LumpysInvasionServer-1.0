class IonProjTrail extends DragonProjTrail;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         DistanceThreshold=100.000000
         UseCrossedSheets=True
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'tk_2009Dragonv2.SFX.IonDragonBeam'
         LifetimeRange=(Min=0.800000,Max=0.800000)
     End Object
     Emitters(0)=TrailEmitter'tk_2009Dragonv2.IonProjTrail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'XEffectMat.Shock.shock_core'
         LifetimeRange=(Min=0.000001,Max=0.000001)
     End Object
     Emitters(1)=SpriteEmitter'tk_2009Dragonv2.IonProjTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000))
         MaxParticles=20
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000))
         SizeScale(0)=(RelativeSize=3.800000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
         LifetimeRange=(Min=0.600000,Max=0.600000)
     End Object
     Emitters(2)=SpriteEmitter'tk_2009Dragonv2.IonProjTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.500000,Max=0.500000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000))
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=10.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=1.000000,Max=1.500000)
     End Object
     Emitters(3)=SpriteEmitter'tk_2009Dragonv2.IonProjTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.200000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'XEffectMat.Shock.shock_ring_b'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(4)=SpriteEmitter'tk_2009Dragonv2.IonProjTrail.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Weapons.LargeSpot'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(5)=SpriteEmitter'tk_2009Dragonv2.IonProjTrail.SpriteEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
         UseParticleColor=True
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSizeRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         LifetimeRange=(Min=0.000001,Max=0.000001)
         InitialDelayRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(6)=MeshEmitter'tk_2009Dragonv2.IonProjTrail.MeshEmitter0'

}
