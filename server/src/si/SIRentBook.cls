 
 /*------------------------------------------------------------------------
    File        : SIRentBook
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 21:35:19 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


@program FILE(name="SIRentBook.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRentBook", URI="/SIRentBook", schemaName="dsRentBook", schemaFile="").

USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIRentBook: 
 
    {src/include/dsRentBook.i}
    
    DEFINE VARIABLE beRentBook AS src.be.BERentBook NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SIRentBook():

        beRentBook = NEW src.be.BERentBook().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadRentBook( INPUT filter AS CHARACTER, OUTPUT DATASET dsRentBook):
        
       DATASET dsRentBook:empty-dataset(). 
       MESSAGE "DEBUG SI: Start ReadRentBook".   
       beRentBook:ReadRentBook(INPUT filter, OUTPUT DATASET dsRentBook BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadRentBook".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records 
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRentBook(INPUT-OUTPUT DATASET dsRentBook):
         
         MESSAGE "DEBUG SI: Start CreateRentBook".  
         
         beRentBook:CreateRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
         
         MESSAGE "DEBUG SI: End CreateRentBook".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        MESSAGE "DEBUG SI: Start UpdateRentBook".  
        
        beRentBook:UpdateRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateRentBook". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        MESSAGE "DEBUG SI: Start DeleteRentBook". 
        
        beRentBook:DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE). 
        
        MESSAGE "DEBUG SI: End DeleteRentBook".
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountRentBook( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beRentBook:CountRentBook(INPUT filter, OUTPUT numRecs). 

    END METHOD.


END CLASS.
