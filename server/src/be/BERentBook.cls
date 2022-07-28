 
/*------------------------------------------------------------------------
   File        : BERentBook
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 21:33:16 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/


USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BERentBook INHERITS src.be.BEBase: 
    {src/include/dsRentBook.i} 
    {src/include/dsBookStock.i}
    {src/include/dsRent.i}
    
    DEFINE PRIVATE VARIABLE daRentBook AS src.da.DARentBook NO-UNDO.
    
    CONSTRUCTOR PUBLIC BERentBook():
        
        daRentBook = NEW src.da.DARentBook().
      
        
    END.
    
    DESTRUCTOR PUBLIC BeRentBook():
        
        DELETE OBJECT daRentBook NO-ERROR.
  
    END DESTRUCTOR.    
    
    METHOD PUBLIC VOID ReadRentBook(INPUT filter AS CHARACTER, OUTPUT DATASET dsRentBook): 
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRentBook:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsRentBook BY-REFERENCE).
       
    END METHOD.
    
    METHOD PUBLIC CHARACTER checkStockAvailability(INPUT-OUTPUT DATASET dsRentBook):
        DEFINE VARIABLE cLibraryAgency AS CHARACTER NO-UNDO.
        DEFINE VARIABLE dDateFrom AS DATE NO-UNDO.
        DEFINE VARIABLE dDateTo AS DATE NO-UNDO.
        DEFINE VARIABLE iNrRent AS INTEGER NO-UNDO.
 
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
       
        DEFINE  VARIABLE beRent AS src.be.BERent NO-UNDO.
        DEFINE  VARIABLE beBookStock AS src.be.BEBookStock NO-UNDO.
        
        beRent = NEW src.be.BERent().
        beBookStock = NEW src.be.BEBookStock().
        
        FOR EACH ttRentBook NO-LOCK WHERE ROW-STATE (ttRentBook) = ROW-CREATED  OR ROW-STATE (ttRentBook) = ROW-MODIFIED :
            beRent:getDataByRentId(INPUT ttRentBook.RentId, OUTPUT cLibraryAgency, OUTPUT dDateFrom,  OUTPUT dDateTo).
            
            beBookStock:ReadBookStocks(INPUT SUBSTITUTE ("WHERE BookStock.BookId = '&1' and BookStock.LibraryAgencyId = '&2'", ttRentBook.BookId, cLibraryAgency ),OUTPUT DATASET dsBookStock BY-REFERENCE).
            
            FIND FIRST ttBookStock NO-LOCK WHERE 
                (ttBookStock.ValidTo <> ? AND ttBookStock.ValidFrom <= dDateFrom AND ttBookStock.ValidTo >= dDateTo) OR 
                (ttBookStock.ValidTo EQ ? AND ttBookStock.ValidFrom <= dDateFrom) NO-ERROR.
            IF AVAILABLE (ttBookStock) THEN 
            DO:
                iNrRent = 0.
                
                beRent:ReadRent(INPUT SUBSTITUTE  ("WHERE Rent.LibraryAgencyId = '&1'", cLibraryAgency), OUTPUT DATASET dsRent BY-REFERENCE ).
                
                FOR EACH ttRent NO-LOCK WHERE ttRent.RentStatus <> 1 :
                    IF NOT (ttRent.DateTo < dDateFrom OR ttRent.DateFrom > dDateTo) THEN 
                    DO:
                        iNrRent += getNrRent(INPUT ttRent.RentId, INPUT ttBookStock.BookId ).                      
                    END.
               
                END.
               
               IF  ROW-STATE (ttRentBook) = ROW-CREATED THEN DO:
                IF iNrRent >= ttBookStock.StockAmount THEN 
                    cErrorMessage = cErrorMessage + "Stock unavailable".
               END.
               
               IF ROW-STATE (ttRentBook) = ROW-MODIFIED THEN DO:
                FIND FIRST bttRentBook WHERE bttRentBook.RentBookId = ttRentBook.RentBookId NO-ERROR.
                    IF AVAILABLE bttRentBook THEN DO:
                        IF bttRentBook.BookId = ttRentBook.BookId THEN 
                        iNrRent = iNrRent - 1.
                    END.
                IF iNrRent >= ttBookStock.StockAmount THEN 
                    cErrorMessage = cErrorMessage + "Stock unavailable".
               END.
               
               
               
            END.
            
            ELSE 
                cErrorMessage = cErrorMessage + "Stock unavailable during selected period".

        END.
     
        DELETE OBJECT beRent NO-ERROR.  
        DELETE OBJECT beBookStock NO-ERROR.  
        RETURN cErrorMessage.
        
        
    END METHOD.
    
    METHOD PUBLIC VOID CreateRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.   
        
                                                                                                                                                                                                             
        cErrorMessage = checkStockAvailability (INPUT-OUTPUT DATASET dsRentBook).
        
        
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage).
        
        
        daRentBook:CreateRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
  
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.   
                                                                                                                                                                                          
       
       
        cErrorMessage = checkStockAvailability (INPUT-OUTPUT DATASET dsRentBook).
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage).
        
            
        daRentBook:UpdateRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
        
    END.
    
    METHOD PUBLIC VOID DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook):
        
        daRentBook:DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
        
    END.
    
    METHOD PUBLIC VOID CountRentBook(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRentBook:CountGeneric(INPUT cWhere, OUTPUT numRecs).
        
    END.
    
    METHOD PUBLIC INTEGER getNrRent(INPUT ipcRentId AS CHARACTER, INPUT ipcBookId AS CHARACTER):
        RETURN daRentBook:getNrRent(INPUT ipcRentId,INPUT ipcBookId).
    END METHOD.
    
    
    
    METHOD PUBLIC LOGICAL checkNewDataForUpdateRent(INPUT DATASET dsRentBook, INPUT ipcRentId AS CHARACTER, INPUT ipcLibraryAgencyId AS CHARACTER, INPUT ipdDateFrom AS DATE, INPUT ipdDateTo AS DATE):
        DEFINE  VARIABLE beRent AS src.be.BERent NO-UNDO.
    
        DEFINE  VARIABLE beBookStock AS src.be.BEBookStock NO-UNDO.
        DEFINE VARIABLE iNrRent AS INTEGER NO-UNDO.
        beRent = NEW src.be.BERent().
        beBookStock = NEW src.be.BEBookStock().
        ReadRentBook(INPUT SUBSTITUTE ("where RentBook.RentId = '&1'", ipcRentId), OUTPUT DATASET dsRentBook).
        
        FOR EACH ttRentBook NO-LOCK:
            beBookStock:ReadBookStocks(INPUT SUBSTITUTE ("WHERE BookStock.BookId = '&1' and BookStock.LibraryAgencyId = '&2'", ttRentBook.BookId, ipcLibraryAgencyId ),OUTPUT DATASET dsBookStock BY-REFERENCE).
            
            FIND FIRST ttBookStock NO-LOCK WHERE 
                (ttBookStock.ValidTo <> ? AND ttBookStock.ValidFrom <= ipdDateFrom AND ttBookStock.ValidTo >= ipdDateTo) OR 
                (ttBookStock.ValidTo EQ ? AND ttBookStock.ValidFrom <= ipdDateFrom) NO-ERROR .
            IF AVAILABLE (ttBookStock) THEN 
            DO:
                iNrRent = 0.
                
                beRent:ReadRent(INPUT SUBSTITUTE  ("WHERE Rent.LibraryAgencyId = '&1'", ipcLibraryAgencyId), OUTPUT DATASET dsRent BY-REFERENCE ).
                
                FOR EACH ttRent NO-LOCK :
                    IF NOT (ttRent.DateTo < ipdDateFrom OR ttRent.DateFrom > ipdDateTo) THEN 
                    DO:
                        iNrRent += getNrRent(INPUT ttRent.RentId, INPUT ttBookStock.BookId ).                      
                    END.
               
                END.
                
                IF iNrRent - 1  >= ttBookStock.StockAmount  THEN DO:
                  
                    RETURN FALSE.
                END.
                
            END.
            
            ELSE DO:
               
                RETURN FALSE.
            END.

        END.
         
        RETURN TRUE.
        
        FINALLY:
            
             DELETE OBJECT beRent NO-ERROR.  
             DELETE OBJECT beBookStock NO-ERROR.   
           
        END FINALLY.
        
    END METHOD. 
          
END CLASS.
