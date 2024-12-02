class RPGTabCharacter extends MidGamePanel;

//character components
var automated GUIImage  i_Portrait;
var automated GUIButton b_DropTarget, b_ClassInfo, b_ResetButton, b_BuyClass;
var automated GUILabel l_CharacterName, l_CharacterLevel, l_CharacterXP, l_CharacterStatPoints, l_CharacterClassPoints;
var automated GUIListBox lb_Classes;
// Used for character (not just weapons!)
var() editinline editconst noexport SpinnyWeap      SpinnyDude; // MUST be set to null when you leave the window
var() vector            SpinnyDudeOffset;
var() bool              bRenderDude;
var localized string    ShowBioCaption;
var localized string    Show3DViewCaption;
var localized string    DefaultText;
var() editconst noexport float SavedPitch;


var() xUtil.PlayerRecord PlayerRec;
var() string    sChar, sCharD;
var() int       nfov;

var localized string MasterAbilityCat, CurrentLevelText, MaxText, CostText, CantBuyText;

struct AbilityInfo
{
	var class<RPGAbility> Ability;
	var int Level;
};


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  super.InitComponent(MyController, MyOwner);

  // Spawn spinning character actor
  if ( SpinnyDude == None )
      SpinnyDude = PlayerOwner().spawn(class'XInterface.SpinnyWeap');

  SpinnyDude.bPlayCrouches = false;
  SpinnyDude.bPlayRandomAnims = false;

  SpinnyDude.SetDrawType(DT_Mesh);
  SpinnyDude.SetDrawScale(0.9);
  SpinnyDude.SpinRate = 0;

  i_Portrait = GUIImage(Controls[0]);
  b_DropTarget = GUIButton(Controls[1]);
  b_ClassInfo = GUIButton(Controls[2]);
  b_ResetButton = GUIButton(Controls[9]);
    b_BuyClass = GUIButton(Controls[10]);
  l_CharacterName = GUILabel(Controls[3]);
  l_CharacterLevel = GUILabel(Controls[4]);
  l_CharacterXP = GUILabel(Controls[5]);
  l_CharacterStatPoints = GUILabel(Controls[6]);
  l_CharacterClassPoints = GUILabel(Controls[7]);
  lb_Classes = GUIListBox(Controls[8]);



  RefreshClassListBox();
  FillCharacterDetails();
}

function RefreshClassListBox()
{
  local PlayerController PC;
  local int x, y, Index, Level, OldAbilityListIndex;
  local RPGPlayerDataObject TempDataObject;
  local AbilityInfo AInfo;
  local array<AbilityInfo> MasterAbilities;
  local RPGStatsInv StatsInv;

  //Get the stats inv
  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);

  if (StatsInv.Role < ROLE_Authority)
  {
    TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
    TempDataObject.InitFromDataStruct(StatsInv.Data);
  }
  else
  {
    TempDataObject = StatsInv.DataObject;
  }

  for (x = 0; x < StatsInv.AllAbilities.length; x++)
  {
    Index = -1;
    for (y = 0; y < StatsInv.Data.ClassAbilities.length; y++)
      if (StatsInv.AllAbilities[x] == StatsInv.Data.ClassAbilities[y])
      {
        Index = y;
        y = StatsInv.Data.ClassAbilities.length;
      }
    if (Index == -1)
      Level = 0;
    else
      Level = StatsInv.Data.ClassLevels[Index];

    if (StatsInv.AllAbilities[x].default.bMasterAbility)
    {
      AInfo.Ability = StatsInv.AllAbilities[x];
      AInfo.Level = Level;
      MasterAbilities.Insert(0,1);
      MasterAbilities[0]=(AInfo);
    }
  }

  OldAbilityListIndex = lb_Classes.List.Index;
  lb_Classes.List.Clear();
  AddMasterAbilities(TempDataObject,MasterAbilities);
  lb_Classes.List.SetIndex(OldAbilityListIndex);
  UpdateAbilityButtons(lb_Classes);

  // free the temporary data object on clients
  if (StatsInv.Role < ROLE_Authority)
  {
    StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
  }
}

