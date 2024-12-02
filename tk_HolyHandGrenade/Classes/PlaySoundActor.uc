//=================================================
// Only 1 sound can play per actor,
// so I figured, why not create a sound actor lulz
//=================================================
class PlaySoundActor extends Actor;

function Play(Sound TheSound, optional float Volume)
{
	local float SoundDuration;
	
	SoundDuration = GetSoundDuration(TheSound);
	SetTimer(SoundDuration, false);
	
	PlaySound(TheSound,,Volume);
}

function Timer()
{
	Destroy();
}

defaultproperties
{
	bHidden=True
}