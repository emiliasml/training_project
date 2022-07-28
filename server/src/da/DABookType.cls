 
 /*------------------------------------------------------------------------
    File        : DABookTypeType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 10:21:21 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DABookType INHERITS src.da.DAGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBookType.i}
    CONSTRUCTOR PUBLIC DABookType (  ):
        TableName = "BookType".
        TempTableName = "ttBookType".  
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DABookType( ):
    END DESTRUCTOR.
    
    /*------------------------------------------------------------------------------
    Purpose: Creates the book types from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateBookType(INPUT-OUTPUT DATASET dsBookType):
        DEFINE BUFFER bufBookType FOR BookType. 
        
        FOR EACH ttBookType NO-LOCK
                WHERE ROW-STATE(ttBookType) = ROW-CREATED:
            CREATE bufBookType.
            BUFFER-COPY ttBookType EXCEPT BookTypeId TO bufBookType.
            ASSIGN
                bufBookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId)).
        END.
    END METHOD.
    
     /*------------------------------------------------------------------------------
    Purpose: Updates the book types from the given dataset in the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    
    METHOD PUBLIC VOID UpdateBookType(INPUT-OUTPUT DATASET dsBookType):
        DEFINE BUFFER bufBookType FOR BookType.
        FOR EACH ttBookType NO-LOCK
                WHERE ROW-STATE(ttBookType) = ROW-MODIFIED:
                    
            FIND FIRST bufBookType EXCLUSIVE-LOCK
                WHERE bufBookType.BookTypeId = ttBookType.BookTypeId NO-ERROR.
            IF AVAILABLE bufBookType THEN
            DO:
                BUFFER-COPY ttBookType EXCEPT BookTypeId TO bufBookType.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the BookType.",100).
            END.
        END.   
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes the book types from the given dataset from the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    
    METHOD PUBLIC VOID DeleteBookType(INPUT-OUTPUT DATASET dsBookType):
        DEFINE BUFFER bufBookType FOR BookType.
        FOR EACH bttBookType NO-LOCK
                WHERE ROW-STATE(bttBookType) = ROW-DELETED:
            FIND FIRST bufBookType EXCLUSIVE-LOCK
                WHERE bufBookType.BookTypeId = bttBookType.BookTypeId NO-ERROR.
            IF AVAILABLE bttBookType THEN
            DO:
                DELETE bufBookType.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the BookType.",100).
            END.
        END.   
    END METHOD.
    
    /*
    Purpose:  Checks if a book type with the given id exist
    @param    ipcId AS CHARACTER
    @return   true if the book exist, false otherwise
    ------------------------------------------------------------------------------*/            
    METHOD PUBLIC LOGICAL CheckBookTypeId(INPUT ipcId AS CHARACTER):
         DEFINE BUFFER bufBookType FOR BookType.
         RETURN CAN-FIND( FIRST bufBookType
                                WHERE bufBookType.BookTypeId = ipcId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book type with the given description exist
    @param    ipcDescription AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/       
    
    METHOD PUBLIC LOGICAL CanFindBookType(INPUT ipcDescription AS CHARACTER):
         DEFINE BUFFER bufBookType FOR BookType.
         RETURN CAN-FIND( FIRST bufBookType
                                WHERE bufBookType.Description = ipcDescription).
    END METHOD.
END CLASS.