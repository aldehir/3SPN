/*******************************************************************************
 * Misc_StatBoard generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Misc_StatBoard extends DMStatsScreen
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var Texture Box;
var Texture BaseTex;
var int KillsX;
var int DamageX;
var int FiredX;
var int AccX;
var Misc_PRI OwnerPRI;
var Misc_PRI ViewPRI;
var Color CurrentColor;

static function float GetPercentage(float f1, float f2)
{
    // End:0x15
    if(f1 == 0.0)
    {
        return 0.0;
    }
    return FMin(100.0, (f2 / f1) * 100.0);
    //return;    
}

function GetStatsFor(class<Weapon> WeaponClass, TeamPlayerReplicationInfo ThePRI, out int killsw)
{
    local int i;

    killsw = 0;
    i = 0;
    J0x0E:
    // End:0x7F [Loop If]
    if(i < ThePRI.WeaponStatsArray.Length)
    {
        // End:0x75
        if(class'Object'.static.ClassIsChildOf(ThePRI.WeaponStatsArray[i].WeaponClass, WeaponClass))
        {
            killsw = ThePRI.WeaponStatsArray[i].Kills;
            return;
        }
        ++ i;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

simulated function DrawBars(Canvas C, int Num, int X, int Y, int W, int H)
{
    C.SetPos(float(X), float(Y));
    C.DrawColor = CurrentColor;
    C.DrawRect(Box, float(W), float(H * Num));
    C.DrawColor = HudClass.default.WhiteColor * 0.40;
    C.SetPos(float(X), float(Y));
    C.DrawRect(Box, float(W), 1.0);
    C.SetPos(float(X), float(Y));
    C.DrawRect(Box, 1.0, float(H * Num));
    C.SetPos(float(X + W), float(Y));
    C.DrawRect(Box, 1.0, float(H * Num));
    C.SetPos(float(X), float(Y + (H * Num)));
    C.DrawRect(Box, float(W + 1), 1.0);
    //return;    
}

simulated function DrawHitStat(Canvas C, int Fired, int Hit, int Dam, int killsw, string WeaponName, int X, int Y, int W, int H, int TextX, int TextY)
{
    local int acc;
    local float XL, YL;

    DrawBars(C, 1, X, Y, W, H);
    acc = int(GetPercentage(float(Fired), float(Hit)));
    C.SetPos(float(X + TextX), float(Y + TextY));
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.DrawText(WeaponName, true);
    C.StrLen(string(killsw), XL, YL);
    C.SetPos(float(X + KillsX) - XL, float(Y + TextY));
    C.DrawText(string(killsw), true);
    C.StrLen(string(Fired) @ ":", XL, YL);
    C.SetPos(float(X + FiredX) - XL, float(Y + TextY));
    C.DrawText(string(Fired) @ ":", true);
    C.StrLen(string(acc), XL, YL);
    C.SetPos(float(X + AccX) - XL, float(Y + TextY));
    C.DrawText(string(acc) $ "%", true);
    C.StrLen(string(Dam), XL, YL);
    C.SetPos(float(X + DamageX) - XL, float(Y + TextY));
    C.DrawText(string(Dam), true);
    //return;    
}

simulated function DrawHitStats(Canvas C, HitStats Stats, string WeaponName, int X, int Y, int W, int H, int TextX, int TextY, Misc_PRI TmpPRI, class<Weapon> WeaponClass)
{
    local int acc, PriAcc, AltAcc, Dam, PriDam, AltDam,
	    Fired, PriFired, AltFired, killsw;

    local float XL, YL;

    DrawBars(C, 1, X, Y, W, H);
    // End:0x65
    if(Stats.primary.Fired > 0)
    {
        PriAcc = int(GetPercentage(float(Stats.primary.Fired), float(Stats.primary.Hit)));
    }
    // End:0xAB
    if(Stats.Secondary.Fired > 0)
    {
        AltAcc += int(GetPercentage(float(Stats.Secondary.Fired), float(Stats.Secondary.Hit)));
    }
    GetStatsFor(WeaponClass, TmpPRI, killsw);
    PriFired = Stats.primary.Fired;
    AltFired = Stats.Secondary.Fired;
    Fired = PriFired + AltFired;
    acc = int(GetPercentage(float(Fired), float(Stats.primary.Hit + Stats.Secondary.Hit)));
    PriDam = Stats.primary.Damage;
    AltDam = Stats.Secondary.Damage;
    Dam = PriDam + AltDam;
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.SetPos(float(X + TextX), float(Y + TextY));
    C.DrawText(WeaponName, true);
    // End:0x1F7
    if(class<FlakCannon>(WeaponClass) != none)
    {
        Fired = (PriFired / 9) + AltFired;
    }
    C.StrLen(string(Fired) @ ":", XL, YL);
    C.SetPos(float(X + FiredX) - XL, float(Y + TextY));
    C.DrawText(string(Fired) @ ":", true);
    C.StrLen(string(acc), XL, YL);
    C.SetPos(float(X + AccX) - XL, float(Y + TextY));
    C.DrawText(string(acc) $ "%", true);
    C.StrLen(string(Dam), XL, YL);
    C.SetPos(float(X + DamageX) - XL, float(Y + TextY));
    C.DrawText(string(Dam), true);
    C.StrLen(string(killsw), XL, YL);
    C.SetPos(float(X + KillsX) - XL, float(Y + TextY));
    C.DrawText(string(killsw), true);
    Y += H;
    C.SetPos(float((X + TextX) + TextX), float(Y + TextY));
    C.DrawText("Pri:", true);
    C.StrLen(string(PriFired) @ ":", XL, YL);
    C.SetPos(float(X + FiredX) - XL, float(Y + TextY));
    C.DrawText(string(PriFired) @ ":", true);
    C.StrLen(string(PriAcc), XL, YL);
    C.SetPos(float(X + AccX) - XL, float(Y + TextY));
    C.DrawText(string(PriAcc) $ "%", true);
    C.StrLen(string(PriDam), XL, YL);
    C.SetPos(float(X + DamageX) - XL, float(Y + TextY));
    C.DrawText(string(PriDam), true);
    Y += H;
    C.SetPos(float((X + TextX) + TextX), float(Y + TextY));
    C.DrawText("Alt:", true);
    C.StrLen(string(AltFired) @ ":", XL, YL);
    C.SetPos(float(X + FiredX) - XL, float(Y + TextY));
    C.DrawText(string(AltFired) @ ":", true);
    C.StrLen(string(AltAcc), XL, YL);
    C.SetPos(float(X + AccX) - XL, float(Y + TextY));
    C.DrawText(string(AltAcc) $ "%", true);
    C.StrLen(string(AltDam), XL, YL);
    C.SetPos(float(X + DamageX) - XL, float(Y + TextY));
    C.DrawText(string(AltDam), true);
    //return;    
}

simulated event DrawScoreboard(Canvas C)
{
    local Misc_PRI TmpPRI;
    local int Awards, Combos, TextX, TextY, Dam, killsw,
	    i, j;

    local float XL, YL;
    local Color Red, Blue, OwnerColor, ViewedColor;
    local string Name;
    local byte OwnerTeam, ViewTeam;
    local int BarX, BarY, BarW, BarH, MiscX, MiscY,
	    MiscW, MiscH, PlayerBoxX, PlayerBoxY, PlayerBoxW,
	    PlayerBoxH;

    // End:0x33
    if(PlayerOwner == none)
    {
        PlayerOwner = UnrealPlayer(Owner);
        // End:0x33
        if(PlayerOwner == none)
        {
            super.DrawScoreboard(C);
            return;
        }
    }
    // End:0x102
    if(PRI == none)
    {
        PRI = TeamPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);
        // End:0x6F
        if(PRI == none)
        {
            super.DrawScoreboard(C);
            return;
        }
        // End:0x102
        if(PRI.bOnlySpectator || PRI.bOutOfLives)
        {
            // End:0xFC
            if((Pawn(PlayerOwner.ViewTarget) != none) && Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo != none)
            {
                PRI = TeamPlayerReplicationInfo(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
            }
            // End:0x102
            else
            {
                NextStats();
            }
        }
    }
    ViewPRI = Misc_PRI(PRI);
    // End:0x12A
    if(ViewPRI == none)
    {
        super.DrawScoreboard(C);
        return;
    }
    // End:0x1F0
    if((OwnerPRI == none) || Misc_Player(PlayerOwner).bFirstOpen)
    {
        OwnerPRI = Misc_PRI(PlayerOwner.PlayerReplicationInfo);
        // End:0x1DA
        if(PlayerOwner.PlayerReplicationInfo.bOnlySpectator && Pawn(PlayerOwner.ViewTarget) != none)
        {
            OwnerPRI = Misc_PRI(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
            // End:0x1DA
            if(OwnerPRI == none)
            {
                OwnerPRI = ViewPRI;
            }
        }
        Misc_Player(PlayerOwner).bFirstOpen = false;
    }
    Red = HudClass.default.RedColor;
    Red.A = 200;
    Blue = HudClass.default.TurqColor;
    Blue.A = 200;
    // End:0x253
    if(OwnerPRI.Team == none)
    {
        OwnerTeam = byte(255);
    }
    // End:0x272
    else
    {
        OwnerTeam = byte(OwnerPRI.Team.TeamIndex);
    }
    // End:0x293
    if(ViewPRI.Team == none)
    {
        ViewTeam = byte(255);
    }
    // End:0x2B2
    else
    {
        ViewTeam = byte(ViewPRI.Team.TeamIndex);
    }
    // End:0x2DD
    if((OwnerTeam == 255) || OwnerTeam == 1)
    {
        OwnerColor = Blue;
    }
    // End:0x2E8
    else
    {
        OwnerColor = Red;
    }
    // End:0x313
    if((ViewTeam == 255) || ViewTeam == 1)
    {
        ViewedColor = Blue;
    }
    // End:0x31E
    else
    {
        ViewedColor = Red;
    }
    // End:0x378
    if((Level.TimeSeconds - LastUpdateTime) > float(5))
    {
        LastUpdateTime = Level.TimeSeconds;
        PlayerOwner.ServerUpdateStats(OwnerPRI);
        PlayerOwner.ServerUpdateStats(ViewPRI);
    }
    MiscW = int(C.ClipX * 0.480);
    PlayerBoxX = int(C.ClipX * 0.020);
    PlayerBoxW = int(C.ClipX * 0.460);
    PlayerBoxH = int(C.ClipY * 0.51740);
    BarH = PlayerBoxH / 15;
    BarW = int(C.ClipX * 0.460);
    TextX = int(0.0050 * C.ClipX);
    TextY = int(0.00360 * C.ClipY);
    KillsX = int(float(int(float(PlayerBoxW) * 0.690)) * 0.40);
    AccX = int(float(int(float(PlayerBoxW) * 0.690)) * 0.750);
    DamageX = int(float(PlayerBoxW) * 0.690) - TextX;
    C.Style = 5;
    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = 175;
    MiscX = int(C.ClipX * 0.010);
    MiscY = int(C.ClipY * 0.10);
    MiscH = int(C.ClipY * 0.11830);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 126.0, 772.0, 137.0);
    MiscX = int(C.ClipX * 0.510);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 125.0, 772.0, 137.0);
    MiscX = int(C.ClipX * 0.010);
    MiscY = MiscY + MiscH;
    MiscH = int(C.ClipY * 0.03660);
    MiscW = int(C.ClipX * 0.00750);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 263.0, 10.0, 10.0);
    MiscX = int(C.ClipX * 0.510);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 263.0, 10.0, 10.0);
    MiscX = int((C.ClipX * 0.010) + float(MiscW));
    MiscW = int((C.ClipX * 0.480) - float(MiscW * 2));
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawColor = OwnerColor;
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 137.0, 263.0, 751.0, 42.0);
    C.SetPos(float(MiscX + MiscW), float(MiscY));
    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = 175;
    C.DrawTile(BaseTex, C.ClipX * 0.00690, float(MiscH), 888.0, 263.0, 10.0, 10.0);
    MiscX = int(float(MiscX) + (C.ClipX * 0.50));
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawColor = ViewedColor;
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 137.0, 263.0, 751.0, 42.0);
    C.SetPos(float(MiscX + MiscW), float(MiscY));
    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = 175;
    C.DrawTile(BaseTex, C.ClipX * 0.00690, float(MiscH), 888.0, 263.0, 10.0, 10.0);
    MiscX = int(C.ClipX * 0.010);
    MiscY = MiscY + MiscH;
    MiscH = int(C.ClipY * 0.0050);
    MiscW = int(C.ClipX * 0.480);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 306.0, 772.0, 4.0);
    MiscX = int(C.ClipX * 0.510);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 306.0, 772.0, 4.0);
    PlayerBoxY = int(float(MiscY + MiscH) + (C.ClipY * 0.0050));
    MiscX = int(C.ClipX * 0.010);
    MiscY = MiscY + MiscH;
    MiscH = int(C.ClipY * 0.51750);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 398.0, 772.0, 10.0);
    MiscX = int(C.ClipX * 0.510);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 398.0, 772.0, 10.0);
    MiscX = int(C.ClipX * 0.010);
    MiscY = MiscY + MiscH;
    MiscH = int(C.ClipY * 0.06330);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 829.0, 772.0, 68.0);
    MiscX = int(C.ClipX * 0.510);
    C.SetPos(float(MiscX), float(MiscY));
    C.DrawTile(BaseTex, float(MiscW), float(MiscH), 126.0, 829.0, 772.0, 68.0);
    i = 0;
    J0xD09:
    // End:0x185E [Loop If]
    if(i < 2)
    {
        // End:0xD4B
        if(i == 0)
        {
            TmpPRI = OwnerPRI;
            BarX = int(C.ClipX * 0.020);
        }
        // End:0xD73
        else
        {
            BarX = int(C.ClipX * 0.520);
            TmpPRI = ViewPRI;
        }
        BarY = int(C.ClipY * 0.1550);
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
        // End:0xE00
        if(TmpPRI.bOutOfLives)
        {
            C.DrawColor = HudClass.default.WhiteColor * 0.50;
        }
        // End:0xE25
        else
        {
            C.DrawColor = HudClass.default.WhiteColor * 0.70;
        }
        C.SetPos(float(BarX) + (C.ClipX * 0.010), float(BarY) + (C.ClipY * 0.0080));
        Name = TmpPRI.PlayerName;
        C.StrLen(Name, XL, YL);
        // End:0xEF4
        if(XL > (C.ClipX * 0.230))
        {
            Name = Left(Name, int(((C.ClipX * 0.230) / XL) * float(Len(Name))));
        }
        C.DrawText(Name, true);
        Name = string(int(TmpPRI.Score % float(10000)));
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.270)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0080));
        C.DrawText(Name, true);
        // End:0x1018
        if(!PlayerController(Owner).GameReplicationInfo.bTeamGame)
        {
            Name = string(int(TmpPRI.Score / float(10000)));
        }
        // End:0x102E
        else
        {
            Name = string(TmpPRI.Kills);
        }
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.350)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0080));
        C.DrawText(Name, true);
        C.DrawColor = HudClass.default.CyanColor * 0.50;
        C.DrawColor.B = 150;
        C.DrawColor.R = 20;
        Name = string(Min(999, TmpPRI.Ping * 4));
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.420)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0080));
        C.DrawText(Name, true);
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -3);
        Name = string(TmpPRI.PacketLoss);
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.420)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0350));
        C.DrawText(Name, true);
        // End:0x137C
        if(!GRI.bMatchHasBegun)
        {
            // End:0x12BD
            if(TmpPRI.bReadyToPlay)
            {
                Name = class'TAM_Scoreboard'.default.ReadyText;
            }
            // End:0x12D1
            else
            {
                Name = class'TAM_Scoreboard'.default.NotReadyText;
            }
            // End:0x133E
            if(TmpPRI.bAdmin)
            {
                Name = "Admin -" @ Name;
                C.DrawColor.R = 170;
                C.DrawColor.G = 20;
                C.DrawColor.B = 20;
            }
            // End:0x1379
            else
            {
                C.DrawColor = HudClass.default.RedColor * 0.70;
                C.DrawColor.G = 130;
            }
        }
        // End:0x14DC
        else
        {
            // End:0x145A
            if(!TmpPRI.bAdmin && !TmpPRI.bOutOfLives)
            {
                C.DrawColor = HudClass.default.RedColor * 0.70;
                C.DrawColor.G = 130;
                // End:0x1443
                if(((TmpPRI.Team != none) && TmpPRI.Team.TeamIndex == OwnerTeam) || TmpPRI == OwnerPRI)
                {
                    Name = TmpPRI.GetLocationName();
                }
                // End:0x1457
                else
                {
                    Name = TmpPRI.StringUnknown;
                }
            }
            // End:0x14DC
            else
            {
                C.DrawColor.R = 170;
                C.DrawColor.G = 20;
                C.DrawColor.B = 20;
                // End:0x14BE
                if(TmpPRI.bAdmin)
                {
                    Name = "Admin";
                }
                // End:0x14DC
                else
                {
                    // End:0x14DC
                    if(TmpPRI.bOutOfLives)
                    {
                        Name = "Dead";
                    }
                }
            }
        }
        C.StrLen(Name, XL, YL);
        // End:0x154C
        if(XL > (C.ClipX * 0.230))
        {
            Name = Left(Name, int(((C.ClipX * 0.230) / XL) * float(Len(Name))));
        }
        C.SetPos(float(BarX) + (C.ClipX * 0.020), float(BarY) + (C.ClipY * 0.0350));
        C.DrawText(Name, true);
        C.DrawColor = HudClass.default.WhiteColor * 0.550;
        // End:0x1614
        if(TmpPRI.PlayedRounds > 0)
        {
            XL = (TmpPRI.Score % float(10000)) / float(TmpPRI.PlayedRounds);
        }
        // End:0x1631
        else
        {
            XL = TmpPRI.Score % float(10000);
        }
        // End:0x16B3
        if(int((XL - float(int(XL))) * float(10)) < 0)
        {
            // End:0x1673
            if(int(XL) == 0)
            {
                Name = "-" $ string(int(XL));
            }
            // End:0x1682
            else
            {
                Name = string(int(XL));
            }
            Name = (Name $ ".") $ string(-int((XL - float(int(XL))) * float(10)));
        }
        // End:0x16EE
        else
        {
            Name = string(int(XL));
            Name = (Name $ ".") $ string(int((XL - float(int(XL))) * float(10)));
        }
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.270)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0350));
        C.DrawText(Name, true);
        C.DrawColor.R = 170;
        C.DrawColor.G = 20;
        C.DrawColor.B = 20;
        Name = string(int(TmpPRI.Deaths));
        C.StrLen(Name, XL, YL);
        C.SetPos((float(BarX) + (C.ClipX * 0.350)) - (XL * 0.50), float(BarY) + (C.ClipY * 0.0350));
        C.DrawText(Name, true);
        ++ i;
        // [Loop Continue]
        goto J0xD09;
    }
    j = 0;
    J0x1865:
    // End:0x343E [Loop If]
    if(j < 2)
    {
        // End:0x18C7
        if(j == 0)
        {
            TmpPRI = OwnerPRI;
            PlayerBoxX = int(C.ClipX * 0.020);
            CurrentColor = OwnerColor * 0.350;
            CurrentColor.A = 75;
        }
        // End:0x190F
        else
        {
            TmpPRI = ViewPRI;
            PlayerBoxX = int(C.ClipX * 0.520);
            CurrentColor = ViewedColor * 0.350;
            CurrentColor.A = 75;
        }
        MiscX = int(float(PlayerBoxX) + (float(PlayerBoxW) * 0.70));
        MiscY = PlayerBoxY;
        MiscW = int(float(PlayerBoxW) * 0.2950);
        MiscH = int(C.ClipY * 0.020);
        C.StrLen("Test", XL, YL);
        TextY = int((float(MiscH) * 0.60) - (YL * 0.50));
        Awards = 1;
        // End:0x19CC
        if(TmpPRI.bFirstBlood)
        {
            ++ Awards;
        }
        i = 0;
        J0x19D3:
        // End:0x1A0C [Loop If]
        if(i < 6)
        {
            // End:0x1A02
            if(TmpPRI.Spree[i] > 0)
            {
                ++ Awards;
            }
            ++ i;
            // [Loop Continue]
            goto J0x19D3;
        }
        i = 0;
        J0x1A13:
        // End:0x1A4C [Loop If]
        if(i < 7)
        {
            // End:0x1A42
            if(TmpPRI.MultiKills[i] > 0)
            {
                ++ Awards;
            }
            ++ i;
            // [Loop Continue]
            goto J0x1A13;
        }
        // End:0x1A68
        if(TmpPRI.flakcount > 4)
        {
            ++ Awards;
        }
        // End:0x1A84
        if(TmpPRI.combocount > 4)
        {
            ++ Awards;
        }
        // End:0x1AA0
        if(TmpPRI.headcount > 2)
        {
            ++ Awards;
        }
        // End:0x1ABC
        if(TmpPRI.GoalsScored > 2)
        {
            ++ Awards;
        }
        // End:0x1AD7
        if(TmpPRI.GoalsScored > 0)
        {
            ++ Awards;
        }
        // End:0x1AF2
        if(TmpPRI.FlawlessCount > 0)
        {
            ++ Awards;
        }
        // End:0x1B0D
        if(TmpPRI.OverkillCount > 0)
        {
            ++ Awards;
        }
        // End:0x1B28
        if(TmpPRI.DarkHorseCount > 0)
        {
            ++ Awards;
        }
        // End:0x1B44
        if(TmpPRI.ranovercount > 4)
        {
            ++ Awards;
        }
        // End:0x1B5F
        if(TmpPRI.CampCount > 1)
        {
            ++ Awards;
        }
        // End:0x1B7B
        if(TmpPRI.Suicides > 2)
        {
            ++ Awards;
        }
        // End:0x1B97
        if(TmpPRI.RoxCount >= 7)
        {
            ++ Awards;
        }
        DrawBars(C, Awards, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.DrawText("Awards", true);
        // End:0x2399
        if(Awards > 1)
        {
            MiscX += TextX;
            MiscY += MiscH;
            // End:0x1C9D
            if(TmpPRI.bFirstBlood)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText(FirstBloodString);
                MiscY += MiscH;
            }
            i = 0;
            J0x1CA4:
            // End:0x1D68 [Loop If]
            if(i < 6)
            {
                // End:0x1D5E
                if(TmpPRI.Spree[i] > 0)
                {
                    C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                    C.DrawText(((class'KillingSpreeMessage'.default.SelfSpreeNote[i] $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.Spree[i]));
                    MiscY += MiscH;
                }
                ++ i;
                // [Loop Continue]
                goto J0x1CA4;
            }
            i = 0;
            J0x1D6F:
            // End:0x1E2A [Loop If]
            if(i < 7)
            {
                // End:0x1E20
                if(TmpPRI.MultiKills[i] > 0)
                {
                    C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                    C.DrawText(((KillString[i] $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.MultiKills[i]));
                    MiscY += MiscH;
                }
                ++ i;
                // [Loop Continue]
                goto J0x1D6F;
            }
            // End:0x1E87
            if(TmpPRI.flakcount > 4)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText(FlakMonkey);
                MiscY += MiscH;
            }
            // End:0x1EE9
            if(TmpPRI.ranovercount > 4)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText("Bukkake!");
                MiscY += MiscH;
            }
            // End:0x1F46
            if(TmpPRI.combocount > 4)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText(Combowhore);
                MiscY += MiscH;
            }
            // End:0x1FA3
            if(TmpPRI.headcount > 2)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText(Headhunter);
                MiscY += MiscH;
            }
            // End:0x203C
            if(TmpPRI.GoalsScored > 0)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText((("Final Kill!" $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.GoalsScored));
                MiscY += MiscH;
            }
            // End:0x2099
            if(TmpPRI.GoalsScored > 2)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText(HatTrick);
                MiscY += MiscH;
            }
            // End:0x2130
            if(TmpPRI.FlawlessCount > 0)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText((("Flawless!" $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.FlawlessCount));
                MiscY += MiscH;
            }
            // End:0x21C7
            if(TmpPRI.OverkillCount > 0)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText((("Overkill!" $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.OverkillCount));
                MiscY += MiscH;
            }
            // End:0x2260
            if(TmpPRI.DarkHorseCount > 0)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText((("Dark Horse!" $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.DarkHorseCount));
                MiscY += MiscH;
            }
            // End:0x22C8
            if(TmpPRI.CampCount > 1)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText("Campy Bastard!", true);
                MiscY += MiscH;
            }
            // End:0x2327
            if(TmpPRI.Suicides > 2)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText("Emo!", true);
                MiscY += MiscH;
            }
            // End:0x238D
            if(TmpPRI.RoxCount >= 7)
            {
                C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                C.DrawText("Rocket Man!", true);
                MiscY += MiscH;
            }
            MiscX -= TextX;
        }
        // End:0x23BE
        if(Awards == 1)
        {
            MiscY += int(float(MiscH) * 1.2750);
        }
        // End:0x23D5
        else
        {
            MiscY += int(float(MiscH) * 0.2750);
        }
        Combos = 1;
        i = 0;
        J0x23E3:
        // End:0x241C [Loop If]
        if(i < 5)
        {
            // End:0x2412
            if(TmpPRI.Combos[i] > 0)
            {
                ++ Combos;
            }
            ++ i;
            // [Loop Continue]
            goto J0x23E3;
        }
        DrawBars(C, Combos, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.DrawText("Combos", true);
        // End:0x258A
        if(Combos > 1)
        {
            MiscX += TextX;
            i = 0;
            J0x24C3:
            // End:0x257E [Loop If]
            if(i < 5)
            {
                // End:0x2574
                if(TmpPRI.Combos[i] > 0)
                {
                    MiscY += MiscH;
                    C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
                    C.DrawText(((ComboNames[i] $ (MakeColorCode(HudClass.default.GoldColor * 0.70))) $ "x") $ string(TmpPRI.Combos[i]));
                }
                ++ i;
                // [Loop Continue]
                goto J0x24C3;
            }
            MiscX -= TextX;
        }
        MiscY += int(float(MiscH) * 1.2750);
        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
        C.DrawText("Efficiency:", true);
        Name = string(int(GetPercentage(TmpPRI.Deaths + float(TmpPRI.Kills), float(TmpPRI.Kills)))) $ "%";
        C.StrLen(Name, XL, YL);
        C.SetPos(float((MiscX + MiscW) - TextX) - XL, float(MiscY + TextY));
        C.DrawText(Name, true);
        // End:0x281F
        if(PlayerController(Owner).GameReplicationInfo.bTeamGame)
        {
            MiscY += int(float(MiscH) * 1.2750);
            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
            C.DrawColor = HudClass.default.WhiteColor * 0.70;
            C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
            C.DrawText("ReverseFF:", true);
            Name = string(int(TmpPRI.ReverseFF * float(100))) $ "%";
            C.StrLen(Name, XL, YL);
            C.SetPos(float((MiscX + MiscW) - TextX) - XL, float(MiscY + TextY));
            C.DrawText(Name, true);
        }
        MiscX = int(float(PlayerBoxX) + (float(PlayerBoxW) * 0.0050));
        MiscY = PlayerBoxY;
        MiscW = int(float(PlayerBoxW) * 0.690);
        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.DrawText("Weapon", true);
        C.StrLen("Kills", XL, YL);
        C.SetPos(float(MiscX + KillsX) - XL, float(MiscY + TextY));
        C.DrawText("Kills", true);
        C.StrLen("Fired : Acc", XL, YL);
        C.SetPos(float(MiscX + AccX) - XL, float(MiscY + TextY));
        C.DrawText("Fired : Acc%", true);
        C.StrLen("Dam.", XL, YL);
        C.SetPos(float(MiscX + DamageX) - XL, float(MiscY + TextY));
        C.DrawText("Dam.", true);
        MiscY += int(float(MiscH) * 1.2750);
        C.StrLen(" Acc", XL, YL);
        FiredX = int(float(AccX) - XL);
        // End:0x2C1C
        if(TmpPRI.SGDamage > 0)
        {
            DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
            Dam = TmpPRI.SGDamage;
            // End:0x2ADC
            if(Dam > 0)
            {
                C.DrawColor = HudClass.default.WhiteColor * 0.70;
            }
            // End:0x2B01
            else
            {
                C.DrawColor = HudClass.default.WhiteColor * 0.30;
            }
            C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
            C.DrawText("Shield", true);
            C.StrLen(string(Dam), XL, YL);
            C.SetPos(float(MiscX + DamageX) - XL, float(MiscY + TextY));
            C.DrawText(string(Dam), true);
            GetStatsFor(class'ShieldGun', TmpPRI, killsw);
            C.StrLen(string(killsw), XL, YL);
            C.SetPos(float(MiscX + KillsX) - XL, float(MiscY + TextY));
            C.DrawText(string(killsw), true);
        }
        MiscY += int(float(MiscH) * 1.2750);
        // End:0x2CBB
        if((TmpPRI.Assault.primary.Fired > 0) || TmpPRI.Assault.Secondary.Fired > 0)
        {
            DrawHitStats(C, TmpPRI.Assault, "Assault", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'AssaultRifle');
        }
        MiscY += int(float(MiscH) * 3.2750);
        // End:0x2D6C
        if(TmpPRI.Bio.Fired > 0)
        {
            GetStatsFor(class'BioRifle', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Bio.Fired, TmpPRI.Bio.Hit, TmpPRI.Bio.Damage, killsw, "Bio", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += int(float(MiscH) * 1.2750);
        // End:0x2E09
        if((TmpPRI.Shock.primary.Fired > 0) || TmpPRI.Shock.Secondary.Fired > 0)
        {
            DrawHitStats(C, TmpPRI.Shock, "Shock", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'ShockRifle');
        }
        MiscY += int(float(MiscH) * 3.2750);
        // End:0x2EB0
        if(TmpPRI.Combo.Fired > 0)
        {
            DrawHitStat(C, TmpPRI.Combo.Fired, TmpPRI.Combo.Hit, TmpPRI.Combo.Damage, TmpPRI.combocount, "Combo", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += int(float(MiscH) * 1.2750);
        // End:0x2F4C
        if((TmpPRI.Link.primary.Fired > 0) || TmpPRI.Link.Secondary.Fired > 0)
        {
            DrawHitStats(C, TmpPRI.Link, "Link", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'LinkGun');
        }
        MiscY += int(float(MiscH) * 3.2750);
        // End:0x2FE8
        if((TmpPRI.Mini.primary.Fired > 0) || TmpPRI.Mini.Secondary.Fired > 0)
        {
            DrawHitStats(C, TmpPRI.Mini, "Mini", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'Minigun');
        }
        MiscY += int(float(MiscH) * 3.2750);
        // End:0x3084
        if((TmpPRI.Flak.primary.Fired > 0) || TmpPRI.Flak.Secondary.Fired > 0)
        {
            DrawHitStats(C, TmpPRI.Flak, "Flak", MiscX, MiscY, MiscW, MiscH, TextX, TextY, TmpPRI, class'FlakCannon');
        }
        MiscY += int(float(MiscH) * 3.2750);
        // End:0x3139
        if(TmpPRI.Rockets.Fired > 0)
        {
            GetStatsFor(class'RocketLauncher', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Rockets.Fired, TmpPRI.Rockets.Hit, TmpPRI.Rockets.Damage, killsw, "Rockets", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += int(float(MiscH) * 1.2750);
        // End:0x31F0
        if(TmpPRI.Sniper.Fired > 0)
        {
            GetStatsFor(class'SniperRifle', TmpPRI, killsw);
            DrawHitStat(C, TmpPRI.Sniper.Fired, TmpPRI.Sniper.Hit, TmpPRI.Sniper.Damage, killsw, "Lightning", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += int(float(MiscH) * 1.2750);
        // End:0x3294
        if(TmpPRI.Sniper.Hit > 0)
        {
            DrawHitStat(C, TmpPRI.Sniper.Hit, TmpPRI.HeadShots, TmpPRI.HeadShots * 140, TmpPRI.headcount, "Headshot", MiscX, MiscY, MiscW, MiscH, TextX, TextY);
        }
        MiscY += int(float(MiscH) * 1.2750);
        DrawBars(C, 1, MiscX, MiscY, MiscW, MiscH);
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
        C.SetPos(float(MiscX + TextX), float(MiscY + TextY));
        C.DrawText("Total", true);
        Dam = TmpPRI.EnemyDamage;
        C.StrLen(string(Dam), XL, YL);
        C.SetPos(float(MiscX + DamageX) - XL, float(MiscY + TextY));
        C.DrawText(string(Dam), true);
        killsw = TmpPRI.Kills;
        C.StrLen(string(killsw), XL, YL);
        C.SetPos(float(MiscX + KillsX) - XL, float(MiscY + TextY));
        C.DrawText(string(killsw), true);
        MiscY += int(float(MiscH) * 1.2750);
        ++ j;
        // [Loop Continue]
        goto J0x1865;
    }
    bDisplayMessages = true;
    //return;    
}

defaultproperties
{
    Box=Texture'Engine.WhiteSquareTexture'
    BaseTex=Texture'textures.Scoreboard_old'
}