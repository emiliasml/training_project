 
/*------------------------------------------------------------------------
   File        : DARent
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 21:11:16 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

 
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.


CLASS src.da.DARent INHERITS src.da.DAGeneric: 
    {src/include/dsRent.i} 
    {src/include/dsLibraryAgency.i}
    DEFINE VARIABLE daAppUser AS src.da.DAAppUser NO-UNDO.
    DEFINE VARIABLE daUserRole AS src.da.DAUserRole NO-UNDO.
    DEFINE VARIABLE daLibraryAgency AS src.da.DALibraryAgency NO-UNDO.
    
    CONSTRUCTOR PUBLIC DARent():
        TableName = "Rent".
        TempTableName = "ttRent".
        daAppUser = NEW src.da.DAAppUser().
        daUserRole = NEW src.da.DAUserRole().
        daLibraryAgency =  NEW src.da.DALibraryAgency().
    END CONSTRUCTOR. 

    DESTRUCTOR PUBLIC DARent():
        DELETE OBJECT daAppUser NO-ERROR.
        DELETE OBJECT daLibraryAgency NO-ERROR.
    END DESTRUCTOR.
   
    
    METHOD PUBLIC VOID CreateRent(INPUT-OUTPUT DATASET dsRent):
        DEFINE VARIABLE dToday AS DATE NO-UNDO.
        DEFINE BUFFER bufRent FOR Rent.
        
        dToday = TODAY.
        FOR EACH ttRent NO-LOCK
            WHERE ROW-STATE(ttRent) = ROW-CREATED:
            IF NOT daAppUser:CanFindAppUser(ttRent.AppUserId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("AppUser does not exist!").
            END.
            IF NOT daLibraryAgency:CanFindLibraryAgency(ttRent.LibraryAgencyId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("LibraryAgency does not exist!").
            END.
            
            ELSE DO:
                daLibraryAgency:ReadGeneric(SUBSTITUTE("WHERE LibraryAgencyId = &1",QUOTER(ttRent.LibraryAgencyId)) , 0, 0, OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
                FOR FIRST ttLibraryAgency:
                    IF NOT (daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttRent.AppUserId, ttLibraryAgency.LibraryId) 
                        OR daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttRent.AppUserId, "all"))THEN
                        UNDO, THROW NEW Progress.Lang.AppError("This user does not a have a role for the chosen library!").
                END.
                
                CREATE bufRent.
                BUFFER-COPY ttRent EXCEPT RentId RentStatus TO bufRent . 
                ASSIGN 
                    bufRent.RentId = STRING(NEXT-VALUE(NextRentId)) .
            
                IF dToday < ttRent.DateFrom THEN
                    ASSIGN
                        bufRent.RentStatus =  0. //opened
                ELSE IF dToday > ttRent.DateTo THEN 
                    ASSIGN
                        bufRent.RentStatus = 1. //finished
                ELSE IF dToday >= ttRent.DateFrom AND dToday <= ttRent.DateTo THEN
                    ASSIGN
                        bufRent.RentStatus = 2. //on going
                      
            END.
        END.        
    END METHOD.
    
    
    METHOD PUBLIC VOID getDataByRentId(INPUT ipcRentId AS CHARACTER, OUTPUT opcLibraryAgencyId AS CHARACTER, OUTPUT opdDateFrom AS DATE ,  OUTPUT opdDateTo AS DATE ):
        DEFINE BUFFER bufRent FOR Rent.
        
        FIND FIRST bufRent NO-LOCK WHERE bufRent.RentId = ipcRentId NO-ERROR.
        IF AVAILABLE (bufRent) THEN
        DO:
            opcLibraryAgencyId = bufRent.LibraryAgencyId.
            opdDateFrom = bufRent.DateFrom.
            opdDateTo = bufRent.DateTo.
        END.
        ELSE  UNDO, THROW NEW Progress.Lang.AppError("Rent does not exist!").
        
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):
        DEFINE VARIABLE dToday AS DATE NO-UNDO.
        DEFINE BUFFER bufRent FOR Rent.
        
        
        dToday = TODAY.
        FOR EACH ttRent NO-LOCK
            WHERE ROW-STATE(ttRent) = ROW-MODIFIED:
            IF NOT daAppUser:CanFindAppUser(ttRent.AppUserId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("AppUser does not exist!").
            END.
            IF NOT daLibraryAgency:CanFindLibraryAgency(ttRent.LibraryAgencyId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("LibraryAgency does not exist!").
            END.
            ELSE DO:
                daLibraryAgency:ReadGeneric(SUBSTITUTE("WHERE LibraryAgencyId = &1",QUOTER(ttRent.LibraryAgencyId)) , 0, 0, OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
                FOR FIRST ttLibraryAgency:
                    IF NOT (daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttRent.AppUserId, ttLibraryAgency.LibraryId) 
                        OR daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttRent.AppUserId, "all"))THEN
                        UNDO, THROW NEW Progress.Lang.AppError("This user does not a have a role for the chosen library!").
                END.
                    
                FIND FIRST bufRent EXCLUSIVE-LOCK
                    WHERE bufRent.RentId = ttRent.RentId NO-ERROR.
           
                IF AVAILABLE bufRent THEN
            
                DO:
                    BUFFER-COPY ttRent EXCEPT RentId RentStatus TO bufRent.
                
                    IF dToday < ttRent.DateFrom THEN 
                        ASSIGN
                            bufRent.RentStatus =  0.  //opened
                    ELSE IF dToday > ttRent.DateTo THEN
                        ASSIGN
                            bufRent.RentStatus = 1. //finished    
                    ELSE IF dToday >= ttRent.DateFrom AND dToday <= ttRent.DateTo THEN 
                        ASSIGN
                            bufRent.RentStatus = 2. //on going    
                END.              
            
                ELSE
                    UNDO, THROW NEW Progress.Lang.AppError("Cannot find the rent").
            END.
        END.
    END METHOD.
    
    METHOD PUBLIC VOID DeleteRent(INPUT-OUTPUT DATASET dsRent):
        
         DEFINE BUFFER bufRent FOR Rent.
        
        FOR EACH bttRent NO-LOCK
            WHERE ROW-STATE(bttRent) = ROW-DELETED:
            
            FIND FIRST bufRent EXCLUSIVE-LOCK
                WHERE bufRent.RentId = bttRent.RentId NO-ERROR.
                    
            IF AVAILABLE bttRent THEN
                DELETE bufRent.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the rent").
        END.
    END METHOD.   


    METHOD PUBLIC LOGICAL CanFindRent(INPUT ipcRentId AS CHARACTER):
        DEFINE BUFFER bufRent FOR Rent.
        
        RETURN CAN-FIND(FIRST bufRent NO-LOCK
            WHERE bufRent.RentId = ipcRentId).
    END METHOD.
    
    
    
    METHOD PUBLIC INTEGER getNumberOfRents(INPUT ipcAppUserId AS CHARACTER ):


        DEFINE BUFFER bufRent FOR Rent.
        DEFINE VARIABLE iNrOfRents AS INTEGER NO-UNDO. 
    
        FOR EACH bufRent NO-LOCK WHERE bufRent.AppUserId = ipcAppUserId:
            iNrOfRents = iNrOfRents + 1.
        END.
        
        RETURN iNrOfRents.
        
    END METHOD .

END CLASS.
