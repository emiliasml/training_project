@program FILE(name="SILibraryy.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SILibraryy", URI="/SILibraryy", schemaName="dsLibraryy", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SILibraryy
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Tue Aug 03 09:33:17 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SILibraryy: 
    {src/include/dsLibraryy.i}
    DEFINE PRIVATE VARIABLE beLibraryy AS src.be.BELibraryy.

    CONSTRUCTOR PUBLIC SILibraryy (  ):
        SUPER ().
        beLibraryy = NEW src.be.BELibraryy().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SILibraryy ( ):
        DELETE OBJECT beLibraryy NO-ERROR.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadLibraryy(INPUT filter AS CHARACTER, OUTPUT DATASET dsLibraryy): 
        MESSAGE "DEBUG SI: Start ReadLibraryy". 
        beLibraryy:ReadLibraryy(INPUT filter, OUTPUT DATASET dsLibraryy BY-REFERENCE).
        MESSAGE "DEBUG SI: End ReadLibraryy". 
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountLibraryy(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        beLibraryy:CountLibraryy(INPUT filter, OUTPUT numRecs).
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        MESSAGE "DEBUG SI: Start CreateLibraryy". 
        beLibraryy:CreateLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).
        MESSAGE "DEBUG SI: End CreateLibraryy". 
        
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        MESSAGE "DEBUG SI: Start UpdateLibraryy". 
        beLibraryy:UpdateLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).
        MESSAGE "DEBUG SI: End UpdateLibraryy". 
        
    END METHOD.
    
    
   
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        MESSAGE "DEBUG SI: Start DeleteLibraryy". 
        beLibraryy:DeleteLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).     
        MESSAGE "DEBUG SI: End DeleteLibraryy". 
        
    END METHOD.
    
    
   
    
END CLASS.