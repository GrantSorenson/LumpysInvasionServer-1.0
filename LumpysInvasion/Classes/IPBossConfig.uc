class IPBossConfig extends GUICustomPropertyPage;

var() int ActiveBoss;
var() class<Monster> CurrentMonsterClass; //current monsterclass for current boss
var() bool bEditMode;

var() Automated moNumericEdit currentBoss;
var() Automated moNumericEdit currentBossID;
var() Automated moNumericEdit currentBossScoreAward;
var() Automated moNumericEdit currentBossHealth;

var() Automated moComboBox currentBossMonsterName;

var() Automated moEditBox currentBossName;
var() Automated moEditBox currentBossSound;

var() Automated moSlider currentGroundSpeed;
var() Automated moSlider currentAirSpeed;
var() Automated moSlider currentWaterSpeed;
var() Automated moSlider currentJumpZ;
var() Automated moSlider currentGibMultiplier;
var() Automated moSlider currentGibSizeMultiplier;
var() Automated moSlider currentBossDamageMultiplier;

var() Automated moFloatEdit currentDrawScale;
var() Automated moFloatEdit currentCollisionHeight;
var() Automated moFloatEdit currentCollisionRadius;

var() Automated moFloatEdit currentPrePivotX;
var() Automated moFloatEdit currentPrePivotY;
var() Automated moFloatEdit currentPrePivotZ;

var() Automated GUIButton b_EditMode;

var() Automated GUIButton b_Default;
var() Automated GUIButton b_Random;

var() Automated GUIButton b_Paste;

var() Automated GUILabel monsterPrePivotLabel;
var() Automated moCheckBox currentbSetup;

//var() String LastMonsterName;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;

	Super.InitComponent(MyController, MyOwner);

	b_OK.WinWidth=0.251747;
	b_OK.WinHeight=0.049962;
	b_OK.WinLeft=0.385094;
	b_OK.WinTop=0.782116;

	b_Cancel.WinWidth=0.251747;
	b_Cancel.WinHeight=0.049962;
	b_Cancel.WinLeft=0.385094;
	b_Cancel.WinTop=0.851290;

	currentBossMonsterName.MyComboBox.MaxVisibleItems=20;
	currentBossMonsterName.MyComboBox.Edit.FontScale=FNS_Small;
	currentBossMonsterName.StandardHeight=0.03;

	currentBossName.StandardHeight=0.03;

	sb_Main.Caption = "InvasionPro Boss Configuration";
	sb_Main.bScaleToParent=true;
	sb_Main.WinWidth=0.948281;
	sb_Main.WinHeight=0.918939;
	sb_Main.WinLeft=0.025352;
	sb_Main.WinTop=0.045161;

	t_WindowTitle.Caption = "InvasionPro: Boss Configuration";

	for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
	{
		currentBossMonsterName.AddItem(class'IPMonsterTable'.default.MonsterTable[i].MonsterName);
	}

	currentBossName.MyEditBox.FontScale=FNS_Small;

	currentBoss.Setup(0, class'IPConfigs'.default.Bosses.Length - 1, 1);
	currentBoss.SetValue(0);

	bEditMode = false;
	RefreshBoss(False);
}

function bool SaveBoss(GUIComponent Sender)
{
	ActiveBoss = currentBoss.GetValue();

	class'IPConfigs'.default.Bosses[ActiveBoss].BossID = currentBossID.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossMonsterName = currentBossMonsterName.GetText();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossName = currentBossName.GetText();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossHealth = currentBossHealth.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossScoreAward = currentBossScoreAward.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossDamageMultiplier = currentBossDamageMultiplier.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossGroundSpeed = currentGroundSpeed.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossAirSpeed = currentAirSpeed.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossWaterSpeed = currentWaterSpeed.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossJumpZ = currentJumpZ.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossGibMultiplier = currentGibMultiplier.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].BossGibSizeMultiplier = currentGibSizeMultiplier.GetValue();
	class'IPConfigs'.default.Bosses[ActiveBoss].WarningSound = currentBossSound.GetText();

	if(bEditMode || !class'IPConfigs'.default.Bosses[ActiveBoss].bSetup)
	{
		class'IPConfigs'.default.Bosses[ActiveBoss].NewDrawScale = currentDrawScale.GetValue();
		class'IPConfigs'.default.Bosses[ActiveBoss].NewCollisionHeight = currentCollisionHeight.GetValue();
		class'IPConfigs'.default.Bosses[ActiveBoss].NewCollisionRadius = currentCollisionRadius.GetValue();
		class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.X = currentPrePivotX.GetValue();
		class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.Y = currentPrePivotY.GetValue();
		class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.Z = currentPrePivotZ.GetValue();
	}

	class'IPConfigs'.default.Bosses[ActiveBoss].bSetup = true;

	class'IPConfigs'.static.StaticSaveConfig();

	return true;
}

