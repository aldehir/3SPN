/*******************************************************************************
 * NewNet_ShockRifle generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_ShockRifle extends ShockRifle
    config(User)
    hidedropdown
    cacheexempt;

struct ReplicatedRotator
{
    var int Yaw;
    var int Pitch;
};

struct ReplicatedVector
{
    var float X;
    var float Y;
    var float Z;
};

var NewNet_TimeStamp t;
var TAM_Mutator M;

replication
{
    // Pos:0x00D
    unreliable if(bDemoRecording)
        SpawnBeamEffect

    // Pos:0x000
    reliable if(Role < ROLE_Authority)
        NewNet_OldServerStartFire, NewNet_ServerStartFire
}

function DisableNet()
{
    NewNet_ShockBeamFire(FireMode[0]).bUseEnhancedNetCode = false;
    NewNet_ShockBeamFire(FireMode[0]).PingDT = 0.0;
    //return;    
}

simulated function float RateSelf()
{
    // End:0x11
    if(Instigator == none)
    {
        return -2.0;
    }
    return super(Weapon).RateSelf();
    //return;    
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    // End:0x0D
    if(Instigator == none)
    {
        return;
    }
    super(Weapon).BringUp(PrevWeapon);
    //return;    
}

simulated function bool PutDown()
{
    // End:0x0D
    if(Instigator == none)
    {
        return false;
    }
    return super(Weapon).PutDown();
    //return;    
}

simulated event ClientStartFire(int Mode)
{
    // End:0x55
    if(((Level.NetMode != NM_Client) || !class'Misc_Player'.static.UseNewNet()) || NewNet_ShockBeamFire(FireMode[Mode]) == none)
    {
        super(Weapon).ClientStartFire(Mode);
    }
    // End:0x60
    else
    {
        NewNet_ClientStartFire(Mode);
    }
    //return;    
}

simulated event NewNet_ClientStartFire(int Mode)
{
    local ReplicatedRotator R;
    local ReplicatedVector V;
    local Vector Start;
    local float stamp;

    // End:0x48
    if(Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
    {
        return;
    }
    // End:0x201
    if(Role < ROLE_Authority)
    {
        // End:0x1FE
        if((AltReadyToFire(Mode)) && StartFire(Mode))
        {
            // End:0xCE
            if(!ReadyToFire(Mode))
            {
                // End:0xA6
                if(t == none)
                {
                    // End:0xA5
                    foreach DynamicActors(class'NewNet_TimeStamp', t)
                    {
                        // End:0xA5
                        break;                        
                    }                    
                }
                stamp = t.ClientTimeStamp;
                NewNet_OldServerStartFire(byte(Mode), stamp);
                return;
            }
            R.Pitch = Pawn(Owner).Controller.Rotation.Pitch;
            R.Yaw = Pawn(Owner).Controller.Rotation.Yaw;
            Start = Pawn(Owner).Location + Pawn(Owner).EyePosition();
            V.X = Start.X;
            V.Y = Start.Y;
            V.Z = Start.Z;
            // End:0x1B4
            if(t == none)
            {
                // End:0x1B3
                foreach DynamicActors(class'NewNet_TimeStamp', t)
                {
                    // End:0x1B3
                    break;                    
                }                
            }
            stamp = t.ClientTimeStamp;
            NewNet_ShockBeamFire(FireMode[Mode]).DoInstantFireEffect();
            NewNet_ServerStartFire(byte(Mode), stamp, R, V);
        }
    }
    // End:0x20C
    else
    {
        StartFire(Mode);
    }
    //return;    
}

simulated function bool AltReadyToFire(int Mode)
{
    local int alt;
    local float F;

    F = 0.0150;
    // End:0x1D
    if(!ReadyToFire(Mode))
    {
        return false;
    }
    // End:0x32
    if(Mode == 0)
    {
        alt = 1;
    }
    // End:0x39
    else
    {
        alt = 0;
    }
    // End:0xEC
    if(((((FireMode[alt] != FireMode[Mode]) && FireMode[alt].bModeExclusive) && FireMode[alt].bIsFiring) || !FireMode[Mode].AllowFire()) || FireMode[Mode].NextFireTime > ((Level.TimeSeconds + FireMode[Mode].PreFireTime) - F))
    {
        return false;
    }
    return true;
    //return;    
}

function NewNet_ServerStartFire(byte Mode, float ClientTimeStamp, ReplicatedRotator R, ReplicatedVector V)
{
    // End:0x64
    if((Instigator != none) && Instigator.Weapon != self)
    {
        // End:0x49
        if(Instigator.Weapon == none)
        {
            Instigator.ServerChangedWeapon(none, self);
        }
        // End:0x62
        else
        {
            Instigator.Weapon.SynchronizeWeapon(self);
        }
        return;
    }
    // End:0x84
    if(M == none)
    {
        // End:0x83
        foreach DynamicActors(class'TAM_Mutator', M)
        {
            // End:0x83
            break;            
        }        
    }
    // End:0xF6
    if((Team_GameBase(Level.Game) != none) && Misc_Player(Instigator.Controller) != none)
    {
        Misc_Player(Instigator.Controller).NotifyServerStartFire(ClientTimeStamp, M.ClientTimeStamp, M.AverDT);
    }
    NewNet_ShockBeamFire(FireMode[Mode]).PingDT = (M.ClientTimeStamp - ClientTimeStamp) + (1.750 * M.AverDT);
    NewNet_ShockBeamFire(FireMode[Mode]).bUseEnhancedNetCode = true;
    // End:0x305
    if((FireMode[Mode].NextFireTime <= (Level.TimeSeconds + FireMode[Mode].PreFireTime)) && StartFire(Mode))
    {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = false;
        NewNet_ShockBeamFire(FireMode[Mode]).savedVec.X = V.X;
        NewNet_ShockBeamFire(FireMode[Mode]).savedVec.Y = V.Y;
        NewNet_ShockBeamFire(FireMode[Mode]).savedVec.Z = V.Z;
        NewNet_ShockBeamFire(FireMode[Mode]).SavedRot.Yaw = R.Yaw;
        NewNet_ShockBeamFire(FireMode[Mode]).SavedRot.Pitch = R.Pitch;
        NewNet_ShockBeamFire(FireMode[Mode]).bUseReplicatedInfo = IsReasonable(NewNet_ShockBeamFire(FireMode[Mode]).savedVec);
    }
    // End:0x355
    else
    {
        // End:0x33B
        if(FireMode[Mode].AllowFire())
        {
            FireMode[Mode].bServerDelayStartFire = true;
        }
        // End:0x355
        else
        {
            ClientForceAmmoUpdate(Mode, AmmoAmount(Mode));
        }
    }
    //return;    
}

function NewNet_OldServerStartFire(byte Mode, float ClientTimeStamp)
{
    // End:0x20
    if(M == none)
    {
        // End:0x1F
        foreach DynamicActors(class'TAM_Mutator', M)
        {
            // End:0x1F
            break;            
        }        
    }
    NewNet_ShockBeamFire(FireMode[Mode]).PingDT = (M.ClientTimeStamp - ClientTimeStamp) + (1.750 * M.AverDT);
    NewNet_ShockBeamFire(FireMode[Mode]).bUseEnhancedNetCode = true;
    ServerStartFire(Mode);
    //return;    
}

function bool IsReasonable(Vector V)
{
    local Vector LocDiff;
    local float clErr;

    // End:0x1F
    if((Owner == none) || Pawn(Owner) == none)
    {
        return true;
    }
    LocDiff = V - (Pawn(Owner).Location + Pawn(Owner).EyePosition());
    clErr = LocDiff Dot LocDiff;
    return clErr < 750.0;
    //return;    
}

simulated function SpawnBeamEffect(Vector HitLocation, Vector HitNormal, Vector Start, Rotator Dir, int ReflectNum)
{
    local ShockBeamEffect Beam;

    // End:0x25
    if(bClientDemoNetFunc)
    {
        Start.Z = Start.Z - 64.0;
    }
    Beam = Spawn(class'NewNet_Client_ShockBeamEffect',,, Start, Dir);
    // End:0x5A
    if(ReflectNum != 0)
    {
        Beam.Instigator = none;
    }
    Beam.AimAt(HitLocation, HitNormal);
    //return;    
}

defaultproperties
{
    FireModeClass[0]=class'NewNet_ShockBeamFire'
    FireModeClass[1]=class'NewNet_ShockProjFire'
}