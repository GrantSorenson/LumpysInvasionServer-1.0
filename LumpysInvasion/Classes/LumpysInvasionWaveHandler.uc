class LumpysInvasionWaveHandler extends Actor;

// struct WaveNameInfo
// {
//   var() string WaveName;
//   var() Color WaveColor;
// };
 var() string WaveNames[30];
 var() Color WaveColor;

replication
{
    reliable if(bNetInitial && Role==ROLE_Authority)
        WaveNames,WaveColor;
}

event PreBeginPlay()
{
    Super.PreBeginPlay();
}

function string GetTitle(int Index) {
    return WaveNames[Index];
}

defaultproperties
{
     WaveColor=(R=0,B=0,G=255,A=255)
     WaveNames(0)=" Welcome to Lumpy Invasion "
     WaveNames(1)=" Wave 2"
     WaveNames(2)=" Wave 3"
     WaveNames(3)=" Wave 4"
     WaveNames(4)=" Wave 5"
     WaveNames(5)=" Wave 6"
     WaveNames(6)=" Wave 7"
     WaveNames(7)=" Wave 8"
     WaveNames(8)=" Wave 9"
     WaveNames(9)=" Wave 10"
     WaveNames(10)=" Wave 11"
     WaveNames(11)=" Wave 12"
     WaveNames(12)=" Wave 13"
     WaveNames(13)=" Wave 14"
     WaveNames(14)=" Wave 15"
     WaveNames(15)=" Wave 16"
     WaveNames(16)=" Wave 17"
     WaveNames(17)=" Wave 18"
     WaveNames(18)=" Wave 19"
     WaveNames(19)=" Wave 20"
     WaveNames(20)=" Wave 21"
     bHidden=True
     bAlwaysRelevant=True
}
