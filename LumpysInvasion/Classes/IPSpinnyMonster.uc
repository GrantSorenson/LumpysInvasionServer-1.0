class IPSpinnyMonster extends Actor;

var() int SpinRate;

var() bool bPlayRandomAnims;
var() float AnimChangeInterval;
var() array<name> AnimNames;

var() float CurrentTime;
var() float NextAnimTime;
var() name currentAnim;
var() int RotateSpeed;

function Tick(float Delta)
{
    local rotator NewRot, R;

    NewRot = Rotation;
    NewRot.Yaw += Delta * SpinRate/Level.TimeDilation;
    SetRotation(NewRot);

    CurrentTime += Delta/Level.TimeDilation;

	R = Rotation;
	R.Yaw -= (RotateSpeed);
	SetRotation(r);
}

event AnimEnd( int Channel )
{
    Super.AnimEnd(Channel);
}

function PlayNextAnim()
{
    local name NewAnimName;
    local int i, AnimNumber;

    if(Mesh == None || AnimNames.Length == 0)
    {
        return;
	}

	//get current anim
	for(i=0;i<AnimNames.Length;i++)
	{
		if( currentAnim == AnimNames[i] )
		{
			AnimNumber = i;
		}
	}

    NewAnimName = AnimNames[AnimNumber];
    if(NewAnimName != '')
    {
		PlayAnim(NewAnimName, 1.0/Level.TimeDilation, 0.25/Level.TimeDilation);
		currentAnim = NewAnimName;
    	NextAnimTime = CurrentTime + AnimChangeInterval;
	}
}

function PlayRandomAnim()
{
    local name NewAnimName;

    if(Mesh == None || AnimNames.Length == 0)
    {
        return;
	}

    NewAnimName = AnimNames[Rand(AnimNames.Length)];
    if(NewAnimName != '')
    {
		PlayAnim(NewAnimName, 1.0/Level.TimeDilation, 0.25/Level.TimeDilation);
		currentAnim = NewAnimName;
    	NextAnimTime = CurrentTime + AnimChangeInterval;
	}
}

event GainedChild(Actor Other)
{
	if(Other.Class == class'IPCylinderActor')
	{
		IPCylinderActor(Other).SetBase(self);
	}

	Super.GainedChild(Other);
}

defaultproperties
{
    spinRate=20000
    AnimChangeInterval=3.00
    AnimNames=
    DrawType=8
    bOnlyOwnerSee=True
    bOnlyDrawIfAttached=True
    RemoteRole=0
    LODBias=100000.00
    DrawScale=0.50
    bUnlit=True
    bAlwaysTick=True
}
