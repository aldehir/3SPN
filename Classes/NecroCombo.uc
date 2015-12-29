/*******************************************************************************
 * NecroCombo generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NecroCombo extends Combo
    dependson(NecroLeech)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force)
    config;

var() config float NecroScoreAward;
var() config float ShieldOnResurrect;
var() config float SacrificePercentage;
var() config int HealthOnResurrect;
var() config bool bSacrificeHealth;
var() config bool bShareHealth;
var() localized string PropsDisplayText[6];
var() localized string PropsDescText[6];
var Controller Resurrectee;

function Controller PickWhoToRes()
{
    local array<Controller> MyControllerList;
    local Controller C, Necromancer;
    local int i;
    local float BestRezTime;

    i = 0;
    BestRezTime = 100000.0;
    Necromancer = Pawn(Owner).Controller;
    // End:0x4E
    if((Necromancer == none) || Necromancer.PlayerReplicationInfo == none)
    {
        return none;
    }
    C = Level.ControllerList;
    J0x62:
    // End:0x32D [Loop If]
    if(C != none)
    {
        // End:0x7F
        if(C == Necromancer)
        {
        }
        // End:0x316
        else
        {
            // End:0x96
            if(C.PlayerReplicationInfo == none)
            {
            }
            // End:0x316
            else
            {
                // End:0xD3
                if(C.PlayerReplicationInfo.bOnlySpectator || !C.PlayerReplicationInfo.bOutOfLives)
                {
                }
                // End:0x316
                else
                {
                    // End:0x10E
                    if((Misc_Player(C) != none) && Level.TimeSeconds < Misc_Player(C).NextRezTime)
                    {
                    }
                    // End:0x316
                    else
                    {
                        // End:0x15C
                        if((!C.UnresolvedNativeFunction_97('PlayerController') && !C.PlayerReplicationInfo.bBot) || C.Pawn != none)
                        {
                        }
                        // End:0x316
                        else
                        {
                            // End:0x192
                            if(C.PlayerReplicationInfo.Team != Necromancer.PlayerReplicationInfo.Team)
                            {
                            }
                            // End:0x316
                            else
                            {
                                // End:0x26F
                                if((C.UnresolvedNativeFunction_97('Freon_Player') && Freon_Player(C).FrozenPawn != none) || C.UnresolvedNativeFunction_97('Freon_Bot') && Freon_Bot(C).FrozenPawn != none)
                                {
                                    // End:0x240
                                    if(Misc_Player(C) != none)
                                    {
                                        // End:0x227
                                        if(Misc_Player(C).LastRezTime < BestRezTime)
                                        {
                                            MyControllerList.Length = 0;
                                        }
                                        BestRezTime = Misc_Player(C).LastRezTime;
                                    }
                                    i = MyControllerList.Length;
                                    MyControllerList.Length = i + 1;
                                    MyControllerList[i] = C;
                                }
                                // End:0x316
                                else
                                {
                                    // End:0x316
                                    if(C.PlayerReplicationInfo.bBot || PlayerController(C) != none)
                                    {
                                        // End:0x2EA
                                        if(Misc_Player(C) != none)
                                        {
                                            // End:0x2D1
                                            if(Misc_Player(C).LastRezTime < BestRezTime)
                                            {
                                                MyControllerList.Length = 0;
                                            }
                                            BestRezTime = Misc_Player(C).LastRezTime;
                                        }
                                        i = MyControllerList.Length;
                                        MyControllerList.Length = i + 1;
                                        MyControllerList[i] = C;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        C = C.nextController;
        // [Loop Continue]
        goto J0x62;
    }
    // End:0x33B
    if(MyControllerList.Length == 0)
    {
        return none;
    }
    return MyControllerList[Rand(MyControllerList.Length)];
    //return;    
}

function StopEffect(xPawn P)
{
    //return;    
}

function StartEffect(xPawn P)
{
    // End:0x2F
    if((P.Controller == none) || P.PlayerReplicationInfo == none)
    {
        Destroy();
        return;
    }
    Resurrectee = PickWhoToRes();
    DoResurrection();
    //return;    
}

function Abort()
{
    local Controller Necromancer;
    local Pawn P;

    P = Pawn(Owner);
    // End:0x34
    if(P != none)
    {
        Necromancer = Pawn(Owner).Controller;
    }
    // End:0x60
    if(Necromancer != none)
    {
        -- TeamPlayerReplicationInfo(Necromancer.PlayerReplicationInfo).Combos[4];
    }
    // End:0x89
    if(PlayerController(Necromancer) != none)
    {
        PlayerController(Necromancer).ClientPlaySound(sound'ShortCircuit');
    }
    // End:0xD1
    if(Level.Game.UnresolvedNativeFunction_97('Freon'))
    {
        // End:0xCE
        if(P != none)
        {
            Pawn(Owner).ReceiveLocalizedMessage(class'NecroMessages', 3, none, none);
        }
    }
    // End:0xF8
    else
    {
        // End:0xF8
        if(P != none)
        {
            Pawn(Owner).ReceiveLocalizedMessage(class'NecroMessages', 1, none, none);
        }
    }
    Destroy();
    //return;    
}

function DoResurrection()
{
    local int ResurrecteeHealth;
    local float ResurrecteeShield, SacrificedHealth, SacrificedShield;
    local Inventory LeechInv;
    local Controller Necromancer;
    local Pawn P;
    local NavigationPoint StartSpot;
    local int TeamNum;
    local Freon_Pawn xPawn;

    // End:0x13
    if(Resurrectee == none)
    {
        Abort();
        return;
    }
    P = Pawn(Owner);
    // End:0x36
    if(P == none)
    {
        Abort();
        return;
    }
    Necromancer = P.Controller;
    // End:0x5D
    if(Necromancer == none)
    {
        Abort();
        return;
    }
    // End:0x89
    if(Freon_Player(Resurrectee) != none)
    {
        xPawn = Freon_Player(Resurrectee).FrozenPawn;
    }
    // End:0xB2
    else
    {
        // End:0xB2
        if(Freon_Bot(Resurrectee) != none)
        {
            xPawn = Freon_Bot(Resurrectee).FrozenPawn;
        }
    }
    // End:0x22E
    if(xPawn != none)
    {
        // End:0x1E4
        if((Freon(Level.Game) == none) || Freon(Level.Game).TeleportOnThaw == false)
        {
            // End:0x139
            if((Resurrectee.PlayerReplicationInfo == none) || Resurrectee.PlayerReplicationInfo.Team == none)
            {
                TeamNum = 255;
            }
            // End:0x15F
            else
            {
                TeamNum = Resurrectee.PlayerReplicationInfo.Team.TeamIndex;
            }
            StartSpot = Level.Game.FindPlayerStart(Resurrectee, byte(TeamNum));
            // End:0x1E4
            if(StartSpot != none)
            {
                xPawn.SetLocation(StartSpot.Location);
                xPawn.SetRotation(StartSpot.Rotation);
                xPawn.Velocity = vect(0.0, 0.0, 0.0);
            }
        }
        xPawn.Thaw();
        UnresolvedNativeFunction_97(sound'Thaw', 0, 300.0);
        BroadcastLocalizedMessage(class'NecroMessages', 2, Necromancer.PlayerReplicationInfo, Resurrectee.PlayerReplicationInfo);
    }
    // End:0x36B
    else
    {
        Resurrectee.PlayerReplicationInfo.bOutOfLives = false;
        Resurrectee.PlayerReplicationInfo.NumLives = 1;
        Level.Game.RestartPlayer(Resurrectee);
        // End:0x29A
        if(Resurrectee.Pawn == none)
        {
            Abort();
            return;
        }
        // End:0x2BE
        if(PlayerController(Resurrectee) != none)
        {
            PlayerController(Resurrectee).ClientReset();
        }
        // End:0x334
        if(((Team_GameBase(Level.Game) != none) && Team_GameBase(Level.Game).bSpawnProtectionOnRez == false) && Misc_Pawn(Resurrectee.Pawn) != none)
        {
            Misc_Pawn(Resurrectee.Pawn).DeactivateSpawnProtection();
        }
        UnresolvedNativeFunction_97(sound'Resurrection', 0, 300.0);
        BroadcastLocalizedMessage(class'NecroMessages', 0, Necromancer.PlayerReplicationInfo, Resurrectee.PlayerReplicationInfo);
    }
    ResurrecteeHealth = HealthOnResurrect;
    ResurrecteeShield = ShieldOnResurrect;
    // End:0x4C0
    if(bSacrificeHealth)
    {
        SacrificePercentage = FClamp(SacrificePercentage, 0.0, 1.0);
        SacrificedHealth = float(P.Health) / 100.0;
        SacrificedHealth *= (SacrificePercentage * float(100));
        SacrificedHealth = float(Clamp(int(SacrificedHealth), int(SacrificedHealth), P.Health));
        SacrificedShield = (P.ShieldStrength / float(100)) * (SacrificePercentage * float(100));
        // End:0x43E
        if(bShareHealth)
        {
            ResurrecteeHealth = int(SacrificedHealth);
            ResurrecteeShield = SacrificedShield;
        }
        // End:0x4C0
        if(P.FindInventoryType(class'NecroLeech') == none)
        {
            LeechInv = UnresolvedNativeFunction_97(class'NecroLeech', P,,);
            // End:0x4C0
            if(LeechInv != none)
            {
                LeechInv.GiveTo(P);
                NecroLeech(LeechInv).LeechAmount = int(SacrificedHealth);
                NecroLeech(LeechInv).ShieldLeechAmount = SacrificedShield;
            }
        }
    }
    Resurrectee.Pawn.Health = ResurrecteeHealth;
    Resurrectee.Pawn.ShieldStrength = ResurrecteeShield;
    // End:0x52C
    if(Misc_Player(Resurrectee) != none)
    {
        Misc_Player(Resurrectee).LastRezTime = Level.TimeSeconds;
    }
    Necromancer.Adrenaline -= AdrenalineCost;
    Necromancer.PlayerReplicationInfo.Score += NecroScoreAward;
    // End:0x5BE
    if((Team_GameBase(Level.Game) != none) && Team_GameBase(Level.Game).DarkHorse == Necromancer)
    {
        Team_GameBase(Level.Game).DarkHorse = none;
    }
    Destroy();
    //return;    
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    local int i;

    super(Info).FillPlayInfo(PlayInfo);
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "NecroScoreAward", default.PropsDisplayText[++ i], 0, 10, "Text");
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "HealthOnResurrect", default.PropsDisplayText[++ i], 0, 10, "Text");
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "ShieldOnResurrect", default.PropsDisplayText[++ i], 0, 10, "Text");
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "bSacrificeHealth", default.PropsDisplayText[++ i], 0, 10, "Check");
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "SacrificePercentage", default.PropsDisplayText[++ i], 0, 10, "Text");
    PlayInfo.UnresolvedNativeFunction_98("Necro Combo v3", "bShareHealth", default.PropsDisplayText[++ i], 0, 10, "Check");
    //return;    
}

static function string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        // End:0x23
        case "NecroScoreAward":
            return default.PropsDescText[0];
        // End:0x41
        case "HealthOnResurrect":
            return default.PropsDescText[1];
        // End:0x60
        case "ShieldOnResurrect":
            return default.PropsDescText[2];
        // End:0x7E
        case "bSacrificeHealth":
            return default.PropsDescText[3];
        // End:0x9F
        case "SacrificePercentage":
            return default.PropsDescText[4];
        // End:0xB9
        case "bShareHealth":
            return default.PropsDescText[5];
        // End:0xFFFF
        default:
            return super(Info).GetDescriptionText(PropName);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    //return;    
}

defaultproperties
{
    NecroScoreAward=5.0
    ShieldOnResurrect=100.0
    HealthOnResurrect=100
    PropsDisplayText[0]="Necro Score Award"
    PropsDisplayText[1]="Health When Resurrected"
    PropsDisplayText[2]="Shield When Resurrected"
    PropsDisplayText[3]="bSacrificeHealth"
    PropsDisplayText[4]="SacrificePercentage"
    PropsDisplayText[5]="bShareHealth"
    PropsDescText[0]="How many points should the player receive for performing the necro combo"
    PropsDescText[1]="How much health the resurrectee should spawn with."
    PropsDescText[2]="How much shield the resurrectee should spawn with."
    PropsDescText[3]="Should the Necromancer Sacrifice their Health and Shield? (A percentage of health is taken away from the necromancer and given to the player ressed, as their starting health)."
    PropsDescText[4]="The percentage of health to be sacrificed from the necromancer and given to the player being ressed as starting health."
    PropsDescText[5]="If true, the health lost by the necromancer will be given to the ressed player instead of the health specified in HealthOnResurrect and ShieldOnResurrect (bSacrificeHalth needs to be true for this setting to work)."
    ExecMessage="Necromancy!"
    Duration=1.0
    ActivateSound=none
    ActivationEffectClass=none
    keys[0]=1
    keys[1]=1
    keys[2]=2
    keys[3]=2
}