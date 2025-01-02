//==========================================================
//IPMonsterConfig Copyright � Shaun Goeppinger 2012
//==========================================================
class IPMonsterConfig extends GUICustomPropertyPage;

var() editinline editconst noexport IPSpinnyMonster SpinnyDude;
var() vector SpinnyDudeOffset;
var() automated GUIButton b_DropTarget;
var() Automated moSlider currentModelFOV;
var() Automated GUILabel currentModelViewer;
var() int nfov;
var() bool bEditMode;
var() bool bValid;
var() bool bAnimPaused;
var() bool bSpinnyWireMode;
var() Name CurrentAnim;
var() name NameConversion;

var() editinline editconst noexport IPCylinderActor MonsterCylinder;
var() Shader CylinderShader;
var() FinalBlend CylinderTexture;
var() class<Shader> ShaderClass;
var() class<FinalBlend> FinalBlendClass;

var() class<Monster> M;
var() int ActiveMonster;
var() int ActiveBioNumber;
//monster stats for bio information
var() string m_Name;
var() string m_health;
var() string m_score;
var() string m_groundspeed;
var() string m_airspeed;
var() string m_waterspeed;
var() string m_jumpZ;
var() string m_maxhealth;
var() string m_drawscale;
var() string m_col_h;
var() string m_col_r;
var() string m_PivotX;
var() string m_PivotY;
var() string m_PivotZ;
var() string m_kills;
var() string m_spawns;
var() string m_damage;
var() string m_descrip;

var() string AssembledInformation;

var() Automated moEditBox newMonsterName;

var() Automated GUIScrollTextBox  absoluteDefaults;

var() Automated GUILabel monsterPrePivotLabel;
var() Automated GUISectionBackground monsterBio;

var() Automated moNumericEdit currentHealth;
var() Automated moNumericEdit currentMaxHealth;
var() Automated moNumericEdit currentScoreAward;

var() Automated moSlider currentGroundSpeed;
var() Automated moSlider currentAirSpeed;
var() Automated moSlider currentWaterSpeed;
var() Automated moSlider currentJumpZ;
var() Automated moSlider currentGibMultiplier;
var() Automated moSlider currentGibSizeMultiplier;
var() Automated moSlider currentDamageMultiplier;
var() Automated moSlider currentModelRotation;

var() Automated moFloatEdit currentDrawScale;
var() Automated moFloatEdit currentCollisionHeight;
var() Automated moFloatEdit currentCollisionRadius;

var() Automated moFloatEdit currentPrePivotX;
var() Automated moFloatEdit currentPrePivotY;
var() Automated moFloatEdit currentPrePivotZ;

var() Automated moCheckBox currentbRandomHealth;
var() Automated moCheckBox currentbRandomSpeed;
var() Automated moCheckBox currentbRandomSize;

var() Automated moCheckBox currentbSetup;

var() Automated GUIButton b_Random; //set random monster
var() Automated GUIButton b_defaults; //set the defaults
var() Automated GUIButton b_EditMode;
var() Automated GUIButton b_WireMode;
var() Automated GUIButton b_Copy; //copy drawscale,collision height + radius, prepivot to the monster clipboard
var() Automated GUIButton b_SaveUnique;

var() Automated moComboBox currentMonster;
var() Automated moEditBox currentMonsterSkin;
var() Automated moComboBox currentAnimList;

var() Automated GUIGFXButton b_UArrow;
var() Automated GUIGFXButton b_DArrow;
var() Automated GUIGFXButton b_LArrow;
var() Automated GUIGFXButton b_RArrow;
var() Automated GUIGFXButton b_CArrow;

var() Automated GUIGFXButton b_Play;
var() Automated GUIGFXButton b_Pause;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local rotator R;
	local int i,x;

	Super.InitComponent(MyController, MyOwner);

  	//Spawn spinning character actor
	if ( SpinnyDude == None )
	{
		SpinnyDude = PlayerOwner().spawn(Class'LumpysInvasion.IPSpinnyMonster');
	}

	if(SpinnyDude != None)
	{
		SpinnyDude.bPlayRandomAnims = false;
		SpinnyDude.SetDrawType(DT_Mesh);
		SpinnyDude.SetDrawScale(0.9);
		SpinnyDude.SpinRate = 0;
		SpinnyDude.AmbientGlow = SpinnyDude.default.AmbientGlow * 0.8;
		R.Yaw = 32768;
		R.Pitch = -1024;
		SpinnyDude.SetRotation(R+PlayerOwner().Rotation);
		SpinnyDude.bHidden = false;
	}

	if(MonsterCylinder == None)
	{
		MonsterCylinder = PlayerOwner().spawn(Class'LumpysInvasion.IPCylinderActor',SpinnyDude);
		//alocate shader and set it up
		CylinderShader= Shader(PlayerOwner().Level.ObjectPool.AllocateObject(ShaderClass));
		CylinderShader.Diffuse=Texture'UCGeneric.SolidColours.Red';
		CylinderShader.Opacity = None;
		CylinderShader.Specular = None;
		CylinderShader.SpecularityMask = None;
		CylinderShader.SelfIllumination = None;
		CylinderShader.SelfIlluminationMask = None;
		CylinderShader.Detail = None;
		CylinderShader.DetailScale = 8.000000;
		CylinderShader.OutputBlending = OB_Normal;
		CylinderShader.TwoSided = false;
		CylinderShader.WireFrame = true;
		CylinderShader.PerformLightingOnSpecularPass = False;
		CylinderShader.ModulateSpecular2X = False;
		CylinderShader.FallbackMaterial = None;
		CylinderShader.SurfaceType = EST_Default;
		//alocate finalblend and set it up
		CylinderTexture = FinalBlend(PlayerOwner().Level.ObjectPool.AllocateObject(FinalBlendClass));
		CylinderTexture.FrameBufferBlending = FB_Translucent;
		CylinderTexture.ZWrite = True;
		CylinderTexture.ZTest = true;
		CylinderTexture.AlphaTest = False;
		CylinderTexture.TwoSided = True;
		CylinderTexture.AlphaRef = 0;
		CylinderTexture.Material = CylinderShader;
		CylinderTexture.FallbackMaterial = None;
		CylinderTexture.SurfaceType = EST_Default;

		MonsterCylinder.Skins[0] = CylinderTexture;
	}

	//window that binds the mesh/character
	b_DropTarget.WinWidth=0.283570;
	b_DropTarget.WinHeight=0.480464;
	b_DropTarget.WinLeft=0.663153;
	b_DropTarget.WinTop=0.151119;


	//resize main inside window


	sb_Main.Caption = "Monster Configuration";
	sb_Main.bScaleToParent=true;
	sb_Main.WinWidth=0.961562;
	sb_Main.WinHeight=0.928808;
	sb_Main.WinLeft=0.017539;
	sb_Main.WinTop=0.048823;

	t_WindowTitle.Caption = "IP: Monster Configuration";

	//resize ok/save button
	b_OK.WinWidth=0.202528;
	b_OK.WinHeight=0.044743;
	b_OK.WinLeft=0.043377;
	b_OK.WinTop=0.895495;

	//resize cancel/close button
	b_Cancel.WinWidth=0.171970;
	b_Cancel.WinHeight=0.048624;
	b_Cancel.WinLeft=0.787296;
	b_Cancel.WinTop=0.895495;

	b_Copy.FontScale = FNS_Small;
	b_SaveUnique.FontScale = FNS_Small;

	//resize scrolling information window
	absoluteDefaults.MyScrollText.FontScale=FNS_Small;

	monsterBio.Managecomponent(absoluteDefaults);


	//set zoom/foz of character values to mid range
	//nFov = 60;
	//currentModelFOV.SetValue(1);
	currentModelFOV.SetValue(90);

	//set max visible monster list
	currentMonster.MyComboBox.MaxVisibleItems=20;

	currentAnimList.MyLabel.FontScale = FNS_Small;
	currentAnimList.MyComboBox.Edit.FontScale = FNS_Small;

	//update available monsters and skins
	for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
	{
		currentMonster.AddItem(class'IPMonsterTable'.default.MonsterTable[i].MonsterName);
	}



	//update current monster and set edit mode
	bEditMode = false;
	UpdateMonster();

}

