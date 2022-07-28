 
/*------------------------------------------------------------------------
   File        : DARoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 18:57:15 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/
  
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.


CLASS src.da.DARoleType INHERITS src.da.DAGeneric: 
    {src/include/dsRoleType.i} 
    
    CONSTRUCTOR PUBLIC DARoleType():
        TableName = "RoleType".
        TempTableName = "ttRoleType".
    END CONSTRUCTOR. 

    DESTRUCTOR PUBLIC DARoleType():
    END DESTRUCTOR.
   
    
    /*------------------------------------------------------------------------------
    Purpose: Creates the role types from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        FOR EACH ttRoleType NO-LOCK
            WHERE ROW-STATE(ttRoleType) = ROW-CREATED:
            
            CREATE bufRoleType.
            BUFFER-COPY ttRoleType EXCEPT RoleTypeId TO bufRoleType . 
            ASSIGN 
                bufRoleType.RoleTypeId = STRING(NEXT-VALUE(NextRoleTypeId)).           
        END.        
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates the role types from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
         
        FOR EACH ttRoleType NO-LOCK
            WHERE ROW-STATE(ttRoleType) = ROW-MODIFIED:
           
            FIND FIRST bufRoleType EXCLUSIVE-LOCK
                WHERE bufRoleType.RoleTypeId = ttRoleType.RoleTypeId NO-ERROR.
            
            IF AVAILABLE bufRoleType THEN 
                BUFFER-COPY ttRoleType EXCEPT RoleTypeId TO bufRoleType.            
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the role type").
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deleted the role types from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
         
        FOR EACH bttRoleType NO-LOCK
            WHERE ROW-STATE(bttRoleType) = ROW-DELETED:
            
            FIND FIRST bufRoleType EXCLUSIVE-LOCK
                WHERE bufRoleType.RoleTypeId = bttRoleType.RoleTypeId NO-ERROR.
                    
            IF AVAILABLE bttRoleType THEN
                DELETE bufRoleType.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the role type").
        END.
    END METHOD.   
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a role type with the given id exists
    @param    ipcRoleTypeId as char
    @return   true if the user exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindRoleType(INPUT ipcRoleTypeId AS CHARACTER):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        RETURN CAN-FIND(FIRST bufRoleType NO-LOCK
            WHERE bufRoleType.RoleTypeId = ipcRoleTypeId).
    END METHOD.
END CLASS.
