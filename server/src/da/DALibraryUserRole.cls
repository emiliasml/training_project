
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DALibraryUserRole: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsLibraryUserRole.i}
    CONSTRUCTOR PUBLIC DALibraryUserRole (  ):
        SUPER ().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DALibraryUserRole ( ):
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadLibraryUserRole(INPUT ipcAppUserId AS CHARACTER,  OUTPUT DATASET dsLibraryUserRole):
         
        DEFINE BUFFER bLibraryy  FOR Libraryy.  
        DEFINE BUFFER bUserRole FOR UserRole.       
        DEFINE BUFFER bRoleType FOR RoleType.
        
        FOR EACH bUserRole NO-LOCK 
            WHERE bUserRole.AppUserId = ipcAppUserId:
            FIND FIRST bRoleType NO-LOCK
                WHERE bRoleType.RoleTypeId = bUserRole.RoleTypeId NO-ERROR.
            IF AVAILABLE bRoleType THEN DO:
                IF bRoleType.Description = "Superadmin" THEN DO:
                    CREATE ttLibraryUserRole.
                    ASSIGN
                        ttLibraryUserRole.LibraryId = "all"
                        ttLibraryUserRole.LibraryName = "All"
                        ttLibraryUserRole.AppUserId = ipcAppUserId
                        ttLibraryUserRole.RoleDescription = bRoleType.Description. 
                END.       
                ELSE DO:
                    FIND FIRST bLibraryy NO-LOCK 
                        WHERE bLibraryy.LibraryId = bUserRole.LibraryId NO-ERROR.
                    IF AVAILABLE bLibraryy THEN DO:
                   
                        CREATE ttLibraryUserRole.
                        ASSIGN
                            ttLibraryUserRole.LibraryId = bLibraryy.LibraryId
                            ttLibraryUserRole.LibraryName = bLibraryy.LibraryName
                            ttLibraryUserRole.AppUserId = ipcAppUserId
                            ttLibraryUserRole.RoleDescription = bRoleType.Description.                   
                    END.  
                END.       
            END.
        END.
          
    END METHOD.
    
END CLASS.