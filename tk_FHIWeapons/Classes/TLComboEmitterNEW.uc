class TLComboEmitterNEW extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter29
         UseColorScale=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=47,G=184,R=223))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=101,G=167,R=226))
         Opacity=0.500000
         MaxParticles=1
         StartSizeRange=(X=(Min=400.000000,Max=400.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         InitialDelayRange=(Min=0.000001,Max=0.000001)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter29'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AlphaTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=32,G=137,R=193))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=94,G=198,R=213))
         FadeOutStartTime=0.200000
         FadeInEndTime=0.200000
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=24.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'tk_FHIWeapons.FHITex.ExplodeRing_C'
         LifetimeRange=(Min=1.500000,Max=1.500000)
         InitialDelayRange=(Min=0.150000,Max=0.150000)
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter10'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AlphaTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=54,G=155,R=209))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=56,G=200,R=207))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.200000
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=26.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=750.000000
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=1.500000,Max=1.500000)
     End Object
     Emitters(2)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter16'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter21
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=75,G=152,R=222))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=35,G=194,R=207))
         FadeOutStartTime=1.000000
         FadeInEndTime=0.100000
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=80.000000,Max=80.000000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=1.500000,Max=1.500000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
         StartVelocityRadialRange=(Min=120.000000,Max=120.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter21'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter22
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=74,G=138,R=208))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=70,G=219,R=211))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=225.000000,Max=225.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=2.500000,Max=2.500000)
     End Object
     Emitters(4)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter22'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter23
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=40,G=168,R=210))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=36,G=204,R=208))
         FadeOutStartTime=0.250000
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=50.000000,Max=50.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000),Y=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Fire.SmallBang'
         LifetimeRange=(Min=1.250000,Max=1.250000)
         StartVelocityRadialRange=(Min=-350.000000,Max=-350.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(5)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter23'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter24
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=125,G=191,R=240))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=86,G=209,R=226))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=39,G=125,R=220))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=18,G=18,R=107))
         MaxParticles=2
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=15.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(6)=SpriteEmitter'tk_FHIWeapons.TLComboEmitterNEW.SpriteEmitter24'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Style=STY_Masked
     bDirectional=True
}
