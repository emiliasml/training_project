 
 /*------------------------------------------------------------------------
    File        : DABookStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 11:51:12 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.da.DAGeneric.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DABookStock INHERITS DAGeneric: 
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBookStock.i}
    CONSTRUCTOR PUBLIC DABookStock (  ):
        TableName = "BookStock".
        TempTableName = "ttBookStock".     
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DABookStock ( ):
    END DESTRUCTOR.
    
    /*------------------------------------------------------------------------------
    Purpose: Creates the book stocks from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateBookStock(INPUT-OUTPUT DATASET dsBookStock):
        DEFINE BUFFER bufBookStock FOR BookStock.
        
        FOR EACH ttBookStock NO-LOCK
                WHERE ROW-STATE(ttBookStock) = ROW-CREATED:
            CREATE bufBookStock.
            BUFFER-COPY ttBookStock EXCEPT BookStockId TO bufBookStock.
            ASSIGN
                bufBookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId)).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates the book stocks from the given dataset in the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateBookStock(INPUT-OUTPUT DATASET dsBookStock):
        DEFINE BUFFER bufBookStock FOR BookStock.
        
        FOR EACH ttBookStock NO-LOCK
                WHERE ROW-STATE(ttBookStock) = ROW-MODIFIED:
            
            FIND FIRST bufBookStock EXCLUSIVE-LOCK
                WHERE bufBookStock.BookStockId = ttBookStock.BookStockId NO-ERROR.
            IF AVAILABLE bufBookStock THEN
            DO:
                BUFFER-COPY ttBookStock EXCEPT BookStockId TO bufBookStock.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the BookStock.",100).
            END.
        END.   
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes the book stocks from the given dataset from the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID DeleteBookStock(INPUT-OUTPUT DATASET dsBookStock):
        DEFINE BUFFER bufBookStock FOR BookStock.
        
        FOR EACH bttBookStock NO-LOCK
                WHERE ROW-STATE(bttBookStock) = ROW-DELETED:
            
            FIND FIRST bufBookStock EXCLUSIVE-LOCK
                WHERE bufBookStock.BookStockId = bttBookStock.BookStockId NO-ERROR.
            IF AVAILABLE bttBookStock THEN
            DO:
                DELETE bufBookStock.
            END.
            ELSE
            DO:
                UNDO,THROW NEW Progress.Lang.AppError("Cannot find the BookStock.",100).
            END.
        END.   
    END METHOD.

/*------------------------------------------------------------------------------
    Purpose:  Checks if a book stock with the given id for book stock exist
    @param    ipcId AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC LOGICAL CheckBookStockId(INPUT ipcId AS CHARACTER):
         DEFINE BUFFER bufBookStock FOR BookStock.
         RETURN CAN-FIND( FIRST bufBookStock 
                                WHERE bufBookStock.BookStockId = ipcId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book stock with the given data exist for validating datefrom and dateto
    @param    INPUT ipdDateFrom AS DATE,INPUT ipdDateTo AS DATE,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC LOGICAL CanFindStock(INPUT ipdDateFrom AS DATE,INPUT ipdDateTo AS DATE,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER):
         DEFINE BUFFER bufBookStock FOR BookStock.
         RETURN CAN-FIND( FIRST bufBookStock 
                                WHERE bufBookStock.BookId = ipcBookId AND bufBookStock.LibraryAgencyId = ipcLibraryAgencyId
                                AND (NOT ((bufBookStock.ValidTo < ipdDateFrom) OR (bufBookStock.ValidFrom > ipdDateTo)))).

    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book stock with the given data exist for validating datefrom and dateto and id of libraryagency is not equal to the given id
    @param    INPUT ipcId AS CHARACTER,ipdDateFrom AS DATE,INPUT ipdDateTo AS DATE,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC LOGICAL CanFindStockNotSameId(INPUT ipcId AS CHARACTER,INPUT ipdDateFrom AS DATE,INPUT ipdDateTo AS DATE,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER):
         DEFINE BUFFER bufBookStock FOR BookStock.
         RETURN CAN-FIND( FIRST bufBookStock 
                                WHERE bufBookStock.BookId = ipcBookId AND bufBookStock.LibraryAgencyId = ipcLibraryAgencyId
                                AND bufBookStock.LibraryAgencyId NE ipcId
                                AND (NOT ((bufBookStock.ValidTo < ipdDateFrom) OR (bufBookStock.ValidFrom > ipdDateTo)))).

    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a book stock is greater than the new value
    @param    INPUT ipiStock AS INTEGER,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER
    @return   true if the book  exist, false otherwise
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC LOGICAL UpdateStock(INPUT ipiStock AS INTEGER,INPUT ipcBookId AS CHARACTER,INPUT ipcLibraryAgencyId AS CHARACTER):
         DEFINE BUFFER bufBookStock FOR BookStock.
         RETURN CAN-FIND( FIRST bufBookStock 
                                WHERE bufBookStock.BookId = ipcBookId AND bufBookStock.LibraryAgencyId = ipcLibraryAgencyId
                                 AND bufBookStock.StockAmount > ipiStock ).

    END METHOD.

END CLASS.