class AwarenessModifierInteraction extends Interaction config(WeaponsOfPower);

var WopStatsInv OwnerStats;

var float        fRadarDistance;
var float        fRadarPulse;
var float        fRadarScale;
var config float fRadarPosX;
var config float fRadarPosY;
var float        fLastDrawRadar;
var float        fMinEnemyDistance;
var color        colorBlack;

var config bool bShowFriendlyHealth;
var config bool bShowHostileHealth;
var config bool bFadeBars;
var config bool bNoRadarSound;

var AwarenessEnemyList EnemyList;
var Material           HealthBarMaterial;
var float              BarUSize, BarVSize;

#EXEC OBJ LOAD FILE=InterfaceContent.utx
#EXEC OBJ LOAD FILE=AS_FX_TX.utx

var int iDebug;

event Initialize() {
	BarUSize = HealthBarMaterial.MaterialUSize();
	BarVSize = HealthBarMaterial.MaterialVSize();
	EnemyList = ViewportOwner.Actor.Spawn(class'AwarenessEnemyList');
}

function color GetPawnTeamColor(
	Pawn p
) {
	local color          colorTeam;
	local HudCDeathmatch hud;

	hud = HudCDeathmatch(ViewportOwner.Actor.myHUD);

	if (hud != None) {
		colorTeam = class'HudCDeathmatchHelper'.static.GetHudTeamColor(p);
	} else {
		colorTeam = class'Colors'.default.White;
	}

	return colorTeam;
}

function color GetPawnTypeColor(
	Pawn p
) {
	local color colorType;

	if (p == None) {
		return colorBlack;
	}

	if (Monster(p) != None) {
		if (FriendlyMonsterController(p.Controller) != None) {
			colorType = GetPawnTeamColor(FriendlyMonsterController(p.Controller).Master.Pawn);
		} else {
			colorType = class'Colors'.default.Yellow;
		}
	} else {
		colorType = GetPawnTeamColor(p);
	}

	return colorType;
}

function color GetPawnHealthColor(
	Pawn p
) {
	local float fHealthRatio;
	local float fFadePercent;
	local color colorPawnHealth;

	fHealthRatio = p.Health / p.HealthMax;

	if (fHealthRatio > 0.5) {
		fFadePercent = fclamp(1.0 - fHealthRatio * 2.0, 0.0, 1.0);

		colorPawnHealth.R = 255.0 * fFadePercent;
		colorPawnHealth.G = 255.0;
 		colorPawnHealth.B = 63.0  * (1.0 - fFadePercent);
	} else {
		fFadePercent = fclamp(2.0 * fHealthRatio, 0.0, 1.0);

		colorPawnHealth.R = 255.0;
		colorPawnHealth.G = 255.0 * fFadePercent;
 		colorPawnHealth.B = 63.0  * fFadePercent;
	}

	return colorPawnHealth;
}

function color GetPawnVerticalDirectionColor(
	float fDistance
) {
	local float fVerticalColor;
	local color colorVertical;

	fVerticalColor = 255.0 * (1.0 - fclamp(abs(fDistance) / 1000.0, 0.0, 1.0));

	if (fDistance > 0.0) {
		colorVertical.R = 255.0;
		colorVertical.G = fVerticalColor;
		colorVertical.B = fVerticalColor;
	} else {
		colorVertical.R = fVerticalColor;
		colorVertical.G = fVerticalColor;
		colorVertical.B = 255.0;
	}

	return colorVertical;
}

function DrawPawnHealthBar(
	Canvas canvas,
	Pawn   p,
	float  fFade,
	float  fX,
	float  fY,
	float  fWidth,
	float  fHeight
) {
	local color colorPawnHealth;

	canvas.Style     = 1;
	canvas.DrawColor = colorBlack;
	canvas.SetPos(fX, fY);
	canvas.DrawTile(
		Texture'Engine.WhiteSquareTexture',
		fWidth,
		fHeight,
		0,
		0,
		fWidth,
		fHeight
	);

	colorPawnHealth = GetPawnHealthColor(p);

	if (bFadeBars == True) {
		colorPawnHealth = class'Colors'.static.MultiplyColor(colorPawnHealth, fFade);
	}

	canvas.DrawColor = colorPawnHealth;
	canvas.SetPos(fX + 1, fY + 1);
	canvas.DrawTile(
		Texture'Engine.WhiteSquareTexture',
		fWidth  - 1,
		fHeight - 1,
		0,
		0,
		fWidth  - 1,
		fHeight - 1
	);
}

