/*******************************************************************************
 * NewNet_ClassicSniperRifle generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_ClassicSniperRifle extends ClassicSniperRifle
    dependson(NewNet_ClassicSniperFire)
    config(User)
    hidedropdown
    cacheexempt;

var NewNet_TimeStamp t;
var TAM_Mutator M;

replication
{
    // Pos:0x000
    reliable if(Role < ROLE_Authority)
        NewNet_ServerStartFire
}

function DisableNet()
{
    NewNet_ClassicSniperFire(FireMode[0]).bUseEnhancedNetCode = false;
    NewNet_ClassicSniperFire(FireMode[0]).PingDT = 0.0;
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

simulated function ClientStartFire(int Mode)
{
    // End:0x5F
    if(Mode == 1)
    {
        FireMode[Mode].bIsFiring = true;
        // End:0x5C
        if(Instigator.Controller.IsA('PlayerController'))
        {
            PlayerController(Instigator.Controller).ToggleZoom();
        }
    }
    // End:0x6A
    else
    {
        SuperClientStartFire(Mode);
    }
    //return;    
}

simulated event SuperClientStartFire(int Mode)
{
    // End:0x3D
    if((Level.NetMode != NM_Client) || !class'Misc_Player'.static.UseNewNet())
    {
        ClientStartFire(Mode);
    }
    // End:0x48
    else
    {
        NewNet_ClientStartFire(Mode);
    }
    //return;    
}

simulated event NewNet_ClientStartFire(int Mode)
{
    // End:0x48
    if(Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
    {
        return;
    }
    // End:0xA4
    if(Role < ROLE_Authority)
    {
        // End:0xA1
        if(StartFire(Mode))
        {
            // End:0x86
            if(t == none)
            {
                // End:0x85
                foreach DynamicActors(class'NewNet_TimeStamp', t)
                {
                    // End:0x85
                    break;                    
                }                
            }
            NewNet_ServerStartFire(byte(Mode), t.ClientTimeStamp);
        }
    }
    // End:0xAF
    else
    {
        StartFire(Mode);
    }
    //return;    
}

function NewNet_ServerStartFire(byte Mode, float ClientTimeStamp)
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
    // End:0x92
    if((Team_GameBase(Level.Game) != none) && Misc_Player(Instigator.Controller) != none)
    {
        Misc_Player(Instigator.Controller).NotifyServerStartFire(ClientTimeStamp, M.ClientTimeStamp, M.AverDT);
    }
    // End:0x110
    if(NewNet_ClassicSniperFire(FireMode[Mode]) != none)
    {
        NewNet_ClassicSniperFire(FireMode[Mode]).PingDT = (M.ClientTimeStamp - ClientTimeStamp) + (1.750 * M.AverDT);
        NewNet_ClassicSniperFire(FireMode[Mode]).bUseEnhancedNetCode = true;
    }
    ServerStartFire(Mode);
    //return;    
}

defaultproperties
{
    FireModeClass=class'NewNet_ClassicSniperFire'
}