function UpdateMonster()
{
	local int i;

	m_Name = currentMonster.GetText();

	if(m_Name ~= "None")
	{
		bValid = false;
	}
	else
	{
		bValid = true;
	}

	SetAvailableConfigs();
	currentHealth.Setup(1, 999999, 1);

	if(bValid)
	{
		for(i=0;i<class'IPMonsterTable'.default.MonsterTable.Length;i++)
		{
			if( class'IPMonsterTable'.default.MonsterTable[i].MonsterName ~= m_Name )
			{
				ActiveMonster = i;
				M = class<Monster>(DynamicLoadObject(class'IPMonsterTable'.default.MonsterTable[i].MonsterClassName, class'Class',true));
				break;
			}
		}
	}

	if(M == None)
	{
		bValid = false;
	}

	ActiveBioNumber = 0;
	for(i=0;i<class'IPMonsterTable'.default.MonsterDescription.Length;i++)
	{
		if( class'IPMonsterTable'.default.MonsterDescription[i].MonsterName ~= m_Name )
		{
			ActiveBioNumber = i;
			break;
		}
	}

	currentbSetup.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bSetup);
	//initialize monster if not set up
	if( !currentbSetup.IsChecked() && bValid)
	{
		currentDamageMultiplier.SetValue(1);
		currentHealth.SetComponentValue(M.default.Health);
		currentMaxHealth.SetComponentValue(M.default.HealthMax);
		currentScoreAward.SetComponentValue(M.default.ScoringValue);
		currentGroundSpeed.SetComponentValue(M.default.GroundSpeed);
		currentAirSpeed.SetComponentValue(M.default.AirSpeed);
		currentWaterSpeed.SetComponentValue(M.default.WaterSpeed);
		currentJumpZ.SetComponentValue(M.default.JumpZ);
		currentGibMultiplier.SetValue(1.00);
		currentGibSizeMultiplier.SetValue(1.00);
		currentDrawScale.SetComponentValue(M.default.DrawScale);
		currentCollisionHeight.SetComponentValue(M.default.CollisionHeight);
		currentCollisionRadius.SetComponentValue(M.default.CollisionRadius);
		currentPrePivotX.SetComponentValue(M.default.PrePivot.X);
		currentPrePivotY.SetComponentValue(M.default.PrePivot.Y);
		currentPrePivotZ.SetComponentValue(M.default.PrePivot.Z);
		currentbRandomHealth.SetComponentValue(False);
		currentbRandomSpeed.SetComponentValue(False);
		currentbRandomSize.SetComponentValue(False);
		currentbSetup.SetComponentValue(true);

		//update edit cylinder

		SaveMonster(currentMonster);
	}
	else if(bValid)
	{
		currentDamageMultiplier.SetValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].DamageMultiplier);
		currentHealth.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewHealth);
		currentMaxHealth.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewMaxHealth);
		currentScoreAward.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewScoreAward);
		currentGroundSpeed.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGroundSpeed);
		currentAirSpeed.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewAirSpeed);
		currentWaterSpeed.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewWaterSpeed);
		currentJumpZ.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewJumpZ);
		currentGibMultiplier.SetValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGibMultiplier);
		currentGibSizeMultiplier.SetValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGibSizeMultiplier);
		currentDrawScale.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewDrawScale);
		currentCollisionHeight.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewCollisionHeight);
		currentCollisionRadius.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewCollisionRadius);
		currentPrePivotX.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.X);
		currentPrePivotY.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.Y);
		currentPrePivotZ.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.Z);
		currentbRandomHealth.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomHealth);
		currentbRandomSpeed.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomSpeed);
		currentbRandomSize.SetComponentValue(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomSize);
		currentMonsterSkin.SetText(string(M.default.Skins[0]));
	}

	if(M  != None)
	{
		//log(M.default.bUseCylinderCollision);
		if(M.default.bUseCylinderCollision == false)
		{
			b_EditMode.DisableMe();
			b_EditMode.EnableMe();

		}
		else
		{
			b_EditMode.EnableMe();
		}

		m_health = string(M.default.Health);
		m_score = string(M.default.ScoringValue);
		m_groundspeed = string(M.default.GroundSpeed);
		m_airspeed = string(M.default.AirSpeed);
		m_waterspeed = string(M.default.WaterSpeed);
		m_jumpZ = string(M.default.JumpZ);
		m_maxhealth = string(M.default.HealthMax);
		m_drawscale = string(M.default.DrawScale);
		m_col_h = string(M.default.CollisionHeight);
		m_col_r = string(M.default.CollisionRadius);
		m_PivotX = string(M.default.PrePivot.X);
		m_PivotY = string(M.default.PrePivot.Y);
		m_PivotZ = string(M.default.PrePivot.Z);
		m_kills = string(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NumKills);
		m_spawns = string(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NumSpawns);
		m_damage = string(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NumDamage);
		UpdateScroll();
	}

	if(bValid)
	{
		currentAnimList.EnableMe();
		b_WireMode.EnableMe();
		UpDateCylinder();
		UpdateSpinnyDude();
	}
	else
	{
		ClearAllData();
	}
}

