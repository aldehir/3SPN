/*******************************************************************************
 * TAM_Mutator generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class TAM_Mutator extends DMMutator
    dependson(Team_GameBase)
    dependson(ArenaMaster)
    dependson(Misc_Pawn)
    dependson(WeaponFire_Shield)
    dependson(DamType_BioGlob)
    dependson(DamType_FlakChunk)
    dependson(DamType_FlakShell)
    dependson(DamType_Rocket)
    dependson(DamType_RocketHoming)
    dependson(DamType_ShockCombo)
    dependson(Freon_Pawn)
    dependson(NewNet_BioGlob)
    dependson(NewNet_FlakChunk)
    dependson(NewNet_FlakShell)
    dependson(NewNet_RocketProj)
    dependson(NewNet_SeekingRocketProj)
    dependson(NewNet_TimeStamp)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force)
    config
    hidedropdown
    cacheexempt;

const AVERDT_SEND_PERIOD = 4.00;

struct WeaponData
{
    var string WeaponName;
    var int Ammo[2];
    var float MaxAmmo[2];
};

var WeaponData WeaponInfo[9];
var WeaponData WeaponDefaults[9];
var bool EnableNewNet;
var NewNet_PawnCollisionCopy PCC;
var NewNet_TimeStamp StampInfo;
var float AverDT;
var float ClientTimeStamp;
var array<float> DeltaHistory;
var NewNet_FakeProjectileManager FPM;
var float LastReplicatedAverDT;
var class<Weapon> WeaponClasses[9];
var class<Weapon> NewNetWeaponClasses[9];
var string NewNetWeaponNames[9];

replication
{
    // Pos:0x000
    reliable if(bNetInitial && Role == ROLE_Authority)
        EnableNewNet
}

static function bool IsPredicted(Actor A)
{
    // End:0x23
    if((A == none) || A.UnresolvedNativeFunction_97('xPawn'))
    {
        return true;
    }
    // End:0x54
    if(A.UnresolvedNativeFunction_97('Vehicle') && Vehicle(A).Driver != none)
    {
        return true;
    }
    return false;
    //return;    
}

function ModifyPlayer(Pawn Other)
{
    // End:0x1A
    if(EnableNewNet)
    {
        SpawnCollisionCopy(Other);
        RemoveOldPawns();
    }
    super(Mutator).ModifyPlayer(Other);
    //return;    
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    // End:0x14
    if(EnableNewNet)
    {
        SpawnCollisionCopy(V);
    }
    // End:0x38
    if(NextMutator != none)
    {
        NextMutator.DriverEnteredVehicle(V, P);
    }
    //return;    
}

function SpawnCollisionCopy(Pawn Other)
{
    // End:0x30
    if(PCC == none)
    {
        PCC = UnresolvedNativeFunction_97(class'NewNet_PawnCollisionCopy');
        PCC.SetPawn(Other);
    }
    // End:0x44
    else
    {
        PCC.AddPawnToList(Other);
    }
    //return;    
}

function RemoveOldPawns()
{
    PCC = PCC.RemoveOldPawns();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x51
    if(Level.Pauser != none)
    {
        // End:0x4F
        if(Level.NetMode == NM_DedicatedServer)
        {
            Team_GameBase(Level.Game).UpdateTimeOut(DeltaTime);
        }
        return;
    }
    // End:0x5E
    if(!EnableNewNet)
    {
        return;
    }
    // End:0x107
    if(Level.NetMode == NM_DedicatedServer)
    {
        // End:0x90
        if(StampInfo == none)
        {
            StampInfo = UnresolvedNativeFunction_97(class'NewNet_TimeStamp');
        }
        ClientTimeStamp += DeltaTime;
        AverDT = ((9.0 * AverDT) + DeltaTime) / 10.0;
        StampInfo.ReplicatetimeStamp(ClientTimeStamp);
        // End:0x105
        if(ClientTimeStamp > (LastReplicatedAverDT + 4.0))
        {
            StampInfo.ReplicatedAverDT(AverDT);
            LastReplicatedAverDT = ClientTimeStamp;
        }
        return;
    }
    // End:0x139
    if(Level.NetMode == NM_Client)
    {
        // End:0x139
        if(FPM == none)
        {
            FPM = UnresolvedNativeFunction_97(class'NewNet_FakeProjectileManager');
        }
    }
    //return;    
}

function InitWeapons(int AssaultAmmo, int AssaultGrenades, int BioAmmo, int ShockAmmo, int LinkAmmo, int MiniAmmo, int FlakAmmo, int RocketAmmo, int LightningAmmo)
{
    local int i;
    local class<Weapon> WeaponClass;

    i = 0;
    J0x07:
    // End:0x6B7 [Loop If]
    if(i < 9)
    {
        // End:0x2D
        if(WeaponInfo[i].WeaponName ~= "")
        {
            // [Explicit Continue]
            goto J0x6AD;
        }
        // End:0x8C
        if(WeaponInfo[i].WeaponName ~= "xWeapons.AssaultRifle")
        {
            WeaponInfo[i].Ammo[0] = AssaultAmmo;
            WeaponInfo[i].Ammo[1] = AssaultGrenades;
        }
        // End:0x269
        else
        {
            // End:0xCF
            if(WeaponInfo[i].WeaponName ~= "xWeapons.BioRifle")
            {
                WeaponInfo[i].Ammo[0] = BioAmmo;
            }
            // End:0x269
            else
            {
                // End:0x114
                if(WeaponInfo[i].WeaponName ~= "xWeapons.ShockRifle")
                {
                    WeaponInfo[i].Ammo[0] = ShockAmmo;
                }
                // End:0x269
                else
                {
                    // End:0x156
                    if(WeaponInfo[i].WeaponName ~= "xWeapons.LinkGun")
                    {
                        WeaponInfo[i].Ammo[0] = LinkAmmo;
                    }
                    // End:0x269
                    else
                    {
                        // End:0x198
                        if(WeaponInfo[i].WeaponName ~= "xWeapons.MiniGun")
                        {
                            WeaponInfo[i].Ammo[0] = MiniAmmo;
                        }
                        // End:0x269
                        else
                        {
                            // End:0x1DD
                            if(WeaponInfo[i].WeaponName ~= "xWeapons.FlakCannon")
                            {
                                WeaponInfo[i].Ammo[0] = FlakAmmo;
                            }
                            // End:0x269
                            else
                            {
                                // End:0x226
                                if(WeaponInfo[i].WeaponName ~= "xWeapons.RocketLauncher")
                                {
                                    WeaponInfo[i].Ammo[0] = RocketAmmo;
                                }
                                // End:0x269
                                else
                                {
                                    // End:0x269
                                    if(WeaponInfo[i].WeaponName ~= "xWeapons.SniperRifle")
                                    {
                                        WeaponInfo[i].Ammo[0] = LightningAmmo;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        WeaponClass = class<Weapon>(DynamicLoadObject(WeaponInfo[i].WeaponName, class'Class'));
        // End:0x2CE
        if(WeaponClass == none)
        {
            LogInternal("Could not find weapon:" @ WeaponInfo[i].WeaponName, '3SPN');
            // [Explicit Continue]
            goto J0x6AD;
        }
        WeaponDefaults[i].WeaponName = WeaponInfo[i].WeaponName;
        // End:0x3DB
        if((class<Translauncher>(WeaponClass) != none) && WeaponInfo[i].Ammo[0] > 0)
        {
            WeaponDefaults[i].MaxAmmo[0] = class'Translauncher'.default.AmmoChargeRate;
            WeaponDefaults[i].MaxAmmo[1] = class'Translauncher'.default.AmmoChargeF;
            WeaponDefaults[i].Ammo[0] = int(class'Translauncher'.default.AmmoChargeMax);
            class'Translauncher'.default.AmmoChargeRate = 0.0;
            class'Translauncher'.default.AmmoChargeMax = float(WeaponInfo[i].Ammo[0]);
            class'Translauncher'.default.AmmoChargeF = float(WeaponInfo[i].Ammo[0]);
        }
        // End:0x65D
        else
        {
            // End:0x3EE
            if(class<ShieldGun>(WeaponClass) != none)
            {
            }
            // End:0x65D
            else
            {
                // End:0x509
                if(WeaponClass.default.FireModeClass[0].default.AmmoClass != none)
                {
                    WeaponDefaults[i].Ammo[0] = WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount;
                    WeaponDefaults[i].MaxAmmo[0] = float(WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo);
                    WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount = Min(999, WeaponInfo[i].Ammo[0]);
                    WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo = Min(999, int(float(WeaponInfo[i].Ammo[0]) * WeaponInfo[i].MaxAmmo[0]));
                }
                // End:0x65D
                if((WeaponClass.default.FireModeClass[1].default.AmmoClass != none) && WeaponClass.default.FireModeClass[0].default.AmmoClass != WeaponClass.default.FireModeClass[1].default.AmmoClass)
                {
                    WeaponDefaults[i].Ammo[1] = WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount;
                    WeaponDefaults[i].MaxAmmo[1] = float(WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo);
                    WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount = Min(999, WeaponInfo[i].Ammo[1]);
                    WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo = Min(999, int(float(WeaponInfo[i].Ammo[1]) * WeaponInfo[i].MaxAmmo[0]));
                }
            }
        }
        class'Freon_Pawn'.default.RequiredEquipment[i + 1] = WeaponInfo[i].WeaponName;
        class'Misc_Pawn'.default.RequiredEquipment[i + 1] = WeaponInfo[i].WeaponName;
        J0x6AD:
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    class'BioGlob'.default.MyDamageType = class'DamType_BioGlob';
    class'FlakChunk'.default.MyDamageType = class'DamType_FlakChunk';
    class'FlakShell'.default.MyDamageType = class'DamType_FlakShell';
    class'RocketProj'.default.MyDamageType = class'DamType_Rocket';
    class'SeekingRocketProj'.default.MyDamageType = class'DamType_RocketHoming';
    // End:0x8DC
    if(EnableNewNet)
    {
        class'NewNet_BioGlob'.default.MyDamageType = class'DamType_BioGlob';
        class'NewNet_FlakChunk'.default.MyDamageType = class'DamType_FlakChunk';
        class'NewNet_FlakShell'.default.MyDamageType = class'DamType_FlakShell';
        class'NewNet_RocketProj'.default.MyDamageType = class'DamType_Rocket';
        class'NewNet_SeekingRocketProj'.default.MyDamageType = class'DamType_RocketHoming';
        class'DamTypeShieldImpact'.default.WeaponClass = class'NewNet_ShieldGun';
        class'DamTypeAssaultBullet'.default.WeaponClass = class'NewNet_AssaultRifle';
        class'DamTypeAssaultGrenade'.default.WeaponClass = class'NewNet_AssaultRifle';
        class'DamType_BioGlob'.default.WeaponClass = class'NewNet_BioRifle';
        class'DamType_FlakChunk'.default.WeaponClass = class'NewNet_FlakCannon';
        class'DamType_FlakShell'.default.WeaponClass = class'NewNet_FlakCannon';
        class'DamTypeLinkPlasma'.default.WeaponClass = class'NewNet_LinkGun';
        class'DamTypeLinkShaft'.default.WeaponClass = class'NewNet_LinkGun';
        class'DamTypeMinigunAlt'.default.WeaponClass = class'NewNet_MiniGun';
        class'DamTypeMinigunBullet'.default.WeaponClass = class'NewNet_MiniGun';
        class'DamType_Rocket'.default.WeaponClass = class'NewNet_RocketLauncher';
        class'DamType_RocketHoming'.default.WeaponClass = class'NewNet_RocketLauncher';
        class'DamTypeShockBall'.default.WeaponClass = class'NewNet_ShockRifle';
        class'DamTypeShockBeam'.default.WeaponClass = class'NewNet_ShockRifle';
        class'DamType_ShockCombo'.default.WeaponClass = class'NewNet_ShockRifle';
        class'DamTypeSniperHeadShot'.default.WeaponClass = class'NewNet_SniperRifle';
        class'DamTypeSniperShot'.default.WeaponClass = class'NewNet_SniperRifle';
    }
    //return;    
}

function ResetWeaponsToDefaults(bool bModifyShieldGun)
{
    local int i;
    local class<Weapon> WeaponClass;

    i = 0;
    J0x07:
    // End:0x25F [Loop If]
    if(i < 9)
    {
        // End:0x2D
        if(WeaponDefaults[i].WeaponName ~= "")
        {
            // [Explicit Continue]
            goto J0x255;
        }
        WeaponClass = class<Weapon>(DynamicLoadObject(WeaponDefaults[i].WeaponName, class'Class'));
        // End:0x61
        if(WeaponClass == none)
        {
            // [Explicit Continue]
            goto J0x255;
        }
        // End:0xF3
        if((class<Translauncher>(WeaponClass) != none) && WeaponDefaults[i].Ammo[0] > 0)
        {
            class'Translauncher'.default.AmmoChargeRate = WeaponDefaults[i].MaxAmmo[0];
            class'Translauncher'.default.AmmoChargeMax = float(WeaponDefaults[i].Ammo[0]);
            class'Translauncher'.default.AmmoChargeF = WeaponDefaults[i].MaxAmmo[1];
            // [Explicit Continue]
            goto J0x255;
        }
        // End:0x106
        if(class<ShieldGun>(WeaponClass) != none)
        {
            // [Explicit Continue]
            goto J0x255;
        }
        // End:0x191
        if(WeaponClass.default.FireModeClass[0].default.AmmoClass != none)
        {
            WeaponClass.default.FireModeClass[0].default.AmmoClass.default.InitialAmount = WeaponDefaults[i].Ammo[0];
            WeaponClass.default.FireModeClass[0].default.AmmoClass.default.MaxAmmo = int(WeaponDefaults[i].MaxAmmo[0]);
        }
        // End:0x255
        if((WeaponClass.default.FireModeClass[1].default.AmmoClass != none) && WeaponClass.default.FireModeClass[0].default.AmmoClass != WeaponClass.default.FireModeClass[1].default.AmmoClass)
        {
            WeaponClass.default.FireModeClass[1].default.AmmoClass.default.InitialAmount = WeaponDefaults[i].Ammo[1];
            WeaponClass.default.FireModeClass[1].default.AmmoClass.default.MaxAmmo = int(WeaponDefaults[i].MaxAmmo[1]);
        }
        J0x255:
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x2E0
    if(bModifyShieldGun)
    {
        class'ShieldFire'.default.SelfForceScale = 1.0;
        class'ShieldFire'.default.SelfDamageScale = 0.30;
        class'ShieldFire'.default.MinSelfDamage = 8.0;
        class'WeaponFire_Shield'.default.SelfForceScale = 1.0;
        class'WeaponFire_Shield'.default.SelfDamageScale = 0.30;
        class'WeaponFire_Shield'.default.MinSelfDamage = 8.0;
    }
    class'FlakChunk'.default.MyDamageType = class'DamTypeFlakChunk';
    class'FlakShell'.default.MyDamageType = class'DamTypeFlakShell';
    class'BioGlob'.default.MyDamageType = class'DamTypeBioGlob';
    class'RocketProj'.default.MyDamageType = class'DamTypeRocket';
    class'SeekingRocketProj'.default.MyDamageType = class'DamTypeRocketHoming';
    // End:0x66A
    if(EnableNewNet)
    {
        class'GrenadeAmmo'.default.InitialAmount = 4;
        class'ShieldGun'.default.FireModeClass[0] = class'ShieldFire';
        class'ShieldGun'.default.FireModeClass[1] = class'ShieldAltFire';
        class'AssaultRifle'.default.FireModeClass[0] = class'AssaultFire';
        class'AssaultRifle'.default.FireModeClass[1] = class'AssaultGrenade';
        class'BioRifle'.default.FireModeClass[0] = class'BioFire';
        class'BioRifle'.default.FireModeClass[1] = class'BioChargedFire';
        class'ShockRifle'.default.FireModeClass[0] = class'ShockBeamFire';
        class'ShockRifle'.default.FireModeClass[1] = class'ShockProjFire';
        class'LinkGun'.default.FireModeClass[0] = class'LinkAltFire';
        class'LinkGun'.default.FireModeClass[1] = class'LinkFire';
        class'Minigun'.default.FireModeClass[0] = class'MinigunFire';
        class'Minigun'.default.FireModeClass[1] = class'MinigunAltFire';
        class'FlakCannon'.default.FireModeClass[0] = class'FlakFire';
        class'FlakCannon'.default.FireModeClass[1] = class'FlakAltFire';
        class'RocketLauncher'.default.FireModeClass[0] = class'RocketFire';
        class'RocketLauncher'.default.FireModeClass[1] = class'RocketMultiFire';
        class'SniperRifle'.default.FireModeClass[0] = class'SniperFire';
        class'ClassicSniperRifle'.default.FireModeClass[0] = class'ClassicSniperFire';
        class'SuperShockRifle'.default.FireModeClass[0] = class'SuperShockBeamFire';
        class'SuperShockRifle'.default.FireModeClass[1] = class'SuperShockBeamFire';
        class'DamTypeShieldImpact'.default.WeaponClass = class'ShieldGun';
        class'DamTypeAssaultBullet'.default.WeaponClass = class'AssaultRifle';
        class'DamTypeAssaultGrenade'.default.WeaponClass = class'AssaultRifle';
        class'DamType_BioGlob'.default.WeaponClass = class'BioRifle';
        class'DamType_FlakChunk'.default.WeaponClass = class'FlakCannon';
        class'DamType_FlakShell'.default.WeaponClass = class'FlakCannon';
        class'DamTypeLinkPlasma'.default.WeaponClass = class'LinkGun';
        class'DamTypeLinkShaft'.default.WeaponClass = class'LinkGun';
        class'DamTypeMinigunAlt'.default.WeaponClass = class'Minigun';
        class'DamTypeMinigunBullet'.default.WeaponClass = class'Minigun';
        class'DamType_Rocket'.default.WeaponClass = class'RocketLauncher';
        class'DamType_RocketHoming'.default.WeaponClass = class'RocketLauncher';
        class'DamTypeShockBall'.default.WeaponClass = class'ShockRifle';
        class'DamTypeShockBeam'.default.WeaponClass = class'ShockRifle';
        class'DamType_ShockCombo'.default.WeaponClass = class'ShockRifle';
        class'DamTypeSniperHeadShot'.default.WeaponClass = class'SniperRifle';
        class'DamTypeSniperShot'.default.WeaponClass = class'SniperRifle';
    }
    //return;    
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local LinkedReplicationInfo lPRI;
    local int X, i;
    local WeaponLocker L;

    bSuperRelevant = 0;
    // End:0x200
    if(EnableNewNet)
    {
        // End:0x85
        if(xWeaponBase(Other) != none)
        {
            X = 0;
            J0x28:
            // End:0x80 [Loop If]
            if(X < 9)
            {
                // End:0x76
                if(xWeaponBase(Other).WeaponType == WeaponClasses[X])
                {
                    xWeaponBase(Other).WeaponType = NewNetWeaponClasses[X];
                }
                ++ X;
                // [Loop Continue]
                goto J0x28;
            }
            return true;
        }
        // End:0x13C
        else
        {
            // End:0x13C
            if(WeaponLocker(Other) != none)
            {
                L = WeaponLocker(Other);
                X = 0;
                J0xAC:
                // End:0x13A [Loop If]
                if(X < 9)
                {
                    i = 0;
                    J0xBF:
                    // End:0x130 [Loop If]
                    if(i < L.Weapons.Length)
                    {
                        // End:0x126
                        if(L.Weapons[i].WeaponClass == WeaponClasses[X])
                        {
                            L.Weapons[i].WeaponClass = NewNetWeaponClasses[X];
                        }
                        ++ i;
                        // [Loop Continue]
                        goto J0xBF;
                    }
                    ++ X;
                    // [Loop Continue]
                    goto J0xAC;
                }
                return true;
            }
        }
        // End:0x1FD
        if(PlayerReplicationInfo(Other) != none)
        {
            // End:0x1D1
            if(PlayerReplicationInfo(Other).CustomReplicationInfo != none)
            {
                lPRI = PlayerReplicationInfo(Other).CustomReplicationInfo;
                J0x17E:
                // End:0x1A9 [Loop If]
                if(lPRI.NextReplicationInfo != none)
                {
                    lPRI = lPRI.NextReplicationInfo;
                    // [Loop Continue]
                    goto J0x17E;
                }
                lPRI.NextReplicationInfo = UnresolvedNativeFunction_97(class'NewNet_PRI', Other.Owner);
            }
            // End:0x1FB
            else
            {
                PlayerReplicationInfo(Other).CustomReplicationInfo = UnresolvedNativeFunction_97(class'NewNet_PRI', Other.Owner);
            }
            return true;
        }
    }
    // End:0x4A8
    else
    {
        // End:0x4A8
        if(Other.UnresolvedNativeFunction_97('Weapon'))
        {
            // End:0x246
            if(Other.UnresolvedNativeFunction_97('ShieldGun'))
            {
                ShieldGun(Other).FireModeClass[0] = class'WeaponFire_Shield';
            }
            // End:0x4A8
            else
            {
                // End:0x293
                if(Other.UnresolvedNativeFunction_97('AssaultRifle'))
                {
                    AssaultRifle(Other).FireModeClass[0] = class'WeaponFire_Assault';
                    AssaultRifle(Other).FireModeClass[1] = class'WeaponFire_AssaultAlt';
                }
                // End:0x4A8
                else
                {
                    // End:0x2E0
                    if(Other.UnresolvedNativeFunction_97('BioRifle'))
                    {
                        BioRifle(Other).FireModeClass[0] = class'WeaponFire_Bio';
                        BioRifle(Other).FireModeClass[1] = class'WeaponFire_BioAlt';
                    }
                    // End:0x4A8
                    else
                    {
                        // End:0x345
                        if(Other.UnresolvedNativeFunction_97('ShockRifle') && !Other.UnresolvedNativeFunction_97('SuperShockRifle'))
                        {
                            ShockRifle(Other).FireModeClass[0] = class'WeaponFire_Shock';
                            ShockRifle(Other).FireModeClass[1] = class'WeaponFire_ShockAlt';
                        }
                        // End:0x4A8
                        else
                        {
                            // End:0x392
                            if(Other.UnresolvedNativeFunction_97('LinkGun'))
                            {
                                LinkGun(Other).FireModeClass[0] = class'WeaponFire_LinkAlt';
                                LinkGun(Other).FireModeClass[1] = class'WeaponFire_Link';
                            }
                            // End:0x4A8
                            else
                            {
                                // End:0x3DF
                                if(Other.UnresolvedNativeFunction_97('Minigun'))
                                {
                                    Minigun(Other).FireModeClass[0] = class'WeaponFire_Mini';
                                    Minigun(Other).FireModeClass[1] = class'WeaponFire_MiniAlt';
                                }
                                // End:0x4A8
                                else
                                {
                                    // End:0x42C
                                    if(Other.UnresolvedNativeFunction_97('FlakCannon'))
                                    {
                                        FlakCannon(Other).FireModeClass[0] = class'WeaponFire_Flak';
                                        FlakCannon(Other).FireModeClass[1] = class'WeaponFire_FlakAlt';
                                    }
                                    // End:0x4A8
                                    else
                                    {
                                        // End:0x479
                                        if(Other.UnresolvedNativeFunction_97('RocketLauncher'))
                                        {
                                            RocketLauncher(Other).FireModeClass[0] = class'WeaponFire_Rocket';
                                            RocketLauncher(Other).FireModeClass[1] = class'WeaponFire_RocketAlt';
                                        }
                                        // End:0x4A8
                                        else
                                        {
                                            // End:0x4A8
                                            if(Other.UnresolvedNativeFunction_97('SniperRifle'))
                                            {
                                                SniperRifle(Other).FireModeClass[0] = class'WeaponFire_Lightning';
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x506
    if(((Other.UnresolvedNativeFunction_97('Pickup') && !Other.UnresolvedNativeFunction_97('Misc_PickupHealth')) && !Other.UnresolvedNativeFunction_97('Misc_PickupShield')) && !Other.UnresolvedNativeFunction_97('Misc_PickupAdren'))
    {
        return false;
    }
    // End:0x543
    if(Other.UnresolvedNativeFunction_97('xPickUpBase') && !Other.UnresolvedNativeFunction_97('Misc_PickupBase'))
    {
        Other.bHidden = true;
    }
    return true;
    //return;    
}

function bool ReplaceWith(Actor Other, string aClassName)
{
    local Actor A;
    local class<Actor> aClass;

    // End:0x0E
    if(aClassName == "")
    {
        return true;
    }
    aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
    // End:0x7A
    if(aClass != none)
    {
        A = UnresolvedNativeFunction_97(aClass, Other.Owner, Other.Tag, Other.Location, Other.Rotation);
    }
    // End:0x1AB
    if(Other.UnresolvedNativeFunction_97('Pickup'))
    {
        // End:0x166
        if(Pickup(Other).myMarker != none)
        {
            Pickup(Other).myMarker.markedItem = Pickup(A);
            // End:0x14E
            if(Pickup(A) != none)
            {
                Pickup(A).myMarker = Pickup(Other).myMarker;
                A.SetLocation(A.Location + ((A.CollisionHeight - Other.CollisionHeight) * vect(0.0, 0.0, 1.0)));
            }
            Pickup(Other).myMarker = none;
        }
        // End:0x1AB
        else
        {
            // End:0x1AB
            if(A.UnresolvedNativeFunction_97('Pickup') && !A.UnresolvedNativeFunction_97('WeaponPickup'))
            {
                Pickup(A).RespawnTime = 0.0;
            }
        }
    }
    // End:0x1F2
    if(A != none)
    {
        A.Event = Other.Event;
        A.Tag = Other.Tag;
        return true;
    }
    return false;
    //return;    
}

function string GetInventoryClassOverride(string InventoryClassName)
{
    local int X;

    // End:0x4C
    if(EnableNewNet)
    {
        X = 0;
        J0x10:
        // End:0x4C [Loop If]
        if(X < 9)
        {
            // End:0x42
            if(InventoryClassName ~= WeaponInfo[X].WeaponName)
            {
                return NewNetWeaponNames[X];
            }
            ++ X;
            // [Loop Continue]
            goto J0x10;
        }
    }
    // End:0x6C
    if(NextMutator != none)
    {
        return NextMutator.GetInventoryClassOverride(InventoryClassName);
    }
    return InventoryClassName;
    //return;    
}

function GiveWeapons(Pawn P)
{
    local int i;
    local Misc_Pawn xp;

    xp = Misc_Pawn(P);
    // End:0x1D
    if(xp == none)
    {
        return;
    }
    i = 0;
    J0x24:
    // End:0x9C [Loop If]
    if(i < 9)
    {
        // End:0x78
        if((WeaponClasses[i] == none) || (WeaponInfo[i].Ammo[0] <= 0) && WeaponInfo[i].Ammo[1] <= 0)
        {
            // [Explicit Continue]
            goto J0x92;
        }
        xp.GiveWeaponClass(WeaponClasses[i]);
        J0x92:
        ++ i;
        // [Loop Continue]
        goto J0x24;
    }
    //return;    
}

function GiveAmmo(Pawn P)
{
    local Weapon W;
    local int i;

    i = 0;
    J0x07:
    // End:0x114 [Loop If]
    if(i < 9)
    {
        // End:0x61
        if((WeaponInfo[i].WeaponName == "") || (WeaponInfo[i].Ammo[0] <= 0) && WeaponInfo[i].Ammo[1] <= 0)
        {
            // [Explicit Continue]
            goto J0x10A;
        }
        W = Weapon(P.FindInventoryType(WeaponClasses[i]));
        // End:0x94
        if(W == none)
        {
            // [Explicit Continue]
            goto J0x10A;
        }
        // End:0xCF
        if(WeaponInfo[i].Ammo[0] > 0)
        {
            W.AmmoCharge[0] = WeaponInfo[i].Ammo[0];
        }
        // End:0x10A
        if(WeaponInfo[i].Ammo[1] > 0)
        {
            W.AmmoCharge[1] = WeaponInfo[i].Ammo[1];
        }
        J0x10A:
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ServerTraveling(string URL, bool bItems)
{
    // End:0x39
    if(Team_GameBase(Level.Game) != none)
    {
        Team_GameBase(Level.Game).ResetDefaults();
    }
    // End:0x6F
    else
    {
        // End:0x6F
        if(ArenaMaster(Level.Game) != none)
        {
            ArenaMaster(Level.Game).ResetDefaults();
        }
    }
    super(Mutator).ServerTraveling(URL, bItems);
    //return;    
}

defaultproperties
{
    WeaponInfo[0]=(WeaponName="xWeapons.ShockRifle",Ammo=20,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[1]=(WeaponName="xWeapons.LinkGun",Ammo=100,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[2]=(WeaponName="xWeapons.MiniGun",Ammo=75,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[3]=(WeaponName="xWeapons.FlakCannon",Ammo=12,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[4]=(WeaponName="xWeapons.RocketLauncher",Ammo=12,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[5]=(WeaponName="xWeapons.SniperRifle",Ammo=10,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[6]=(WeaponName="xWeapons.BioRifle",Ammo=20,Ammo[1]=0,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[7]=(WeaponName="xWeapons.AssaultRifle",Ammo=999,Ammo[1]=5,MaxAmmo=1.50,MaxAmmo[1]=0.0)
    WeaponInfo[8]=(WeaponName="xWeapons.ShieldGun",Ammo=0,Ammo[1]=100,MaxAmmo=1.0,MaxAmmo[1]=1.0)
    EnableNewNet=true
    WeaponClasses[0]=Class'XWeapons.ShockRifle'
    WeaponClasses[1]=Class'XWeapons.LinkGun'
    WeaponClasses[2]=Class'XWeapons.Minigun'
    WeaponClasses[3]=Class'XWeapons.FlakCannon'
    WeaponClasses[4]=Class'XWeapons.RocketLauncher'
    WeaponClasses[5]=Class'XWeapons.SniperRifle'
    WeaponClasses[6]=Class'XWeapons.BioRifle'
    WeaponClasses[7]=Class'XWeapons.AssaultRifle'
    WeaponClasses[8]=Class'XWeapons.ShieldGun'
    NewNetWeaponClasses[0]=class'NewNet_ShockRifle'
    NewNetWeaponClasses[1]=class'NewNet_LinkGun'
    NewNetWeaponClasses[2]=class'NewNet_MiniGun'
    NewNetWeaponClasses[3]=class'NewNet_FlakCannon'
    NewNetWeaponClasses[4]=class'NewNet_RocketLauncher'
    NewNetWeaponClasses[5]=class'NewNet_SniperRifle'
    NewNetWeaponClasses[6]=class'NewNet_BioRifle'
    NewNetWeaponClasses[7]=class'NewNet_AssaultRifle'
    NewNetWeaponClasses[8]=class'NewNet_ShieldGun'
    NewNetWeaponNames[0]="3SPNv3210CW.NewNet_ShockRifle"
    NewNetWeaponNames[1]="3SPNv3210CW.NewNet_LinkGun"
    NewNetWeaponNames[2]="3SPNv3210CW.NewNet_MiniGun"
    NewNetWeaponNames[3]="3SPNv3210CW.NewNet_FlakCannon"
    NewNetWeaponNames[4]="3SPNv3210CW.NewNet_RocketLauncher"
    NewNetWeaponNames[5]="3SPNv3210CW.NewNet_SniperRifle"
    NewNetWeaponNames[6]="3SPNv3210CW.NewNet_BioRifle"
    NewNetWeaponNames[7]="3SPNv3210CW.NewNet_AssaultRifle"
    NewNetWeaponNames[8]="3SPNv3210CW.NewNet_ShieldGun"
    bAddToServerPackages=true
    FriendlyName="3SPN"
    Description="3SPN"
    bNetTemporary=true
    bAlwaysRelevant=true
    RemoteRole=2
    bAlwaysTick=true
}