function WriteDebug(
	canvas c,
	coerce string s
) {
	local color oldColor;

	oldColor = c.DrawColor;

	c.DrawColor.R = 255;
	c.DrawColor.G = 255;
	c.DrawColor.B = 255;

	c.SetPos(200, iDebug);
	c.DrawText(s);

	iDebug += 25;

	c.DrawColor = oldColor;
}

function DrawIndicator(
	Canvas canvas,
	float  fRadarPosX,
	float  fRadarPosY,
	float  fRadarSize,
	Pawn   p,
	float  fPulseDistance
) {
	local float fDistance;
	local float fRadarX;
	local float fRadarY;
	local float fAngle;
	local float fDotSize;
	local float fOffsetY;
	local float fOffsetScale;
	local float fVertDist;
	local float fPulseBrightness;

	local vector  vecStart;
	local rotator Direction;

	fDistance = vsize(ViewportOwner.Actor.Pawn.Location - p.Location);
	vecStart  = ViewportOwner.Actor.Pawn.Location;

	if (fDistance >= fRadarDistance) {
		return;
	}

	fDotSize     = 24 * canvas.ClipX * ViewportOwner.Actor.myHud.HudScale / 1600;
	WriteDebug(canvas, p.CollisionRadius);
	fDotSize     = fDotSize * (0.10 * sqrt(p.CollisionRadius));
	fOffsetY     = fRadarPosY + fRadarSize / canvas.ClipY;
	Direction    = rotator(p.Location - vecStart);
	fOffsetScale = fRadarScale * fDistance * 0.000167;
	fAngle       = ((Direction.Yaw - ViewportOwner.Actor.Rotation.Yaw) & 65535) * 6.2832 / 65536;
	fRadarX      = fRadarPosX * canvas.ClipX + fOffsetScale * canvas.ClipX * sin(fAngle) - 0.5 * fDotSize;
	fRadarY      = fOffsetY   * canvas.ClipY - fOffsetScale * canvas.ClipX * cos(fAngle) - 0.5 * fDotSize;
	fVertDist    = vecStart.Y - p.Location.Y;

	if (Monster(p) != None) {
		fMinEnemyDistance = FMin(fMinEnemyDistance, fDistance);
	}

	if (fDistance < fPulseDistance) {
		fPulseBrightness = 1.0 - abs(fDistance * 0.00033 - fRadarPulse);
	} else {
		fPulseBrightness = 1.0 - abs(fDistance * 0.00033 - fRadarPulse - 1);
	}

	canvas.DrawColor = class'Colors'.static.MultiplyColor(GetPawnTypeColor(p), fPulseBrightness);
	canvas.Style     = 3;
	canvas.SetPos(fRadarX, fRadarY);
	canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', fDotSize, fDotSize, 838, 238, 144, 144);

	if (p.GetTeam() == ViewportOwner.Actor.Pawn.GetTeam()) {
		if (bShowFriendlyHealth == True) {
			DrawPawnHealthBar(canvas, p, fPulseBrightness, fRadarX, fRadarY - fDotSize * 0.35, fDotSize, fDotSize * 0.30);
		}
	} else {
		if (bShowHostileHealth == True) {
			DrawPawnHealthBar(canvas, p, fPulseBrightness, fRadarX, fRadarY - fDotSize * 0.35, fDotSize, fDotSize * 0.30);
		}
	}
}

function DrawTargets(
	Canvas canvas,
	float  fRadarPosX,
	float  fRadarPosY,
	float  fRadarSize
) {
	local Pawn    p;
	local float   fPulseDistance;

	fPulseDistance    = fRadarDistance * fRadarPulse;
	fMinEnemyDistance = fRadarDistance;
	fLastDrawRadar    = ViewportOwner.Actor.Level.TimeSeconds;

	foreach ViewportOwner.Actor.DynamicActors(class'Pawn', p) {
		if (p.Health > 0) {
			// Don't draw an indicator for yourself.
			if (
				(p == ViewportOwner.Actor.Pawn) ||
				(
					(Vehicle(p) != None) &&
					(Vehicle(p).Driver == ViewportOwner.Actor.Pawn)
				)
			) {
				continue;
			}

			DrawIndicator(
				canvas,
				fRadarPosX,
				fRadarPosY,
				fRadarSize,
				p,
				fPulseDistance
			);
		}
	}
}