function AddMasterAbilities(RPGPlayerDataObject Data, array<AbilityInfo> MasterAbilities)
{
  local int i;
  local int Cost;

  //Cost = 0;

  lb_Classes.List.Add(MasterAbilityCat,None,"1010",true);//SectionHeader

  for(i=0;i<MasterAbilities.Length;i++)
  {
    if (MasterAbilities[i].Level >= MasterAbilities[i].Ability.default.MaxLevel)
    {
      lb_Classes.List.Add(MasterAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@MasterAbilities[i].Level@"["$MaxText$"])", MasterAbilities[i].Ability, "0");
    }
    else
    {
      Cost = MasterAbilities[i].Ability.static.Cost(Data, MasterAbilities[i].Level);

      if (Cost <= 0)
        lb_Classes.List.Add(MasterAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@MasterAbilities[i].Level$","@CantBuyText$")", MasterAbilities[i].Ability, string(Cost));
      else
        lb_Classes.List.Add(MasterAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@MasterAbilities[i].Level$","@CostText@Cost$")", MasterAbilities[i].Ability, string(Cost));
    }
  }
}
function FillCharacterDetails()
{
  local PlayerController PC;
  local RPGStatsInv StatsInv;


  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);

  l_CharacterName.Caption = PC.Pawn.PlayerReplicationInfo.PlayerName;
  l_CharacterLevel.Caption = "Level: " $ String(StatsInv.Data.Level);
  l_CharacterXP.Caption = "Experience: " $ String(StatsInv.Data.Experience) $ "/" $ String(StatsInv.Data.NeededExp);
  l_CharacterStatPoints.Caption = "Stat Points: " $ String(StatsInv.Data.PointsAvailable);
  l_CharacterClassPoints.Caption = "Class Points: " $ String(StatsInv.Data.ClassPoints);
}

event LoseFocus(GUIComponent Sender)
{
    super.LoseFocus(Sender);

    SpinnyDude.bHidden = True;
}

function InitPanel()   // Should be Subclassed
{
  local rotator PlayerRot;

  super.InitPanel();

  PlayerRot = PlayerOwner().Rotation;
  SavedPitch = PlayerRot.Pitch;
  PlayerRot.Pitch = 0;
  PlayerRot.Roll = 0;
  PlayerOwner().SetRotation(PlayerRot);
}

function SetPlayerRec()
{
    local int i;
    local array<xUtil.PlayerRecord> PList;

    class'xUtil'.static.GetPlayerList(PList);

    // Filter out to only characters without the 's' menu setting
    for(i=0; i<PList.Length; i++)
    {
        if ( sChar ~= Plist[i].DefaultName )
        {
            PlayerRec = PList[i];
            break;
        }
    }

    ShowSpinnyDude();
}

function ShowPanel(bool bShow)
{
    local int i;

    Super.ShowPanel(bShow);
    if ( bShow )
    {
      RefreshClassListBox();
      FillCharacterDetails();
        if ( bInit )
        {
            bInit = False;

            bRenderDude = True;
            SetPlayerRec();
            for (i = 0; i < Components.Length; i++)
                Components[i].OnChange = InternalOnChange;

            return;
        }
    }
}

