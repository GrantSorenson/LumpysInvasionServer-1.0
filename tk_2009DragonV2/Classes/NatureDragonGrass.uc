class NatureDragonGrass extends Actor placeable;

#EXEC OBJ LOAD FILE=ArboreaHardware.usx

var Material GrassSkins[5];
var StaticMesh GrassMesh[3];
var bool bAlternate;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetStaticMesh(GrassMesh[Rand(3)]);

    if(StaticMesh == StaticMesh'DragonGrass02')
    {
        Skins[0] = GrassSkins[Rand(5)];
    }
    else if(StaticMesh != StaticMesh'ArboreaHardware.Organics.AbFernA')
    {
        Skins[0] = GrassSkins[Rand(4)];
    }

    Disable('Tick');
}

simulated event Landed(vector HitNormal)
{
    local Rotator Rot;

    Rot.Yaw = RandRange(0,32768);
    SetDrawScale(0.100000);
    SetRotation(Rotation + Rot);
    GoToState('Growing');
    Super.Landed(HitNormal);
}

simulated State Growing
{
    simulated function BeginState()
    {
        SetTimer(0.01,True);
    }

    simulated function EndState()
    {
        bAlternate = true;
    }

Begin:
    Sleep(6.5);
    GoToState('');
}

simulated function Timer()
{
    if(!bAlternate && DrawScale < 0.8)
    {
        SetDrawScale(DrawScale + 0.01);
    }
    else if(bAlternate && DrawScale > 0.1)
    {
        SetDrawScale(DrawScale - 0.01);
    }

    Super.Timer();
}

defaultproperties
{
     GrassSkins(0)=Shader'tk_2009Dragonv2.SFX.DragonGrassTex'
     GrassSkins(1)=Shader'tk_2009Dragonv2.SFX.DragonGrassTex02'
     GrassSkins(2)=Shader'tk_2009Dragonv2.SFX.DragonGrassTex03'
     GrassSkins(3)=Shader'tk_2009Dragonv2.SFX.DragonGrassTex04'
     GrassSkins(4)=Shader'tk_2009Dragonv2.SFX.DragonGrassTex05'
     GrassMesh(0)=StaticMesh'tk_2009Dragonv2.DragonGrass01'
     GrassMesh(1)=StaticMesh'tk_2009Dragonv2.DragonGrass02'
     GrassMesh(2)=StaticMesh'ArboreaHardware.Organics.AbFernA'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_2009Dragonv2.DragonGrass01'
     bAcceptsProjectors=False
     Physics=PHYS_Falling
     LifeSpan=8.000000
     DrawScale=0.000001
     PrePivot=(Z=10.000000)
     AmbientGlow=60
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideWorld=True
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bUseCylinderCollision=True
}
