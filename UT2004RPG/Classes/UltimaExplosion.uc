class UltimaExplosion extends Emitter
	placeable;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.330000)
        ColorScale(2)=(RelativeTime=0.660000,Color=(B=15,G=255,R=51))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=40
        RespawnDeadParticles=False
        StartLocationOffset=(Z=-64.000000)
        MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
        MeshSpawning=PTMS_Linear
        MeshScaleRange=(Z=(Min=2.000000,Max=2.000000))
        UniformMeshScale=False
        UseRevolution=True
        RevolutionsPerSecondRange=(Z=(Min=-0.200000,Max=0.200000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=16.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=4000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Smoke.Smokepuff2'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-1.000000,Max=-1.000000)
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(1)=(RelativeTime=0.500000)
        VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=3000.000000,Y=3000.000000,Z=1000.000000))
        VelocityScale(3)=(RelativeTime=1.000000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter0"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.330000)
        ColorScale(2)=(RelativeTime=0.660000,Color=(G=255,R=128,A=190))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=60
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=64.000000,Max=128.000000)
        MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
        MeshScaleRange=(Z=(Min=2.000000,Max=2.000000))
        UniformMeshScale=False
        UseRevolution=True
        RevolutionsPerSecondRange=(Z=(Min=-0.200000,Max=0.200000))
        SpinParticles=True
        StartSpinRange=(X=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=16.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=4000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Smoke.Smokepuff2'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=1.000000,Max=1.000000)
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(1)=(RelativeTime=0.500000)
        VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=-3000.000000,Y=-3000.000000,Z=-1000.000000))
        VelocityScale(3)=(RelativeTime=1.000000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter1"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.330000,Color=(B=60,G=60,R=60,A=100))
        ColorScale(2)=(RelativeTime=0.660000,Color=(B=80,G=80,R=80,A=255))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=150
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=128.000000,Max=128.000000)
        MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
        MeshScaleRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
        UniformMeshScale=False
        UseRevolution=True
        RevolutionsPerSecondRange=(Z=(Min=0.100000,Max=0.100000))
        UseRevolutionScale=True
        RevolutionScale(0)=(RelativeRevolution=(Z=10.000000))
        RevolutionScale(1)=(RelativeTime=1.000000)
        SpinParticles=True
        StartSpinRange=(X=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=16.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=50.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=4000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EpicParticles.Smoke.Smokepuff'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        InitialDelayRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-0.800000,Max=-1.000000)
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(1)=(RelativeTime=0.500000)
        VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=3000.000000,Y=3000.000000,Z=1000.000000))
        VelocityScale(3)=(RelativeTime=1.000000,RelativeVelocity=(X=300.000000,Y=300.000000,Z=100.000000))
        SecondsBeforeInactive=0
        Name="SpriteEmitter2"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.330000)
        ColorScale(2)=(RelativeTime=0.660000,Color=(B=15,G=255,R=51))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=50
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=64.000000,Max=128.000000)
        MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
        MeshScaleRange=(X=(Min=1.500000,Max=1.500000),Y=(Min=1.500000,Max=1.500000))
        UniformMeshScale=False
        UseRevolution=True
        RevolutionsPerSecondRange=(Z=(Min=-0.200000,Max=0.200000))
        UseRevolutionScale=True
        RevolutionScale(0)=(RelativeRevolution=(Z=1.000000))
        RevolutionScale(1)=(RelativeTime=1.000000)
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=16.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=4000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Smoke.Smokepuff2'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-1.000000,Max=-1.000000)
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(1)=(RelativeTime=0.500000)
        VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=2000.000000,Y=2000.000000,Z=500.000000))
        VelocityScale(3)=(RelativeTime=1.000000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter3"
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionRing'
        UseParticleColor=True
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=55,G=255,R=55))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=0,G=255,R=0))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=1
        RespawnDeadParticles=False
        StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Smoke.FlameGradient'
        LifetimeRange=(Min=1.000000,Max=1.000000)
        InitialDelayRange=(Min=1.000000,Max=1.000000)
        SecondsBeforeInactive=0
        Name="MeshEmitter0"
    End Object
    Emitters(4)=MeshEmitter'MeshEmitter0'
    Begin Object Class=MeshEmitter Name=MeshEmitter1
        StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionSphere'
        RenderTwoSided=True
        UseParticleColor=True
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=0,G=255,R=0,A=255))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=0,G=255,R=0,A=128))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=1
        RespawnDeadParticles=False
        SpinsPerSecondRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=18.000000)
        StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
        UniformSize=True
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EpicParticles.Smoke.FlameGradient'
        LifetimeRange=(Min=0.750000,Max=0.750000)
        InitialDelayRange=(Min=1.500000,Max=1.500000)
        SecondsBeforeInactive=0
        Name="MeshEmitter1"
    End Object
    Emitters(5)=MeshEmitter'MeshEmitter1'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        UseColorScale=True
        ColorScale(0)=(Color=(B=16,G=158,R=30))
        ColorScale(1)=(RelativeTime=0.600000,Color=(B=64,G=255,R=87))
        ColorScale(2)=(RelativeTime=0.800000,Color=(B=23,G=187,R=60))
        ColorScale(3)=(RelativeTime=1.000000)
        MaxParticles=2
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.800000,RelativeSize=10.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000))
        UniformSize=True
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Flares.SoftFlare'
        LifetimeRange=(Min=1.250000,Max=1.250000)
        InitialDelayRange=(Min=0.800000,Max=0.800000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter4"
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter4'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        ColorScale(0)=(Color=(B=111,G=255,R=172))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=55,G=234,R=100))
        FadeOutStartTime=0.900000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=2
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.700000,RelativeSize=15.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        UniformSize=True
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Flares.BurnFlare1'
        LifetimeRange=(Min=1.000000,Max=1.000000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter5"
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter5'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        UseDirectionAs=PTDU_Right
        UseColorScale=True
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=253,R=32))
        FadeOutStartTime=0.600000
        FadeOut=True
        FadeInEndTime=0.200000
        FadeIn=True
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=256.000000,Max=256.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        StartSizeRange=(X=(Min=80.000000,Max=80.000000),Y=(Min=40.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
        SecondsBeforeInactive=0
        Name="SpriteEmitter6"
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter6'
    Begin Object Class=MeshEmitter Name=MeshEmitter2
        StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionSphere'
        RenderTwoSided=True
        UseParticleColor=True
        UseColorScale=True
        ColorScale(0)=(Color=(B=0,G=255,R=0,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=255,R=0,A=255))
        FadeOutStartTime=0.750000
        FadeOut=True
        MaxParticles=1
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        DrawStyle=PTDS_AlphaBlend
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(Z=(Min=0.800000,Max=0.800000))
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=1.000000,Max=1.000000)
        InitialDelayRange=(Min=1.200000,Max=1.200000)
        SecondsBeforeInactive=0
        Name="MeshEmitter2"
    End Object
    Emitters(9)=MeshEmitter'MeshEmitter2'
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_DumbProxy
    bNetTemporary=true
}
