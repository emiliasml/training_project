 @program FILE(name="SILibraryAgency.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SILibraryAgency", URI="/SILibraryAgency", schemaName="dsLibraryAgency", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SILibraryAgency
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Tue Aug 03 10:04:31 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SILibraryAgency: 
    {src/include/dsLibraryAgency.i}
    DEFINE PRIVATE VARIABLE beLibraryAgency AS src.be.BELibraryAgency.


    CONSTRUCTOR PUBLIC SILibraryAgency (  ):
        SUPER ().
        beLibraryAgency = NEW src.be.BELibraryAgency().
    END CONSTRUCTOR.


    DESTRUCTOR PUBLIC SILibraryAgency ( ):
        DELETE OBJECT beLibraryAgency NO-ERROR.
    END DESTRUCTOR.


 
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadLibraryAgency(INPUT filter AS CHARACTER, OUTPUT DATASET dsLibraryAgency): 
        MESSAGE "DEBUG SI: Start ReadLibraryAgency". 
        beLibraryAgency:ReadLibraryAgency(INPUT filter, OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        MESSAGE "DEBUG SI: End ReadLibraryAgency". 
    END METHOD.
    
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountLibraryAgency(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        beLibraryAgency:CountLibraryAgency(INPUT filter, OUTPUT numRecs).
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        MESSAGE "DEBUG SI: Start CreateLibraryAgency". 
        beLibraryAgency:CreateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        MESSAGE "DEBUG SI: End CreateLibraryAgency". 
        
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        MESSAGE "DEBUG SI: Start UpdateLibraryAgency". 
        beLibraryAgency:UpdateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        MESSAGE "DEBUG SI: End UpdateLibraryAgency". 
        
    END METHOD.
    
    
   
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        MESSAGE "DEBUG SI: Start DeleteLibraryAgency". 
        beLibraryAgency:DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).     
        MESSAGE "DEBUG SI: End DeleteLibraryAgency". 
        
    END METHOD.
    









END CLASS.