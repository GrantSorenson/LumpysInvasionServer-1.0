//================================================================================
// LuciferProjExplode.
//================================================================================

class LuciferProjExplode extends Emitter
  Placeable;

simulated event BaseChange ()
{
  if ( Base == None )
  {
    Kill();
  }
  Super.BaseChange();
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseVelocityScale=True
        Acceleration=(X=0.0,Y=0.0,Z=10.0)
        ColorScale(0)=(RelativeTime=0.0,Color=(R=192,G=192,B=192,A=0))
        ColorScale(1)=(RelativeTime=0.6,Color=(R=50,G=89,B=141,A=0))
        ColorScale(2)=(RelativeTime=1.0,Color=(R=0,G=0,B=0,A=0))
        ColorMultiplierRange=(X=(Min=1.0,Max=1.0),Y=(Min=1.0,Max=1.0),Z=(Min=0.8,Max=0.8))
        FadeOutStartTime=0.01
        MaxParticles=20
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=1.0,Max=2.0)
        StartSpinRange=(X=(Min=0.0,Max=1.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=3.5)
        StartSizeRange=(X=(Min=20.0,Max=20.0),Y=(Min=60.0,Max=80.0),Z=(Min=60.0,Max=80.0))
        InitialParticlesPerSecond=1000.0
        Texture=Texture'AW-2004Explosions.Fire.Part_explode'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=1.5,Max=2.0)
        StartVelocityRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        VelocityScale(0)=(RelativeTime=0.0,RelativeVelocity=(X=10.0,Y=10.0,Z=10.0))
        VelocityScale(1)=(RelativeTime=0.5,RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(2)=(RelativeTime=1.0,RelativeVelocity=(X=10.0,Y=10.0,Z=10.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseVelocityScale=True
        ColorScale(0)=(RelativeTime=0.0,Color=(R=0,G=0,B=0,A=0))
        ColorScale(1)=(RelativeTime=0.8,Color=(R=33,G=95,B=222,A=0))
        ColorScale(2)=(RelativeTime=1.0,Color=(R=0,G=0,B=0,A=0))
        Opacity=0.2
        MaxParticles=0
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=1.0,Max=2.0)
        StartLocationPolarRange=(X=(Min=0.0,Max=0.0),Y=(Min=-32768.0,Max=32768.0),Z=(Min=10.0,Max=10.0))
        UseRotationFrom=PTRS_Actor
        RotationOffset=(Pitch=0,Yaw=-16384,Roll=0)
        SpinsPerSecondRange=(X=(Min=-0.2,Max=0.2))
        StartSpinRange=(X=(Min=0.0,Max=1.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=20.0,Max=20.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        InitialParticlesPerSecond=1000.0
        Texture=Texture'AW-2004Explosions.Fire.Part_explode2s'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=-10.0,Max=10.0),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        VelocityScale(0)=(RelativeTime=0.0,RelativeVelocity=(X=5.0,Y=5.0,Z=5.0))
        VelocityScale(1)=(RelativeTime=1.0,RelativeVelocity=(X=0.0,Y=0.0,Z=0.0))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    AutoDestroy=True
    bNoDelete=False
    RemoteRole=2
    bNotOnDedServer=False
}
