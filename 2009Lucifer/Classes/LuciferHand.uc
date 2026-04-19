//================================================================================
// LuciferHand.
//================================================================================

class LuciferHand extends Emitter
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
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        CoordinateSystem=1
        MaxParticles=5
        StartSpinRange=(X=(Min=2.0,Max=5.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=10.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.5,Max=2.0)
    End Object
    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=True
        RespawnDeadParticles=False
        AutoReset=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        CoordinateSystem=1
        MaxParticles=5
        StartSpinRange=(X=(Min=2.0,Max=5.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode2s'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.5,Max=1.0)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter4'
    Emitters(1)=SpriteEmitter'SpriteEmitter5'

    AutoDestroy=True

    bNoDelete=False

    RemoteRole=2

    bNotOnDedServer=False

}
