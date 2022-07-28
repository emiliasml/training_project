 
/*------------------------------------------------------------------------
   File        : SIUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:14:48 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

@program FILE(name="SIUserRole.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIUserRole", URI="/SIUserRole", schemaName="dsUserRole", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIUserRole: 
 
    {src/include/dsUserRole.i}
    
    DEFINE VARIABLE beUserRole AS src.be.BEUserRole NO-UNDO.

    CONSTRUCTOR PUBLIC SIUserRole():

        beUserRole = NEW src.be.BEUserRole().

    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC SIUserRole ( ):
        
        DELETE OBJECT beUserRole NO-ERROR.
        
    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadUserRole( INPUT filter AS CHARACTER, OUTPUT DATASET dsUserRole):
        
        MESSAGE "DEBUG SI: Start ReadUserRole". 
         
        beUserRole:ReadUserRole(INPUT filter, OUTPUT DATASET dsUserRole BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadUserRole".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more records 
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
         
        MESSAGE "DEBUG SI: Start CreateUserRole".  
         
        beUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateUserRole".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
        MESSAGE "DEBUG SI: Start UpdateUserRole".  
        
        beUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateUserRole". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        
        MESSAGE "DEBUG SI: Start DeleteUserRole". 
        
        beUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE). 
        
        MESSAGE "DEBUG SI: End DeleteUserRole".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Count records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountUserRole( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beUserRole:CountUserRole(INPUT filter, OUTPUT numRecs). 

    END METHOD.


END CLASS.