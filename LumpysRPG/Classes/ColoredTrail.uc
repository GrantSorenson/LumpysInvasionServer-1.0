class ColoredTrail extends xEmitter;

//var Color Color;
var() array<Material> TrailSkins;
var() config Color Red;

#exec obj load file="LumpysTextures.utx"

// replication
// {
// 	reliable if(Role == ROLE_Authority && bNetDirty)
// 		Color;
// }

// simulated event Tick(float dt)
// {
// 	Super.Tick(dt);
	
// 	mColorRange[0] = Color;
// 	mColorRange[1] = Color;
// }

function SetSkin(int skinNum)
{
	Skins[0]=TrailSkins[skinNum];
	Skins[1]=TrailSkins[skinNum];
	UpdatePrecacheMaterials();
	//mColorRange[0]=Red;
	//mColorRange[1]=Red;
}

defaultproperties
{
	TrailSkins(0)=Texture'LumpysTextures.SpeedTrailTextures.STYellow'
	TrailSkins(1)=Texture'LumpysTextures.SpeedTrailTextures.STBlue'
	TrailSkins(2)=Texture'LumpysTextures.SpeedTrailTextures.STRed'
	mParticleType=PT_Stream
	mStartParticles=0
	Red=(R=255,B=0,G=0,A=255)
	mLifeRange(0)=0.650000
	mLifeRange(1)=0.650000
	mRegenRange(0)=10.000000
	mRegenRange(1)=10.000000
	mDirDev=(X=0.500000,Y=0.500000,Z=0.500000)
	mPosDev=(X=2.000000,Y=2.000000,Z=2.000000)
	mSpeedRange(0)=-20.000000
	mSpeedRange(1)=-20.000000
	mMassRange(0)=-0.100000
	mMassRange(1)=-0.100000
	mAirResistance=0.000000
	mSizeRange(0)=12.000000
	mSizeRange(1)=12.000000
	mGrowthRate=-12.000000
	mAttenKa=0.000000
	bNetTemporary=False
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=60.000000
    Skins(0) = Texture'LumpysTextures.SpeedTrailTextures.STBlue';
    Skins(1) = Texture'LumpysTextures.SpeedTrailTextures.STBlue';
	Style=STY_Additive
}
