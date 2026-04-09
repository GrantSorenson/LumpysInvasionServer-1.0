class M_Fry extends tk_NaliFighter
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
          PlaySound(Sound'tk_Futurama.Fry.sciwon');
		Controller.Destination = Location;
		Controller.GotoState('TacticalMove','WaitForAnim');
	}
}

defaultproperties
{
     FireRateScale=5.400000
     HitSound(0)=Sound'tk_Futurama.Fry.scsperm'
     HitSound(1)=Sound'tk_Futurama.Fry.scgonnadie'
     HitSound(2)=Sound'tk_Futurama.Fry.scwoooooo'
     HitSound(3)=Sound'tk_Futurama.Fry.scbleaugh'
     DeathSound(0)=Sound'tk_Futurama.Fry.sccantbehappening'
     DeathSound(1)=Sound'tk_Futurama.Fry.schelpme'
     DeathSound(2)=Sound'tk_Futurama.Fry.scmetyourequal'
     DeathSound(3)=Sound'tk_Futurama.Fry.sctrickortwo'
     ChallengeSound(0)=Sound'tk_Futurama.Fry.schangofgame'
     ChallengeSound(1)=Sound'tk_Futurama.Fry.scsecondbase'
     ChallengeSound(2)=Sound'tk_Futurama.Fry.scanus'
     ChallengeSound(3)=Sound'tk_Futurama.Fry.scpancakes2'
     ScoringValue=20
     Health=100
	HP=100
     Mesh=SkeletalMesh'tk_Futurama.Fry.fry'
     Skins(0)=Texture'tk_Futurama.Fry.fryBody'
     Skins(1)=Texture'tk_Futurama.Fry.fryHead'
}
