
/*------------------------------------------------------------------------
   File        : SIRoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:06:31 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

@program FILE(name="SIRoleType.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRoleType", URI="/SIRoleType", schemaName="dsRoleType", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIRoleType: 
 
    {src/include/dsRoleType.i}
    
    DEFINE VARIABLE beRoleType AS src.be.BERoleType NO-UNDO.

    CONSTRUCTOR PUBLIC SIRoleType():

        beRoleType = NEW src.be.BERoleType().

    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC SIRoleType ( ):
        
        DELETE OBJECT beRoleType NO-ERROR.
        
    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadRoleType( INPUT filter AS CHARACTER, OUTPUT DATASET dsRoleType):
        
        MESSAGE "DEBUG SI: Start ReadRoleType".  
        
        beRoleType:ReadRoleType(INPUT filter, OUTPUT DATASET dsRoleType BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadRoleType".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more records 
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
         
        MESSAGE "DEBUG SI: Start CreateRoleType".  
         
        beRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateRoleType".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        
        MESSAGE "DEBUG SI: Start UpdateRoleType".  
        
        beRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateRoleType". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        
        MESSAGE "DEBUG SI: Start DeleteRoleType". 
        
        beRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE). 
        
        MESSAGE "DEBUG SI: End DeleteRoleType".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Count records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountRoleType( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beRoleType:CountRoleType(INPUT filter, OUTPUT numRecs).
        
    END METHOD.


END CLASS.