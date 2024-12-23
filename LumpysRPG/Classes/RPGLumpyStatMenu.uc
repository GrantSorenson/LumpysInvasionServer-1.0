class RPGLumpyStatMenu extends FloatingWindow;

var(MidGame) array<GUITabItem> Panels;
var RPGStatsInv StatsInv;
var() editconst noexport float SavedPitch;
var(MidGame) automated GUITabControl c_Main;

function InitComponent(GUIController MyController, GUIComponent MyComponent)
{
  local rotator PlayerRot;

  Super.InitComponent(MyController, MyComponent);

   // Set camera's pitch to zero when menu initialised (otherwise spinny weap goes kooky)
  PlayerRot = PlayerOwner().Rotation;
  SavedPitch = PlayerRot.Pitch;
  PlayerRot.Pitch = 0;
  PlayerRot.Roll = 0;
  PlayerOwner().SetRotation(PlayerRot);

  if ( Panels.Length > 0 )
      AddPanels();

  SetTitle();
  T_WindowTitle.DockedTabs = c_Main;
}

function InitFor(RPGStatsInv PlayerStatsInv)
{
  StatsInv = PlayerStatsInv;
}
function bool FloatingPreDraw( Canvas C )
{
    if (PlayerOwner().GameReplicationInfo!=None)
        SetVisibility(true);
    else
        SetVisibility(false);

    return false;
}


function InternalOnClose(optional Bool bCanceled)
{
    local rotator NewRot;

    // Reset player
    NewRot = PlayerOwner().Rotation;
    NewRot.Pitch = SavedPitch;
    PlayerOwner().SetRotation(NewRot);

    Super.OnClose(bCanceled);
}

function AddPanels()
{
    local int i;
    local MidGamePanel Panel;

    for ( i = 0; i < Panels.Length; i++ )
    {
       Panel = MidGamePanel(c_Main.AddTabItem(Panels[i]));
    }
}

function SetTitle()
{
    local PlayerController PC;

    PC = PlayerOwner();
    if ( PC.Level.NetMode == NM_StandAlone || PC.GameReplicationInfo == None || PC.GameReplicationInfo.ServerName == "" )
        WindowName = PC.Level.GetURLMap();
    else WindowName = PC.GameReplicationInfo.ServerName;

    t_WindowTitle.SetCaption(WindowName);
}

event bool NotifyLevelChange()
{
    bPersistent = false;
    LevelChanged();
    return true;
}

defaultproperties
{
     //Panels(0)=(ClassName="GUI2K4.UT2K4Tab_ServerMOTD",Caption="MOTD",Hint="Message of the Day")
     Panels(0)=(ClassName="LumpysRPG.RPGTabWelcome",Caption="Welcome",Hint="Invasion and RPG information")
     Panels(1)=(ClassName="LumpysRPG.RPGTabCharacter",Caption="Character",Hint="Player Character")
     Panels(2)=(ClassName="LumpysRPG.RPGTabStats",Caption="Stats",Hint="Player Stats")
     Panels(3)=(ClassName="LumpysRPG.RPGTabAbilities",Caption="Abilities",Hint="Player Abilities")
     Panels(4)=(ClassName="LumpysRPG.RPGTabStore",Caption="Store",Hint="Player Store")
     
     Begin Object Class=FloatingImage Name=FloatingFrameBackground
         Image=Texture'LumpysTextures.MenuTextures.MenuDisplay01'//2K4Menus.CustomControls.CustomDisplay2
         DropShadow=None
         ImageStyle=ISTY_Stretched
         ImageRenderStyle=MSTY_Normal
         WinWidth=0.996248
     		WinHeight=0.985834
     		WinLeft=0.002346
     		WinTop=0.014166
         RenderWeight=0.000003
     End Object
     i_FrameBG=FloatingImage'LumpysRPG.RPGLumpyStatMenu.FloatingFrameBackground'

     Begin Object Class=GUITabControl Name=RPGMenuTC
         bFillSpace=True
         bDockPanels=True
         TabHeight=0.037500
         BackgroundStyleName="TabBackground"
         WinTop=0.060215
         WinLeft=0.012500
         WinWidth=0.974999
         WinHeight=0.044644
         bScaleToParent=True
         bAcceptsInput=True
         OnActivate=RPGMenuTC.InternalOnActivate
     End Object
     c_Main=GUITabControl'LumpysRPG.RPGLumpyStatMenu.RPGMenuTC'

     bResizeWidthAllowed=false
     bResizeHeightAllowed=false
     bMoveAllowed=false
     OnClose=RPGLumpyStatMenu.InternalOnClose
     DefaultLeft=0.110313
     DefaultTop=0.057916
     DefaultWidth=0.779688
     DefaultHeight=0.847083
     bRequire640x480=true
     bPersistent=true
     bAllowedAsLast=true
     WinTop=0.057916
     WinLeft=0.110313
     WinWidth=0.779688
     WinHeight=0.847083
}
