//-----------------------------------------------------------------------------

Author: Shaun Goeppinger (aka Iniquitous)
Date: 04/04/2021
Version: 1

//-----------------------------------------------------------------------------
// Description
//-----------------------------------------------------------------------------

This monster pack for Invasion adds 13 new monsters from Super Mario.

The monsters are:

Angry Sun - A flying monster with a continuous area of effect attack.

Blooper - A flying monster that can shoot projectiles and has a melee attack.

Bob_omb - A melee range only monster that explodes in close proximity to players.

Boo - A flying monster with melee only attacks.

Bullet Bill - A flying monster that explodes on contact with players.

Goomba - A melee only monster.

Hammer Bro - A monster that can throw hammer projectiles and has a melee attack.

Koopa - A melee only monster that if jump on top of can be turned into a shell projectile.

Lakitu - A flying monster with the ability to throw Spiny monsters and has a melee attack.

Piranha Plant - A monster with a ranged fireball attack and a melee attack.

Pokey - A melee only monster consiting of ball shaped segments that can be destroyed individually.

Spiny - A melee only monster that caused damage if jumped on top of.

Thwomp - A flying monster with melee only attacks.

//-------------------------------------------------------------------
//Installation
//-------------------------------------------------------------------

.u files go in the System folder
.ini files go in the System folder
.uxk files go in the Animations folder
.uax files go in the Sounds folder
.usx files go in the StaticMesh folder
.utx files go in the Textures folder

To use these monsters online you must include the ServerPackages line
in your UT2004.ini file.

ServerPackages=MarioMonstersv1

To use the monsters in game, you must use a mutator or gametype which supports
custom monsters such as InvasionPro, Satoremonsterpack, Monstermanager etc..

Monster Lines are as follows:

MonsterTable=(MonsterName="Super Mario Angry Sun",MonsterClassName="MarioMonstersv1.Angry_Sun")
MonsterTable=(MonsterName="Super Mario Boo",MonsterClassName="MarioMonstersv1.Boo")
MonsterTable=(MonsterName="Super Mario Blooper",MonsterClassName="MarioMonstersv1.Blooper")
MonsterTable=(MonsterName="Super Mario Bob Omb",MonsterClassName="MarioMonstersv1.Bob_Omb")
MonsterTable=(MonsterName="Super Mario Bullet Bill",MonsterClassName="MarioMonstersv1.Bullet_Bill")
MonsterTable=(MonsterName="Super Mario Goomba",MonsterClassName="MarioMonstersv1.Goomba")
MonsterTable=(MonsterName="Super Mario Hammer Bro",MonsterClassName="MarioMonstersv1.Hammer_Bro")
MonsterTable=(MonsterName="Super Mario Koopa",MonsterClassName="MarioMonstersv1.Koopa")
MonsterTable=(MonsterName="Super Mario Piranha Plant",MonsterClassName="MarioMonstersv1.Piranha_Plant")
MonsterTable=(MonsterName="Super Mario Pokey",MonsterClassName="MarioMonstersv1.Pokey")
MonsterTable=(MonsterName="Super Mario Spiny",MonsterClassName="MarioMonstersv1.Spiny")
MonsterTable=(MonsterName="Super Mario Thwomp",MonsterClassName="MarioMonstersv1.Thwomp")
MonsterTable=(MonsterName="Super Mario Lakitu",MonsterClassName="MarioMonstersv1.Lakitu")


//-------------------------------------------------------------------
//Configuration
//-------------------------------------------------------------------

The monsters come with many config settings. To configure your monsters
open the MarioMonstersConfig.ini file. In the file you will find the
following settings. 

This is what they all mean. 

Just change them to what you want!

[MarioMonstersv1.Angry_Sun]
bUseHealthConfig=True //If true the health settings will take effect
NewHealth=280 //The new health setting to apply if bUseHealthConfig is true
bScaleHeatWithDistance=true //If true the heat damage will scale with how far players are from the monster
HeatDamagePerSecond=10 //How much damage per second the heat effect causes
HeatRadius=1000 //The readius of the heat damage
BlastRadius=1000 //The damage radius of the explosion when the monster is killed
BlastDamage=100 //How much damage the explosion causes when the monster is killed

