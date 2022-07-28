 
 /*------------------------------------------------------------------------
    File        : SIRent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 21:29:49 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

@program FILE(name="SIRent.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRent", URI="/SIRent", schemaName="dsRent", schemaFile="").

USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIRent: 
 
    {src/include/dsRent.i}
    
    DEFINE VARIABLE beRent AS src.be.BERent NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SIRent():

        beRent = NEW src.be.BERent().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadRent( INPUT filter AS CHARACTER, OUTPUT DATASET dsRent):
        
       DATASET dsRent:empty-dataset(). 
       MESSAGE "DEBUG SI: Start ReadRent".   
       beRent:ReadRent(INPUT filter, OUTPUT DATASET dsRent BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadRent".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records 
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRent(INPUT-OUTPUT DATASET dsRent):
         
         MESSAGE "DEBUG SI: Start CreateRent".  
         
         beRent:CreateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
         
         MESSAGE "DEBUG SI: End CreateRent".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):
        
        MESSAGE "DEBUG SI: Start UpdateRent".  
        
        beRent:UpdateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateRent". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRent(INPUT-OUTPUT DATASET dsRent):
        
        MESSAGE "DEBUG SI: Start DeleteRent". 
        
        beRent:DeleteRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE). 
        
        MESSAGE "DEBUG SI: End DeleteRent".
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountRent( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beRent:CountRent(INPUT filter, OUTPUT numRecs). 

    END METHOD.


END CLASS.
