//-------------------------------------------------------
Read Me for 2009Lucifer monster for UT2004
Author: Shaun Goeppinger aka Iniquitous
Date: 20/07/09
Version: 1

//-------------------------------------------------------
Description
//-------------------------------------------------------
This is a new version of the popular LuciferBOSS monster.
In this version I have changed the effects, sounds, and given
him a choice of attacks. I have also included an option to
try and fix the death animation so he doesn't float in the
air.

//-------------------------------------------------------
Installation
//-------------------------------------------------------
.u files go in the system folder
.ini files go in the system folder
.ukx files go in the system folder

You will need to add a serverpackage line for online play.

ServerPackages=2009Lucifer

The line for satoremonsterpack is:

MonsterTable=(MonsterName="2009Lucifer",MonsterClassName="2009Lucifer.LuciferMonster")

The line for monstermanager is:

MonsterTable=(MonsterName="[INI] 2009Lucifer",MonsterClassName="2009Lucifer.LuciferMonster",bUseMonster=True,bUseGibReduction=False)

//-------------------------------------------------------
Configuration
//-------------------------------------------------------
Configuring the Monsters2009.ini file. Update your copy of
the Monsters2009.ini file with these new settings. Simple
create the file if you do not have it.

[2009Lucifer.LuciferMonster]
UseConfigs=True
LuciferHealth=200
FixDeathAnim=true

UseConfigs: Setting this to true means the new Health setting will be used.

LuciferHealth: If UseConfigs is true, then this is the new health.

FixDeathAnim: If this is true then the death animation will attempt to align itself properly.
Turn this off if you experience any problems.

//-------------------------------------------------------
me@shaungoeppinger.com
www.shaungoeppinger.com/unreal.html
//-------------------------------------------------------


