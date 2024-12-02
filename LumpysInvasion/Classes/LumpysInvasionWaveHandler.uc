class LumpysInvasionWaveHandler extends Actor;

struct WaveNameInfo
{
  var() string WaveName;
  var() Color WaveColor;
};
 var() config WaveNameInfo WaveNames[21];

replication
{
    reliable if(bNetInitial && Role==ROLE_Authority)
        WaveNames;
}

event PreBeginPlay()
{
    Super.PreBeginPlay();
}

function string GetTitle(int Index) {
    return WaveNames[Index].WaveName;
}

defaultproperties
{
     WaveNames(0)=(WaveName=" Wave 1:",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(1)=(WaveName=" Wave 2",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(2)=(WaveName=" Wave 3",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(3)=(WaveName=" Wave 4",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(4)=(WaveName=" Wave 5",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(5)=(WaveName=" Wave 6",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(6)=(WaveName=" Wave 7",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(7)=(WaveName=" Wave 8",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(8)=(WaveName=" Wave 9",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(9)=(WaveName=" Wave 10",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(10)=(WaveName=" Wave 11",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(11)=(WaveName=" Wave 12",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(12)=(WaveName=" Wave 13",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(13)=(WaveName=" Wave 14",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(14)=(WaveName=" Wave 15",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(15)=(WaveName=" Wave 16",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(16)=(WaveName=" Wave 17",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(17)=(WaveName=" Wave 18",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(18)=(WaveName=" Wave 19",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(19)=(WaveName=" Wave 20",WaveColor=(B=255,G=255,R=255,A=255))
     WaveNames(20)=(WaveName=" Wave 21",WaveColor=(B=255,G=255,R=255,A=255))
     bHidden=True
     bAlwaysRelevant=True
}
