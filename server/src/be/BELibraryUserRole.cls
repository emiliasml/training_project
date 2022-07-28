 
/*------------------------------------------------------------------------
   File        : BELibraryUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 09 13:30:15 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BELibraryUserRole: 
    {src/include/dsLibraryUserRole.i}
    
    DEFINE VARIABLE daLibraryUserRole AS src.da.DALibraryUserRole.
    
    CONSTRUCTOR PUBLIC BELibraryUserRole ():
        daLibraryUserRole = NEW src.da.DALibraryUserRole().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BELibraryUserRole ():
        DELETE OBJECT daLibraryUserRole NO-ERROR.
    END DESTRUCTOR.
    
    
    METHOD PUBLIC VOID ReadLibraryUserRole(INPUT ipcAppUserId AS CHARACTER,  OUTPUT DATASET dsLibraryUserRole):
        daLibraryUserRole:ReadLibraryUserRole(INPUT ipcAppUserId, OUTPUT DATASET dsLibraryUserRole BY-REFERENCE).
    END METHOD.
    
  
END CLASS.