function DrawRadar(
	Canvas canvas,
	float  fRadarPosX,
	float  fRadarPosY,
	float  fRadarSize,
	float  fPulseWidth
) {
	local rotator Direction;
	local vector  vecZero;
	local color   colorPulse;
	local float   PulseBrightness;

	Direction = rotator(vecZero - ViewportOwner.Actor.Pawn.Location);

	colorPulse = class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn);

	canvas.DrawColor = colorPulse;

	PulseBrightness = FMax(0, (1 - 2 * fRadarPulse));
	canvas.DrawColor.R = PulseBrightness * colorPulse.R;
	canvas.DrawColor.G = PulseBrightness * colorPulse.G;
	canvas.DrawColor.B = PulseBrightness * colorPulse.B;

	canvas.Style = 3;

	canvas.SetPos(
		fRadarPosX * canvas.ClipX - 0.5 * fPulseWidth,
		fRadarPosY * canvas.ClipY + fRadarSize - 0.5 * fPulseWidth
	);

	canvas.DrawTile(Material'InterfaceContent.SkinA', fPulseWidth, fPulseWidth, 0, 880, 142, 142);

	fPulseWidth = fRadarPulse * fRadarScale * canvas.ClipX;

	canvas.DrawColor = colorPulse;

	canvas.SetPos(
		fRadarPosX * canvas.ClipX - 0.5 * fPulseWidth,
		fRadarPosY * canvas.ClipY + fRadarSize - 0.5 * fPulseWidth
	);

	canvas.DrawTile(Material'InterfaceContent.SkinA', fPulseWidth, fPulseWidth, 0, 880, 142, 142);

	canvas.Style       = 5;
	canvas.DrawColor   = colorPulse;
	canvas.DrawColor.A = 255;
	canvas.SetPos(fRadarPosX * canvas.ClipX - fRadarSize, fRadarPosY * canvas.ClipY + fRadarSize);
	canvas.DrawTile(Material'AS_FX_TX.AssaultRadar', fRadarSize, fRadarSize, 0, 512, 512, -512);
	canvas.SetPos(fRadarPosX * canvas.ClipX, fRadarPosY * canvas.ClipY + fRadarSize);
	canvas.DrawTile(Material'AS_FX_TX.AssaultRadar', fRadarSize, fRadarSize, 512, 512, -512, -512);
	canvas.SetPos(fRadarPosX * canvas.ClipX - fRadarSize, fRadarPosY * canvas.ClipY);
	canvas.DrawTile(Material'AS_FX_TX.AssaultRadar', fRadarSize, fRadarSize, 0, 0, 512, 512);
	canvas.SetPos(fRadarPosX * canvas.ClipX, fRadarPosY * canvas.ClipY);
	canvas.DrawTile(Material'AS_FX_TX.AssaultRadar', fRadarSize, fRadarSize, 512, 0, -512, 512);
}

function PreRender(Canvas Canvas)
{
	local int i;
	local float Dist, XScale, YScale, HealthScale, ScreenX;
	local vector BarLoc, CameraLocation, X, Y, Z;
	local rotator CameraRotation;
	local Pawn Enemy;

	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return;
	}

	OwnerStats = FindWopStatsInv();

	if (OwnerStats == None) {
		return;
	}

	if (class'WopRpgInteraction'.static.ShouldDisplayHud(ViewportOwner) == false) {
		return;
	}

	if (OwnerStats.CurrentAwarenessLevel <= 0) {
		return;
	}

	for (i = 0; i < EnemyList.Enemies.length; i++)
	{
		Enemy = EnemyList.Enemies[i];
		if (Enemy == None || Enemy.Health <= 0 || (xPawn(Enemy) != None && xPawn(Enemy).bInvis))
			continue;
		Canvas.GetCameraLocation(CameraLocation, CameraRotation);
		if (Normal(Enemy.Location - CameraLocation) dot vector(CameraRotation) < 0)
			continue;
		ScreenX = Canvas.WorldToScreen(Enemy.Location).X;
		if (ScreenX < 0 || ScreenX > Canvas.ClipX)
			continue;
 		Dist = VSize(Enemy.Location - CameraLocation);
 		if (Dist > ViewportOwner.Actor.TeamBeaconMaxDist * FClamp(0.04 * Enemy.CollisionRadius, 1.0, 3.0))
 			continue;
		if (!Enemy.FastTrace(Enemy.Location + Enemy.CollisionHeight * vect(0,0,1), ViewportOwner.Actor.Pawn.Location + ViewportOwner.Actor.Pawn.EyeHeight * vect(0,0,1)))
			continue;

		GetAxes(rotator(Enemy.Location - CameraLocation), X, Y, Z);
		if (Enemy.IsA('Monster'))
		{
			BarLoc = Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight * 1.25 + BarVSize / 2) * vect(0,0,1) - Enemy.CollisionRadius * Y);
		}
		else
		{
			BarLoc = Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight + BarVSize / 2) * vect(0,0,1) - Enemy.CollisionRadius * Y);
		}
		XScale = (Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight + BarVSize / 2) * vect(0,0,1) + Enemy.CollisionRadius * Y).X - BarLoc.X) / BarUSize;
		YScale = FMin(0.15 * XScale, 0.50);

 		Canvas.SetPos(BarLoc.X, BarLoc.Y);
 		Canvas.Style = 1;
 		HealthScale = Enemy.Health / Enemy.HealthMax;
 		if (OwnerStats.CurrentAwarenessLevel > 1)
		{
	 		if (HealthScale > 0.5)
 			{
	 			Canvas.DrawColor.R = Clamp(255 * (1.f - (Enemy.HealthMax - (Enemy.HealthMax - Enemy.Health) * 2)/Enemy.HealthMax), 0, 255);
	 			Canvas.DrawColor.G = 255;
		 		Canvas.DrawColor.B = 0;
		 		Canvas.DrawColor.A = 255;
	 		}
		 	else
		 	{
	 			Canvas.DrawColor.R = 255;
	 			Canvas.DrawColor.G = Clamp(255 * (2.f * HealthScale), 0, 255);
		 		Canvas.DrawColor.B = 0;
		 		Canvas.DrawColor.A = 255;
	 		}
	 		if (HealthScale > 1.0) {
		 		HealthScale = 1.0;
	 		}
			Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*HealthScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
			if (Enemy.ShieldStrength > 0 && xPawn(Enemy) != None)
			{
				Canvas.DrawColor = class'HUD'.default.GoldColor;
				YScale /= 2;
				Canvas.SetPos(BarLoc.X, BarLoc.Y - BarVSize * (YScale + 0.05));
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*Enemy.ShieldStrength/xPawn(Enemy).ShieldStrengthMax, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
			}
		}
		else
		{
			if (HealthScale < 0.25)
				Canvas.DrawColor = class'HUD'.default.RedColor;
			else if (HealthScale < 0.50)
				Canvas.DrawColor = class'HUD'.default.GoldColor;
			else
				Canvas.DrawColor = class'HUD'.default.GreenColor;
			Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
		}
	}
}

