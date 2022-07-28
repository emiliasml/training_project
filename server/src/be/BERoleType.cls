 
/*------------------------------------------------------------------------
   File        : BERoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:03:22 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BERoleType INHERITS src.be.BEBase: 
    {src/include/dsRoleType.i} 
    
    DEFINE PRIVATE VARIABLE daRoleType AS src.da.DARoleType NO-UNDO.
    
    CONSTRUCTOR PUBLIC BERoleType():
        daRoleType = NEW src.da.DARoleType().
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC BeRoleType():
        DELETE OBJECT daRoleType NO-ERROR.
    END DESTRUCTOR.    
    
    /*------------------------------------------------------------------------------
    Purpose: Fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadRoleType(INPUT filter AS CHARACTER, OUTPUT DATASET dsRoleType): 
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRoleType:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsRoleType BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the role types from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        
        IF ValidateCreateUpdate(INPUT DATASET dsRoleType BY-REFERENCE, OUTPUT cErrors) THEN
            daRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        ELSE
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the role types from the given dataset if the
    records pass the validations 
    @param   the dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        
        IF ValidateCreateUpdate(INPUT DATASET dsRoleType BY-REFERENCE, OUTPUT cErrors) THEN
            daRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        ELSE
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the role types from the given dataset if they pass the validation
    @param   a dataset  
    ------------------------------------------------------------------------------*/   
    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
        
        IF ValidateDelete(INPUT DATASET dsRoleType BY-REFERENCE, OUTPUT cErrors) THEN
            daRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        ELSE
            UNDO, THROW NEW Progress.Lang.AppError(cErrors).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Counts how many records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC VOID CountRoleType(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRoleType:CountGeneric(INPUT cWhere, OUTPUT numRecs).
    END.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role type with the given id exists
    @param    ipcRoleTypeId as char
    @return   true if the role type exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindRoleType(INPUT ipcRoleTypeId AS CHARACTER):
        daRoleType:CanFindRoleType(INPUT ipcRoleTypeId).
    END METHOD.
          
    /*------------------------------------------------------------------------------
    Purpose:  Validates role types for create or update
    @param    a dataset and a string with all the errors
    @return   true if we allow the role types to be created or updated, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateCreateUpdate(INPUT DATASET dsRoleType, OUTPUT opcErrors AS CHARACTER):
        opcErrors = "".
        FOR EACH ttRoleType NO-LOCK
            WHERE ROW-STATE(ttRoleType) = ROW-MODIFIED OR ROW-STATE(ttRoleType) = ROW-CREATED:
            IF NOT src.utils.ValidateClass:validateString(ttRoleType.Description) THEN
                opcErrors = opcErrors + "The description cannot be empty!".
                
            IF ttRoleType.Description NE "User" AND ttRoleType.Description NE "Admin" AND ttRoleType.Description NE "Superadmin" THEN
                opcErrors = opcErrors + "The roles can only be: User, Admin and Superadmin!".
        END.  
        
        RETURN opcErrors = "".
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Validates role types for delete
    @param    a dataset and a string with all the errors
    @return   true if we allow the role types to be deleted, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateDelete(INPUT DATASET dsRoleType, OUTPUT opcErrors AS CHARACTER):
        opcErrors = "".
        FOR EACH ttRoleType NO-LOCK
            WHERE ROW-STATE(ttRoleType) = ROW-DELETED:
            opcErrors = opcErrors + "The role types cannot be deleted!".
        END. 
        
        RETURN opcErrors = "".
    END METHOD.
END CLASS.