class IPCopyPaste extends Object config(IPSettings);

var() config float ClipBoardDrawScale;
var() config float ClipBoardCollisionHeight;
var() config float ClipBoardCollisionRadius;
var() config vector ClipBoardPrePivot;

var() config bool ClipBoardbBossWave;
var() config bool ClipBoardbBossesSpawnTogether;
var() config string ClipBoardBossID;
var() config int ClipBoardFallbackBossID;
var() config int ClipBoardBossTimeLimit;
var() config int ClipBoardBossOverTimeDamage;
var() config color ClipBoardWaveDrawColour;
var() config int ClipBoardWaveDuration;
var() config float ClipBoardWaveDifficulty;
var() config int ClipBoardWaveMaxMonsters;
var() config int ClipBoardMaxMonsters;
var() config int ClipBoardMaxLives;
var() config string ClipBoardMonsters[30];
var() config string ClipBoardWaveFallbackMonster;

defaultproperties
{
}