function bool ExitBoss(GUIComponent Sender)
{
	Controller.CloseMenu(false);

	return true;
}

function SetNone()
{
	currentBossID.SetComponentValue(0);
	currentBossMonsterName.SetText("This is a fake boss");
	currentBossName.SetText("None");
	currentBossSound.SetText("None");
	currentBossHealth.SetComponentValue(0);
	currentBossScoreAward.SetComponentValue(0);
	currentBossDamageMultiplier.SetComponentValue(0);
	currentGroundSpeed.SetComponentValue(0);
	currentAirSpeed.SetComponentValue(0);
	currentWaterSpeed.SetComponentValue(0);
	currentJumpZ.SetComponentValue(0);
	currentGibMultiplier.SetComponentValue(0);
	currentGibSizeMultiplier.SetComponentValue(0);
	currentDrawScale.SetComponentValue(0);
	currentCollisionHeight.SetComponentValue(0);
	currentCollisionRadius.SetComponentValue(0);
	currentPrePivotX.SetComponentValue(0);
	currentPrePivotY.SetComponentValue(0);
	currentPrePivotZ.SetComponentValue(0);
	currentbSetup.SetComponentValue(false);
}

function bool DefaultBoss(GUIComponent Sender)
{
	//if(CurrentMonsterClass == None)
	//{
		RefreshBoss(False);
	//}

	if(CurrentMonsterClass != None)
	{
		currentBossHealth.SetComponentValue(CurrentMonsterClass.default.Health);
		currentBossScoreAward.SetComponentValue(CurrentMonsterClass.default.ScoringValue);
		currentBossDamageMultiplier.SetComponentValue(1.00);
		currentGroundSpeed.SetComponentValue(CurrentMonsterClass.default.GroundSpeed);
		currentAirSpeed.SetComponentValue(CurrentMonsterClass.default.AirSpeed);
		currentWaterSpeed.SetComponentValue(CurrentMonsterClass.default.WaterSpeed);
		currentJumpZ.SetComponentValue(CurrentMonsterClass.default.JumpZ);
		currentGibMultiplier.SetComponentValue(1.00);
		currentGibSizeMultiplier.SetComponentValue(1.00);
		currentDrawScale.SetComponentValue(CurrentMonsterClass.default.DrawScale);
		currentCollisionHeight.SetComponentValue(CurrentMonsterClass.default.CollisionHeight);
		currentCollisionRadius.SetComponentValue(CurrentMonsterClass.default.CollisionRadius);
		currentPrePivotX.SetComponentValue(CurrentMonsterClass.default.PrePivot.X);
		currentPrePivotY.SetComponentValue(CurrentMonsterClass.default.PrePivot.Y);
		currentPrePivotZ.SetComponentValue(CurrentMonsterClass.default.PrePivot.Z);
	}

	return true;
}

function bool RandomBoss(GUIComponent Sender)
{
	local int i;

	i = Max(100,Rand(1000));

	currentBossHealth.SetComponentValue( i );
	i = Max(10,Rand(200));
	currentBossScoreAward.SetComponentValue( i );
	currentBossDamageMultiplier.SetComponentValue(fRand() * 10);
	currentGroundSpeed.SetComponentValue(fRand() * 1000);
	currentAirSpeed.SetComponentValue(fRand() * 1000);
	currentWaterSpeed.SetComponentValue(fRand() * 1000);
	currentJumpZ.SetComponentValue(fRand() * 1000);
	currentGibMultiplier.SetComponentValue(fRand() * 10);
	currentGibSizeMultiplier.SetComponentValue(fRand() * 10);

	return true;
}

