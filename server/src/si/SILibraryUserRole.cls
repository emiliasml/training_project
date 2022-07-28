@program FILE(name="SILibraryUserRole.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SILibraryUserRole", URI="/SILibraryUserRole", schemaName="dsLibraryUserRole", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SILibraryUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 09 13:42:24 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SILibraryUserRole: 

    {src/include/dsLibraryUserRole.i}
    
    DEFINE VARIABLE beLibraryUserRole AS src.be.BELibraryUserRole.
    
    CONSTRUCTOR PUBLIC SILibraryUserRole ():
        beLibraryUserRole = NEW src.be.BELibraryUserRole().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SILibraryUserRole ():
        DELETE OBJECT beLibraryUserRole NO-ERROR.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/ReadLibraryUserRole", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadLibraryUserRole(INPUT ipcAppUserId AS CHARACTER,  OUTPUT DATASET dsLibraryUserRole):
        DATASET dsLibraryUserRole:EMPTY-DATASET ().
        beLibraryUserRole:ReadLibraryUserRole(INPUT ipcAppUserId, OUTPUT DATASET dsLibraryUserRole BY-REFERENCE).
    END METHOD.
    
END CLASS.