class IPWaveConfig extends GUICustomPropertyPage;

var() int ActiveWave;
var() Automated GUIButton b_Copy;
var() Automated GUIButton b_Paste;
var() Automated GUIButton b_Reset;
var() Automated GUIButton b_Random;
var() Automated GUIButton b_Default;
// var() Automated GUIButton b_OK;
// var() Automated GUIButton b_Cancel;
var() Automated moCheckBox currentbBossWave;
var() Automated moCheckBox currentbBossesSpawnTogether;
var() Automated moFloatEdit currentWaveDifficulty;
var() Automated moNumericEdit currentWave;
var() Automated moNumericEdit currentWaveDuration;
var() Automated moNumericEdit currentWaveMaxMonsters;
var() Automated moNumericEdit currentMaxMonsters;
var() Automated moNumericEdit currentWaveOverTimeDamage;
var() Automated moNumericEdit currentBossTimeLimit;
var() Automated moEditBox currentBossID;
var() Automated moNumericEdit currentMaxLives;
var() Automated moComboBox currentFallbackMonster;
var() Automated moComboBox currentWaveMonster[30];
var() Automated moEditBox currentWaveName;
var() Automated moNumericEdit currentFallbackBossID;
var() Automated moSlider currentWaveColourR;
var() Automated moSlider currentWaveColourG;
var() Automated moSlider currentWaveColourB;
var() Automated GUILabel currentWaveColour;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i, h;

	Super.InitComponent(MyController, MyOwner);

	b_OK.WinWidth = default.b_OK.WinWidth;
	b_OK.WinHeight = default.b_OK.WinHeight;
	b_OK.WinLeft = default.b_OK.WinLeft;
	b_OK.WinTop = default.b_OK.WinTop;
	b_Cancel.WinWidth = default.b_Cancel.WinWidth;
	b_Cancel.WinHeight = default.b_Cancel.WinHeight;
	b_Cancel.WinLeft = default.b_Cancel.WinLeft;
	b_Cancel.WinTop = default.b_Cancel.WinTop;

	currentFallbackMonster.MyComboBox.MaxVisibleItems=20;
	currentFallbackMonster.MyComboBox.Edit.FontScale=FNS_Small;
	currentFallbackMonster.StandardHeight=0.03;

	sb_Main.Caption = "Wave Configuration";
	sb_Main.bScaleToParent=true;
	sb_Main.WinWidth=0.948281;
	sb_Main.WinHeight=0.918939;
	sb_Main.WinLeft=0.025352;
	sb_Main.WinTop=0.045161;

	t_WindowTitle.Caption = "Lumpys Invasion: Wave Configuration";

	for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
	{
		currentFallbackMonster.AddItem(class'IPMonsterTable'.default.MonsterTable[i].MonsterName);
	}

	for(i=0;i<30;i++)
	{
		currentWaveMonster[i].StandardHeight=0.04;
		currentWaveMonster[i].MyComboBox.MaxVisibleItems=15;
	}

	for(i=0;i<30;i++)
	{
		for(h=0;h<class'IPMonsterTable'.default.MonsterTable.Length;h++)
		{
			if(class'IPMonsterTable'.default.MonsterTable[h].MonsterName != "")
			{
				currentWaveMonster[i].AddItem(class'IPMonsterTable'.default.MonsterTable[h].MonsterName);
			}
			else
			{
				currentWaveMonster[i].SetText("None");
			}
		}
	}

	currentBossID.MyEditBox.AllowedCharSet = "0123456789,";
	currentWave.SetValue(0);
	ActiveWave = currentWave.GetValue();
	RefreshWave();
}

function bool InternalDraw(Canvas Canvas)
{
	local color TestColor;

	if(Canvas != None)
	{
		TestColor.R = currentWaveColourR.GetValue();
		TestColor.G = currentWaveColourG.GetValue();
		TestColor.B = currentWaveColourB.GetValue();
		TestColor.A = 255;
		currentWaveColour.TextColor = TestColor;
		currentWaveColour.FocusedTextColor = TestColor;
	}

	return false;
}

function bool ExitWave(GUIComponent Sender)
{
	Controller.CloseMenu(false);

	return true;
}

function bool InternalOnClick(GUIComponent Sender)
{
	Controller.CloseMenu(false);
	return true;
}

function InternalOnChange(GUIComponent Sender)
{
	if(Sender == currentWave)
	{
		ActiveWave = currentWave.GetValue();
		RefreshWave();
	}
}

