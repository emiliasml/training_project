
 /*------------------------------------------------------------------------
    File        : DABook
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 19:50:56 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.da.DAGeneric.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DABook INHERITS DAGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBook.i}
    CONSTRUCTOR PUBLIC DABook (  ):
        TableName = "Book".
        TempTableName = "ttBook".     
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DABook ( ):
    END DESTRUCTOR.
    /*------------------------------------------------------------------------------
    Purpose: Creates the books from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateBook(INPUT-OUTPUT DATASET dsBook):
        DEFINE BUFFER bufBook FOR Book.
        FOR EACH ttBook NO-LOCK
                WHERE ROW-STATE(ttBook) = ROW-CREATED:
            CREATE bufBook.
            BUFFER-COPY ttBook EXCEPT BookId TO bufBook.
            ASSIGN
                bufBook.BookId = STRING(NEXT-VALUE(NextBookId)).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates the books from the given dataset in the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateBook(INPUT-OUTPUT DATASET dsBook):
         DEFINE BUFFER bufBook FOR Book.
         
        FOR EACH ttBook NO-LOCK
                WHERE ROW-STATE(ttBook) = ROW-MODIFIED:
                    
            FIND FIRST bufBook EXCLUSIVE-LOCK
                WHERE bufBook.BookId = ttBook.BookId NO-ERROR.
            IF AVAILABLE bufBook THEN
            DO:
                BUFFER-COPY ttBook EXCEPT BookId TO bufBook.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the book.",100).
            END.
        END.   
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes the books from the given dataset from the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID DeleteBook(INPUT-OUTPUT DATASET dsBook):
        DEFINE BUFFER bufBook FOR Book.
        
        FOR EACH bttBook NO-LOCK
                WHERE ROW-STATE(bttBook) = ROW-DELETED:
                    
            FIND FIRST bufBook EXCLUSIVE-LOCK
                WHERE bufBook.BookId = bttBook.BookId NO-ERROR.
                
            IF AVAILABLE bttBook THEN
            DO:
                DELETE bufBook.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the book.",100).
            END.
        END.   
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book with the given id exist
    @param    ipcId AS CHARACTER
    @return   true if the book exist, false otherwise
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC LOGICAL CheckBookId(INPUT ipcId AS CHARACTER):
         DEFINE BUFFER bufBook FOR Book.
         
         RETURN CAN-FIND( FIRST bufBook 
                                WHERE bufBook.BookId = ipcId).
    END METHOD.
 
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book with the given id for book type exist
    @param    ipcId AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC LOGICAL CheckBookTypeId(INPUT ipcId AS CHARACTER):
         DEFINE BUFFER bufBook FOR Book.
         
         RETURN CAN-FIND( FIRST bufBook 
                                WHERE bufBook.BookTypeId = ipcId).
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book with the given data exist
    @param    ipcTitle AS CHARACTER,ipcAuthor AS CHARACTER,ipcPublisher AS CHARACTER,ipcBookType AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC LOGICAL CanFindBook(INPUT ipcTitle AS CHARACTER,INPUT ipcAuthor AS CHARACTER,INPUT ipcPublisher AS CHARACTER,INPUT ipcBookType AS CHARACTER):
         DEFINE BUFFER bufBook FOR Book.
         
         RETURN CAN-FIND( FIRST bufBook 
                                WHERE bufBook.Author = ipcAuthor AND bufBook.BookTitle = ipcTitle AND bufBook.Publisher = ipcPublisher AND bufBook.BookTypeId = ipcBookType).
    END METHOD.
END CLASS.