//update everything about the cylinder
function UpDateCylinder()
{
	local float ColHeight;
	local float ColRadius;
	local vector Piv;
	local vector DScale;
	//get information

	ColHeight = currentCollisionHeight.GetValue();
	ColRadius = currentCollisionRadius.GetValue();
	Piv.X = currentPrePivotX.GetValue();
	Piv.Y = currentPrePivotY.GetValue();
	Piv.Z = currentPrePivotZ.GetValue();

	DScale.X = ( (ColRadius / 10) * 0.4 );
	DScale.Y = DScale.X;
	DScale.Z = ( (ColHeight / 10) * 0.2275 );

	MonsterCylinder.PrePivot.X = Piv.X;
	MonsterCylinder.PrePivot.Y = Piv.Y;
	MonsterCylinder.PrePivot.Z = Piv.Z;

	MonsterCylinder.SetDrawScale3D(DScale);
}

function ClearAllData()
{
	b_DropTarget.Caption = "# Offline #";
	currentAnimList.ResetComponent();

	currentHealth.Setup(0, 0, 1);
	currentHealth.SetComponentValue(0);
	currentDamageMultiplier.SetValue(0);
	currentMaxHealth.SetComponentValue(0);
	currentScoreAward.SetComponentValue(0);
	currentGroundSpeed.SetComponentValue(0);
	currentAirSpeed.SetComponentValue(0);
	currentWaterSpeed.SetComponentValue(0);
	currentJumpZ.SetComponentValue(0);
	currentGibMultiplier.SetValue(0);
	currentGibSizeMultiplier.SetValue(0);
	currentDrawScale.SetComponentValue(0);
	currentCollisionHeight.SetComponentValue(0);
	currentCollisionRadius.SetComponentValue(0);
	currentPrePivotX.SetComponentValue(0);
	currentPrePivotY.SetComponentValue(0);
	currentPrePivotZ.SetComponentValue(0);
	currentbRandomHealth.SetComponentValue(False);
	currentbRandomSpeed.SetComponentValue(False);
	currentbRandomSize.SetComponentValue(False);
	currentbSetup.SetComponentValue(True);
	currentModelFOV.SetComponentValue(0,true);
	currentModelRotation.SetComponentValue(0,true);
	currentMonsterSkin.SetText("");

	currentAnimList.DisableMe();
	currentModelRotation.DisableMe();
	b_Random.DisableMe();
	b_defaults.DisableMe();
	b_EditMode.DisableMe();
	b_WireMode.DisableMe();
	b_Copy.DisableMe();
	b_SaveUnique.DisableMe();
	currentHealth.DisableMe();
	currentDamageMultiplier.DisableMe();
	currentMaxHealth.DisableMe();
	currentScoreAward.DisableMe();
	currentGroundSpeed.DisableMe();
	currentAirSpeed.DisableMe();
	currentWaterSpeed.DisableMe();
	currentJumpZ.DisableMe();
	currentGibMultiplier.DisableMe();
	currentGibSizeMultiplier.DisableMe();
	currentDrawScale.DisableMe();
	currentCollisionHeight.DisableMe();
	currentCollisionRadius.DisableMe();
	currentPrePivotX.DisableMe();
	currentPrePivotY.DisableMe();
	currentPrePivotZ.DisableMe();
	currentbRandomHealth.DisableMe();
	currentbRandomSpeed.DisableMe();
	currentbRandomSize.DisableMe();
	currentbSetup.DisableMe();
	currentModelFOV.DisableMe();
	currentMonsterSkin.DisableMe();

	b_OK.DisableMe();
	b_EditMode.DisableMe();
	b_WireMode.DisableMe();
}

function AssembleInfo()
{
	local string BioInfoPartA, BioInfoPartB, BioInfoPartC, BioInfoPartD;
	local string m_info;

	if(!bValid)
	{
		AssembledInformation = "     # No information #  ";
		return;
	}

	BioInfoPartA = "|"@"Name: "@m_Name@"|"@"|"@"Health: "@m_health@"|"@"MaxHealth: "@m_maxhealth@"|"@"ScoreAward: "@m_score@"|"@"Groundspeed: "@m_groundspeed@"|";
	BioInfoPartB = "Airspeed: "@m_airspeed@"|"@"Waterspeed: "@m_waterspeed@"|"@"JumpZ: "@m_jumpZ@"|"@"Drawscale:"@m_drawscale@"|";
	BioInfoPartC = "CollisionHeight: "@m_col_h@"|"@"CollisionRadius: "@m_col_r@"|"@"PrePivot.X : "@m_PivotX@"|"@"              .Y : "@m_PivotY@"|"@"              .Z : "@m_PivotZ@"|";
	BioInfoPartD = "Total Spawns: "@m_spawns@"|"@"Total Damage: "@m_damage@"|"@"Total Kills: "@m_kills@"||"@"      # Tactical Data #  "@"|"@"|"@class'IPMonsterTable'.default.MonsterDescription[ActiveBioNumber].BioData;

	if(M.default.bUseCylinderCollision == false)
	{
		m_info = BioInfoPartA@BioInfoPartB@BioInfoPartD;
	}
	else
	{
		m_info = BioInfoPartA@BioInfoPartB@BioInfoPartC@BioInfoPartD;
	}

	AssembledInformation = m_info;
}

function UpdateScroll()
{
	AssembleInfo();
    absoluteDefaults.SetContent(AssembledInformation);
}

