 
/*------------------------------------------------------------------------
   File        : SIAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:14:34 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

@program FILE(name="SIAppUser.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIAppUser", URI="/SIAppUser", schemaName="dsAppUser", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SIAppUser: 
 
    {src/include/dsAppUser.i}
    
    DEFINE VARIABLE beAppUser AS src.be.BEAppUser NO-UNDO.

    CONSTRUCTOR PUBLIC SIAppUser():

        beAppUser = NEW src.be.BEAppUser().

    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC SIAppUser ( ):
        
        DELETE OBJECT beAppUser NO-ERROR.
        
    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadAppUser( INPUT filter AS CHARACTER, OUTPUT DATASET dsAppUser):
        
        MESSAGE "DEBUG SI: Start ReadAppUser".   
       
        beAppUser:ReadAppUser(INPUT filter, OUTPUT DATASET dsAppUser BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadAppUser".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more records 
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
         
        MESSAGE "DEBUG SI: Start CreateAppUser".  
         
        beAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateAppUser".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
        MESSAGE "DEBUG SI: Start UpdateAppUser".  
        
        beAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateAppUser". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
        MESSAGE "DEBUG SI: Start DeleteAppUser". 
        
        beAppUser:DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE). 
        
        MESSAGE "DEBUG SI: End DeleteAppUser".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Count records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountAppUser( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beAppUser:CountAppUser(INPUT filter, OUTPUT numRecs). 

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Check if the user can login
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/login", alias="", mediaType="application/json").
    METHOD PUBLIC VOID Login(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):       
        DATASET dsAppUser:EMPTY-DATASET ().
        beAppUser:Login(INPUT ipcUserName, INPUT ipcPassword, OUTPUT DATASET dsAppUser BY-REFERENCE).
       
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Read users that have role for the given library
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/ReadUsersFromLibrary", alias="", mediaType="application/json").
    METHOD PUBLIC VOID ReadUsersFromLibrary(INPUT ipcLibraryId AS CHARACTER, OUTPUT DATASET dsAppUser): 
        beAppUser:ReadUsersFromLibrary(INPUT ipcLibraryId, OUTPUT DATASET dsAppUser BY-REFERENCE).
    END METHOD.

END CLASS.