function bool ClearWave(GUIComponent Sender)
{
	local int i;

	ActiveWave = currentWave.GetValue();
	for(i=0;i<30;i++)
	{
		currentWaveMonster[i].SetText("None");
	}

	return true;
}

function bool RandomWave(GUIComponent Sender)
{
	local int i;

	ActiveWave = currentWave.GetValue();
	for(i=0;i<30;i++)
	{
		currentWaveMonster[i].SetText(RandomMonster());
	}

	return true;
}

function bool DefaultWave(GUIComponent Sender)
{
	local int i;

	ActiveWave = currentWave.GetValue();

	currentbBossWave.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].bBossWave);
	currentBossID.SetText(class'IPDefaultWaves'.default.Waves[ActiveWave].BossID);
	currentFallbackBossID.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].FallbackBossID);
	currentWaveName.SetText(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveName);
	currentWaveDuration.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveDuration);
	currentWaveDifficulty.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveDifficulty);
	currentWaveMaxMonsters.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveMaxMonsters);
	currentFallbackMonster.SetText(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveFallbackMonster);
	currentMaxLives.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].MaxLives);
	currentWaveColourR.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveDrawColour.R);
	currentWaveColourG.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveDrawColour.G);
	currentWaveColourB.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].WaveDrawColour.B);
	currentMaxMonsters.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].MaxMonsters);
	currentWaveOverTimeDamage.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].BossOverTimeDamage);
	currentBossTimeLimit.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].BossTimeLimit);
	currentbBossesSpawnTogether.SetComponentValue(class'IPDefaultWaves'.default.Waves[ActiveWave].bBossesSpawnTogether);

	for(i=0;i<30;i++)
	{
		if(class'IPDefaultWaves'.default.Waves[ActiveWave].Monsters[i] != "")
		{
			currentWaveMonster[i].SetText(class'IPDefaultWaves'.default.Waves[ActiveWave].Monsters[i]);
		}
		else
		{
			currentWaveMonster[i].SetText("None");
		}
	}

	return true;
}

function string RandomMonster()
{
	local string LuckyMonster;
	local int i;

	i = Max(1,Rand(class'IPMonsterTable'.default.MonsterTable.Length));
	//default to which ever monster happens to be in number 1 position (default is pupae)
	LuckyMonster = class'IPMonsterTable'.default.MonsterTable[i].MonsterName;
	return LuckyMonster;
}

function bool SaveWave(GUIComponent Sender)
{
	local int i;

	ActiveWave = currentWave.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].BossID = currentBossID.GetText();
	class'IPConfigs'.default.Waves[ActiveWave].bBossWave = currentbBossWave.IsChecked();
	class'IPConfigs'.default.Waves[ActiveWave].FallbackBossID = currentFallbackBossID.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveName = currentWaveName.GetText();
	class'IPConfigs'.default.Waves[ActiveWave].WaveDuration = currentWaveDuration.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveDifficulty = currentWaveDifficulty.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveMaxMonsters = currentWaveMaxMonsters.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].MaxMonsters = currentMaxMonsters.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveFallbackMonster = currentFallbackMonster.GetText();
	class'IPConfigs'.default.Waves[ActiveWave].MaxLives = currentMaxLives.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.R = currentWaveColourR.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.G = currentWaveColourG.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.B = currentWaveColourB.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].BossOverTimeDamage = currentWaveOverTimeDamage.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].BossTimeLimit = currentBossTimeLimit.GetValue();
	class'IPConfigs'.default.Waves[ActiveWave].bBossesSpawnTogether = currentbBossesSpawnTogether.IsChecked();

	for(i=0;i<30;i++)
	{
		class'IPConfigs'.default.Waves[ActiveWave].Monsters[i] = currentWaveMonster[i].GetText();
	}

	class'IPConfigs'.static.StaticSaveConfig();
	return true;
}