function bool RandomizeMonster(GUIComponent Sender)
{
	local int i;

	i = Max(100,Rand(1000));

	currentHealth.SetComponentValue( i );
	currentMaxHealth.SetComponentValue( i );
	i = Max(3,Rand(15));
	currentScoreAward.SetComponentValue( i );
	currentDamageMultiplier.SetComponentValue(fRand() * 10);
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

function UpdateSpinnyDude()
{
    local Material MonsterSkin;
    local array<string> SkinList;
    local int i;

	if(bValid)
	{
    	M = class<Monster>(DynamicLoadObject(class'IPMonsterTable'.default.MonsterTable[ActiveMonster].MonsterClassName, class'class',true));
	}

    if(M == None)
    {
		b_DropTarget.Caption = "# Offline #";
		return;
	}

	SpinnyDudeOffset.X = currentModelFOV.GetValue();
	SpinnyDude.SetDrawScale(currentDrawScale.GetValue());
	b_DropTarget.Caption = "";

	for(i=0;i<M.default.Skins.Length;i++)
	{
		SkinList.Insert(i,1);
		SkinList[i] = string(M.default.Skins[i]);
	}

	SpinnyDude.SetDrawType(M.default.DrawType);
	SpinnyDude.SetStaticMesh(M.default.StaticMesh);
	SpinnyDude.LinkMesh(M.default.Mesh);
	SpinnyDude.Texture = M.default.Texture;
	//Metal Skaarj & SMPMerc fix & any with none applied
	for(i=0;i<SkinList.Length;i++)
	{
		if(SkinList[i] ~= "None" || SkinList[i] ~= "")
		{
			SkinList[i] = "Engine.DefaultTexture";
		}

		MonsterSkin = Material(DynamicLoadObject(SkinList[i], class'Engine.Material',true));
	    if(MonsterSkin == None)
   		{
        	Log("Could not load body material: " @ SkinList[i] @"for" @ M @ "mesh = " @ M.default.Mesh);
   		}

   		SpinnyDude.Skins[i] = MonsterSkin;
	}

	if(MonsterIs2D(M))
	{
		SpinnyDude.SetDrawType(DT_StaticMesh);
		//SpinnyDude.SetStaticMesh(StaticMesh'2K4ChargerMeshes.WeaponChargerMesh-DS');
		SpinnyDude.Skins[0] = SpinnyDude.Texture;
		currentAnimList.DisableMe();
		b_Play.DisableMe();
		b_Pause.DisableMe();
	}
	else
	{
		currentAnimList.EnableMe();
		b_Play.EnableMe();
		b_Pause.EnableMe();
	}

    SetUpAnimation();
}

function bool MonsterIs2D(class<Monster> MClass)
{
	local string PackageLeft, PackageRight;

	Divide(string(MClass),".",PackageLeft, PackageRight);

	if(PackageLeft ~= "BloodMonstersv1" || PackageLeft ~= "DukeNukemMonstersv1"
	|| PackageLeft ~= "HereticMonstersv1" || PackageLeft ~= "HexenMonstersv2"
	|| PackageLeft ~= "HexenMonstersv1" || PackageLeft ~= "ShadowWarriorMonstersv1" || PackageLeft ~= "DoomPawns2k4")
	{
		return true;
	}

	return false;
}

//=======================================================================================================
//Animation functions
//=======================================================================================================
function PlayNewAnim()
{
	if(CurrentAnim != '')
	{
		if(bAnimPaused)
		{
			if( SpinnyDude.TweenAnim( CurrentAnim, 1.0, 0 ) )
			{
				SpinnyDude.LoopAnim(CurrentAnim,1.0/SpinnyDude.Level.TimeDilation,,0 );
			}
		}

		SpinnyDude.LoopAnim(CurrentAnim,1.0/SpinnyDude.Level.TimeDilation,,0 );
		bAnimPaused = false;
	}
}

function SetUpAnimation()
{
	local int i;
	local int AnimCount;

	AnimCount = currentAnimList.ItemCount();

	currentAnimList.RemoveItem(0, AnimCount);

	//try and get any accessable anims the monster may already provide
	FindMonsterAnimations();
	//add the configured anims
	for(i=0;i<class'IPAnimationManager'.default.AnimNames.Length;i++)
	{
		ValidAnim(class'IPAnimationManager'.default.AnimNames[i]);
		//check if mesh has the animation in the list
	}

	currentAnimList.MyComboBox.List.Sort();
}

function FindMonsterAnimations()
{
	local int i;

	for(i=0;i<4;i++)
	{
		ValidAnim(M.default.MovementAnims[i]);
		ValidAnim(M.default.CrouchAnims[i]);
		ValidAnim(M.default.AirAnims[i]);
		ValidAnim(M.default.TakeoffAnims[i]);
		ValidAnim(M.default.LandAnims[i]);
		ValidAnim(M.default.DodgeAnims[i]);
		ValidAnim(M.default.DoubleJumpAnims[i]);
		ValidAnim(M.default.WallDodgeAnims[i]);
		ValidAnim(M.default.WalkAnims[i]);
		ValidAnim(M.default.SwimAnims[i]);
	}

	ValidAnim(M.default.TakeoffStillAnim);
	ValidAnim(M.default.AirStillAnim);
	ValidAnim(M.default.CrouchTurnRightAnim);
	ValidAnim(M.default.CrouchTurnLeftAnim);
	ValidAnim(M.default.TurnLeftAnim);
	ValidAnim(M.default.TurnLeftAnim);
	ValidAnim(M.default.TurnRightAnim);
	ValidAnim(M.default.IdleRifleAnim);
	ValidAnim(M.default.IdleHeavyAnim);
	ValidAnim(M.default.IdleWeaponAnim);
	ValidAnim(M.default.FireHeavyBurstAnim);
	ValidAnim(M.default.FireHeavyRapidAnim);
	ValidAnim(M.default.FireRifleBurstAnim);
	ValidAnim(M.default.FireRifleRapidAnim);
	ValidAnim(M.default.IdleChatAnim);
	ValidAnim(M.default.IdleSwimAnim);
}

function ValidAnim(name vAnim)
{
	if(vAnim != '' && SpinnyDude.HasAnim(vAnim) && currentAnimList.Find(string(vAnim),false,false) == "" )
	{
		currentAnimList.AddItem( String(vAnim) );
	}
}

function bool AnimControls(GUIComponent Sender)
{
	local float AnimRate, AnimFrame;


	if(Sender == b_Play)
	{
		PlayNewAnim();
	}

	if(Sender == b_Pause)
	{
		if(CurrentAnim != '')
		{
			if(bAnimPaused)
			{
				return true;
			}

			SpinnyDude.GetAnimParams ( 0, CurrentAnim, AnimFrame, AnimRate );
			SpinnyDude.TweenAnim( CurrentAnim, 0, 0 );
			SpinnyDude.SetAnimFrame(AnimFrame, 0, 0);
			bAnimPaused = true;
		}
	}

	return true;
}

//=======================================================================================================
//GUI events
//=======================================================================================================

function bool InternalDraw(Canvas canvas)
{
    local vector CamPos, X, Y, Z;
    local rotator CamRot;
    local float   oOrgX, oOrgY;
    local float   oClipX, oClipY;

	oOrgX = Canvas.OrgX;
	oOrgY = Canvas.OrgY;
	oClipX = Canvas.ClipX;
	oClipY = Canvas.ClipY;

	Canvas.OrgX = b_DropTarget.ActualLeft();
	Canvas.OrgY = b_DropTarget.ActualTop();
	Canvas.ClipX = b_DropTarget.ActualWidth();
	Canvas.ClipY = b_DropTarget.ActualHeight();

	canvas.GetCameraLocation(CamPos, CamRot);
	GetAxes(CamRot, X, Y, Z);

	SpinnyDude.SetLocation(CamPos + (SpinnyDudeOffset.X * X) + (SpinnyDudeOffset.Y * Y) + (SpinnyDudeOffset.Z * Z));
	MonsterCylinder.SetLocation(SpinnyDude.Location);
	canvas.DrawActorClipped(SpinnyDude, bSpinnyWireMode,  b_DropTarget.ActualLeft(), b_DropTarget.ActualTop(), b_DropTarget.ActualWidth(), b_DropTarget.ActualHeight(), true, nFov);
	canvas.DrawActorClipped(MonsterCylinder, false,  b_DropTarget.ActualLeft(), b_DropTarget.ActualTop(), b_DropTarget.ActualWidth(), b_DropTarget.ActualHeight(), false, nFov);

	Canvas.OrgX = oOrgX;
	Canvas.OrgY = oOrgY;
	Canvas.ClipX = oClipX;
	Canvas.ClipY = oClipY;

    return true;
}

event Closed(GUIComponent Sender, bool bCancelled)
{
    Super.Closed(Sender, bCancelled);

    if ( SpinnyDude != None )
    {
        SpinnyDude.bHidden = true;
	}

	if ( MonsterCylinder != None )
	{
		MonsterCylinder.bHidden = true;
	}
	//release materials back into the pool with ensured defaults
	if(CylinderTexture != None)
	{
		CylinderTexture.FrameBufferBlending = FB_Overwrite;
		CylinderTexture.ZWrite = True;
		CylinderTexture.ZTest = True;
		CylinderTexture.AlphaTest = False;
		CylinderTexture.TwoSided = False;
		CylinderTexture.AlphaRef = 0;
		CylinderTexture.Material = None;
		CylinderTexture.FallbackMaterial = None;
		CylinderTexture.SurfaceType = EST_Default;

		PlayerOwner().Level.ObjectPool.FreeObject(CylinderTexture);

		CylinderTexture = None;
	}

	if(CylinderShader != None)
	{
		CylinderShader.Diffuse = None;
		CylinderShader.Opacity = None;
		CylinderShader.Specular = None;
		CylinderShader.SpecularityMask = None;
		CylinderShader.SelfIllumination = None;
		CylinderShader.SelfIlluminationMask = None;
		CylinderShader.Detail = None;
		CylinderShader.DetailScale = 8.000000;
		CylinderShader.OutputBlending = OB_Normal;
		CylinderShader.TwoSided = false;
		CylinderShader.WireFrame = false;
		CylinderShader.PerformLightingOnSpecularPass = False;
		CylinderShader.ModulateSpecular2X = False;
		CylinderShader.FallbackMaterial = None;
		CylinderShader.SurfaceType = EST_Default;

		PlayerOwner().Level.ObjectPool.FreeObject(CylinderShader);

		CylinderShader = None;
	}
}

function bool RaceCapturedMouseMove(float deltaX, float deltaY)
{
    local rotator r;

	//SpinnyMonster.DrawDebugLine ( SpinnyMonster, vector LineEnd, byte R, byte G, byte B )
    r = SpinnyDude.Rotation;
    r.Yaw -= (256 * DeltaX);
    r.Pitch += (256 * DeltaY);
    SpinnyDude.SetRotation(r);
    //MonsterCylinder.SetRotation(SpinnyDude.Rotation);
    return true;
}

function InternalOnChange(GUIComponent Sender)
{
	if(Sender == currentModelFOV)
	{
		//nFov = currentModelFOV.GetValue();
		SpinnyDudeOffset.X = currentModelFOV.GetValue();
	}

	if(Sender == currentMonster)
	{
		UpdateMonster();
	}

	if(Sender == currentModelRotation)
	{
		SpinnyDude.RotateSpeed = currentModelRotation.GetValue();
	}

	if( Sender == currentCollisionHeight || Sender == currentCollisionRadius || Sender == currentPrePivotX || Sender == currentPrePivotY || Sender == currentPrePivotZ)
	{
		UpDateCylinder();
	}

	if( Sender == currentDrawScale)
	{
		SpinnyDude.SetDrawScale(currentDrawScale.GetValue());
	}

	if(Sender == currentAnimList)
	{
		CurrentAnim = StringToName( currentAnimList.GetText() );
		PlayNewAnim();
	}

}

function name StringToName(string str)
{
  SetPropertyText("NameConversion", str);
 // log("name conversion" @ NameConversion);
  return NameConversion;
}

function bool ToggleEditMode(GUIComponent Sender)
{
	if(Sender == b_EditMode)
	{
		bEditMode = !bEditMode;
		SetAvailableConfigs();
	}

	if(Sender == b_WireMode)
	{
		bSpinnyWireMode = !bSpinnyWireMode;
	}

	return true;
}

function SetAvailableConfigs()
{
	currentHealth.EnableMe();
	currentDamageMultiplier.EnableMe();
	currentMaxHealth.EnableMe();
	currentScoreAward.EnableMe();
	currentGroundSpeed.EnableMe();
	currentAirSpeed.EnableMe();
	currentWaterSpeed.EnableMe();
	currentJumpZ.EnableMe();
	currentGibMultiplier.EnableMe();
	currentGibSizeMultiplier.EnableMe();
	currentbRandomHealth.EnableMe();
	currentbRandomSpeed.EnableMe();
	currentbRandomSize.EnableMe();
	currentbSetup.EnableMe();
	currentModelFOV.EnableMe();
	currentModelRotation.EnableMe();
	currentMonsterSkin.EnableMe();
	b_Random.EnableMe();
	b_defaults.EnableMe();
	b_EditMode.EnableMe();
	b_WireMode.EnableMe();
	b_Copy.EnableMe();
	b_OK.EnableMe();

	currentModelFOV.SetValue(90);

	if(!bEditMode)
	{
		b_SaveUnique.DisableMe();
		currentDrawScale.DisableMe();
		currentCollisionHeight.DisableMe();
		currentCollisionRadius.DisableMe();
		currentMonster.EnableMe();
		currentPrePivotX.DisableMe();
		currentPrePivotY.DisableMe();
		currentPrePivotZ.DisableMe();
		MonsterCylinder.SetDrawType(DT_None);

		return;
	}

	b_SaveUnique.EnableMe();
	currentDrawScale.EnableMe();
	currentCollisionHeight.EnableMe();
	currentCollisionRadius.EnableMe();
	currentMonster.DisableMe();
	currentPrePivotX.EnableMe();
	currentPrePivotY.EnableMe();
	currentPrePivotZ.EnableMe();
	MonsterCylinder.SetDrawType(DT_StaticMesh);
}

function bool SetDefaultMonster(GUIComponent Sender)
{
	currentDamageMultiplier.SetValue(1);
	currentHealth.SetComponentValue(M.default.Health);
	currentMaxHealth.SetComponentValue(M.default.HealthMax);
	currentScoreAward.SetComponentValue(M.default.ScoringValue);
	currentGroundSpeed.SetComponentValue(M.default.GroundSpeed);
	currentAirSpeed.SetComponentValue(M.default.AirSpeed);
	currentWaterSpeed.SetComponentValue(M.default.WaterSpeed);
	currentJumpZ.SetComponentValue(M.default.JumpZ);
	currentGibMultiplier.SetValue(1.00);
	currentGibSizeMultiplier.SetValue(1.00);
	currentDrawScale.SetComponentValue(M.default.DrawScale);
	currentCollisionHeight.SetComponentValue(M.default.CollisionHeight);
	currentCollisionRadius.SetComponentValue(M.default.CollisionRadius);
	currentPrePivotX.SetComponentValue(M.default.PrePivot.X);
	currentPrePivotY.SetComponentValue(M.default.PrePivot.Y);
	currentPrePivotZ.SetComponentValue(M.default.PrePivot.Z);
	currentbRandomHealth.SetComponentValue(False);
	currentbRandomSpeed.SetComponentValue(False);
	currentbRandomSize.SetComponentValue(False);
	currentMonsterSkin.SetText(string(M.default.Skins[0]));


	return true;
}

function bool SaveMonster(GUIComponent Sender)
{
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewHealth = currentHealth.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewMaxHealth = currentMaxHealth.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGroundSpeed = currentGroundSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewAirSpeed = currentAirSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewWaterSpeed = currentWaterSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewJumpZ = currentJumpZ.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewScoreAward = currentScoreAward.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGibMultiplier = currentGibMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewGibSizeMultiplier = currentGibSizeMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].DamageMultiplier = currentDamageMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomHealth = currentbRandomHealth.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomSpeed = currentbRandomSpeed.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bRandomSize = currentbRandomSize.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].CurrentSkin = currentMonsterSkin.GetText();

	if(bEditMode || !class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bSetup)
	{
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewDrawScale = currentDrawScale.GetValue();
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewCollisionHeight = currentCollisionHeight.GetValue();
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewCollisionRadius = currentCollisionRadius.GetValue();
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.X = currentPrePivotX.GetValue();
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.Y = currentPrePivotY.GetValue();
		class'IPMonsterTable'.default.MonsterTable[ActiveMonster].NewPrePivot.Z = currentPrePivotZ.GetValue();
	}

	class'IPMonsterTable'.default.MonsterTable[ActiveMonster].bSetup = true;

	class'IPMonsterTable'.static.StaticSaveConfig();

	return true;
}

