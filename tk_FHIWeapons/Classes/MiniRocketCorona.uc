class MiniRocketCorona extends Effects;

auto state Start
{
	simulated function Tick(float dt)
	{
		SetDrawScale(FMin(DrawScale + dt*12.0, 1.5));
		if (DrawScale >= 1.5)
			GotoState('End');
	}
}

state End
{
	simulated function Tick(float dt)
	{
		SetDrawScale(FMax(DrawScale - dt*12.0, 0.9));
		if (DrawScale <= 0.9)
			GotoState('');
	}
}

defaultproperties
{
     bHighDetail=True
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     Texture=Texture'XEffects.RocketFlare'
     DrawScale=0.350000
     DrawScale3D=(X=0.150000,Y=0.075000,Z=0.075000)
     Skins(0)=Texture'XEffects.RocketFlare'
     Style=STY_Translucent
     Mass=13.000000
}