function PostRender(Canvas canvas) {
	local float fRadarSize;
	local float fPulseWidth;

	iDebug = 0;

	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return;
	}

	OwnerStats = FindWopStatsInv();

	if (OwnerStats == None) {
		return;
	}

	if (class'WopRpgInteraction'.static.ShouldDisplayHud(ViewportOwner) == false) {
		return;
	}

	if (OwnerStats.ShouldShowRadar() == false)	{
		return;
	}

	if (ViewportOwner.Actor.myHUD.IsA('AwarenessInvasionHUD') == true) {
		// Sync the two radars so the pulse is at the same location in both.
		fRadarPulse = AwarenessInvasionHUD(ViewportOwner.Actor.myHUD).RadarPulse;
	}

	fRadarScale = Default.fRadarScale * ViewportOwner.Actor.myHud.HudScale;
	fRadarSize  = 0.5 * fRadarScale * canvas.ClipX;
	fPulseWidth = fRadarScale * canvas.ClipX;

	DrawRadar(
		canvas,
		fRadarPosX,
		fRadarPosY,
		fRadarSize,
		fPulseWidth
	);

	DrawTargets(
		canvas,
		fRadarPosX,
		fRadarPosY,
		fRadarSize
	);
}

function Tick(float fDeltaTime) {
	Super.Tick(fDeltaTime);

	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		OwnerStats = None;
		return;
	}

	if (ViewportOwner.Actor.myHUD.IsA('AwarenessInvasionHUD') == false) {
		fRadarPulse = fRadarPulse + 0.5 * fDeltaTime;

		if (fRadarPulse >= 1) {
			if (
				(bNoRadarSound == False) &&
				(ViewportOwner.Actor.Level.TimeSeconds - fLastDrawRadar < 0.2)
			) {
				ViewportOwner.Actor.ClientPlaySound(
					Sound'RadarPulseSound',
					true,
					FMin(1.0, 300 / fMinEnemyDistance)
				);
			}

			fRadarPulse = fRadarPulse - 1;
		}
	}
}

function WopStatsInv FindWopStatsInv() {
	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return None;
	}

	return WopStatsInv(ViewportOwner.Actor.Pawn.FindInventoryType(class'WopStatsInv'));
}

event NotifyLevelChange() {
	EnemyList.Destroy();
	EnemyList = None;
	Master.RemoveInteraction(self);
}

defaultproperties
{
    fRadarDistance=3000.00
    fRadarScale=0.20
    fRadarPosX=0.90
    fRadarPosY=0.25
    bShowFriendlyHealth=True
    bShowHostileHealth=True
    HealthBarMaterial=Texture'Engine.WhiteSquareTexture'
    iDebug=200
    bActive=False
    bVisible=True
    bRequiresTick=True
}