function bool ExitMonster(GUIComponent Sender)
{
	Controller.CloseMenu(false);

	return true;
}
//SpinnyDudeOffset=(X=70,Y=0,Z=0)
function bool PanView(GUIComponent Sender)
{
	local Rotator R;

	if(Sender == b_UArrow)
	{
		SpinnyDudeOffset.Z = (SpinnyDudeOffset.Z + 5);
	}

	if(Sender == b_DArrow)
	{
		SpinnyDudeOffset.Z = (SpinnyDudeOffset.Z - 5);
	}

	if(Sender == b_LArrow)
	{
		SpinnyDudeOffset.Y = (SpinnyDudeOffset.Y - 5);
	}

	if(Sender == b_RArrow)
	{
		SpinnyDudeOffset.Y = (SpinnyDudeOffset.Y + 5);
	}

	if(Sender == b_CArrow)
	{
		//reset pivot and rotations
		SpinnyDudeOffset.X = 70;
		SpinnyDudeOffset.Y = 0;
		SpinnyDudeOffset.Z = 0;
		R.Yaw = 32768;
		R.Pitch = -1024;
		SpinnyDude.SetRotation(R+PlayerOwner().Rotation);
		currentModelFOV.SetValue(65);
		//MonsterCylinder.SetRotation(SpinnyDude.Rotation);
	}

	return true;
}

