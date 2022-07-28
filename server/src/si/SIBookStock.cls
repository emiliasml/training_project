@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIBookStock", URI="/SIBookStock", schemaName="dsBookStock", schemaFile="").
  
/*------------------------------------------------------------------------
   File        : SIBookStock
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 11:57:10 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIBookStock: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBookStock.i}
    DEFINE VARIABLE beBookStock AS src.be.BEBookStock NO-UNDO.
    CONSTRUCTOR PUBLIC SIBookStock (  ):
        beBookStock = NEW src.be.BEBookStock().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SIBookStock ( ):
        DELETE OBJECT beBookStock NO-ERROR.
    END DESTRUCTOR.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadBookStocks( INPUT filter AS CHARACTER, OUTPUT DATASET dsBookStock):
        
        DATASET dsBookStock:EMPTY-DATASET ().   
        beBookStock:ReadBookStocks(INPUT filter, OUTPUT DATASET dsBookStock BY-REFERENCE). 

    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateBookStock( INPUT-OUTPUT DATASET dsBookStock):

        beBookStock:CreateBookStock(INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).

    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateBookStock( INPUT-OUTPUT DATASET dsBookStock):
        
        beBookStock:UpdateBookStock(INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
        
    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteBookStock( INPUT-OUTPUT DATASET dsBookStock):
        
        beBookStock:DeleteBookStock(INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
    
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountBookStock( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beBookStock:CountBookStocks(INPUT filter, OUTPUT numRecs).

    END METHOD.

    
END CLASS.