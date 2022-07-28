 
 /*------------------------------------------------------------------------
    File        : BEBookStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 11:55:49 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BEBase.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEBookStock INHERITS BEBase: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBookStock.i}
    {src/include/dsBook.i}
    {src/include/dsLibraryAgency.i}
    DEFINE PRIVATE VARIABLE daBookStock AS src.da.DABookStock NO-UNDO.
    DEFINE PRIVATE VARIABLE daBook AS src.da.DABook NO-UNDO.
    DEFINE PRIVATE VARIABLE daLibraryAgency AS src.da.DALibraryAgency NO-UNDO.
    CONSTRUCTOR PUBLIC BEBookStock (  ):
        daBookStock = NEW src.da.DABookStock().
        daBook = NEW src.da.DABook(). 
        daLibraryAgency = NEW src.da.DALibraryAgency().     
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BEBookStock ( ):
        DELETE OBJECT daBookStock NO-ERROR.
        DELETE OBJECT daBook NO-ERROR.
        DELETE OBJECT daLibraryAgency NO-ERROR.
    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID ReadBookStocks( INPUT filter AS CHARACTER,OUTPUT DATASET dsBookStock):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBookStock:ReadGeneric(cWhere, iMaxRows, iSkipRows,OUTPUT DATASET dsBookStock BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the book stocks from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateBookStock (INPUT-OUTPUT DATASET dsBookStock):
         
         DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBookStock NO-LOCK
             WHERE ROW-STATE(ttBookStock) = ROW-CREATED:
             IF NOT src.utils.ValidateClass:validateDate(INPUT ttBookStock.ValidFrom) THEN
                    cErrors = cErrors + "The date from is incorrect!".
             IF src.utils.ValidateClass:validateDates(INPUT ttBookStock.ValidFrom, INPUT ttBookStock.ValidTo) THEN
                    cErrors = cErrors + "The date from must be before date to!".
             IF ttBookStock.StockAmount < 0 OR ttBookStock.StockAmount = ? THEN
                    cErrors = cErrors + "The book stock must be greater than 0!".
             IF NOT daBook:CheckBookId(INPUT ttBookStock.BookId) THEN
                    cErrors = cErrors + "The book must exist!". 
             IF NOT daLibraryAgency:CanFindLibraryAgency(INPUT ttBookStock.LibraryAgencyId) THEN
                    cErrors = cErrors + "The library angency must exist!".
             IF daBookStock:CanFindStock(ttBookStock.ValidFrom, ttBookStock.ValidTo, ttBookStock.BookId, ttBookStock.LibraryAgencyId) THEN
                    cErrors = cErrors + "There is a stock for this book during this time!".     
         END.
         IF cErrors = "" THEN 
            daBookStock:CreateBookStock (INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).        
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates and validates the new changes for book stocks from the given dataset
    @param   the dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateBookStock (INPUT-OUTPUT DATASET dsBookStock):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBookStock NO-LOCK
             WHERE ROW-STATE(ttBookStock) = ROW-MODIFIED:
             IF NOT src.utils.ValidateClass:validateDate(INPUT ttBookStock.ValidFrom) THEN
                    cErrors = cErrors + "The date from is incorrect!".
             IF NOT src.utils.ValidateClass:validateDate(INPUT ttBookStock.ValidTo) THEN
                    cErrors = cErrors + "The date to is incorrect!".
             IF src.utils.ValidateClass:validateDates(INPUT ttBookStock.ValidFrom, INPUT ttBookStock.ValidTo) THEN
                    cErrors = cErrors + "The date from must be before date to!".
             IF ttBookStock.StockAmount < 0 OR ttBookStock.StockAmount = ? THEN
                    cErrors = cErrors + "The book stock must be greater than 0!".
             IF NOT daBook:CheckBookId(INPUT ttBookStock.BookId) THEN
                    cErrors = cErrors + "The book must exist!". 
             IF NOT daLibraryAgency:CanFindLibraryAgency(INPUT ttBookStock.LibraryAgencyId) THEN
                    cErrors = cErrors + "The library angency must exist!".           
             IF daBookStock:CanFindStockNotSameId(ttBookStock.LibraryAgencyId, ttBookStock.ValidFrom, ttBookStock.ValidTo, ttBookStock.BookId, ttBookStock.LibraryAgencyId) THEN
                    cErrors = cErrors + "There is a stock for this book during this time!".   
             IF daBookStock:UpdateStock(ttBookStock.StockAmount, ttBookStock.BookId,  ttBookStock.LibraryAgencyId) THEN
                    cErrors = cErrors + "The stock for this book cannot be less than existing one!".   
         END.
         IF cErrors = "" THEN 
            daBookStock:UpdateBookStock (INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100). 
         
         daBookStock:UpdateBookStock (INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the book stocks 
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID DeleteBookStock (INPUT-OUTPUT DATASET dsBookStock):
         
         daBookStock:DeleteBookStock (INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: counts how many records records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CountBookStocks( INPUT filter AS CHARACTER,OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBookStock:CountGeneric(cWhere, OUTPUT numRecs).
    END METHOD.
    
    METHOD PUBLIC LOGICAL CheckBookStock(INPUT ipcId AS CHARACTER):
        daBookStock:CheckBookStockId(INPUT ipcId).
    END METHOD.

END CLASS.