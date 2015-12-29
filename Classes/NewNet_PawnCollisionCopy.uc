/*******************************************************************************
 * NewNet_PawnCollisionCopy generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_PawnCollisionCopy extends Actor
    dependson(PawnHistoryElement)
    dependson(TAM_Mutator)
    notplaceable;

const MAX_HISTORY_LENGTH = 0.350;

var NewNet_PawnCollisionCopy Next;
var float CrouchHeight;
var float CrouchRadius;
var TAM_Mutator M;
var Pawn CopiedPawn;
var bool bNormalDestroy;
var PawnHistoryElement PawnHistoryFirst;
var PawnHistoryElement PawnHistoryLast;
var PawnHistoryElement PawnHistoryFree;
var bool bCrouched;

function SetPawn(Pawn Other)
{
    // End:0x46
    if(Level.NetMode == NM_Client)
    {
        Warn("Client should never have a collision copy");
    }
    // End:0x7C
    if(Other == none)
    {
        Warn("PawnCopy spawned without proper Other");
        return;
    }
    CopiedPawn = Other;
    // End:0xA7
    if(M == none)
    {
        // End:0xA6
        foreach DynamicActors(class'TAM_Mutator', M)
        {
            // End:0xA6
            break;            
        }        
    }
    CrouchHeight = CopiedPawn.CrouchHeight;
    CrouchRadius = CopiedPawn.CrouchRadius;
    bUseCylinderCollision = CopiedPawn.bUseCylinderCollision;
    bCrouched = CopiedPawn.bIsCrouched;
    // End:0x11D
    if(!bUseCylinderCollision)
    {
        LinkMesh(CopiedPawn.Mesh);
    }
    // End:0x13C
    else
    {
        SetCollisionSize(CopiedPawn.CollisionRadius, CopiedPawn.CollisionHeight);
    }
    //return;    
}

function GoToPawn()
{
    // End:0x0D
    if(CopiedPawn == none)
    {
        return;
    }
    SetLocation(CopiedPawn.Location);
    SetCollisionSize(CopiedPawn.CollisionRadius, CopiedPawn.CollisionHeight);
    // End:0xB1
    if(bUseCylinderCollision)
    {
        // End:0x7D
        if(!bCrouched && CopiedPawn.bIsCrouched)
        {
            SetCollisionSize(CrouchRadius, CrouchHeight);
            bCrouched = true;
        }
        // End:0xB1
        else
        {
            // End:0xB1
            if(bCrouched && !CopiedPawn.bIsCrouched)
            {
                SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
                bCrouched = false;
            }
        }
    }
    SetCollision(true);
    //return;    
}

function TimeTravelPawn(float dt)
{
    local PawnHistoryElement Current, Floor, Ceiling;
    local Vector V;
    local float StampDT, Alpha, Interpdt;

    // End:0x23
    if((CopiedPawn == none) || CopiedPawn.DrivenVehicle != none)
    {
        return;
    }
    StampDT = M.ClientTimeStamp - dt;
    SetCollision(false);
    // End:0x6F
    if((PawnHistoryLast == none) || PawnHistoryLast.TimeStamp < StampDT)
    {
        GoToPawn();
        return;
    }
    Current = PawnHistoryLast;
    J0x7A:
    // End:0xD0 [Loop If]
    if(Current != none)
    {
        // End:0xAB
        if(Current.TimeStamp >= StampDT)
        {
            Floor = Current;
        }
        // End:0xB9
        else
        {
            Ceiling = Current;
            // [Explicit Break]
            goto J0xD0;
        }
        Current = Current.Prev;
        J0xD0:
        // [Loop Continue]
        goto J0x7A;
    }
    // End:0x34F
    if(Ceiling != none)
    {
        Alpha = (Floor.TimeStamp - StampDT) / (Floor.TimeStamp - Ceiling.TimeStamp);
        V.X = Lerp(Alpha, Floor.Location.X, Ceiling.Location.X);
        V.Y = Lerp(Alpha, Floor.Location.Y, Ceiling.Location.Y);
        V.Z = Lerp(Alpha, Floor.Location.Z, Ceiling.Location.Z);
        // End:0x295
        if((Floor.Physics == 2) && Ceiling.Physics == 2)
        {
            // End:0x236
            if(Alpha > 0.50)
            {
                Interpdt = (1.0 - Alpha) * (Floor.TimeStamp - Ceiling.TimeStamp);
            }
            // End:0x261
            else
            {
                Interpdt = Alpha * (Floor.TimeStamp - Ceiling.TimeStamp);
            }
            V = V - ((0.50 * CopiedPawn.PhysicsVolume.Gravity) * Square(Interpdt));
        }
        // End:0x333
        if(bUseCylinderCollision)
        {
            // End:0x2E9
            if((!bCrouched && Floor.bCrouched) && Ceiling.bCrouched)
            {
                SetCollisionSize(CrouchRadius, CrouchHeight);
                bCrouched = true;
            }
            // End:0x333
            else
            {
                // End:0x333
                if(bCrouched && !Floor.bCrouched || !Ceiling.bCrouched)
                {
                    SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
                    bCrouched = false;
                }
            }
        }
        SetLocation(V);
        SetRotation(Floor.Rotation);
    }
    // End:0x3DF
    else
    {
        // End:0x371
        if(Floor.bCrouched)
        {
            SetCollisionSize(CrouchRadius, CrouchHeight);
        }
        // End:0x3BD
        else
        {
            // End:0x395
            if(CopiedPawn.IsA('xPawn'))
            {
                SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
            }
            // End:0x3BD
            else
            {
                // End:0x3BD
                if(bUseCylinderCollision)
                {
                    SetCollisionSize(CopiedPawn.CollisionRadius, CopiedPawn.CollisionHeight);
                }
            }
        }
        SetLocation(Floor.Location);
        SetRotation(Floor.Rotation);
    }
    SetCollision(true);
    //return;    
}

function TurnOffCollision()
{
    SetCollision(false);
    //return;    
}

function AddPawnToList(Pawn Other)
{
    // End:0x30
    if(Next == none)
    {
        Next = Spawn(class'NewNet_PawnCollisionCopy');
        Next.SetPawn(Other);
    }
    // End:0x44
    else
    {
        Next.AddPawnToList(Other);
    }
    //return;    
}

function NewNet_PawnCollisionCopy RemoveOldPawns()
{
    // End:0x36
    if(CopiedPawn == none)
    {
        bNormalDestroy = true;
        Destroy();
        // End:0x31
        if(Next != none)
        {
            return Next.RemoveOldPawns();
        }
        return none;
    }
    // End:0x56
    else
    {
        // End:0x56
        if(Next != none)
        {
            Next = Next.RemoveOldPawns();
        }
    }
    return self;
    //return;    
}

event TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType)
{
    Warn("Pawn collision copy should never take damage");
    //return;    
}

event Destroyed()
{
    // End:0x30
    if(!bNormalDestroy)
    {
        Warn("DESTROYED WITHOUT SETTING UP LIST");
    }
    super.Destroyed();
    //return;    
}

function Identify()
{
    // End:0x1E
    if(CopiedPawn == none)
    {
        Log("PCC: No pawn");
    }
    // End:0x70
    else
    {
        // End:0x5B
        if(CopiedPawn.PlayerReplicationInfo != none)
        {
            Log("PCC: Pawn" @ CopiedPawn.PlayerReplicationInfo.PlayerName);
        }
        // End:0x70
        else
        {
            Log("PCC: Unnamed Pawn");
        }
    }
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0x46
    if(Level.NetMode == NM_Client)
    {
        Warn("Client should never have a collision copy");
    }
    // End:0x53
    if(CopiedPawn == none)
    {
        return;
    }
    // End:0xB6
    if((bCollideActors || bCollideWorld) || bBlockActors)
    {
        Warn("COLLISION COPY SHOULD NEVER HAVE COLLISION EXCEPT DURING A TRACE");
    }
    RemoveOutdatedHistory();
    AddHistory();
    //return;    
}

function AddHistory()
{
    local PawnHistoryElement Current;

    // End:0x2D
    if(PawnHistoryFree != none)
    {
        Current = PawnHistoryFree;
        PawnHistoryFree = PawnHistoryFree.Next;
    }
    // End:0x3C
    else
    {
        Current = new class'PawnHistoryElement';
    }
    Current.Location = CopiedPawn.Location;
    Current.Rotation = CopiedPawn.Rotation;
    Current.bCrouched = CopiedPawn.bIsCrouched;
    Current.TimeStamp = M.ClientTimeStamp;
    Current.Physics = CopiedPawn.Physics;
    // End:0x113
    if(PawnHistoryLast == none)
    {
        PawnHistoryFirst = Current;
        PawnHistoryLast = Current;
        Current.Prev = none;
        Current.Next = none;
    }
    // End:0x156
    else
    {
        PawnHistoryLast.Next = Current;
        Current.Prev = PawnHistoryLast;
        Current.Next = none;
        PawnHistoryLast = Current;
    }
    //return;    
}

function RemoveOutdatedHistory()
{
    local PawnHistoryElement Current, End, N;

    End = PawnHistoryFirst;
    J0x0B:
    // End:0x58 [Loop If]
    if(End != none)
    {
        // End:0x41
        if((End.TimeStamp + 0.350) >= M.ClientTimeStamp)
        {
            // [Explicit Break]
            goto J0x58;
        }
        End = End.Next;
        J0x58:
        // [Loop Continue]
        goto J0x0B;
    }
    Current = PawnHistoryFirst;
    J0x63:
    // End:0xB3 [Loop If]
    if(Current != End)
    {
        N = Current.Next;
        Current.Next = PawnHistoryFree;
        PawnHistoryFree = Current;
        Current = N;
        // [Loop Continue]
        goto J0x63;
    }
    PawnHistoryFirst = End;
    // End:0xD3
    if(PawnHistoryFirst == none)
    {
        PawnHistoryLast = none;
    }
    // End:0xE3
    else
    {
        PawnHistoryFirst.Prev = none;
    }
    //return;    
}

defaultproperties
{
    CrouchHeight=29.0
    CrouchRadius=25.0
    bHidden=true
    bAcceptsProjectors=false
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    RemoteRole=0
    CollisionRadius=25.0
    CollisionHeight=44.0
}