function bool InternalOnClick(GUIComponent Sender)
{
	Controller.CloseMenu(false);
	return true;
}

function InternalOnChange(GUIComponent Sender)
{
	if(Sender == currentBoss)
	{
		RefreshBoss(False);
	}
	else if(Sender == currentBossMonsterName && !currentbSetup.IsChecked())
	{
		RefreshBoss(True);
	}
}

function bool PasteSize(GUIComponent Sender)
{
	if(bEditMode)
	{
		currentDrawScale.SetComponentValue(class'IPCopyPaste'.default.ClipBoardDrawScale);
		currentCollisionHeight.SetComponentValue(class'IPCopyPaste'.default.ClipBoardCollisionHeight);
		currentCollisionRadius.SetComponentValue(class'IPCopyPaste'.default.ClipBoardCollisionRadius);
		currentPrePivotX.SetComponentValue(class'IPCopyPaste'.default.ClipBoardPrePivot.X);
		currentPrePivotY.SetComponentValue(class'IPCopyPaste'.default.ClipBoardPrePivot.Y);
		currentPrePivotZ.SetComponentValue(class'IPCopyPaste'.default.ClipBoardPrePivot.Z);
	}

	return true;
}

function bool ValidString(String TestString)
{
	if(TestString ~= "" || TestString ~= "None" || TestString ~= "This is a fake boss")
	{
		return false;
	}

	return true;
}


function RefreshBoss(bool NewBoss)
{
	local int i;

	ActiveBoss = currentBoss.GetValue();
	currentbSetup.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].bSetup);
	if(!NewBoss)
	{
		currentBossMonsterName.SetText(class'IPConfigs'.default.Bosses[ActiveBoss].BossMonsterName);
		//LastMonsterName = currentBossMonsterName.GetText();
	}

	currentBossID.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossID);
	currentBossName.SetText(class'IPConfigs'.default.Bosses[ActiveBoss].BossName);
	currentBossHealth.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossHealth);
	currentBossScoreAward.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossScoreAward);
	currentBossDamageMultiplier.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossDamageMultiplier);
	currentGroundSpeed.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossGroundSpeed);
	currentAirSpeed.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossAirSpeed);
	currentWaterSpeed.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossWaterSpeed);
	currentJumpZ.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossJumpZ);
	currentGibMultiplier.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossGibMultiplier);
	currentGibSizeMultiplier.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].BossGibSizeMultiplier);
	currentDrawScale.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewDrawScale);
	currentCollisionHeight.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewCollisionHeight);
	currentCollisionRadius.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewCollisionRadius);
	currentPrePivotX.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.X);
	currentPrePivotY.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.Y);
	currentPrePivotZ.SetComponentValue(class'IPConfigs'.default.Bosses[ActiveBoss].NewPrePivot.Z);

	CurrentMonsterClass = None;

	if(ValidString(currentBossMonsterName.GetText()))
	{
		for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
		{
			if( class'IPMonsterTable'.default.MonsterTable[i].MonsterName ~= currentBossMonsterName.GetText() )
			{
				CurrentMonsterClass = class<Monster>(DynamicLoadObject(class'IPMonsterTable'.default.MonsterTable[i].MonsterClassName, class'Class',true));
				break;
			}
		}
	}

	//initialize boss if not set up
	if( !currentbSetup.IsChecked())
	{
		if(CurrentMonsterClass != None)
		{
			if(!ValidString(currentBossSound.GetText()))
			{
				currentBossSound.SetText("");
			}

			if(!ValidString(currentBossName.GetText()))
			{
				currentBossSound.SetText("Boss");
			}

			currentBossID.SetComponentValue(currentBoss.GetValue());
			currentBossHealth.SetComponentValue(CurrentMonsterClass.default.Health);
			currentBossScoreAward.SetComponentValue(CurrentMonsterClass.default.ScoringValue);
			currentBossDamageMultiplier.SetComponentValue(1);
			currentGroundSpeed.SetComponentValue(CurrentMonsterClass.default.GroundSpeed);
			currentAirSpeed.SetComponentValue(CurrentMonsterClass.default.AirSpeed);
			currentWaterSpeed.SetComponentValue(CurrentMonsterClass.default.WaterSpeed);
			currentJumpZ.SetComponentValue(CurrentMonsterClass.default.JumpZ);
			currentGibMultiplier.SetComponentValue(1);
			currentGibSizeMultiplier.SetComponentValue(1);
			currentDrawScale.SetComponentValue(CurrentMonsterClass.default.DrawScale);
			currentCollisionHeight.SetComponentValue(CurrentMonsterClass.default.CollisionHeight);
			currentCollisionRadius.SetComponentValue(CurrentMonsterClass.default.CollisionRadius);
			currentPrePivotX.SetComponentValue(CurrentMonsterClass.default.PrePivot.X);
			currentPrePivotY.SetComponentValue(CurrentMonsterClass.default.PrePivot.Y);
			currentPrePivotZ.SetComponentValue(CurrentMonsterClass.default.PrePivot.Z);
			currentbSetup.SetComponentValue(true);
			currentBossName.SetText("Boss ("$currentBossMonsterName.GetText()$")");
			SaveBoss(b_OK);
		}
	}

	SetAvailableConfigs();
	if(CurrentMonsterClass != None)
	{
		if(CurrentMonsterClass.default.bUseCylinderCollision == false)
		{
			b_EditMode.DisableMe();
		}
		else
		{
			b_EditMode.EnableMe();
		}
	}

	/*if(NewBoss)
	{
		SaveBoss(currentBossMonsterName);
	}*/
}

