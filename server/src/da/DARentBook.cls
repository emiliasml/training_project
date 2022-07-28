 
/*------------------------------------------------------------------------
   File        : DARentBook
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 21:31:16 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

  
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.


CLASS src.da.DARentBook INHERITS src.da.DAGeneric: 
    {src/include/dsRentBook.i} 
    
    DEFINE VARIABLE daBook AS src.da.DABook NO-UNDO.
    DEFINE VARIABLE daRent AS src.da.DARent NO-UNDO.
    
    CONSTRUCTOR PUBLIC DARentBook():
        TableName = "RentBook".
        TempTableName = "ttRentBook".
        
        daBook =  NEW src.da.DABook() .
        daRent = NEW src.da.DARent().
        
    END CONSTRUCTOR. 

    DESTRUCTOR PUBLIC DARentBook():
        DELETE OBJECT daBook NO-ERROR.
        DELETE OBJECT daRent NO-ERROR.
    END DESTRUCTOR.
   
    
    METHOD PUBLIC VOID CreateRentBook(INPUT-OUTPUT DATASET dsRentBook):
          DEFINE BUFFER bufRentBook FOR RentBook.
        
            FOR EACH ttRentBook NO-LOCK
            WHERE ROW-STATE(ttRentBook) = ROW-CREATED:
            IF NOT daRent:CanFindRent(ttRentBook.RentId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Rent does not exist!").
            END.
            IF NOT daBook:CheckBookId(ttRentBook.BookId) THEN 
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Book does not exist!").
            END.
            ELSE DO:
                CREATE bufRentBook.
                BUFFER-COPY ttRentBook EXCEPT RentBookId TO bufRentBook . 
                ASSIGN 
                    bufRentBook.RentBookId = STRING(NEXT-VALUE(NextRentBookId)). 
            END.          
        END.        
    END METHOD.
    
    
    
    METHOD PUBLIC INTEGER getNrRent(INPUT ipcRentId AS CHARACTER, INPUT ipcBookId AS CHARACTER):
        
        DEFINE BUFFER bufRentBook FOR RentBook.
        
        DEFINE VARIABLE iNrRent AS INTEGER NO-UNDO.
        FOR EACH bufRentBook NO-LOCK  WHERE bufRentBook.RentId = ipcRentId:
            IF bufRentBook.BookId = ipcBookId THEN 
                iNrRent = iNrRent + 1.
        END.
            RETURN iNrRent.
        END METHOD.
        
        
    
        METHOD PUBLIC VOID UpdateRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        
            DEFINE BUFFER bufRentBook FOR RentBook.
        
            FOR EACH ttRentBook NO-LOCK
                WHERE ROW-STATE(ttRentBook) = ROW-MODIFIED:
                IF NOT daRent:CanFindRent(ttRentBook.RentId) THEN 
                DO:
                    UNDO, THROW NEW Progress.Lang.AppError("Rent does not exist!").
                END.
                IF NOT daBook:CheckBookId(ttRentBook.BookId) THEN 
                DO:
                    UNDO, THROW NEW Progress.Lang.AppError("Book does not exist!").
                END.
                ELSE DO:
                    FIND FIRST bufRentBook EXCLUSIVE-LOCK
                        WHERE bufRentBook.RentBookId = ttRentBook.RentBookId NO-ERROR.
            
                    IF AVAILABLE (RentBook) THEN 
                        BUFFER-COPY ttRentBook EXCEPT RentBookId TO bufRentBook.            
                    ELSE
                        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the rentBook").
                END.
            END.
        END METHOD.
    
        METHOD PUBLIC VOID DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
            DEFINE BUFFER bufRentBook FOR RentBook.
            FOR EACH bttRentBook NO-LOCK
                WHERE ROW-STATE(bttRentBook) = ROW-DELETED:
            
                FIND FIRST bufRentBook EXCLUSIVE-LOCK
                    WHERE bufRentBook.RentBookId = bttRentBook.RentBookId NO-ERROR.
                    
                IF AVAILABLE (bttRentBook) THEN
                    DELETE bufRentBook.
                ELSE
                    UNDO, THROW NEW Progress.Lang.AppError("Cannot find the rentBook").
            END.
        END METHOD.   

    END CLASS.