function bool CopySize(GUIComponent Sender)
{
	class'IPCopyPaste'.default.ClipBoardDrawScale = currentDrawScale.GetValue();
	class'IPCopyPaste'.default.ClipBoardCollisionHeight = currentCollisionHeight.GetValue();
	class'IPCopyPaste'.default.ClipBoardCollisionRadius = currentCollisionRadius.GetValue();
	class'IPCopyPaste'.default.ClipBoardPrePivot.X = currentPrePivotX.GetValue();
	class'IPCopyPaste'.default.ClipBoardPrePivot.Y = currentPrePivotY.GetValue();
	class'IPCopyPaste'.default.ClipBoardPrePivot.Z = currentPrePivotZ.GetValue();

	class'IPCopyPaste'.static.StaticSaveConfig();

	return true;
}

function bool SaveUniqueMonster(GUIComponent Sender)
{
	class'IPMonsterTable'.default.MonsterTable.Insert(class'IPMonsterTable'.default.MonsterTable.length-1,1);
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].MonsterClassName = class'IPMonsterTable'.default.MonsterTable[ActiveMonster].MonsterClassName;
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].MonsterName = newMonsterName.GetText();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewHealth = currentHealth.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewMaxHealth = currentMaxHealth.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewGroundSpeed = currentGroundSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewAirSpeed = currentAirSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewWaterSpeed = currentWaterSpeed.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewJumpZ = currentJumpZ.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewScoreAward = currentScoreAward.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewGibMultiplier = currentGibMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewGibSizeMultiplier = currentGibSizeMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].DamageMultiplier = currentDamageMultiplier.GetValue();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].bRandomHealth = currentbRandomHealth.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].bRandomSpeed = currentbRandomSpeed.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].bRandomSize = currentbRandomSize.IsChecked();
	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].CurrentSkin = currentMonsterSkin.GetText();


	if(bEditMode || !class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].bSetup)
	{
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewDrawScale = currentDrawScale.GetValue();
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewCollisionHeight = currentCollisionHeight.GetValue();
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewCollisionRadius = currentCollisionRadius.GetValue();
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewPrePivot.X = currentPrePivotX.GetValue();
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewPrePivot.Y = currentPrePivotY.GetValue();
		class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].NewPrePivot.Z = currentPrePivotZ.GetValue();
	}

	class'IPMonsterTable'.default.MonsterTable[class'IPMonsterTable'.default.MonsterTable.length-1].bSetup = true;

	class'IPMonsterTable'.static.StaticSaveConfig();

	return true;
}

