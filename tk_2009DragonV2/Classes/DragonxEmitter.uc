class DragonxEmitter extends xEmitter;

simulated event BaseChange()
{
	if(Base == None)
	{
		Destroy();
	}
	super.BaseChange();
}

defaultproperties
{
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
}
