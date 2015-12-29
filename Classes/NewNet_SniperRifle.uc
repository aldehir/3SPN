/*******************************************************************************
 * NewNet_SniperRifle generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_SniperRifle extends SniperRifle
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
        SpawnLGEffect

    // Pos:0x000
    reliable if(Role < ROLE_Authority)
        NewNet_ServerStartFire
}

function DisableNet()
{
    NewNet_SniperFire(FireMode[0]).bUseEnhancedNetCode = false;
    NewNet_SniperFire(FireMode[0]).PingDT = 0.0;
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
    super.BringUp(PrevWeapon);
    //return;    
}

simulated function bool PutDown()
{
    // End:0x0D
    if(Instigator == none)
    {
        return false;
    }
    return super.PutDown();
    //return;    
}

simulated function SpawnLGEffect(class<Actor> tmpHitEmitClass, Vector arcEnd, Vector HitNormal, Vector HitLocation)
{
    local xEmitter hitEmitter;

    hitEmitter = xEmitter(Spawn(tmpHitEmitClass,,, arcEnd, rotator(HitNormal)));
    // End:0x40
    if(hitEmitter != none)
    {
        hitEmitter.mSpawnVecA = HitLocation;
    }
    // End:0x8F
    if(Level.NetMode != NM_Client)
    {
        Warn("Server should never spawn the client lightningbolt");
    }
    //return;    
}

simulated function ClientStartFire(int Mode)
{
    // End:0x26
    if(Level.NetMode != NM_Client)
    {
        super.ClientStartFire(Mode);
        return;
    }
    // End:0x85
    if(Mode == 1)
    {
        FireMode[Mode].bIsFiring = true;
        // End:0x82
        if(Instigator.Controller.IsA('PlayerController'))
        {
            PlayerController(Instigator.Controller).ToggleZoom();
        }
    }
    // End:0xB0
    else
    {
        // End:0xA5
        if(class'Misc_Player'.static.UseNewNet())
        {
            NewNet_ClientStartFire(Mode);
        }
        // End:0xB0
        else
        {
            super(Weapon).ClientStartFire(Mode);
        }
    }
    //return;    
}

simulated function NewNet_ClientStartFire(int Mode)
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
    // End:0x1A9
    if(Role < ROLE_Authority)
    {
        // End:0x1A6
        if((AltReadyToFire(Mode)) && StartFire(Mode))
        {
            R.Pitch = Pawn(Owner).Controller.Rotation.Pitch;
            R.Yaw = Pawn(Owner).Controller.Rotation.Yaw;
            Start = Pawn(Owner).Location + Pawn(Owner).EyePosition();
            V.X = Start.X;
            V.Y = Start.Y;
            V.Z = Start.Z;
            // End:0x15C
            if(t == none)
            {
                // End:0x15B
                foreach DynamicActors(class'NewNet_TimeStamp', t)
                {
                    // End:0x15B
                    break;                    
                }                
            }
            stamp = t.ClientTimeStamp;
            NewNet_SniperFire(FireMode[Mode]).DoInstantFireEffect();
            NewNet_ServerStartFire(byte(Mode), stamp, R, V);
        }
    }
    // End:0x1B4
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
    NewNet_SniperFire(FireMode[Mode]).PingDT = (M.ClientTimeStamp - ClientTimeStamp) + (1.750 * M.AverDT);
    NewNet_SniperFire(FireMode[Mode]).bUseEnhancedNetCode = true;
    // End:0x305
    if((FireMode[Mode].NextFireTime <= (Level.TimeSeconds + FireMode[Mode].PreFireTime)) && StartFire(Mode))
    {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = false;
        NewNet_SniperFire(FireMode[Mode]).savedVec.X = V.X;
        NewNet_SniperFire(FireMode[Mode]).savedVec.Y = V.Y;
        NewNet_SniperFire(FireMode[Mode]).savedVec.Z = V.Z;
        NewNet_SniperFire(FireMode[Mode]).SavedRot.Yaw = R.Yaw;
        NewNet_SniperFire(FireMode[Mode]).SavedRot.Pitch = R.Pitch;
        NewNet_SniperFire(FireMode[Mode]).bUseReplicatedInfo = IsReasonable(NewNet_SniperFire(FireMode[Mode]).savedVec);
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

defaultproperties
{
    FireModeClass=class'NewNet_SniperFire'
}