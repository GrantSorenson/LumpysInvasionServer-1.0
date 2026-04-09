class M_Leela extends tk_NaliFighter
	config(tk_Monsters);

#EXEC OBJ LOAD FILE="Resources/tk_Futurama_rc.u" PACKAGE="tk_Futurama"

function PlayVictory()
{
	if(Controller!=none)
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
		SetAnimAction('gesture_taunt03');
          PlaySound(Sound'tk_Futurama.Leela.youlostbad');
		Controller.Destination = Location;
		Controller.GotoState('TacticalMove','WaitForAnim');
	}
}

defaultproperties
{
     FireRateScale=5.400000
     HitSound(0)=Sound'tk_Futurama.Leela.eeewwww'
     HitSound(1)=Sound'tk_Futurama.Leela.ow'
     HitSound(2)=Sound'tk_Futurama.Leela.wooooo'
     HitSound(3)=Sound'tk_Futurama.Leela.ohyeah'
     DeathSound(0)=Sound'tk_Futurama.Leela.boned'
     DeathSound(1)=Sound'tk_Futurama.Leela.gottobekidding'
     DeathSound(2)=Sound'tk_Futurama.Leela.helpwhatshappening'
     DeathSound(3)=Sound'tk_Futurama.Leela.ohcrud'
     ChallengeSound(0)=Sound'tk_Futurama.Leela.facepunishment'
     ChallengeSound(1)=Sound'tk_Futurama.Leela.fightlikeagirl'
     ChallengeSound(2)=Sound'tk_Futurama.Leela.kicktheirasses'
     ChallengeSound(3)=Sound'tk_Futurama.Leela.welcomingparty'
     ScoringValue=20
     Health=100
	HP=100
     Mesh=SkeletalMesh'tk_Futurama.Leela.Leela'
     Skins(0)=Texture'tk_Futurama.Leela.LeelaBody'
     Skins(1)=Texture'tk_Futurama.Leela.LeelaHead'
}
