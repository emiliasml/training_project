 
/*------------------------------------------------------------------------
   File        : SICSVReports
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Fri Aug 13 16:30:28 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/
@program FILE(name="SICSVReports.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICSVReports", URI="/SICSVReports", schemaName="dsTopTen", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SICSVReports: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    {src/include/dsTopTen.i}
    
    DEFINE VARIABLE beCSVReports AS src.be.BECSVReports.
    
    CONSTRUCTOR PUBLIC SICSVReports (  ):
        beCSVReports = NEW src.be.BECSVReports().
    END CONSTRUCTOR.
 
    DESTRUCTOR PUBLIC SICSVReports ( ):
        DELETE OBJECT beCSVReports NO-ERROR.
    END DESTRUCTOR.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/TopTen", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID TopTen(INPUT ipcTopTen AS CHARACTER, INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
        beCSVReports:TopTen(INPUT ipcTopTen, INPUT iplSendCSV, OUTPUT DATASET dsTopTen BY-REFERENCE).
    END METHOD.
    
END CLASS.