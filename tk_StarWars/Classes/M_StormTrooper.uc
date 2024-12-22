class M_StormTrooper extends tk_NaliFighter
    config(tk_Monsters);

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
     FireRateScale=1.3
     WeaponClassName(0)="tk_StarWars.ImperialBlaster"
     HitSound(0)=Sound'tk_StarWars.StormTrooper.paina'
     HitSound(1)=Sound'tk_StarWars.StormTrooper.pain'
     HitSound(2)=Sound'tk_StarWars.StormTrooper.paina'
     HitSound(3)=Sound'tk_StarWars.StormTrooper.pain'
     DeathSound(0)=Sound'tk_StarWars.StormTrooper.assist'
     DeathSound(1)=Sound'tk_StarWars.StormTrooper.calfor'
     DeathSound(2)=Sound'tk_StarWars.StormTrooper.Death'
     DeathSound(3)=Sound'tk_StarWars.StormTrooper.deathd'
     ChallengeSound(0)=Sound'tk_StarWars.StormTrooper.keep'
     ChallengeSound(1)=Sound'tk_StarWars.StormTrooper.laffa'
     ChallengeSound(2)=Sound'tk_StarWars.StormTrooper.nttuff'
     ChallengeSound(3)=Sound'tk_StarWars.StormTrooper.stay'
     ScoringValue=20
     Health=100
	HP=100
     Mesh=SkeletalMesh'tk_StarWars.StormTrooper'
     Skins(0)=Shader'tk_StarWars.StormTrooper.StormTSkin'
     GibGroupClass=Class'XEffects.xPawnGibGroup'
}
