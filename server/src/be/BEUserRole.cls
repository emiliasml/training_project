 
/*------------------------------------------------------------------------
   File        : BEUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:10:39 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
 
BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEUserRole INHERITS src.be.BEBase: 
    {src/include/dsUserRole.i} 
    {src/include/dsRoleType.i}
    
    DEFINE PRIVATE VARIABLE daUserRole AS src.da.DAUserRole NO-UNDO.
    DEFINE PRIVATE VARIABLE beRoleType AS src.be.BERoleType NO-UNDO.
    
    CONSTRUCTOR PUBLIC BEUserRole():
        daUserRole = NEW src.da.DAUserRole().
        beRoleType = NEW src.be.BERoleType().
    END.
    
    DESTRUCTOR PUBLIC BeUserRole():
        DELETE OBJECT daUserRole NO-ERROR.
        DELETE OBJECT beRoleType NO-ERROR.
    END DESTRUCTOR.    
    
    /*------------------------------------------------------------------------------
    Purpose: Fills the dataset with records based on a given filter
    @param   a filter for read and a dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadUserRole(INPUT filter AS CHARACTER, OUTPUT DATASET dsUserRole): 
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daUserRole:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsUserRole BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the users from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cDelete AS CHARACTER NO-UNDO EXTENT 20.
        DEFINE VARIABLE iLength AS INTEGER NO-UNDO.
        
        DO TRANSACTION:
            IF ValidateCreate(DATASET dsUserRole BY-REFERENCE, cErrors, cDelete, iLength) THEN DO:
                daUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
            
                DeleteUserRolesExceptSuperadmin(iLength, cDelete).
            END.
            ELSE 
                UNDO, THROW NEW Progress.Lang.AppError(cErrors).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the users from the given dataset if the
    records pass the validations 
    @param   the dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cDelete AS CHARACTER NO-UNDO EXTENT 20.
        DEFINE VARIABLE iLength AS INTEGER NO-UNDO.
        
        DO TRANSACTION:
            IF ValidateUpdate(DATASET dsUserRole BY-REFERENCE, cErrors, cDelete, iLength) THEN DO:
                daUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
            
                DeleteUserRolesExceptSuperadmin(iLength, cDelete).
            END.
            ELSE 
                UNDO, THROW NEW Progress.Lang.AppError(cErrors).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the user roles from the given dataset
    @param   a dataset  
    ------------------------------------------------------------------------------*/   
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        daUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Counts how many records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC VOID CountUserRole(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daUserRole:CountGeneric(INPUT cWhere, OUTPUT numRecs).
    END METHOD.
     
    /*------------------------------------------------------------------------------
    Purpose:  Validates users for update
    @param    a dataset and a string with all the errors
    @return   true if we allow the users to be updated, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateUpdate(INPUT DATASET dsUserRole, OUTPUT opcErrors AS CHARACTER, OUTPUT opcDelete AS CHARACTER EXTENT 20, OUTPUT opiLength AS INTEGER):
        DEFINE VARIABLE cSuperadminId AS CHARACTER NO-UNDO.
        
        beRoleType:ReadRoleType(INPUT SUBSTITUTE("WHERE Description = 'Superadmin'"), OUTPUT DATASET dsRoleType BY-REFERENCE).
        FOR FIRST ttRoleType :
            cSuperadminId = ttRoleType.RoleTypeId.
        END.
        
        FOR EACH ttUserRole NO-LOCK
            WHERE ROW-STATE(ttUserRole) = ROW-MODIFIED:
            IF NOT beRoleType:CanFindRoleType(ttUserRole.RoleTypeId) THEN
                opcErrors = opcErrors + "The role does not exist!".
            ELSE DO:
                IF daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttUserRole.AppUserId, ttUserRole.LibraryId) THEN DO:
                    FOR FIRST bttUserRole 
                        WHERE bttUserRole.UserRoleId = ttUserRole.UserRoleId:
                        IF bttUserRole.LibraryId NE ttUserRole.LibraryId THEN
                            opcErrors = opcErrors + "The user already has a role for the chosen library!".
                        IF bttUserRole.RoleTypeId EQ cSuperadminId AND ttUserRole.RoleTypeId NE cSuperadminId AND ttUserRole.LibraryId = "all" THEN
                            opcErrors = opcErrors + "The library does not exist!".
                    END.
                END.
                IF ttUserRole.RoleTypeId = cSuperadminId THEN DO:
                    IF daUserRole:CanFindUserRoleNotSameUserRoleId(ttUserRole.AppUserId, ttUserRole.UserRoleId) THEN DO:
                        opiLength = opiLength + 1.
                        opcDelete[opiLength] = ttUserRole.AppUserId.   
                    END.
                                 
                    IF ttUserRole.LibraryId NE "all" THEN
                        ttUserRole.LibraryId = "all".
                END. 
            END.
        END.
        
        RETURN opcErrors = "".
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Validates users for create
    @param    a dataset and a string with all the errors
    @return   true if we allow the users to be created, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateCreate(INPUT DATASET dsUserRole, OUTPUT opcErrors AS CHARACTER, OUTPUT opcDelete AS CHARACTER EXTENT 20, OUTPUT opiLength AS INTEGER):
        DEFINE VARIABLE cSuperadminId AS CHARACTER NO-UNDO.
        
        beRoleType:ReadRoleType(INPUT SUBSTITUTE("WHERE Description = 'Superadmin'"), OUTPUT DATASET dsRoleType BY-REFERENCE).
        FOR FIRST ttRoleType :
            cSuperadminId = ttRoleType.RoleTypeId.
        END.
        
        FOR EACH ttUserRole NO-LOCK
            WHERE ROW-STATE(ttUserRole) = ROW-CREATED:
            IF NOT beRoleType:CanFindRoleType(ttUserRole.RoleTypeId) THEN
                opcErrors = opcErrors + "The role does not exist!".
            ELSE DO:
                IF daUserRole:CanFindUserRoleByAppUserAndLibraryId(ttUserRole.AppUserId, ttUserRole.LibraryId) THEN 
                    opcErrors = opcErrors + "The user already has a role for the chosen library!".
                    
                IF ttUserRole.RoleTypeId = cSuperadminId THEN DO:
                    IF daUserRole:CanFindUserRoleByRoleType(ttUserRole.AppUserId, cSuperadminId) THEN
                        opcErrors = opcErrors + "The user is already Superadmin!".
                    ELSE IF daUserRole:CanFindUserRoleByAppUser(ttUserRole.AppUserId) THEN DO:
                        opiLength = opiLength + 1.
                        opcDelete[opiLength] = ttUserRole.AppUserId.   
                    END.
                                
                    IF ttUserRole.LibraryId NE "all" THEN
                        ttUserRole.LibraryId = "all".
                END.       
                ELSE DO:
                    IF daUserRole:CanFindUserRoleByRoleType(ttUserRole.AppUserId, cSuperadminId) THEN 
                        opcErrors = opcErrors + "The user is Superadmin!".

                END.
            END.
        END.
        RETURN opcErrors = "".
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the user roles for the given users except the one for Superadmin
    @param   the length and the list of user ids  
    ------------------------------------------------------------------------------*/   
    METHOD PRIVATE VOID DeleteUserRolesExceptSuperadmin(INPUT ipcLength AS INTEGER, INPUT ipcDelete AS CHARACTER EXTENT 20):
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE cSuperadminId AS CHARACTER NO-UNDO.
        
        beRoleType:ReadRoleType(INPUT SUBSTITUTE("WHERE Description = 'Superadmin'"), OUTPUT DATASET dsRoleType BY-REFERENCE).
        FOR FIRST ttRoleType :
            cSuperadminId = ttRoleType.RoleTypeId.
        END.
        
        DO iIndex = 1 TO ipcLength :
            ReadUserRole(INPUT SUBSTITUTE("WHERE AppUserId = &1", QUOTER(ipcDelete[iIndex])), OUTPUT DATASET dsUserRole BY-REFERENCE).
            
            TEMP-TABLE ttUserRole:TRACKING-CHANGES = TRUE.
            
            FOR EACH ttUserRole WHERE ttUserRole.RoleTypeId NE cSuperadminId:
                DELETE ttUserRole.
            END.
            
            TEMP-TABLE ttUserRole:TRACKING-CHANGES = FALSE.
            
            DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        END.
    END METHOD.
END CLASS.