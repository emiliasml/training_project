 
/*------------------------------------------------------------------------
   File        : DAUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:11:17 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.


CLASS src.da.DAUserRole INHERITS src.da.DAGeneric: 
    {src/include/dsUserRole.i} 
    
    DEFINE PRIVATE VARIABLE daAppUser AS src.da.DAAppUser NO-UNDO.
    DEFINE PRIVATE VARIABLE daLibraryy AS src.da.DALibraryy NO-UNDO.
    
    CONSTRUCTOR PUBLIC DAUserRole():
        TableName = "UserRole".
        TempTableName = "ttUserRole".
        daAppUser = NEW src.da.DAAppUser().
        daLibraryy = NEW src.da.DALibraryy().
    END CONSTRUCTOR. 

    DESTRUCTOR PUBLIC DAUserRole():
        DELETE OBJECT daAppUser NO-ERROR. 
        DELETE OBJECT daLibraryy NO-ERROR. 
    END DESTRUCTOR.
   
    /*------------------------------------------------------------------------------
    Purpose: Creates the roles from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        DEFINE BUFFER bufUserRole FOR UserRole.
         
        FOR EACH ttUserRole NO-LOCK
            WHERE ROW-STATE(ttUserRole) = ROW-CREATED:
            IF NOT daAppUser:CanFindAppUser(ttUserRole.AppUserId) THEN DO:
                cErrors = cErrors + "The user does not exist!".
            END.
            IF ttUserRole.LibraryId NE "all" AND NOT daLibraryy:CanFindLibraryy(ttUserRole.LibraryId) THEN DO:
                cErrors = cErrors + "The library does not exist!".
            END.
            ELSE DO:
                CREATE bufUserRole.
                BUFFER-COPY ttUserRole EXCEPT UserRoleId TO bufUserRole. 
                ASSIGN 
                    bufUserRole.UserRoleId = STRING(NEXT-VALUE(NextUserRoleId)).    
            END.      
        END.       
        IF cErrors NE "" THEN
            UNDO, THROW NEW Progress.Lang.AppError(cErrors). 
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates the roles from the given dataset in the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        FOR EACH ttUserRole NO-LOCK
            WHERE ROW-STATE(ttUserRole) = ROW-MODIFIED:
            IF NOT daAppUser:CanFindAppUser(ttUserRole.AppUserId) THEN DO:
                cErrors = cErrors + "The user does not exist!".
            END.
            IF ttUserRole.LibraryId NE "all" AND NOT daLibraryy:CanFindLibraryy(ttUserRole.LibraryId) THEN DO:
                cErrors = cErrors + "The library does not exist!".
            END.
            ELSE DO:
                FIND FIRST bufUserRole EXCLUSIVE-LOCK
                    WHERE bufUserRole.UserRoleId = ttUserRole.UserRoleId NO-ERROR.
            
                IF AVAILABLE bufUserRole THEN 
                    BUFFER-COPY ttUserRole EXCEPT UserRoleId TO bufUserRole.            
                ELSE
                    cErrors = cErrors + "Cannot find the user role!".
            END.
        END.
        IF cErrors NE "" THEN
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes the roles from the given dataset from the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        FOR EACH bttUserRole NO-LOCK
            WHERE ROW-STATE(bttUserRole) = ROW-DELETED:
            
            FIND FIRST bufUserRole EXCLUSIVE-LOCK
                WHERE bufUserRole.UserRoleId = bttUserRole.UserRoleId NO-ERROR.
                    
            IF AVAILABLE bttUserRole THEN
                DELETE bufUserRole.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the user role!").
        END.
    END METHOD.   
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role for the given user and role type exists
    @param    ipcAppUserId as char, ipcRoleTypeId as char
    @return   true if the role exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindUserRoleByRoleType(INPUT ipcAppUserId AS CHARACTER, INPUT ipcRoleTypeId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        RETURN CAN-FIND(FIRST bufUserRole NO-LOCK
            WHERE bufUserRole.AppUserId = ipcAppUserId AND bufUserRole.RoleTypeId = ipcRoleTypeId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role for the given user exists
    @param    ipcAppUserId as char
    @return   true if the role exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindUserRoleByAppUser(INPUT ipcAppUserId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        RETURN CAN-FIND(FIRST bufUserRole NO-LOCK
            WHERE bufUserRole.AppUserId = ipcAppUserId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role for the given user and library exists
    @param    ipcAppUserId as char, ipcLibraryId as char
    @return   true if the role exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindUserRoleByAppUserAndLibraryId(INPUT ipcAppUserId AS CHARACTER, INPUT ipcLibraryId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        RETURN CAN-FIND(FIRST bufUserRole NO-LOCK
            WHERE bufUserRole.AppUserId = ipcAppUserId AND bufUserRole.LibraryId = ipcLibraryId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role, different from the given one for the given 
    user exists
    @param    ipcAppUserId as char, ipcUserRoleId as char
    @return   true if the role exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindUserRoleNotSameUserRoleId(INPUT ipcAppUserId AS CHARACTER, INPUT ipcUserRoleId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        RETURN CAN-FIND(FIRST bufUserRole NO-LOCK
            WHERE bufUserRole.AppUserId = ipcAppUserId AND bufUserRole.UserRoleId NE ipcUserRoleId).
    END METHOD.
END CLASS.
