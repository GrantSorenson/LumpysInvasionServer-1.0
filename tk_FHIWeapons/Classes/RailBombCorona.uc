class RailBombCorona extends Effects;

auto state Start
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMin(DrawScale + dt*12.0, 1.5));
        if (DrawScale >= 1.5)
        {
            GotoState('End');
        }
    }
}

state End
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMax(DrawScale - dt*12.0, 0.9));
        if (DrawScale <= 0.9)
        {
            GotoState('');
        }
    }
}

defaultproperties
{
     bHighDetail=True
     Physics=PHYS_Trailer
     Texture=Texture'EmitterTextures.Flares.EFlareP'
     DrawScale3D=(X=0.290000,Y=0.170000,Z=0.290000)
     Skins(0)=Texture'EmitterTextures.Flares.EFlareP'
     Style=STY_Translucent
     Mass=13.000000
}
