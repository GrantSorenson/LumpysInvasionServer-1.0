this is not made by me ... i just decided to put it on here because it is hard to find

all credits goes to kearin for this wonderful mod   ..   if u r rating this mod then rate it by thinking kearin mod not mine 

Weapons of Power 1.5
--------------------------------------------------------------------------

AUTHOR: Kearin

TEST SERVER: InvasionRPG 24/7 (205.209.190.74:7777)

FORUM: http://quarterpicks.com/forum/

You're free to use this mutator, mod it, extend it, etc. Just be
respectable and give proper credit. That's all I ask. And if you do
make changes I'm interested in hearing about them. Just PM at the forum
above.

Thanks to Teknohead, Lil_Ded, and all the players at the InvasionRPG 24/7
server for helping me to develop this mutator and for using it on their
server. Their feedback has been great and helped Weapons Of Power to
continue to evolve.

And just to clear up any misconceptions:

Weapons of Power was made entirely by me. Other servers have 'claimed' to
have made it or even suggested that Mysterial or Druid made it. This is
not the case. Mysterial created the UT RPG system and Druid created some
additional RPG weapon types. Both of their mods were very influential in
the design and development of Weapons of Power, but the power ups and
weapons of power are my creation.

Other servers have taken WoP and edited it (many have asked, one in
particular did not) and added their own power ups, but that is all that
others have contributed. No one has directly contacted me to add new
things to Weapons Of Power.

--------------------------------------------------------------------------

This mutator adds a new RPG weapon called the "Weapon Of Power" to RPG
games. To add the weapon edit your UT2004RPG.ini and add the following
line:

WeaponModifiers=(WeaponClass=Class'WeaponsOfPower.WeaponOfPower',Chance=1)

You will also need to include the WeaponsOfPower mutator in your mutator
configuration.

Additionally there are 3 RPG artifacts you can add:

	RepairKit:
		Can be used to repair any RPG weapon up to 0 or positive modifier.
		For example, a draining link gun can be repaired up to an energy
		link gun +1.

		AvailableArtifacts=(ArtifactClass=Class'WeaponsOfPower.RepairKitArtifact',Chance=1)

	Upgrade Kit:
		This kit actually allows a weapon to be upgraded up to the max
		level for that weapon. With this you can take a Link Gun + 1 up
		to Link Gun + 5.

		AvailableArtifacts=(ArtifactClass=Class'WeaponsOfPower.UpgradeKitArtifact',Chance=1)

	Revive Artifact:
		This artifact will allow you to revive a fallen player. You can
		select the player to revive using your 'Next Item', 'Prev Item',
		and 'Use Item' keys.

		AvailableArtifacts=(ArtifactClass=Class'WeaponsOfPower.ReviveArtifact',Chance=1)

	Ghost Artifact
		This works exactly like the ghost ability. If you pick up this item you cannot
		use it directly, instead when you die it automatically activates giving you a second
		chance. It has the same effect as ghost level 2.

		AvailableArtifacts=(ArtifactClass=Class'WeaponsOfPower.GhostArtifact',Chance=2)

	Unload Artifact
		This artifact allows a player to unload the power ups from a weapon of power.
		Typically, unless the 'unloadweapon' command is allowed, a player can only
		choose to drop all the power ups from their weapon. This artifact will take
		the power ups and place them back into the player's inventory.

		AvailableArtifacts=(ArtifactClass=Class'WeaponsOfPower.UnloadArtifact',Chance=2)

For the players, there are the following keybinds that can be used with WoP:

	NextPrimaryFireMode
		Certains Weapons of Power have fire mode modifier power ups that add additional
		firing modes. For example, the rocket launcher has the seeker fire mode, the bio
		and link have the spread fire mode. To switch between the normal fire mode and
		the power up fire mode, you need to bind a key to NextPrimaryFireMode.

	NextAlternateFireMode
		This is similar to NextPrimaryFireMode, only this toggles the firing mode of your
		alternate fire.

	ToggleWeaponInfo
		This key bind will cause a popup to appear where the vote menu does. This popup
		will list all of the power ups applied to the current weapon as well as their
		current level.

	ResetWeapon
		This key bind is a shortcut for clearing your weapon. The end result is that your
		current weapon will have all of its power ups removed.

	UnloadWeapon
		This key bind will remove all the power ups from a weapon and return them to the
		player's inventory. This must be enabled by the admin in the web gui before it
		can be used.

	ShowItemDescriptions
		Displays an information box that describes the currently selected item.

	ShowMoreItems/ShowLessItems
		Displays more or less items in the item scroll wheel.


In team speak players can use %i to display their currently selected item.

From there you can use the web admin to access 90% of the options
available in Weapons Of Power. It is highly configurable so take a
moment to browse the options.

For information about the power-ups, check out:

http://mysite.verizon.net/kearin/WoP/index.html
