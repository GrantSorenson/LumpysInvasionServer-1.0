//================================================================================
// LuciferBody.
//================================================================================

class LuciferBody extends Emitter
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
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        Acceleration=(X=0.0,Y=0.0,Z=20.0)
        Opacity=0.60
        CoordinateSystem=1
        ColorMultiplierRange=(X=(Min=1.0,Max=1.0),Y=(Min=0.9,Max=0.8),Z=(Min=0.0,Max=0.0))
        MaxParticles=15
        StartLocationOffset=(X=0.0,Y=0.0,Z=30.0)
        StartLocationShape=1
        SphereRadiusRange=(Min=-10.0,Max=10.0)
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=4.0)
        StartSizeRange=(X=(Min=40.0,Max=40.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'EmitterTextures.MultiFrame.LargeFlames'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=-5.0,Max=5.0),Y=(Min=-5.0,Max=5.0),Z=(Min=2.0,Max=5.0))
        VelocityScale(0)=(RelativeTime=0.0,RelativeVelocity=(X=10.0,Y=10.0,Z=2.0))
        VelocityScale(1)=(RelativeTime=1.0,RelativeVelocity=(X=5.0,Y=5.0,Z=10.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
    
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseVelocityScale=True
        CoordinateSystem=1
        MaxParticles=5
        StartLocationRange=(X=(Min=-20.0,Max=20.0),Y=(Min=-20.0,Max=20.0),Z=(Min=0.0,Max=0.0))
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=10.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=30.0)
        StartSizeRange=(X=(Min=2.0,Max=2.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'EpicParticles.Smoke.Smokepuff2'
        VelocityScale(0)=(RelativeTime=0.0,RelativeVelocity=(X=0.0,Y=0.0,Z=20.0))
        VelocityScale(1)=(RelativeTime=0.6,RelativeVelocity=(X=0.0,Y=0.0,Z=5.0))
        VelocityScale(2)=(RelativeTime=1.0,RelativeVelocity=(X=0.0,Y=0.0,Z=200.0))
        LifetimeRange=(Min=0.5,Max=1.0)
        StartVelocityRange=(X=(Min=0.0,Max=0.0),Y=(Min=0.0,Max=0.0),Z=(Min=2.0,Max=5.0))
    End Object
  
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    AutoDestroy=True

    bNoDelete=False

    RemoteRole=2

    bNotOnDedServer=False

}
