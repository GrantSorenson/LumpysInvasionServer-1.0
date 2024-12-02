class RazorBomb extends tk_FlakCannon
	config(TKWeaponsClient);

simulated function float ChargeBar()
{
	return FMin(1,FireMode[1].HoldTime/RazorBombHeld(FireMode[1]).mHoldClampMax);
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.RazorFire'
     FireModeClass(1)=Class'tk_FHIWeapons.RazorBombHeld'
     SelectAnim="Select"
     bShowChargingBar=True
     Description="The RazorBomb is one of the lesser known weapons created by Trident Defensive Technologies. Building upon the hugely successful 'Negotiator' Flak Cannon design, the RazorBomb takes personal defensive weaponry to the next level, sporting a rapid fire primary mode that can spew out ultra sharp razor disks, and a secondary fragmentation bomb that splits into 3 mini-bombs capable of considerable destruction. The RazorBomb was originally banned from Tournament use for causing unnecessary pain and suffering - until a public outcry brought the weapon back into service. The RazorBomb continues to be a popular weapon with the public spectators."
     Priority=25
     SmallViewOffset=(X=25.000000,Y=10.000000,Z=-8.000000)
     GroupOffset=71
     PickupClass=Class'tk_FHIWeapons.RazorBombPickup'
     PlayerViewOffset=(X=25.000000,Y=10.000000,Z=-8.000000)
     PlayerViewPivot=(Yaw=0,Roll=0)
     BobDamping=2.900000
     AttachmentClass=Class'tk_FHIWeapons.RazorBombAttachment'
     ItemName="RazorBomb"
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.RazorBomb'
     DrawScale=1.690000
     DrawScale3D=(X=1.200000)
}
