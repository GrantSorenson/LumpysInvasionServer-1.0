class BlooperInteraction extends Interaction;

var() float FontScaleX, FontScaleY;
var() float TextOnePosX, TextOnePosY;
var() float TextTwoPosX, TextTwoPosY;

var() int BGStyle;
var() int BGMatSizeX, BGMatSizeY;
var() int BGMatPosX, BGMatPosY;
var() int MatOnePosX, MatOnePosY;
var() int MatTwoPosX, MatTwoPosY;
var() int MaterialSizeX, MaterialSizeY;
var() int LocOffSetX, LocOffSetZ;
var() BlooperReplicationInfo MyRI;
//var() float InkDuration;
var() float InkStartTime;
var() Material InkMaterial;
var() float InkFadeStart;

event Initialized()
{
	InkStartTime = ViewportOwner.Actor.Level.TimeSeconds;
	InkFadeStart = 0;
	//InkMaterial = Material(DynamicLoadObject("MarioMonstersTextures.Effects.ink_splat1",class'Material',True));
}

//0 =STY_None 1 = STY_Normal 2 = STY_Masked 3 = STY_Translucent 4 = STY_Modulated 5 = STY_Alpha 6 = STY_Additive 7 = STY_Subtractive 8 = STY_Particle 9 = STY_AlphaZ
simulated function PostRender(Canvas Canvas)
{
	local Canvas C;
	local BlooperReplicationInfo RI;
	local float InkTime, MatAlpha;//, InkFadeStart;

    if (ViewportOwner.Actor.Pawn == None || ViewportOwner.Actor.Pawn.Health <= 0)
    {
		Master.RemoveInteraction(Self);
        return;
	}

	C = Canvas;

	if(MyRI != None)
	{
		InkTime = (ViewportOwner.Actor.Level.TimeSeconds - InkStartTime);// - MyRI.InkFadeStart;
		//InkFadeStart = ViewportOwner.Actor.Level.TimeSeconds - InkStartTime;//MyRI.InkFadeStart;
		if(InkTime > (MyRI.InkDuration+MyRI.InkFadeStart))
		{
			//ink time has exceeded initial ink period and fade time
			Master.RemoveInteraction(Self);
			return;
		}

		C.Reset();
		C.Style = 5;
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;

		if(InkTime < MyRI.InkFadeStart)
		{
			MatAlpha = 255;
			InkFadeStart = 0;
		}
		else
		{
			if(InkFadeStart <= 0)
			{
				InkFadeStart = ViewportOwner.Actor.Level.TimeSeconds;
			}


			InkTime = ViewportOwner.Actor.Level.TimeSeconds - InkFadeStart;
			//InkTime = InkTime+MyRI.InkFadeStart;
			MatAlpha = (InkTime * 100) / MyRI.InkDuration;
			MatAlpha = (MatAlpha * 255) / 100;
			MatAlpha = Clamp(255-byte(MatAlpha),0,255);
		}
		/*if(MatAlpha > 180)
		{
			MatAlpha+=2;
		}
		else if(MatAlpha < 100)
		{
			MatAlpha-=2;
		}*/

		C.DrawColor.A = MatAlpha;//byte(Clamp ( MatAlpha, 255, 0 ));
		//C.SetPos(MatOnePosX , MatOnePosY);
		C.SetPos((C.ClipX * TextOnePosX) - (Canvas.FontScaleX * MatOnePosX) , (C.ClipY * TextOnePosY) - (Canvas.FontScaleY * MatOnePosY));
		//MonsterMaterial = Material(DynamicLoadObject("MarioMonstersTextures.Effects.ink_splat1",class'Material',True));
		if(InkMaterial != None)
		{
			C.DrawTileJustified(InkMaterial, 0, MaterialSizeX, MaterialSizeY);
		}
	}
	else
	{
		foreach ViewportOwner.Actor.DynamicActors(class'BlooperReplicationInfo', RI)
		{
			if(RI != None)
			{
				MyRI = RI;
			}
		}
	}
}

simulated function NotifyLevelChange()
{
    Master.RemoveInteraction(Self);
}

defaultproperties
{
     FontScaleX=0.500000
     FontScaleY=0.500000
     TextOnePosX=0.500000
     TextOnePosY=0.500000
     TextTwoPosX=0.350000
     TextTwoPosY=0.890000
     BGStyle=1
     BGMatSizeX=138
     BGMatSizeY=138
     BGMatPosX=8
     BGMatPosY=498
     MatOnePosX=512
     MatOnePosY=256
     MatTwoPosX=10
     MatTwoPosY=570
     MaterialSizeX=1024
     MaterialSizeY=2048
     LocOffSetX=128
     InkMaterial=Texture'tk_MarioMonsters.MarioMonsters.ink_splat1'
     bVisible=True
     bRequiresTick=True
}