function RefreshWave()
{
	local int i;

	ActiveWave = currentWave.GetValue();
	if( (ActiveWave + 1) > class'IPConfigs'.default.Waves.Length )
	{
		class'IPConfigs'.default.Waves.Insert(class'IPConfigs'.default.Waves.Length, 1);
		class'IPConfigs'.static.StaticSaveConfig();
	}

	currentbBossWave.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].bBossWave);
	currentBossID.SetText(class'IPConfigs'.default.Waves[ActiveWave].BossID);
	currentFallbackBossID.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].FallbackBossID);
	currentWaveName.SetText(class'IPConfigs'.default.Waves[ActiveWave].WaveName);
	currentWaveDuration.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveDuration);
	currentWaveDifficulty.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveDifficulty);
	currentWaveMaxMonsters.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveMaxMonsters);
	currentMaxMonsters.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].MaxMonsters);
	currentFallbackMonster.SetText(class'IPConfigs'.default.Waves[ActiveWave].WaveFallbackMonster);
	currentMaxLives.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].MaxLives);
	currentWaveColourR.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.R);
	currentWaveColourG.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.G);
	currentWaveColourB.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].WaveDrawColour.B);
	currentWaveOverTimeDamage.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].BossOverTimeDamage);
	currentBossTimeLimit.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].BossTimeLimit);
	currentbBossesSpawnTogether.SetComponentValue(class'IPConfigs'.default.Waves[ActiveWave].bBossesSpawnTogether);

	for(i=0;i<30;i++)
	{
		if(class'IPConfigs'.default.Waves[ActiveWave].Monsters[i] != "")
		{
			currentWaveMonster[i].SetText(class'IPConfigs'.default.Waves[ActiveWave].Monsters[i]);
		}
		else
		{
			currentWaveMonster[i].SetText("None");
		}
	}
}

function bool CopyWave(GUIComponent Sender)
{
	local int i;

	class'IPCopyPaste'.default.ClipBoardbBossWave = currentbBossWave.IsChecked();
	class'IPCopyPaste'.default.ClipBoardbBossesSpawnTogether = currentbBossesSpawnTogether.IsChecked();
	class'IPCopyPaste'.default.ClipBoardBossID = currentBossID.GetText();
	class'IPCopyPaste'.default.ClipBoardFallbackBossID = currentFallbackBossID.GetValue();
	class'IPCopyPaste'.default.ClipBoardBossOverTimeDamage = currentWaveOverTimeDamage.GetValue();
	class'IPCopyPaste'.default.ClipBoardBossTimeLimit = currentBossTimeLimit.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveDrawColour.R = currentWaveColourR.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveDrawColour.G = currentWaveColourG.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveDrawColour.B = currentWaveColourB.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveDuration = currentWaveDuration.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveDifficulty = currentWaveDifficulty.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveMaxMonsters = currentWaveMaxMonsters.GetValue();
	class'IPCopyPaste'.default.ClipBoardMaxMonsters = currentMaxMonsters.GetValue();
	class'IPCopyPaste'.default.ClipBoardMaxLives = currentMaxLives.GetValue();
	class'IPCopyPaste'.default.ClipBoardWaveFallbackMonster = currentFallbackMonster.GetText();

	for(i=0;i<30;i++)
	{
		class'IPCopyPaste'.default.ClipBoardMonsters[i] = currentWaveMonster[i].GetText();
	}

	class'IPCopyPaste'.static.StaticSaveConfig();
	return true;
}

function bool PasteWave(GUIComponent Sender)
{
	local int i;

	currentbBossWave.SetComponentValue(class'IPCopyPaste'.default.ClipBoardbBossWave);
	currentBossID.SetText(class'IPCopyPaste'.default.ClipBoardBossID);
	currentFallbackBossID.SetComponentValue(class'IPCopyPaste'.default.ClipBoardFallbackBossID);
	//currentWaveName.SetText(class'IPCopyPaste'.default.ClipBoardWaveName);
	currentWaveDuration.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveDuration);
	currentWaveDifficulty.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveDifficulty);
	currentWaveMaxMonsters.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveMaxMonsters);
	currentMaxMonsters.SetComponentValue(class'IPCopyPaste'.default.ClipBoardMaxMonsters);
	currentFallbackMonster.SetText(class'IPCopyPaste'.default.ClipBoardWaveFallbackMonster);
	currentMaxLives.SetComponentValue(class'IPCopyPaste'.default.ClipBoardMaxLives);
	currentWaveColourR.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveDrawColour.R);
	currentWaveColourG.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveDrawColour.G);
	currentWaveColourB.SetComponentValue(class'IPCopyPaste'.default.ClipBoardWaveDrawColour.B);
	currentWaveOverTimeDamage.SetComponentValue(class'IPCopyPaste'.default.ClipBoardBossOverTimeDamage);
	currentBossTimeLimit.SetComponentValue(class'IPCopyPaste'.default.ClipBoardBossTimeLimit);
	currentbBossesSpawnTogether.SetComponentValue(class'IPCopyPaste'.default.ClipBoardbBossesSpawnTogether);

	for(i=0;i<30;i++)
	{
		currentWaveMonster[i].SetText(class'IPCopyPaste'.default.ClipBoardMonsters[i]);
	}

	return true;
}

