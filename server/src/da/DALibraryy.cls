 
/*------------------------------------------------------------------------
   File        : DALibraryy
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Mon Aug 02 19:03:06 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DALibraryy INHERITS src.da.DAGeneric: 
    {src/include/dsLibraryy.i}
    
    CONSTRUCTOR PUBLIC DALibraryy (  ):
        SUPER ().
        TableName="Libraryy".
        TempTableName ="ttLibraryy".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DALibraryy ( ):
    END DESTRUCTOR.



    /*------------------------------------------------------------------------------
    Purpose: Creates all the libraries from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        DEFINE BUFFER bLibraryy FOR Libraryy.
        
        FOR EACH ttLibraryy NO-LOCK WHERE ROW-STATE(ttLibraryy) = ROW-CREATED:
            CREATE bLibraryy.
            BUFFER-COPY ttLibraryy EXCEPT ttLibraryy.LibraryId TO bLibraryy.
            ASSIGN 
                bLibraryy.LibraryId=STRING(NEXT-VALUE(NextLibraryId)).
        END.
        
    END METHOD.


    /*------------------------------------------------------------------------------
    Purpose: Updates all the libraries from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateLibraryy(INPUT-OUTPUT  DATASET dsLibraryy):
        
        DEFINE BUFFER bLibraryy FOR Libraryy.
        
        FOR EACH ttLibraryy NO-LOCK
            WHERE ROW-STATE(ttLibraryy) = ROW-MODIFIED:
            FIND FIRST bLibraryy EXCLUSIVE-LOCK 
                WHERE bLibraryy.LibraryId = ttLibraryy.LibraryId NO-ERROR.
            
            IF AVAILABLE(bLibraryy) THEN
                BUFFER-COPY ttLibraryy EXCEPT ttLibraryy.LibraryId TO bLibraryy.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the Library", 100).
        END.
        
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the libraries from the given dataset 
    @param   a dataset  
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID DeleteLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        DEFINE BUFFER bLibraryy FOR Libraryy.
        
        FOR EACH bttLibraryy NO-LOCK
            WHERE ROW-STATE(bttLibraryy) = ROW-DELETED:
            FIND FIRST bLibraryy EXCLUSIVE-LOCK
                WHERE bLibraryy.LibraryId = bttLibraryy.LibraryId NO-ERROR.      
            IF AVAILABLE bttLibraryy THEN
                DELETE bLibraryy.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the Library", 100).
        END.
        
    END METHOD. 

    

    /*------------------------------------------------------------------------------
     Purpose: Check if there exists a library in database with the given id
    @param    ipcLibraryId as char
    @return   true if the library exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindLibraryy(INPUT ipcLibraryId AS CHARACTER):

        DEFINE BUFFER bLibraryy  FOR Libraryy.  
        RETURN CAN-FIND(FIRST bLibraryy NO-LOCK WHERE bLibraryy.LibraryId = ipcLibraryId).

    END METHOD.


    /*------------------------------------------------------------------------------
     Purpose: Check if there exists another library in database with the given name
    @param    ipcLibraryName as char, ipcLibraryId
    @return   true if a library exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ExistsAnotherRecordWithSameName(INPUT ipcLibraryName AS CHARACTER, INPUT ipcLibraryId AS CHARACTER):
        
        DEFINE BUFFER bLibraryy  FOR Libraryy.  
        RETURN CAN-FIND(bLibraryy NO-LOCK 
            WHERE bLibraryy.LibraryName = ipcLibraryName AND bLibraryy.LibraryId NE ipcLibraryId).

    END METHOD.



END CLASS.