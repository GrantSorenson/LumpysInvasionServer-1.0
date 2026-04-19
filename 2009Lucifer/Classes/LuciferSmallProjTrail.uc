//================================================================================
// LuciferSmallProjTrail.
//================================================================================

class LuciferSmallProjTrail extends Emitter
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
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        CoordinateSystem=1
        ColorMultiplierRange=(X=(Min=1.0,Max=1.0),Y=(Min=0.6,Max=0.6),Z=(Min=0.0,Max=0.0))
        StartSpinRange=(X=(Min=2.0,Max=5.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=0.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.5,Max=2.0)
    End Object
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
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
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=0.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode2s'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.5,Max=1.0)
    End Object
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        MaxParticles=20
        StartSpinRange=(X=(Min=2.0,Max=5.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=0.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.0)
        StartSizeRange=(X=(Min=35.0,Max=40.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.05,Max=0.08)
    End Object
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Opacity=0.1
        StartLocationShape=1
        SphereRadiusRange=(Min=-20.0,Max=20.0)
        StartSpinRange=(X=(Min=2.0,Max=5.0))
        SizeScale(0)=(RelativeTime=0.0,RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=0.0)
        StartSizeRange=(X=(Min=35.0,Max=40.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        DrawStyle=1
        Texture=Texture'AW-2004Explosions.Fire.DeSatFireballs3'
        TextureUSubdivisions=4
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.0,Max=5.0)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
    Emitters(1)=SpriteEmitter'SpriteEmitter1'
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    AutoDestroy=True

    bNoDelete=False

    RemoteRole=2

    bNotOnDedServer=False

}