function bool ToggleEditMode(GUIComponent Sender)
{
	if(Sender == b_EditMode)
	{
		bEditMode = !bEditMode;
		SetAvailableConfigs();
	}

	return true;
}

function SetAvailableConfigs()
{
	if( currentBoss.GetValue() == 0)
	{
		currentDrawScale.DisableMe();
		currentCollisionHeight.DisableMe();
		currentCollisionRadius.DisableMe();
		currentBoss.EnableMe();
		currentPrePivotX.DisableMe();
		currentPrePivotY.DisableMe();
		currentPrePivotZ.DisableMe();
		b_Paste.DisableMe();
		currentBossID.DisableMe();
		currentBossMonsterName.DisableMe();
		currentBossName.DisableMe();
		currentBossHealth.DisableMe();
		currentBossScoreAward.DisableMe();
		currentBossDamageMultiplier.DisableMe();
		currentGroundSpeed.DisableMe();
		currentAirSpeed.DisableMe();
		currentWaterSpeed.DisableMe();
		currentJumpZ.DisableMe();
		currentGibMultiplier.DisableMe();
		currentGibSizeMultiplier.DisableMe();
		b_default.DisableMe();
		b_OK.DisableMe();
		b_random.DisableMe();
		currentBossSound.DisableMe();
		currentbSetup.DisableMe();
		b_EditMode.DisableMe();

		return;
	}
	else
	{
		currentBoss.EnableMe();
		currentBossSound.EnableMe();
		currentBossID.EnableMe();
		currentBossMonsterName.EnableMe();
		currentBossName.EnableMe();
		currentBossHealth.EnableMe();
		currentBossScoreAward.EnableMe();
		currentBossDamageMultiplier.EnableMe();
		currentGroundSpeed.EnableMe();
		currentAirSpeed.EnableMe();
		currentWaterSpeed.EnableMe();
		currentJumpZ.EnableMe();
		currentGibMultiplier.EnableMe();
		currentGibSizeMultiplier.EnableMe();
		b_default.EnableMe();
		b_OK.EnableMe();
		b_random.EnableMe();
		currentbSetup.EnableMe();
		b_EditMode.EnableMe();
	}

	if( !bEditMode)
	{
		currentDrawScale.DisableMe();
		currentCollisionHeight.DisableMe();
		currentCollisionRadius.DisableMe();
		currentBoss.EnableMe();
		currentPrePivotX.DisableMe();
		currentPrePivotY.DisableMe();
		currentPrePivotZ.DisableMe();
		b_Paste.DisableMe();

		return;
	}
	else
	{
		currentBoss.DisableMe();
		currentBossID.DisableMe();
		currentBossMonsterName.DisableMe();
		currentBossName.DisableMe();
		currentBossHealth.DisableMe();
		currentBossScoreAward.DisableMe();
		currentBossDamageMultiplier.DisableMe();
		currentGroundSpeed.DisableMe();
		currentAirSpeed.DisableMe();
		currentWaterSpeed.DisableMe();
		currentJumpZ.DisableMe();
		currentGibMultiplier.DisableMe();
		currentGibSizeMultiplier.DisableMe();
		b_default.DisableMe();
		b_random.DisableMe();
		currentBossSound.DisableMe();
		currentbSetup.DisableMe();
		currentDrawScale.EnableMe();
		currentCollisionHeight.EnableMe();
		currentCollisionRadius.EnableMe();
		currentPrePivotX.EnableMe();
		currentPrePivotY.EnableMe();
		currentPrePivotZ.EnableMe();
	}
}

