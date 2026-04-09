class FarnsworthProjectileFX extends Emitter
    placeable;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter49
        UseDirectionAs=PTDU_Scale
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ColorScale(0)=(Color=(B=64,G=32))
        ColorScale(1)=(Color=(B=108,G=210,R=141))
        ColorScale(2)=(RelativeTime=0.800000,Color=(B=108,G=210,R=141))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=64,G=32))
        ColorMultiplierRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=150.000000)
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=110.000000,Max=110.000000))
        InitialParticlesPerSecond=8000.000000
        Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=2.000000
    End Object
    Emitters(0)=SpriteEmitter'FarnsworthProjectileFX.SpriteEmitter49'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter50
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ColorScale(0)=(Color=(B=32,G=255,R=128))
        ColorScale(1)=(RelativeTime=0.700000,Color=(B=32,G=255,R=128))
        ColorScale(2)=(RelativeTime=0.800000)
        ColorScale(3)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        MaxParticles=20
        StartLocationOffset=(X=150.000000)
        SpinsPerSecondRange=(X=(Max=0.200000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
        StartSizeRange=(X=(Min=25.000000,Max=35.000000))
        Texture=Texture'AW-2004Particles.Weapons.PlasmaFlare'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=-500.000000,Max=-500.000000))
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=2.000000
    End Object
    Emitters(1)=SpriteEmitter'FarnsworthProjectileFX.SpriteEmitter50'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        UseRevolution=True
        UseRevolutionScale=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=20
        Name="SpriteEmitter2"
        StartLocationRange=(X=(Min=150.000000,Max=150.000000))
        StartLocationShape=PTLS_All
        SphereRadiusRange=(Min=2.000000,Max=5.000000)
        RevolutionCenterOffsetRange=(X=(Max=150.000000))
        RevolutionsPerSecondRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=-1.250000,Max=1.250000),Z=(Min=-1.500000,Max=1.500000))
        RevolutionScale(0)=(RelativeRevolution=(X=1.000000,Y=1.000000,Z=1.000000))
        RevolutionScale(1)=(RelativeTime=0.500000,RelativeRevolution=(X=0.700000,Y=0.700000,Z=0.700000))
        RevolutionScale(2)=(RelativeTime=1.000000)
        SpinsPerSecondRange=(X=(Max=0.500000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=30.000000))
        Texture=Texture'AW-2004Particles.Weapons.HardSpot'
        LifetimeRange=(Min=0.200000,Max=0.500000)
        StartVelocityRadialRange=(Min=150.000000,Max=300.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'FarnsworthProjectileFX.SpriteEmitter2'

    // bDirectional=True
    // bSelected=True
    AutoDestroy=True
    bNoDelete=False
    RemoteRole=ROLE_SimulatedProxy
    bHardAttach=True
}