class M_BattleDroid extends tk_NaliFighter
	config(tk_Monsters);

var array<Shader> DroidSkin;

function PostBeginPlay()
{
     Super.PostBeginPlay();
     Skins[0] = DroidSkin[RAnd(DroidSkin.Length)];
}

function PlayVictory()
{
	if(Controller!=none)
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
		SetAnimAction('gesture_taunt03');
		Controller.Destination = Location;
		Controller.GotoState('TacticalMove','WaitForAnim');
	}
}

defaultproperties
{
     DroidSkin(0)=Shader'tk_StarWars.BattleDroid.SdroidB'
     DroidSkin(1)=Shader'tk_StarWars.BattleDroid.SdroidB_3'
     DroidSkin(2)=Shader'tk_StarWars.BattleDroid.SdroidC'
     DroidSkin(3)=Shader'tk_StarWars.BattleDroid.SdroidC_3'
     FireRateScale=1.3
	WeaponClassName(0)="tk_StarWars.DroidWeapon"
     HitSound(0)=Sound'tk_StarWars.BattleDroid.uhoh'
     HitSound(1)=Sound'tk_StarWars.BattleDroid.imprsve'
     HitSound(2)=Sound'tk_StarWars.BattleDroid.nblast'
     HitSound(3)=Sound'tk_StarWars.BattleDroid.nboy'
     DeathSound(0)=Sound'tk_StarWars.BattleDroid.retreat'
     DeathSound(1)=Sound'tk_StarWars.BattleDroid.cwoooo'
     DeathSound(2)=Sound'tk_StarWars.BattleDroid.r2scream'
     DeathSound(3)=Sound'tk_StarWars.BattleDroid.whoa'
     ChallengeSound(0)=Sound'tk_StarWars.BattleDroid.nsmwher'
     ChallengeSound(1)=Sound'tk_StarWars.BattleDroid.Incoming'
     ChallengeSound(2)=Sound'tk_StarWars.BattleDroid.nsplit'
     ChallengeSound(3)=Sound'tk_StarWars.BattleDroid.nwhere'
     ScoringValue=20
     Health=100
	HP=100
     Mesh=SkeletalMesh'tk_StarWars.BattleDroid'
     GibGroupClass=Class'XEffects.xBotGibGroup'
}