function RPGStatsInv GetStatsInv(PlayerController PC)
{
	local Inventory Inv;

	for (Inv = PC.Inventory; Inv != None; Inv = Inv.Inventory)
		if ( Inv.IsA('RPGStatsInv') && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
						   || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
			return RPGStatsInv(Inv);

	//fallback - shouldn't happen
	if (PC.Pawn != None)
	{
		Inv = PC.Pawn.FindInventoryType(class'RPGStatsInv');
		if ( Inv != None && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
				      || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
			return RPGStatsInv(Inv);
	}
  return None;
}

function InternalOnChange(GUIComponent Sender)
{
  if (Sender==i_Portrait)
  {
    UpdateSpinnyDude();
  }
}

function OnDestroyPanel(optional bool bCancelled)   // Always call Super.OnDestroyPanel()
{
    Super.OnDestroyPanel();
    SpinnyDude.bHidden = True;
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local PlayerController PC;

    PC = PlayerOwner();
    if ( Sender == i_Portrait )
    {
        sChar = PC.GetUrlOption("Character");
        sCharD = sChar;
    }
}

function bool InternalDraw(Canvas canvas)
{
    local vector CamPos, X, Y, Z;
    local rotator CamRot;
    local float   oOrgX, oOrgY;
    local float   oClipX, oClipY;

    if(bRenderDude)
    {
        oOrgX = Canvas.OrgX;
        oOrgY = Canvas.OrgY;
        oClipX = Canvas.ClipX;
        oClipY = Canvas.ClipY;
        //posistion of drop target canvas
        Canvas.OrgX = b_DropTarget.ActualLeft();
        Canvas.OrgY = b_DropTarget.ActualTop();
        Canvas.ClipX = b_DropTarget.ActualWidth();
        Canvas.ClipY = b_DropTarget.ActualHeight();

        canvas.GetCameraLocation(CamPos, CamRot);
        GetAxes(CamRot, X, Y, Z);

        SpinnyDude.SetLocation(CamPos + (SpinnyDudeOffset.X * X) + (SpinnyDudeOffset.Y * Y) + (SpinnyDudeOffset.Z * Z));
        canvas.DrawActorClipped(SpinnyDude, false,  b_DropTarget.ActualLeft(), b_DropTarget.ActualTop(), b_DropTarget.ActualWidth(), b_DropTarget.ActualHeight(), true, nFov);

        Canvas.OrgX = oOrgX;
        Canvas.OrgY = oOrgY;
        Canvas.ClipX = oClipX;
        Canvas.ClipY = oClipY;
    }

    return bRenderDude;
}
function UpdateSpinnyDude()
{
    local Mesh PlayerMesh;
    local Material BodySkin, HeadSkin;
    local string BodySkinName, HeadSkinName;
    local bool bBrightSkin;

    i_Portrait.Image = PlayerRec.Portrait;
    PlayerMesh = Mesh(DynamicLoadObject(PlayerRec.MeshName, class'Mesh'));
    if(PlayerMesh == None)
    {
        Log("Could not load mesh: "$PlayerRec.MeshName$" For player: "$PlayerRec.DefaultName);
        return;
    }

    // Get the body skin
    BodySkinName = PlayerRec.BodySkinName;// $ TeamSuffix;
    bBrightSkin = class'DMMutator'.default.bBrightSkins && Left(BodySkinName,12) ~= "PlayerSkins.";

    if ( bBrightSkin && "" != "" )
        BodySkinName = "Bright" $ BodySkinName $ "B";

    // Get the head skin
    HeadSkinName = PlayerRec.FaceSkinName;

    BodySkin = Material(DynamicLoadObject(BodySkinName, class'Material'));
    if(BodySkin == None)
    {
        Log("Could not load body material: "$PlayerRec.BodySkinName$" For player: "$PlayerRec.DefaultName);
        return;
    }

    if ( bBrightSkin )
        SpinnyDude.AmbientGlow = SpinnyDude.default.AmbientGlow * 0.8;
    else SpinnyDude.AmbientGlow = SpinnyDude.default.AmbientGlow;


    HeadSkin = Material(DynamicLoadObject(HeadSkinName, class'Material'));
    if(HeadSkin == None)
    {
        Log("Could not load head material: "$HeadSkinName$" For player: "$PlayerRec.DefaultName);
        return;
    }

    SpinnyDude.LinkMesh(PlayerMesh);
    SpinnyDude.Skins[0] = BodySkin;
    SpinnyDude.Skins[1] = HeadSkin;
    SpinnyDude.LoopAnim( 'Idle_Rest', 1.0/SpinnyDude.Level.TimeDilation );
}
function ShowSpinnyDude()
{
    UpdateSpinnyDude(); // Load current character
    b_DropTarget.MouseCursorIndex = 5;
}

function bool RaceCapturedMouseMove(float deltaX, float deltaY)
{
    local rotator r;
    r = SpinnyDude.Rotation;
    r.Yaw -= (256 * DeltaX);
    SpinnyDude.SetRotation(r);
    return true;
}

event Opened(GUIComponent Sender)
{
    local rotator R,PlayerRot;

    Super.Opened(Sender);
    // Set camera's pitch to zero when menu initialised (otherwise spinny weap goes kooky)
    PlayerRot = PlayerOwner().Rotation;
    SavedPitch = PlayerRot.Pitch;
    PlayerRot.Pitch = 0;
    PlayerRot.Roll = 0;
    PlayerOwner().SetRotation(PlayerRot);

    if ( SpinnyDude != None )
    {
        R.Yaw = 32768;
        R.Pitch = -1024;
        SpinnyDude.SetRotation(R+PlayerOwner().Rotation);
        SpinnyDude.bHidden = true;
    }
}

event Closed(GUIComponent Sender, bool bCancelled)
{
    Super.Closed(Sender, bCancelled);
    if ( SpinnyDude != None )
        SpinnyDude.bHidden = true;
}

function Free()
{
    Super.Free();

    if ( SpinnyDude != None )
        SpinnyDude.Destroy();

    SpinnyDude = None;
}

function bool OnResetClicked(GUIComponent Sender)
{
  local PlayerController PC;
  local RPGStatsInv StatsInv;

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);

  StatsInv.ServerResetData(PC.PlayerReplicationInfo);

  RefreshClassListBox();
  FillCharacterDetails();

  return true;
}

function bool ShowClassDesc(GUIComponent Sender)
{
    local class<RPGAbility> Ability;

    Ability = class<RPGAbility>(lb_Classes.List.GetObject());
    Controller.OpenMenu("LumpysRPG.RPGAbilityDescMenu");
    RPGAbilityDescMenu(Controller.TopPage()).t_WindowTitle.Caption = Ability.default.AbilityName;
    RPGAbilityDescMenu(Controller.TopPage()).MyScrollText.SetContent(Ability.default.Description);

    return true;
}

function bool AddClassPoint(GUIComponent Sender)
{
  local PlayerController PC;
  local RPGStatsInv StatsInv;

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);
  Log("AddClassPoint Called");
  StatsInv.ServerAddClass(class<RPGClass>(lb_Classes.List.GetObject()));
  RefreshClassListBox();
  FillCharacterDetails();
  return true;
}

