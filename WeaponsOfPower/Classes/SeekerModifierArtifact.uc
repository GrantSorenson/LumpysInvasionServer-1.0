class SeekerModifierArtifact extends WeaponModifierArtifact;

////////////////////////////////////////////////////////////////////////////////

static function AddPrecacheMaterials(
	LevelInfo level
) {
	super.AddPrecacheMaterials(level);

	level.AddPrecacheMaterial(Texture'SeekerTargetTexture');
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierClass=Class'SeekerModifier'
    Description="Adds the Rocket Launcher Seeker fire mode to the rocket launcher. Activate this mode using the 'NextPrimaryFireMode' keybind and then hold down the primary fire button to lock onto targets. Release to send homing rockets after the targets that will rarely miss."
    PickupClass=Class'SeekerModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.SeekerIcon'
    ItemName="Rocket Launcher Seeker Power Up"
}
