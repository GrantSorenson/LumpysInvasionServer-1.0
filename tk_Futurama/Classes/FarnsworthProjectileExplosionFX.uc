class FarnsworthProjectileExplosionFX extends Emitter
    placeable;

defaultproperties{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter93
        UseColorScale=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(G=255))
        MaxParticles=1
        Name="SpriteEmitter93"
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EpicParticles.Flares.SoftFlare'
        LifetimeRange=(Min=0.700000,Max=0.700000)
    End Object
    Emitters(0)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter93'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter94
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=0.100000,Color=(G=255,R=217))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=34,G=255,R=89))
        ColorScale(3)=(RelativeTime=1.000000,Color=(G=255))
        Opacity=0.300000
        FadeOutStartTime=0.555100
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        Name="SpriteEmitter94"
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=60.000000,Max=65.000000),Y=(Min=80.000000,Max=85.000000),Z=(Min=80.000000,Max=85.000000))
        InitialParticlesPerSecond=20.000000
        Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectCore2a'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=1.000000
    End Object
    Emitters(1)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter94'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter95
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=255,R=172))
        ColorScale(2)=(RelativeTime=1.000000,Color=(G=255))
        MaxParticles=1
        Name="SpriteEmitter95"
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_Darken
        Texture=Texture'AW-2004Particles.Energy.JumpDuck'
        LifetimeRange=(Min=0.600000,Max=0.600000)
    End Object
    Emitters(2)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter95'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter96
        UseColorScale=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(1)=(RelativeTime=0.200000,Color=(G=255,R=255))
        ColorScale(2)=(RelativeTime=0.800000,Color=(G=255))
        ColorScale(3)=(RelativeTime=1.000000)
        Opacity=0.500000
        MaxParticles=1
        Name="SpriteEmitter96"
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
        InitialParticlesPerSecond=500.000000
        Texture=Texture'AW-2004Particles.Energy.SmoothRing'
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(3)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter96'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter98
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=0.696429,Color=(G=255,R=134))
        ColorScale(2)=(RelativeTime=1.000000)
        MaxParticles=1
        Name="SpriteEmitter98"
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        InitialParticlesPerSecond=2000.000000
        Texture=Texture'AW-2004Particles.Fire.BlastMark'
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(4)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter98'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter99
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=0.100000,Color=(G=255))
        ColorScale(2)=(RelativeTime=0.800000,Color=(G=255,R=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(G=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=6
        Name="SpriteEmitter99"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=30.000000,Max=30.000000)
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRadialRange=(Min=50.000000,Max=80.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
    End Object
    Emitters(5)=SpriteEmitter'FarnsworthProjectileExplosionFX.SpriteEmitter99'

    // bDirectional=False
    // bSelected=True
    AutoDestroy=True
    bNoDelete=False
    RemoteRole=ROLE_SimulatedProxy
    bHardAttach=True
    lifespan=0.5
}