function bool UpdateAbilityButtons(GUIComponent Sender)
{
	local int Cost;
  local PlayerController PC;
  local RPGStatsInv StatsInv;

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);


	Cost = int(lb_Classes.List.GetExtra());

	if (Cost <= 0 || Cost > StatsInv.Data.ClassPoints)
		Controls[10].MenuStateChange(MSAT_Disabled);
	else
  	Controls[10].MenuStateChange(MSAT_Blurry);


	return true;
}

defaultproperties
{
  SpinnyDudeOffset=(X=70.000000)
  ShowBioCaption="Portrait"
  Show3DViewCaption="3D View"
  DefaultText="Default"
  nfov=65
  MasterAbilityCat="Master Classes"
  CurrentLevelText="Current Level:"
  MaxText="MAX"
  CostText="Cost:"
  CantBuyText="Can't Buy"


  Begin Object Class=GUIImage Name=PlayerPortrait
      Image=Texture'2K4Menus.Controls.thinpipe_b'
      ImageStyle=ISTY_Scaled
      ImageRenderStyle=MSTY_Normal
      IniOption="@Internal"
      WinTop=0.094895
      WinLeft=0.057016
      WinWidth=0.334368
      WinHeight=0.798132
      RenderWeight=0.300000
      OnDraw=RPGTabCharacter.InternalDraw
      OnLoadINI=RPGTabCharacter.InternalOnLoadINI
  End Object
  Controls(0)=GUIImage'LumpysRPG.RPGTabCharacter.PlayerPortrait'

  Begin Object Class=GUIButton Name=DropTarget
    StyleName="NoBackground"
    WinWidth=0.367535
		WinHeight=0.811835
		WinLeft=-0.047221
		WinTop=0.110823
    MouseCursorIndex=5
    bTabStop=False
    bNeverFocus=True
    bDropTarget=True
    OnKeyEvent=DropTarget.InternalOnKeyEvent
    OnCapturedMouseMove=RPGTabCharacter.RaceCapturedMouseMove
End Object
Controls(1)=GUIButton'LumpysRPG.RPGTabCharacter.DropTarget'

Begin Object Class=GUIButton Name=ClassInfo
  WinWidth=0.150000
  WinHeight=0.078052
  WinLeft=0.547573
  WinTop=0.308686
  Caption="Class info"
  OnClick=RPGTabCharacter.ShowClassDesc
End Object
Controls(2)=GUIButton'LumpysRPG.RPGTabCharacter.ClassInfo'

Begin Object Class=GUILabel Name=CharacterName
    TextColor=(R=255,G=255,B=255,A=255)
    WinWidth=0.225335
		WinHeight=0.042670
  	WinLeft=0.270000
		WinTop=0.095000
End Object
Controls(3)=GUILabel'LumpysRpg.RPGTabCharacter.CharacterName'

Begin Object Class=GUILabel Name=CharacterLevel
    TextColor=(R=255,G=255,B=255,A=255)
    WinWidth=0.225335
		WinHeight=0.042670
  	WinLeft=0.270000
		WinTop=0.130000
End Object
Controls(4)=GUILabel'LumpysRpg.RPGTabCharacter.CharacterLevel'

Begin Object Class=GUILabel Name=CharacterXP
    TextColor=(R=255,G=255,B=255,A=255)
    WinWidth=0.225335
		WinHeight=0.042670
  	WinLeft=0.270000
		WinTop=0.165000
End Object
Controls(5)=GUILabel'LumpysRpg.RPGTabCharacter.CharacterXP'

Begin Object Class=GUILabel Name=CharacterStatPoints
    TextColor=(R=255,G=255,B=255,A=255)
    WinWidth=0.225335
		WinHeight=0.042670
  	WinLeft=0.270000
		WinTop=0.200000
End Object
Controls(6)=GUILabel'LumpysRpg.RPGTabCharacter.CharacterStatPoints'

Begin Object Class=GUILabel Name=CharacterClassPoints
    TextColor=(R=255,G=255,B=255,A=255)
    WinWidth=0.225335
		WinHeight=0.042670
  	WinLeft=0.270000
		WinTop=0.235000
End Object
Controls(7)=GUILabel'LumpysRpg.RPGTabCharacter.CharacterClassPoints'

Begin Object Class=GUIListBox Name=AbilityList
    bVisibleWhenEmpty=True
    OnCreateComponent=AbilityList.InternalOnCreateComponent
    StyleName="AbilityList"
    Hint="These are the abilities you can purchase with stat points."
    WinWidth=0.400000
		WinHeight=0.200000
		WinLeft=0.517377
		WinTop=0.093945
    OnClick=RPGTabCharacter.UpdateAbilityButtons
End Object
Controls(8)=GUIListBox'LumpysRPG.RPGTabCharacter.AbilityList'

Begin Object Class=GUIButton Name=ResetButton
  WinWidth=0.150754
  WinHeight=0.050646
  WinLeft=0.851767
  WinTop=0.932048
  Caption="Reset Character"
  OnClick=RPGTabCharacter.OnResetClicked
End Object
Controls(9)=GUIButton'LumpysRPG.RPGTabCharacter.ResetButton'

Begin Object Class=GUIButton Name=BuyClass
  WinWidth=0.150000
  WinHeight=0.078052
  WinLeft=0.742269
  WinTop=0.308686
  Caption="Add Class Point"
  OnClick=RPGTabCharacter.AddClassPoint
End Object
Controls(10)=GUIButton'LumpysRPG.RPGTabCharacter.BuyClass'
}
