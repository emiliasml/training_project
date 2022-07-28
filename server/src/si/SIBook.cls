@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIBook", URI="/SIBook", schemaName="dsBook", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SIBook
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 20:52:06 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIBook: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBook.i}
    DEFINE VARIABLE beBook AS src.be.BEBook NO-UNDO.
    CONSTRUCTOR PUBLIC SIBook (  ):
        beBook = NEW src.be.BEBook().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SIBook ( ):
        DELETE OBJECT beBook NO-ERROR.
    END DESTRUCTOR.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadBooks( INPUT filter AS CHARACTER, OUTPUT DATASET dsBook):
        
        DATASET dsBook:EMPTY-DATASET ().   
        beBook:ReadBooks(INPUT filter, OUTPUT DATASET dsBook BY-REFERENCE). 

    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateBook( INPUT-OUTPUT DATASET dsBook):

        beBook:CreateBook(INPUT-OUTPUT DATASET dsBook BY-REFERENCE).

    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateBook( INPUT-OUTPUT DATASET dsBook):
        
        beBook:UpdateBook(INPUT-OUTPUT DATASET dsBook BY-REFERENCE).
        
    END METHOD.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteBook( INPUT-OUTPUT DATASET dsBook):
        
        beBook:DeleteBook(INPUT-OUTPUT DATASET dsBook BY-REFERENCE).
    
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountBook( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beBook:CountBooks(INPUT filter, OUTPUT numRecs).

    END METHOD.

    
END CLASS.