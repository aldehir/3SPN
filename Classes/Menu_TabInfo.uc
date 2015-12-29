/*******************************************************************************
 * Menu_TabInfo generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Menu_TabInfo extends UT2K3TabPanel
    editinlinenew
    instanced;

var() automated GUISectionBackground SectionBackg;
var() automated GUIScrollTextBox TextBox;
var array<string> InfoText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local Misc_Player MP;
    local TAM_GRI GRI;
    local string Content;

    super(GUIPanel).InitComponent(MyController, MyOwner);
    MP = Misc_Player(UnresolvedNativeFunction_99());
    // End:0x2B
    if(MP == none)
    {
        return;
    }
    GRI = TAM_GRI(UnresolvedNativeFunction_99().Level.GRI);
    SectionBackg.ManageComponent(TextBox);
    TextBox.MyScrollText.bNeverFocus = true;
    Content = JoinArray(InfoText, TextBox.Separator, true);
    Content = Repl(Content, "[3SPNVersion]", class'Misc_BaseGRI'.default.Version);
    Content = Repl(Content, "[Menu3SPNKey]", class'Interactions'.static.GetFriendlyName(class'Misc_Player'.default.Menu3SPNKey));
    TextBox.SetContent(Content, TextBox.Separator);
    //return;    
}

defaultproperties
{
    begin object name=SectionBackgObj class=AltSectionBackground
        bFillClient=true
        LeftPadding=0.0
        RightPadding=0.0
        WinHeight=1.0
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
        OnPreDraw=InternalPreDraw
    object end
    // Reference: AltSectionBackground'Menu_TabInfo.SectionBackgObj'
    SectionBackg=SectionBackgObj
    begin object name=TextBoxObj class=GUIScrollTextBox
        bNoTeletype=true
        Separator="??"
        OnCreateComponent=InternalOnCreateComponent
        FontScale=0
        WinTop=0.010
        WinLeft=0.10
        WinWidth=0.80
        WinHeight=0.5583330
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    object end
    // Reference: GUIScrollTextBox'Menu_TabInfo.TextBoxObj'
    TextBox=TextBoxObj
    InfoText(0)="Greetings!"
    InfoText(1)="======="
    InfoText(2)="??"
    InfoText(3)="This seems to be the first time you are running 3SPN [3SPNVersion], please take a moment to update your settings!"
    InfoText(4)="??"
    InfoText(5)="NOTE: Your settings have been automatically retrieved from the server if they have been previously saved. Your future settings will be saved on this server automatically and restored on 3SPN updates or UT reinstalls. This behavior can be disabled in the Misc panel. The settings are saved for your PLAYERNAME, so if you change it, you must save the settings again for them to be found later."
    InfoText(6)="??"
    InfoText(7)="You can always access the 3SPN configuration menu later by pressing [Menu3SPNKey] or typing 'menu3spn' in the console."
    InfoText(8)="??"
    InfoText(9)=""
    InfoText(10)=""
    InfoText(11)=""
    InfoText(12)=""
    InfoText(13)=""
    InfoText(14)=""
    InfoText(15)=""
    InfoText(16)=""
    InfoText(17)=""
    InfoText(18)=""
    InfoText(19)=""
    InfoText(20)=""
    InfoText(21)=""
    InfoText(22)=""
    InfoText(23)=""
    InfoText(24)=""
    InfoText(25)=""
    InfoText(26)=""
    InfoText(27)=""
    InfoText(28)=""
    InfoText(29)=""
    InfoText(30)=""
    InfoText(31)=""
    InfoText(32)=""
    InfoText(33)=""
    InfoText(34)=""
    InfoText(35)=""
    InfoText(36)=""
    InfoText(37)=""
    InfoText(38)=""
    InfoText(39)=""
    InfoText(40)=""
    InfoText(41)=""
    InfoText(42)=""
    InfoText(43)=""
    InfoText(44)=""
    InfoText(45)=""
    InfoText(46)=""
    InfoText(47)=""
    InfoText(48)=""
    InfoText(49)=""
    InfoText(50)=""
    InfoText(51)=""
    InfoText(52)=""
    InfoText(53)=""
    InfoText(54)=""
    InfoText(55)=""
    InfoText(56)=""
    InfoText(57)=""
    InfoText(58)=""
    InfoText(59)=""
    InfoText(60)="??"
    InfoText(61)="Send bug reports and feedback at http://www.combowhore.com/forums/ or voidjmp@gmail.com"
    InfoText(62)=""
    InfoText(63)=""
    InfoText(64)=""
    InfoText(65)=""
    InfoText(66)=""
    InfoText(67)=""
    InfoText(68)=""
    InfoText(69)=""
    InfoText(70)="??"
    InfoText(71)="Thank you to:"
    InfoText(72)=" * Aaron Everitt and Joel Moffatt for UTComp."
    InfoText(73)=" * Michael Massey, Eric Chavez, Mike Hillard, Len Bradley and Steven Phillips for 3SPN."
    InfoText(74)=" * Shaun Goeppinger for Necro."
    InfoText(75)="All without whom this mutator would not be possible!"
}