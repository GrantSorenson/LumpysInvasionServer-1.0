//================================================================================
// LuciferEyes.
//================================================================================

class LuciferEyes extends Emitter
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
        UniformSize=True
        CoordinateSystem=1
        ColorMultiplierRange=(X=(Min=1.0,Max=1.0),Y=(Min=0.5,Max=0.5),Z=(Min=0.0,Max=0.0))
        MaxParticles=1
        StartSizeRange=(X=(Min=3.0,Max=4.0),Y=(Min=100.0,Max=100.0),Z=(Min=100.0,Max=100.0))
        Texture=Texture'AW-2004Particles.Weapons.HardSpot'
        LifetimeRange=(Min=0.1,Max=0.1)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    AutoDestroy=True

    bNoDelete=False

    RemoteRole=2

    bNotOnDedServer=False

}
