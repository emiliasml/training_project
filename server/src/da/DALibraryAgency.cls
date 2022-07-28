 
/*------------------------------------------------------------------------
   File        : DALibraryAgency
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Tue Aug 03 09:43:25 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DALibraryAgency INHERITS src.da.DAGeneric: 
    {src/include/dsLibraryAgency.i}
    
    CONSTRUCTOR PUBLIC DALibraryAgency (  ):
        SUPER ().
        TableName="LibraryAgency".
        TempTableName ="ttLibraryAgency".
    END CONSTRUCTOR.
    

    DESTRUCTOR PUBLIC DALibraryAgency ( ):
    END DESTRUCTOR.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Creates all the agencies from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        DEFINE BUFFER bLibraryAgency  FOR LibraryAgency. 
        
        FOR EACH ttLibraryAgency NO-LOCK WHERE ROW-STATE(ttLibraryAgency) = ROW-CREATED:
            CREATE bLibraryAgency.
            BUFFER-COPY ttLibraryAgency EXCEPT ttLibraryAgency.LibraryAgencyId TO bLibraryAgency.
            ASSIGN 
                bLibraryAgency.LibraryAgencyId = STRING(NEXT-VALUE(NextLibraryAgencyId)).
        END.
        
    END METHOD. 
    
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the agencies from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID UpdateLibraryAgency(INPUT-OUTPUT  DATASET dsLibraryAgency):
        
        DEFINE BUFFER bLibraryAgency  FOR LibraryAgency. 
        
        FOR EACH ttLibraryAgency NO-LOCK
            WHERE ROW-STATE(ttLibraryAgency) = ROW-MODIFIED:
            FIND FIRST bLibraryAgency EXCLUSIVE-LOCK 
                WHERE bLibraryAgency.LibraryAgencyId = ttLibraryAgency.LibraryAgencyId NO-ERROR.
            
            IF AVAILABLE(bLibraryAgency) THEN
                BUFFER-COPY ttLibraryAgency EXCEPT ttLibraryAgency.LibraryAgencyId TO bLibraryAgency.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the LibraryAgency", 100).
        END.
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the agencies from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        DEFINE BUFFER bLibraryAgency  FOR LibraryAgency. 
        
        FOR EACH bttLibraryAgency NO-LOCK
            WHERE ROW-STATE(bttLibraryAgency) = ROW-DELETED:
            FIND FIRST bLibraryAgency EXCLUSIVE-LOCK
                WHERE bLibraryAgency.LibraryAgencyId = bttLibraryAgency.LibraryAgencyId NO-ERROR.      
            IF AVAILABLE bttLibraryAgency THEN
                DELETE bLibraryAgency.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the LibraryAgency", 100).
        END.
        
    END METHOD. 
    
    
    /*------------------------------------------------------------------------------
    Purpose: Check if there exists an agency in database with the given id
    @param    ipcLibraryAgencyId as char
    @return   true if the agency exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindLibraryAgency(INPUT ipcLibraryAgencyId AS CHARACTER):

        DEFINE BUFFER bLibraryAgency  FOR LibraryAgency.  
        RETURN CAN-FIND(FIRST bLibraryAgency NO-LOCK 
            WHERE bLibraryAgency.LibraryAgencyId = ipcLibraryAgencyId).

    END METHOD.
    
    

END CLASS.