defaultproperties
{
    bRequire640x480=True
    WinTop=0.05
    WinLeft=0.00
    WinWidth=1.00
    WinHeight=0.90
    bScaleToParent=True

    begin object name=Bosses class=moNumericEdit
        WinWidth=0.158253
        WinHeight=0.033333
        WinLeft=0.417101
        WinTop=0.103292
        Caption="Boss:"
        OnChange=IPBossConfig.InternalOnChange
    end object
    currentBoss=moNumericEdit'IPBossConfig.Bosses'

    begin object name=BossID class=moNumericEdit
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.165106
        Caption="Boss ID:"
    end object
    currentBossID=moNumericEdit'IPBossConfig.BossID'

    begin object name=BossHealth class=moNumericEdit
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.219939
        Caption="Health:"
    end object
    currentBossHealth=moNumericEdit'IPBossConfig.BossHealth'

    begin object name=BossScoreAward class=moNumericEdit
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.332694
        Caption="Score Value:"
    end object
    currentBossScoreAward=moNumericEdit'IPBossConfig.BossScoreAward'

    begin object name=BossClass class=moComboBox
        WinWidth=0.439792
		WinHeight=0.033333
		WinLeft=0.500538
		WinTop=0.167246
        Caption="Species:"
        OnChange=IPBossConfig.InternalOnChange   
    end object
    currentBossMonsterName=moComboBox'IPBossConfig.BossClass'

    begin object name=BossName class=moEditBox
        WinWidth=0.439792
		WinHeight=0.033333
		WinLeft=0.500538
		WinTop=0.218577
        Caption="Boss Name: "
    end object
    currentBossName=moEditBox'IPBossConfig.BossName'

    begin object name=BossSound class=moEditBox
        WinWidth=0.440966
		WinHeight=0.044444
		WinLeft=0.499364
		WinTop=0.713882
        Caption="Warning Sound:"
    end object
    currentBossSound=moEditBox'IPBossConfig.BossSound'

    begin object name=BossGroundSpeed class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.385418
        Caption="Ground Speed:"
        MaxValue=2000.0
        MinValue=0.0
    end object
    currentGroundSpeed=moSlider'IPBossConfig.BossGroundSpeed'

    begin object name=BossAirSpeed class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.488357
        Caption="Air Speed:"
        MaxValue=2000.0
        MinValue=0.0
    end object
    currentAirSpeed=moSlider'IPBossConfig.BossAirSpeed'

    begin object name=BossWaterSpeed class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.437844
        Caption="Water Speed:"
        MaxValue=2000.0
        MinValue=0.0
    end object
    currentWaterSpeed=moSlider'IPBossConfig.BossWaterSpeed'

    begin object name=BossJumpZ class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.540231
        Caption="JumpZ:"
        MaxValue=2000.0
        MinValue=0.0
    end object
    currentJumpZ=moSlider'IPBossConfig.BossJumpZ'

    begin object name=BossGibMultiplier class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.648266
        Caption="Gib Multiplier:"
        MaxValue=10.0
        MinValue=0.0
    end object
    currentGibMultiplier=moSlider'IPBossConfig.BossGibMultiplier'

    begin object name=BossGibSizeMultiplier class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.699117
        Caption="GibSize Multiplier:"
        MaxValue=10.0
        MinValue=0.0
    end object
    currentGibSizeMultiplier=moSlider'IPBossConfig.BossGibSizeMultiplier'
    
    begin object name=BossDamage class=moSlider
        WinWidth=0.396244
		WinHeight=0.033333
		WinLeft=0.066513
		WinTop=0.591560
        Caption="Damage Multiplier:"
        MaxValue=10.0
        MinValue=0.0
    end object
    currentBossDamageMultiplier=moSlider'IPBossConfig.BossDamage'

    begin object name=cDrawScale class=moFloatEdit
        WinWidth=0.439792
		WinHeight=0.030000
		WinLeft=0.500538
		WinTop=0.267143
        Caption="Draw Scale:"
    end object
    currentDrawScale=moFloatEdit'IPBossConfig.cDrawScale'

    begin object name=cCollisionHeight class=moFloatEdit
        WinWidth=0.439792
		WinHeight=0.030000
		WinLeft=0.500538
		WinTop=0.322074
        Caption="Collision Height:"
    end object
    currentCollisionHeight=moFloatEdit'IPBossConfig.cCollisionHeight'
    
    begin object name=cCollisionRadius class=moFloatEdit
        WinWidth=0.439792
		WinHeight=0.030000
		WinLeft=0.500538
		WinTop=0.377005
        Caption="Collision Radius: "
    end object
    currentCollisionRadius=moFloatEdit'IPBossConfig.cCollisionRadius'
    
    begin object name=PivotLabel class=GUILabel
        WinWidth=0.439792
		WinHeight=0.085457
		WinLeft=0.500538
		WinTop=0.409001
        Caption="PrePivot"
    end object
    monsterPrePivotLabel=GUILabel'IPBossConfig.PivotLabel'

    begin object name=cPrePivotX class=moFloatEdit
        WinWidth=0.349353
		WinHeight=0.030000
		WinLeft=0.592556
		WinTop=0.437226
        Caption=".X"
    end object
    currentPrePivotX=moFloatEdit'IPBossConfig.cPrePivotX'

    begin object name=cPrePivotY class=moFloatEdit
        WinWidth=0.349353
		WinHeight=0.030000
		WinLeft=0.592556
		WinTop=0.489853
        Caption=".Y"
    end object
    currentPrePivotY=moFloatEdit'IPBossConfig.cPrePivotY'

    begin object name=cPrePivotZ class=moFloatEdit
        WinWidth=0.349353
		WinHeight=0.030000
		WinLeft=0.592556
		WinTop=0.541122
        Caption=".Z"
    end object
    currentPrePivotZ=moFloatEdit'IPBossConfig.cPrePivotZ'

    begin object name=c_bSetup class=moCheckBox
        WinWidth=0.267203
		WinHeight=0.030000
		WinLeft=0.671098
		WinTop=0.114658
        Caption="Initialized:"
    end object
    currentbSetup=moCheckBox'IPBossConfig.c_bSetup'

    begin object name=EditButton class=GUIButton
    	WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.687682
		WinTop=0.851290
        Caption="Edit Mode"
        OnClick=IPBossConfig.ToggleEditMode
    end object
    b_EditMode=GUIButton'IPBossConfig.EditButton'

    begin object name=DefaultButton class=GUIButton
        WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.069518
		WinTop=0.782116
        Caption="Default"
        OnClick=IPBossConfig.DefaultBoss
    end object
    b_Default=GUIButton'IPBossConfig.DefaultButton'

    begin object name=RandomButton class=GUIButton
        WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.069518
		WinTop=0.851290
        Caption="Random"
        OnClick=IPBossConfig.RandomBoss
    end object
    b_Random=GUIButton'IPBossConfig.RandomButton'

    begin object name=PasteButton class=GUIButton
        WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.687682
		WinTop=0.782116
        Caption="Paste"
    end object
    b_Paste=GUIButton'IPBossConfig.PasteButton'

    begin object name=LockedCancelButton class=GUIButton
        WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.385094
		WinTop=0.851290
        Caption="Close"
        OnClick=IPBossConfig.ExitBoss
    end object
    b_Cancel=GUIButton'IPBossConfig.LockedCancelButton'

    begin object name=LockedOKButton class=GUIButton
        WinWidth=0.251747
		WinHeight=0.049962
		WinLeft=0.385094
		WinTop=0.782116
        Caption="Save Boss"
        OnClick=IPBossConfig.SaveBoss
    end object
    b_OK=GUIButton'IPBossConfig.LockedOKButton'

}