defaultproperties
{
    ShaderClass=Class'IPCylinderShader'
    FinalBlendClass=Class'IPCylinderFinalBlend'
    nfov=65
    bRequire640x480=True
    WinTop=0.00
    WinLeft=0.00
    WinWidth=1.00
    WinHeight=1.00
    bScaleToParent=True
    SpinnyDudeOffset=(X=70.00,Y=0.00,Z=0.00)

	begin object name=NewerMonsterName class=moEditBox
		WinWidth=0.339162
		WinHeight=0.030000
		WinLeft=0.047217
		WinTop=0.130517
        Caption="New Monster Name"
		OnChange=IPMonsterConfig.InternalOnChange
    end object
    newMonsterName=moEditBox'IPMonsterConfig.NewerMonsterName'

    begin object name=DropTarget class=GUIButton
        StyleName="NoBackground"
        WinWidth=0.283570
		WinHeight=0.480464
		WinLeft=0.663153
		WinTop=0.151119
        MouseCursorIndex=5
        bTabStop=False
        bNeverFocus=True
        bDropTarget=True
        OnKeyEvent=DropTarget.InternalOnKeyEvent
        OnCapturedMouseMove=IPMonsterConfig.RaceCapturedMouseMove
        OnDraw=IPMonsterConfig.InternalDraw
    end object
    b_DropTarget=GUIButton'IPMonsterConfig.DropTarget'
    
    begin object name=ModelFOV class=moSlider
        WinWidth=0.283725
		WinHeight=0.030000
		WinLeft=0.664232
		WinTop=0.090465
        OnChange = IPMonsterConfig.InternalOnChange
        MaxValue=400.0
        MinValue=0.0
        Caption="Zoom"
        ComponentJustification = TXTA_Left
        ComponentWidth = -1
        CaptionWidth = 100
        bAutoSizeCaption = true
        //IniOption="@Internal"
    end object
    currentModelFOV=moSlider'IPMonsterConfig.ModelFOV'

    begin object name=ModelDrawer class=GUILabel
        WinWidth=0.241218
		WinHeight=0.557467
		WinLeft=0.692450
		WinTop=0.211205
    end object
    currentModelViewer=GUILabel'IPMonsterConfig.ModelDrawer'

    begin object name=AMonsterDefaults class=GUIScrollTextBox
        WinWidth=0.202538
		WinHeight=0.403435
		WinLeft=0.412666
		WinTop=0.149707
    end object
    absoluteDefaults=GUIScrollTextBox'IPMonsterConfig.AMonsterDefaults'

    begin object name=PivotLabel class=GUILabel
        WinWidth=0.865933
		WinHeight=0.076911
		WinLeft=0.049493
		WinTop=0.429753
        Caption="PrePivot"
    end object
    monsterPrePivotLabel=GUILabel'IPMonsterConfig.PivotLabel'

    begin object name=mBio class=GUISectionBackground
        WinWidth=0.254380
		WinHeight=0.481403
		WinLeft=0.399245
		WinTop=0.098412
        Caption="Biography"
    end object
    monsterBio=GUISectionBackground'IPMonsterConfig.mBio'

    begin object name=cHealth class=moNumericEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.167536
        Caption="Health"
    end object
    currentHealth=moNumericEdit'IPMonsterConfig.cHealth'

    begin object name=cMaxHealth class=moNumericEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.219076
        Caption="Max Health"
    end object
    currentMaxHealth=moNumericEdit'IPMonsterConfig.cMaxHealth'

    begin object name=cScoreAward class=moNumericEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.266548
        Caption="Score Award"
    end object
    currentScoreAward=moNumericEdit'IPMonsterConfig.cScoreAward'

    begin object name=cGroundSpeed class=moSlider
    	WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.042776
		WinTop=0.752704
        Caption="Ground Speed"
        OnCreateComponent=cGroundSpeed.InternalOnCreateComponent
        MaxValue=2000.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentGroundSpeed=moSlider'IPMonsterConfig.cGroundSpeed'

    begin object name=cAirSpeed class=moSlider
        WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.042776
		WinTop=0.787969
        Caption="Air Speed"
        MaxValue=2000.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentAirSpeed=moSlider'IPMonsterConfig.cAirSpeed'

    begin object name=cWaterSpeed class=moSlider
        WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.041800
		WinTop=0.820522
        Caption="Water Speed"
        MaxValue=2000.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentWaterSpeed=moSlider'IPMonsterConfig.cWaterSpeed'

    begin object name=cJumpZ class=moSlider
       	WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.041800
		WinTop=0.854431
        Caption="JumpZ"
        MaxValue=2000.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentJumpZ=moSlider'IPMonsterConfig.cJumpZ'

    begin object name=cGibMultiplier class=moSlider
    	WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.041800
		WinTop=0.682174
        Caption="Gib Multiplier"
        MaxValue=10.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentGibMultiplier=moSlider'IPMonsterConfig.cGibMultiplier'

    begin object name=cGibSizeMultiplier class=moSlider
        WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.041800
		WinTop=0.718796
        Caption="GibSize Multiplier"
        MaxValue=10.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentGibSizeMultiplier=moSlider'IPMonsterConfig.cGibSizeMultiplier'

    begin object name=cDamMultiplier class=moSlider
        WinWidth=0.609379
		WinHeight=0.030000
		WinLeft=0.041800
		WinTop=0.646909
        Caption="Damage Scale"
        MaxValue=10.0
        MinValue=0.0
        CaptionWidth=300
    end object
    currentDamageMultiplier=moSlider'IPMonsterConfig.cDamMultiplier'

    begin object name=ModelRot class=moSlider
        WinWidth=0.283725
		WinHeight=0.030000
		WinLeft=0.664232
		WinTop=0.120304
        OnChange = IPMonsterConfig.InternalOnChange
        Caption="Rotate Speed"
        bAutoSizeCaption = true
        ComponentJustification = TXTA_Left
        IniOption="@Internal"
        CaptionWidth = 0.1
        ComponentWidth = -1
        MaxValue=100.0
        MinValue=0.0
    end object
    currentModelRotation=moSlider'IPMonsterConfig.ModelRot'

    begin object name=cDrawScale class=moFloatEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.311087
        OnChange=IPMonsterConfig.InternalOnChange
        Caption="Draw Scale"
    end object
    currentDrawScale=moFloatEdit'IPMonsterConfig.cDrawScale'

    begin object name=cCollisionHeight class=moFloatEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.357474
        OnChange=IPMonsterConfig.InternalOnChange
        Caption="Collision Height"
    end object
    currentCollisionHeight=moFloatEdit'IPMonsterConfig.cCollisionHeight'
    
    begin object name=cCollisionRadius class=moFloatEdit
        WinWidth=0.338797
		WinHeight=0.030000
		WinLeft=0.047634
		WinTop=0.405081
        OnChange=IPMonsterConfig.InternalOnChange
        Caption="Collision Radius"
    end object
    currentCollisionRadius=moFloatEdit'IPMonsterConfig.cCollisionRadius'
    
    begin object name=cPrePivotX class=moFloatEdit
        WinWidth=0.252080
		WinHeight=0.030000
		WinLeft=0.134548
		WinTop=0.455537
        Caption="X"
        OnChange=IPMonsterConfig.InternalOnChange
    end object
    currentPrePivotX=moFloatEdit'IPMonsterConfig.cPrePivotX'

    begin object name=cPrePivotY class=moFloatEdit
		WinWidth=0.252080
		WinHeight=0.030000
		WinLeft=0.134548
		WinTop=0.500839
        Caption="Y"
        OnChange=IPMonsterConfig.InternalOnChange
    end object
    currentPrePivotY=moFloatEdit'IPMonsterConfig.cPrePivotY'

    begin object name=cPrePivotZ class=moFloatEdit
		WinWidth=0.252080
		WinHeight=0.030000
		WinLeft=0.134548
		WinTop=0.544784
        Caption="Z"
        OnChange=IPMonsterConfig.InternalOnChange
    end object
    currentPrePivotZ=moFloatEdit'IPMonsterConfig.cPrePivotZ'

    begin object name=c_bRandomHealth class=moCheckBox
        WinWidth=0.267203
		WinHeight=0.030000
		WinLeft=0.677023
		WinTop=0.682174
        Caption="Random Health"
    end object
    currentbRandomHealth=moCheckBox'IPMonsterConfig.c_bRandomHealth'

    begin object name=c_bRandomSpeed class=moCheckBox
        WinWidth=0.267203
		WinHeight=0.030000
		WinLeft=0.677414
		WinTop=0.768309
        Caption="Random Speed"
    end object
    currentbRandomSpeed=moCheckBox'IPMonsterConfig.c_bRandomSpeed'

    begin object name=c_bRandomSize class=moCheckBox
        WinWidth=0.267984
		WinHeight=0.030000
		WinLeft=0.676438
		WinTop=0.725583
        Caption="Random Size"
    end object
    currentbRandomSize=moCheckBox'IPMonsterConfig.c_bRandomSize'

    begin object name=c_bSetup class=moCheckBox
        WinWidth=0.267203
		WinHeight=0.030000
		WinLeft=0.677023
		WinTop=0.810432
        Caption="Initialized"
    end object
    currentbSetup=moCheckBox'IPMonsterConfig.c_bSetup'

    begin object name=RandomButton class=GUIButton
        WinWidth=0.168153
		WinHeight=0.042743
		WinLeft=0.430957
		WinTop=0.895495
        Caption="Random"
        OnClick=IPMonsterConfig.RandomizeMonster
    end object
    b_Random=GUIButton'IPMonsterConfig.RandomButton'

    begin object name=DefaultButton class=GUIButton
        WinWidth=0.169715
		WinHeight=0.044493
		WinLeft=0.608580
		WinTop=0.895495
        Caption="Default"
        OnClick=IPMonsterConfig.SetDefaultMonster
    end object
    b_Defaults=GUIButton'IPMonsterConfig.DefaultButton'

    begin object name=EditButton class=GUIButton
        WinWidth=0.168153
		WinHeight=0.040399
		WinLeft=0.254199
		WinTop=0.895495
        Caption="Edit"
        OnClick=IPMonsterConfig.ToggleEditMode
    end object
    b_EditMode=GUIButton'IPMonsterConfig.EditButton'

    begin object name=WireButton class=GUIButton
        WinWidth=0.120059
		WinHeight=0.036493
		WinLeft=0.665484
		WinTop=0.590327
        Caption="Wire Frame"
        OnClick=IPMonsterConfig.ToggleEditMode
    end object
    b_WireMode=GUIButton'IPMonsterConfig.WireButton'

    begin object name=CopyButton class=GUIButton
        WinWidth=0.135340
		WinHeight=0.035712
		WinLeft=0.042346
		WinTop=0.593192
        Caption="Copy"
        OnClick=IPMonsterConfig.CopySize
    end object
    b_Copy=GUIButton'IPMonsterConfig.CopyButton'

	begin object name=SaveUniqueButton class=GUIButton
		WinWidth=0.135340
		WinHeight=0.035712
		WinLeft=0.188284
		WinTop=0.593192
        Caption="Save Unique"
        OnClick=IPMonsterConfig.SaveUniqueMonster
    end object
    b_SaveUnique=GUIButton'IPMonsterConfig.SaveUniqueButton'

    begin object name=cMonster class=moComboBox
        WinWidth=0.339162
		WinHeight=0.040000
		WinLeft=0.047217
		WinTop=0.100243
        OnChange=IPMonsterConfig.InternalOnChange
        Caption="Monster"
    end object
    currentMonster=moComboBox'IPMonsterConfig.cMonster'

	begin object name=cMonsterSkin class=moEditBox
		WinWidth=0.30000
		WinHeight=0.030000
		WinLeft=0.323259
		WinTop=0.595040
        Caption="Monster Skin"
		OnChange=IPMonsterConfig.InternalOnChange
    end object
    currentMonsterSkin=moEditBox'IPMonsterConfig.cMonsterSkin'


    begin object name=c_animlist class=moComboBox
        WinWidth=0.161036
		WinHeight=0.080000
		WinLeft=0.662671
		WinTop=0.161930
        OnChange=IPMonsterConfig.InternalOnChange
        Caption="Anim List"
        bVerticalLayout=True
    end object
    currentAnimList=moComboBox'IPMonsterConfig.c_animlist'

    begin object name=LockedCancelButton class=GUIButton
        WinWidth=0.171970
		WinHeight=0.048624
		WinLeft=0.787296
		WinTop=0.895495
        OnClick=IPMonsterConfig.ExitMonster
        Caption="Close"
    end object
    b_Cancel=GUIButton'IPMonsterConfig.LockedCancelButton'

    begin object name=LockedOKButton class=GUIButton
        WinWidth=0.202528
		WinHeight=0.044743
		WinLeft=0.043377
		WinTop=0.895495
        OnClick=IPMonsterConfig.SaveMonster
        Caption="Save"
    end object
    b_OK=GUIButton'IPMonsterConfig.LockedOKButton'

    // b_UArrow=GUIGFXButton'IPMonsterConfig.PanUp'
    // b_DArrow=GUIGFXButton'IPMonsterConfig.PanDown'
    // b_LArrow=GUIGFXButton'IPMonsterConfig.PanLeft'
    // b_RArrow=GUIGFXButton'IPMonsterConfig.PanRight'
    // b_CArrow=GUIGFXButton'IPMonsterConfig.PanReset'
    // b_Play=GUIGFXButton'IPMonsterConfig.Play'
    // b_Pause=GUIGFXButton'IPMonsterConfig.Pause'

}
