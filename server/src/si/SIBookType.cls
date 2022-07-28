@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIBookType", URI="/SIBookType", schemaName="dsBookType", schemaFile="").
  
/*------------------------------------------------------------------------
   File        : SIBookTypeType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 10:38:58 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIBookType: 
    /*------------------------------------------------------------------------------
         Purpose:
         Notes:
        ------------------------------------------------------------------------------*/
    {src/include/dsBookType.i}
    DEFINE VARIABLE beBookType AS src.be.BEBookType NO-UNDO.
    CONSTRUCTOR PUBLIC SIBookType (  ):
        beBookType = NEW src.be.BEBookType().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SIBookType ( ):
        DELETE OBJECT beBookType NO-ERROR.
    END DESTRUCTOR.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadBookTypes( INPUT filter AS CHARACTER, OUTPUT DATASET dsBookType):
        
        DATASET dsBookType:EMPTY-DATASET ().   
        beBookType:ReadBookTypes(INPUT filter, OUTPUT DATASET dsBookType BY-REFERENCE). 

    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateBookType( INPUT-OUTPUT DATASET dsBookType):

        beBookType:CreateBookType(INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).

    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateBookType( INPUT-OUTPUT DATASET dsBookType):
        
        beBookType:UpdateBookType(INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).
        
    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteBookType( INPUT-OUTPUT DATASET dsBookType):
        
        beBookType:DeleteBookType(INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).
    
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountBookType( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beBookType:CountBookTypes(INPUT filter, OUTPUT numRecs).

    END METHOD.

  
END CLASS.