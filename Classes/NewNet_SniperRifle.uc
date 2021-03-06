/*
UTComp - UT2004 Mutator
Copyright (C) 2004-2005 Aaron Everitt & Jo�l Moffatt

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class NewNet_SniperRifle extends SniperRifle
    HideDropDown
	CacheExempt;

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

var NewNet_TimeStamp_Pawn t;
var TAM_Mutator M;
var float lastDT;

replication
{
    reliable if(Role < Role_Authority)
        NewNet_ServerStartFire;
    unreliable if(bDemoRecording)
        SpawnLGEffect;
}

function DisableNet()
{
    NewNet_SniperFire(FireMode[0]).bUseEnhancedNetCode = false;
    NewNet_SniperFire(FireMode[0]).PingDT = 0.00;
}

simulated function float RateSelf()
{
	if(Instigator==None)
		return -2;
	return Super.RateSelf();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	if(Instigator==None)
		return;
	Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
	if(Instigator==None)
		return false;
	return Super.PutDown();
}

simulated function SpawnLGEffect(class<Actor> tmpHitEmitClass, vector ArcEnd, vector HitNormal, vector HitLocation)
{
    local xEmitter HitEmitter;
    hitEmitter = xEmitter(Spawn(tmpHitEmitClass,,, arcEnd, Rotator(HitNormal)));
    if ( hitEmitter != None )
	  	hitEmitter.mSpawnVecA = HitLocation;
    if(Level.NetMode!=NM_Client)
        Warn("Server should never spawn the client lightningbolt");
}

simulated function ClientStartFire(int mode)
{
    if(Level.NetMode!=NM_Client)
    {
        Super.ClientStartFire(mode);
        return;
    }

    if (mode == 1)
    {
        FireMode[mode].bIsFiring = true;
        if( Instigator.Controller.IsA( 'PlayerController' ) )
            PlayerController(Instigator.Controller).ToggleZoom();
    }
    else
    {
		if(class'Misc_Player'.static.UseNewNet())
			NewNet_ClientStartFire(mode);
		else
			super(Weapon).ClientStartFire(mode);
    }
}

simulated function NewNet_ClientStartFire(int mode)
{
    local ReplicatedRotator R;
    local ReplicatedVector V;
    local Vector Start;
    //local float stamp;
  	local byte stamp;
  	local bool b;
  	local actor A;
  	local vector HN,HL;


    if(Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
        return;
    if (Role < ROLE_Authority)
    {
        if (AltReadyToFire(mode) && StartFire(Mode) )
        {
            R.Pitch = Pawn(Owner).Controller.Rotation.Pitch;
            R.Yaw = Pawn(Owner).Controller.Rotation.Yaw;
            STart=Pawn(Owner).Location + Pawn(Owner).EyePosition();

            V.X = Start.X;
            V.Y = Start.Y;
            V.Z = Start.Z;

            if(T==None)
                foreach DynamicActors(Class'NewNet_TimeStamp_Pawn', T)
                     break;
            stamp = t.TimeStamp;
            NewNet_SniperFire(FireMode[Mode]).DoInstantFireEffect();
            A = Trace(HN,HL,Start+Vector(Pawn(Owner).Controller.Rotation)*40000.0,Start,true);

            if(A !=None && (A.IsA('xPawn')  || A.IsA('Vehicle')) )
            {
                b=true;
            }

            NewNet_ServerStartFire(Mode, stamp, t.dt, R, V, b, A);
        }
    }
    else
    {
        StartFire(Mode);
    }
}

simulated function bool AltReadyToFire(int Mode)
{
    local int alt;
    local float f;

    //There is a very slight descynchronization error on the server
    // with weapons due to differing deltatimes which accrues to a pretty big
    // error if people just hold down the button...
    // This will never cause the weapon to actually fire slower
    f = 0.015;

    if(!ReadyToFire(Mode))
        return false;

    if ( Mode == 0 )
        alt = 1;
    else
        alt = 0;

    if ( ((FireMode[alt] != FireMode[Mode]) && FireMode[alt].bModeExclusive && FireMode[alt].bIsFiring)
		|| !FireMode[Mode].AllowFire()
		|| (FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].PreFireTime - f) )
    {
        return false;
    }

	return true;
}

function NewNet_ServerStartFire(byte Mode, byte ClientTimeStamp, float DT,  ReplicatedRotator R, ReplicatedVector V, bool bBelievesHit, optional actor A)
{
	if ( (Instigator != None) && (Instigator.Weapon != self) )
	{
		if ( Instigator.Weapon == None )
			Instigator.ServerChangedWeapon(None,self);
		else
			Instigator.Weapon.SynchronizeWeapon(self);
		return;
	}
	if(M==None)
        foreach DynamicActors(class'TAM_Mutator', M)
            break;
    if((Team_GameBase(Level.Game) != none) && Misc_Player(Instigator.Controller) != none)
    {
        Misc_Player(Instigator.Controller).NotifyServerStartFire(ClientTimeStamp, M.ClientTimeStamp, M.AverDT);
    }
    NewNet_SniperFire(FireMode[Mode]).PingDT = M.ClientTimeStamp - M.GetStamp(ClientTimeStamp)-DT + 0.5*M.AverDT;
    NewNet_SniperFire(FireMode[Mode]).AverDT = M.AverDT;
    if(bBelievesHit)
    {
        NewNet_SniperFire(FireMode[Mode]).bBelievesHit=true;
        NewNet_SniperFire(FireMode[Mode]).BelievedHitActor=A;
    }
    else
    {
        NewNet_SniperFire(FireMode[Mode]).bBelievesHit=false;
    }
    NewNet_SniperFire(FireMode[Mode]).bUseEnhancedNetCode = true;
    NewNet_SniperFire(FireMode[Mode]).bFirstGo = true;
   if((FireMode[Mode].NextFireTime <= (Level.TimeSeconds + FireMode[Mode].PreFireTime)) && StartFire(Mode))
    {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = false;
        NewNet_SniperFire(FireMode[Mode]).SavedVec.X = V.X;
        NewNet_SniperFire(FireMode[Mode]).SavedVec.Y = V.Y;
        NewNet_SniperFire(FireMode[Mode]).SavedVec.Z = V.Z;
        NewNet_SniperFire(FireMode[Mode]).SavedRot.Yaw = R.Yaw;
        NewNet_SniperFire(FireMode[Mode]).SavedRot.Pitch = R.Pitch;
        NewNet_SniperFire(FireMode[Mode]).bUseReplicatedInfo=IsReasonable(NewNet_SniperFire(FireMode[Mode]).SavedVec);
    }
    else if ( FireMode[Mode].AllowFire() )
    {
        FireMode[Mode].bServerDelayStartFire = true;
	}
	else
		ClientForceAmmoUpdate(Mode, AmmoAmount(Mode));
}

function bool IsReasonable(Vector V)
{
    local vector LocDiff;
    local float clErr;

    if(Owner == none || Pawn(Owner) == none)
        return true;

    LocDiff = V - (Pawn(Owner).Location + Pawn(Owner).EyePosition());
    clErr = (LocDiff dot LocDiff);
//    if(clErr > 500.0*M.AverDT)
//    PlayerController(Pawn(Owner).Controller).ClientMessage("Exceeded error"@clErr);
//    Log(ClErr@(Pawn(Owner).Velocity dot Pawn(Owner).Velocity));
    return clErr < 1250.0;
}

simulated function Weapontick(float deltatime)
{
   lastDT = deltatime;
}

//// client & server ////
simulated function bool StartFire(int Mode)
{
    local int alt;

    if (!ReadyToFire(Mode))
        return false;

    if (Mode == 0)
        alt = 1;
    else
        alt = 0;

    FireMode[Mode].bIsFiring = true;

    FireMode[Mode].NextFireTime = Level.TimeSeconds-LastDT*0.5 + FireMode[Mode].PreFireTime;

    if (FireMode[alt].bModeExclusive)
    {
        // prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[alt].NextFireTime);
    }

    if (Instigator.IsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }
        FireMode[Mode].FireCount = 0;
    }

    return true;
}

defaultproperties
{
     FireModeClass(0)=Class'3SPNv3300CW.NewNet_SniperFire'
}