defaultproperties
{

    bRequire640x480=True
    WinTop=0.05
    WinLeft=0.00
    WinWidth=1.00
    WinHeight=0.90
    bScaleToParent=True

    begin object name=CopyButton class=GUIButton
        WinWidth=0.096758
		WinHeight=0.043801
		WinLeft=0.450489
		WinTop=0.910102
        OnClick=IPWaveConfig.CopyWave
        Caption="Copy"
    end object
    b_Copy=GUIButton'IPWaveConfig.CopyButton'

    begin object name=PasteButton class=GUIButton
        WinWidth=0.096758
		WinHeight=0.043801
		WinLeft=0.554238
		WinTop=0.910102
        OnClick=IPWaveConfig.PasteWave
        Caption="Paste"
    end object
    b_Paste=GUIButton'IPWaveConfig.PasteButton'

    begin object name=ResetButton class=GUIButton
		WinWidth=0.121758
		WinHeight=0.043801
		WinLeft=0.322483
		WinTop=0.910102
        OnClick=IPWaveConfig.ClearWave
        Caption="Clear All"
    end object
    b_Reset=GUIButton'IPWaveConfig.ResetButton'

    begin object name=RandomButton class=GUIButton
        WinWidth=0.121758
		WinHeight=0.043801
		WinLeft=0.197489
		WinTop=0.910102
        OnClick=IPWaveConfig.RandomWave
        Caption="Random"
    end object
    b_Random=GUIButton'IPWaveConfig.RandomButton'

    begin object name=LockedDefaultButton class=GUIButton
        WinWidth=0.121758
		WinHeight=0.043801
		WinLeft=0.073427
		WinTop=0.910102
        OnClick=IPWaveConfig.DefaultWave
        Caption="Default"
    end object
    b_Default=GUIButton'IPWaveConfig.LockedDefaultButton'

    begin object name=bBossWave class=moCheckBox
        WinWidth=0.156239
		WinHeight=0.030000
		WinLeft=0.336451
		WinTop=0.107481
        Caption="Boss Wave"
    end object
    currentbBossWave=moCheckBox'IPWaveConfig.bBossWave'
    
    begin object name=bBossesSpawnTogether class=moCheckBox
        WinWidth=0.277489
		WinHeight=0.030000
		WinLeft=0.051451
		WinTop=0.150814
        Caption="Bosses Spawn Together"
    end object
    currentbBossesSpawnTogether=moCheckBox'IPWaveConfig.bBossesSpawnTogether'

    begin object name=WaveDifficulty class=moFloatEdit
        WinWidth=0.233773
		WinHeight=0.033333
		WinLeft=0.334639
		WinTop=0.214198
        Caption="Wave Difficulty"
    end object
    currentWaveDifficulty=moFloatEdit'IPWaveConfig.WaveDifficulty'

    begin object name=WaveNumber class=moNumericEdit
        WinWidth=0.277489
		WinHeight=0.033333
		WinLeft=0.051084
		WinTop=0.107597
        Caption="Wave Num"
        OnChange=IPWaveConfig.InternalOnChange
    end object
    currentWave=moNumericEdit'IPWaveConfig.WaveNumber'

    begin object name=WaveDuration class=moNumericEdit
        WinWidth=0.233773
		WinHeight=0.033333
		WinLeft=0.334639
		WinTop=0.165159
        Caption="Wave Duration"
    end object
    currentWaveDuration=moNumericEdit'IPWaveConfig.WaveDuration'

    begin object name=WaveMaxMonsters class=moNumericEdit
		WinWidth=0.375022
		WinHeight=0.033333
		WinLeft=0.577958
		WinTop=0.214198
        Caption="Wave Max Monsters"
    end object
    currentWaveMaxMonsters=moNumericEdit'IPWaveConfig.WaveMaxMonsters'

    begin object name=MaxMonsters class=moNumericEdit
        WinWidth=0.233773
		WinHeight=0.033333
		WinLeft=0.334639
		WinTop=0.261328
        Caption="Max Monsters"
    end object
    currentMaxMonsters=moNumericEdit'IPWaveConfig.MaxMonsters'

    begin object name=WaveOverTimeDamage class=moNumericEdit
        WinWidth=0.277489
		WinHeight=0.033333
		WinLeft=0.051084
		WinTop=0.327968
        Caption="Wave OverTime Damage"
    end object
    currentWaveOverTimeDamage=moNumericEdit'IPWaveConfig.WaveOverTimeDamage'

    begin object name=BossTimeLimit class=moNumericEdit
        WinWidth=0.277489
		WinHeight=0.033333
		WinLeft=0.051084
		WinTop=0.285375
        Caption="Boss Time Limit"
    end object
    currentBossTimeLimit=moNumericEdit'IPWaveConfig.BossTimeLimit'

    begin object name=BossID class=moEditBox
        WinWidth=0.277489
		WinHeight=0.044444
		WinLeft=0.050643
		WinTop=0.189842
        Caption="Boss ID"
    end object
    currentBossID=moEditBox'IPWaveConfig.BossID'

    begin object name=MaxLives class=moNumericEdit
        WinWidth=0.375022
		WinHeight=0.033333
		WinLeft=0.577958
		WinTop=0.261298
        Caption="Max Lives"
    end object
    currentMaxLives=moNumericEdit'IPWaveConfig.MaxLives'

    begin object name=FallbackMonster class=moComboBox
        WinWidth=0.373480
		WinHeight=0.033333
		WinLeft=0.577016
		WinTop=0.166187
        Caption="Fallback Monster"
    end object
    currentFallbackMonster=moComboBox'IPWaveConfig.FallbackMonster'

    //0.04164
    begin object name=MonsterNum01 class=moComboBox
        WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.447815
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(0)=moComboBox'IPWaveConfig.MonsterNum01'

    begin object name=MonsterNum02 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.489455
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(1)=moComboBox'IPWaveConfig.MonsterNum02'

    begin object name=MonsterNum03 class=moComboBox
        WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.531095
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(2)=moComboBox'IPWaveConfig.MonsterNum03'

    begin object name=MonsterNum04 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.572736
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(3)=moComboBox'IPWaveConfig.MonsterNum04'

    begin object name=MonsterNum05 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.614376
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(4)=moComboBox'IPWaveConfig.MonsterNum05'

    begin object name=MonsterNum06 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.656016
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(5)=moComboBox'IPWaveConfig.MonsterNum06'

    begin object name=MonsterNum07 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.697656
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(6)=moComboBox'IPWaveConfig.MonsterNum07'

    begin object name=MonsterNum08 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.739296
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(7)=moComboBox'IPWaveConfig.MonsterNum08'

    begin object name=MonsterNum09 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.780936
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(8)=moComboBox'IPWaveConfig.MonsterNum09'

    begin object name=MonsterNum10 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.068388
		WinTop=0.822576
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(9)=moComboBox'IPWaveConfig.MonsterNum10'

    begin object name=MonsterNum11 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.447815
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(10)=moComboBox'IPWaveConfig.MonsterNum11'

    begin object name=MonsterNum12 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.489455
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(11)=moComboBox'IPWaveConfig.MonsterNum12'

        begin object name=MonsterNum13 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.531095
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(12)=moComboBox'IPWaveConfig.MonsterNum13'

    begin object name=MonsterNum14 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.572735
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(13)=moComboBox'IPWaveConfig.MonsterNum14'

    begin object name=MonsterNum15 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.614375
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(14)=moComboBox'IPWaveConfig.MonsterNum15'

    begin object name=MonsterNum16 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.656015
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(15)=moComboBox'IPWaveConfig.MonsterNum16'

    begin object name=MonsterNum17 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.697655
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(16)=moComboBox'IPWaveConfig.MonsterNum17'

    begin object name=MonsterNum18 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.739295
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(17)=moComboBox'IPWaveConfig.MonsterNum18'

    begin object name=MonsterNum19 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.780935
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(18)=moComboBox'IPWaveConfig.MonsterNum19'

    begin object name=MonsterNum20 class=moComboBox
		WinWidth=0.220556
		WinHeight=0.020000
		WinLeft=0.382208
		WinTop=0.822576
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(19)=moComboBox'IPWaveConfig.MonsterNum20'
    
    begin object name=MonsterNum21 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.447815
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(20)=moComboBox'IPWaveConfig.MonsterNum21'

    begin object name=MonsterNum22 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.489455
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(21)=moComboBox'IPWaveConfig.MonsterNum22'

    begin object name=MonsterNum23 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.531095
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(22)=moComboBox'IPWaveConfig.MonsterNum23'

    begin object name=MonsterNum24 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.572735
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(23)=moComboBox'IPWaveConfig.MonsterNum24'

    begin object name=MonsterNum25 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.614375
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(24)=moComboBox'IPWaveConfig.MonsterNum25'

    begin object name=MonsterNum26 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.656015
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(25)=moComboBox'IPWaveConfig.MonsterNum26'

    begin object name=MonsterNum27 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.697655
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(26)=moComboBox'IPWaveConfig.MonsterNum27'

    begin object name=MonsterNum28 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.739295
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(27)=moComboBox'IPWaveConfig.MonsterNum28'

    begin object name=MonsterNum29 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.780935
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(28)=moComboBox'IPWaveConfig.MonsterNum29'

        begin object name=MonsterNum30 class=moComboBox
        WinWidth=0.231566
		WinHeight=0.020000
		WinLeft=0.716932
		WinTop=0.822575
        ComponentJustification=TXTA_Left
        ComponentWidth=-1
        CaptionWidth=0.1
        bVerticalLayout=True
        bHeightFromComponent=True
        bStandardized=False
    end object
    currentWaveMonster(29)=moComboBox'IPWaveConfig.MonsterNum30'

    begin object name=WaveName class=moEditBox
		WinWidth=0.457147
		WinHeight=0.030000
		WinLeft=0.505993
		WinTop=0.105777
        Caption="Wave Name"
    end object
    currentWaveName=moEditBox'IPWaveConfig.WaveName'

    begin object name=FallbackBossID class=moNumericEdit
        WinWidth=0.277489
		WinHeight=0.033333
		WinLeft=0.050643
		WinTop=0.241959
        Caption="Fallback Boss ID"
    end object
    currentFallbackBossID=moNumericEdit'IPWaveConfig.FallbackBossID'

    begin object name=WaveColourR class=moSlider
        WinWidth=0.128065
		WinHeight=0.033333
		WinLeft=0.521884
		WinTop=0.313916
        Caption="R"
        MaxValue=255
        MinValue=0
        ComponentWidth=-1
        CaptionWidth=0.1
    end object
    currentWaveColourR=moSlider'IPWaveConfig.WaveColourR'

    begin object name=WaveColourG class=moSlider
		WinWidth=0.128065
		WinHeight=0.033333
		WinLeft=0.671173
		WinTop=0.313916
        Caption="G"
        MaxValue=255
        MinValue=0
        ComponentWidth=-1
        CaptionWidth=0.1
    end object
    currentWaveColourG=moSlider'IPWaveConfig.WaveColourG'

    begin object name=WaveColourB class=moSlider
		WinWidth=0.128065
		WinHeight=0.033333
		WinLeft=0.821647
		WinTop=0.313916
        Caption="B"
        MaxValue=255
        MinValue=0
        ComponentWidth=-1
        CaptionWidth=0.1
    end object
    currentWaveColourB=moSlider'IPWaveConfig.WaveColourB'

    begin object name=WaveColour class=GUILabel
        WinWidth=0.181976
		WinHeight=0.037037
		WinLeft=0.334867
		WinTop=0.313688
        Caption="Wave Colour"
        OnDraw=IPWaveConfig.InternalDraw
    end object
    currentWaveColour=GUILabel'IPWaveConfig.WaveColour'

    begin object name=InternalFrameImage class=AltSectionBackground
        WinWidth=0.948281
		WinHeight=0.918939
		WinLeft=0.025352
		WinTop=0.045161
    end object
    sb_Main=AltSectionBackground'IPWaveConfig.InternalFrameImage'

    begin object name=LockedCancelButton class=GUIButton
        WinWidth=0.121758
		WinHeight=0.043801
		WinLeft=0.803740
		WinTop=0.910102
        Caption="Close"
        OnClick=IPWaveConfig.InternalOnClick
    end object
    b_Cancel=GUIButton'IPWaveConfig.LockedCancelButton'

    begin object name=LockedOKButton class=GUIButton
        WinWidth=0.141758
		WinHeight=0.043801
		WinLeft=0.658740
		WinTop=0.910102
        Caption="Save Wave"
        OnClick=IPWaveConfig.SaveWave
    end object
    b_OK=GUIButton'IPWaveConfig.LockedOKButton'

}
