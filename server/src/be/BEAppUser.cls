 
/*------------------------------------------------------------------------
   File        : BEAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:10:25 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEAppUser INHERITS src.be.BEBase: 
    {src/include/dsAppUser.i} 
    {src/include/dsUserRole.i} 
    {src/include/dsRent.i}
    
    DEFINE PRIVATE VARIABLE daAppUser AS src.da.DAAppUser NO-UNDO.
     
    CONSTRUCTOR PUBLIC BEAppUser():
        daAppUser = NEW src.da.DAAppUser().
    END.
    
    DESTRUCTOR PUBLIC BeAppUser():
        DELETE OBJECT daAppUser NO-ERROR. 
    END DESTRUCTOR.    
    
    /*------------------------------------------------------------------------------
    Purpose: Fills the dataset with records based on a given filter
    @param   a filter for read and a dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadAppUser(INPUT filter AS CHARACTER, OUTPUT DATASET dsAppUser): 
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daAppUser:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsAppUser BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Fills the dataset with the users that have roles on the given library
    @param   ipcLibraryId as char and a dataset
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadUsersFromLibrary(INPUT ipcLibraryId AS CHARACTER, OUTPUT DATASET dsAppUser): 
        IF ipcLibraryId = "null" THEN 
            daAppUser:ReadGeneric("", 0, 0, OUTPUT DATASET dsAppUser BY-REFERENCE).
        ELSE
            daAppUser:ReadUsersFromLibrary(INPUT ipcLibraryId, OUTPUT DATASET dsAppUser BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the users from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        
        IF ValidateCreateUpdate(INPUT DATASET dsAppUser BY-REFERENCE, OUTPUT cErrors) THEN
            daAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        ELSE
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the users from the given dataset if the
    records pass the validations 
    @param   the dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        
        IF ValidateCreateUpdate(INPUT DATASET dsAppUser BY-REFERENCE, OUTPUT cErrors) THEN
            daAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        ELSE
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the users from the given dataset and all of its roles
    and rents
    @param   a dataset  
    ------------------------------------------------------------------------------*/   
    METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DO TRANSACTION:
            CascadeDelete(INPUT DATASET dsAppUser BY-REFERENCE).
       
            daAppUser:DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Counts how many records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC VOID CountAppUser(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daAppUser:CountGeneric(INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a user with the given username and password exists
    @param    ipcUserName as char, ipcPassword as char and a dataset with the 
    user if it exists
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID Login(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):    
        daAppUser:Login(INPUT ipcUserName, INPUT ipcPassword, OUTPUT DATASET dsAppUser BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a user with the given id exists
    @param    ipcAppUserId as char
    @return   true if the user exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindAppUser(INPUT ipcAppUserId AS CHARACTER):
        RETURN daAppUser:CanFindAppUser(INPUT ipcAppUserId).
    END METHOD.
          
    /*------------------------------------------------------------------------------
    Purpose:  Validates users for create or update
    @param    a dataset and a string with all the errors
    @return   true if we allow the users to be created or updated, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateCreateUpdate(INPUT DATASET dsAppUser, OUTPUT opcErrors AS CHARACTER):
        opcErrors = "".
        
        FOR EACH ttAppUser
            WHERE ROW-STATE(ttAppUser) = ROW-MODIFIED OR ROW-STATE(ttAppUser) = ROW-CREATED:
            IF NOT src.utils.ValidateClass:validateString(ttAppUser.Name) THEN
                opcErrors = opcErrors + "The name of the user cannot be empty!".
            IF INDEX(TRIM(ttAppUser.UserName), ' ') > 0 THEN 
                opcErrors = opcErrors + "The username cannot contain spaces!".
            ELSE
                ttAppUser.UserName = TRIM(ttAppUser.UserName).
            IF NOT src.utils.ValidateClass:validateString(ttAppUser.UserName) THEN
                opcErrors = opcErrors + "The username cannot be empty!".
                
            IF NOT src.utils.ValidateClass:validateString(ttAppUser.Password) THEN
                opcErrors = opcErrors + "The password cannot be empty!".
                
            IF daAppUser:CanFindAppUserByUserName(ttAppUser.UserName, ttAppUser.AppUserId) THEN
                opcErrors = opcErrors + "The username already exists!".
        END.
        
        RETURN opcErrors = "".
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the roles and rents for the given users in the given dataset
    @param   a dataset  
    ------------------------------------------------------------------------------*/   
    METHOD PRIVATE VOID CascadeDelete(INPUT DATASET dsAppUser):
        DEFINE VARIABLE beUserRole AS src.be.BEUserRole NO-UNDO.
        DEFINE  VARIABLE beRent AS src.be.BERent NO-UNDO.
        
        beUserRole = NEW src.be.BEUserRole().
        beRent = NEW src.be.BERent().
        
        FOR EACH bttAppUser
            WHERE ROW-STATE(bttAppUser) = ROW-DELETED:
            beUserRole:ReadUserRole(INPUT SUBSTITUTE("WHERE AppUserId = &1", QUOTER(bttAppUser.AppUserId)), OUTPUT DATASET dsUserRole BY-REFERENCE).
            
            TEMP-TABLE ttUserRole:TRACKING-CHANGES = TRUE.
            
            FOR EACH ttUserRole :
                DELETE ttUserRole.
            END.
            
            TEMP-TABLE ttUserRole:TRACKING-CHANGES = FALSE.
            
            beUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).

            beRent:ReadRent(INPUT SUBSTITUTE("WHERE AppUserId = &1", QUOTER(bttAppUser.AppUserId)), OUTPUT DATASET dsRent BY-REFERENCE).
            
            TEMP-TABLE ttRent:TRACKING-CHANGES = TRUE.
            
            FOR EACH ttRent :
                DELETE ttRent.
            END.
            
            TEMP-TABLE ttRent:TRACKING-CHANGES = FALSE.
            
            beRent:DeleteRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
        END.
        
        FINALLY:
            DELETE OBJECT beUserRole NO-ERROR.   
            DELETE OBJECT beRent NO-ERROR.  
        END FINALLY.
    END METHOD.
END CLASS.