[MarioMonstersv1.Blooper]
bUseHealthConfig=True
bUseDamageConfig=True //If true the damage settings (affects melee and projectiles only) will take effect
NewHealth=130
NewMeleeDamage=18
ProjectileDamage=20 //The amount of damage the projectile does
RangedAttackIntervalTime=4 //the time between ranged attacked (in seconds)
bCanBlindPlayers=true //if true the projectile will "ink" the player temporarily
InkDuration=7 //if players are inked this is how long it lasts in seconds (ink effect fades out)

[MarioMonstersv1.Bob_Omb]
bUseHealthConfig=True
NewHealth=130
ExplodeDamage=50 //How much damage the explosion causes when the monster is killed
ExplodeRadius=400.000000 //The damage radius of the explosion when the monster is killed
ExplodeRange=250.000000 //How close the monster has to get to a player before the self detonate is triggered
bCanDamageMonsters=true //if true the explosion can also hurt other monsters

[MarioMonstersv1.Boo]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=130
NewMeleeDamage=18
bCanBeInvisible=true //if true Boo can go invisible
InvisDuration=5.000000 //how long Boo can go invisible for
InvisIntervalTime=4.0000 //the minimum time that should elapse (in seconds) between going invisible
bCanBeDamagedWhileInvis=false //if false Boo cannot be damaged whilst invisible
bInvisAllowedWhenAttacking=false //if false Boo will stop being invisible if it attacks

[MarioMonstersv1.Bullet_Bill]
bUseHealthConfig=True
NewHealth=130
ExplodeRange=50 //How close the monster has to get to a player before the self detonate is triggered
ExplodeDamage=75 //How much damage the explosion causes when the monster is killed
ExplodeRadius=600.000000 //The damage radius of the explosion when the monster is killed
     
[MarioMonstersv1.Goomba]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=130
NewMeleeDamage=15
bCanBeStomped=true //if tue Goomba can be killed by jumping on

[MarioMonstersv1.Hammer_Bro]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=180
NewMeleeDamage=30
ProjectileDamage=30
RangedAttackIntervalTime=3.000000

[MarioMonstersv1.Koopa]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=100
NewMeleeDamage=15
bCanBeShell=true //If true Koopa will always turn into a shell when killed
bCanBeStomped=true //If true when Koopa is jumped on it will turn into a shell
ShellDamage=30 //How much damage the shell does on contact with players after it has been kicked

[MarioMonstersv1.Lakitu]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=280
bCanSpawnSpinys=true //If true the Spiny shells that Lakitu throws will turn into Spiny monsters
MaxSpinys=8 //The maximum number of Spinys each Lakitu can make appear at any one time
ProjectileDamage=20 
NewMeleeDamage=18
RangedAttackIntervalTime=4
	  
[MarioMonstersv1.Piranha_Plant]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=180
NewMeleeDamage=30
ProjectileDamage=30
RangedAttackIntervalTime=2.100000

[MarioMonstersv1.Pokey]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=130
NewMeleeDamage=15
PokeyBallDamage=10 //How much damage each section of the Pokey does if players are hit by them
SectionHealth=50 //How much health each Pokey section has before it is detached from the Pokey
bSectionsCanBeDestroyed=True //If true the Pokey sections can be damaged and detached from the Pokey
bUseRegularDeathAnimations=False //If true when the Pokey is killed it will play normal death animations instead of detaching all remaining Pokey sections

[MarioMonstersv1.Spiny]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=100
NewMeleeDamage=15
SpikeDamage=50 //How much damage the Spiny does to players if it is jumped on

[MarioMonstersv1.Thwomp]
bUseHealthConfig=True
bUseDamageConfig=True
NewHealth=300
NewMeleeDamage=100

//-------------------------------------------------------------------
//Credits
//-------------------------------------------------------------------

Me! If you like my monsters please consider making a small
donation www.unreal.shaungoeppinger.com/donate.html

Want a monster making? I am available for hire, please enquire.

me@shaungoeppinger.com

A big thank you to everyone who donated to make this monster pack possible.

