 
 /*------------------------------------------------------------------------
    File        : BEBook
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 20:31:01 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BEBase.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEBook INHERITS BEBase: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBook.i}
    {src/include/dsBookType.i}
    {src/include/dsBookStock.i}
    {src/include/dsRent.i}
    {src/include/dsRentBook.i}
    DEFINE PRIVATE VARIABLE daBook AS src.da.DABook NO-UNDO.
    DEFINE PRIVATE VARIABLE daBookType AS src.da.DABookType NO-UNDO.
    DEFINE PRIVATE VARIABLE beBookStock AS src.be.BEBookStock NO-UNDO.
    DEFINE PRIVATE VARIABLE beRentBook AS src.be.BERentBook NO-UNDO.
    DEFINE PRIVATE VARIABLE beRent AS src.be.BERent NO-UNDO.
    CONSTRUCTOR PUBLIC BEBook (  ):
        daBook = NEW src.da.DABook().  
        daBookType = NEW src.da.DABookType(). 
        beBookStock = NEW src.be.BEBookStock().
        beRentBook = NEW src.be.BERentBook().
        beRent = NEW src.be.BERent().  
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BEBook ( ):
        DELETE OBJECT daBook NO-ERROR.
        DELETE OBJECT daBookType NO-ERROR.
        DELETE OBJECT beBookStock NO-ERROR.
        DELETE OBJECT beRentBook NO-ERROR.
        DELETE OBJECT beRent NO-ERROR.
    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID ReadBooks( INPUT filter AS CHARACTER,OUTPUT DATASET dsBook):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBook:ReadGeneric(cWhere, iMaxRows, iSkipRows,OUTPUT DATASET dsBook BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the books from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateBook (INPUT-OUTPUT DATASET dsBook):
         DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBook NO-LOCK
             WHERE ROW-STATE(ttBook) = ROW-CREATED:
             IF NOT src.utils.ValidateClass:validateString(ttBook.BookTitle) THEN
                    cErrors = cErrors + "The title of the book cannot be empty!".
             IF NOT src.utils.ValidateClass:validateString(ttBook.Author) THEN
                    cErrors = cErrors + "The author of the book cannot be empty!".
             IF NOT src.utils.ValidateClass:validateString(ttBook.Publisher) THEN
                    cErrors = cErrors + "The publisher of the book cannot be empty!".
             IF NOT daBookType:CheckBookTypeId(INPUT ttBook.BookTypeId) THEN
                    cErrors = cErrors + "The book type must belong to the existing types!". 
             IF daBook:CanFindBook(INPUT ttBook.BookTitle, INPUT ttBook.Author, INPUT ttBook.Publisher,INPUT ttBook.BookTypeId) THEN
                    cErrors = cErrors + "The book already exist !". 
         END.
         IF cErrors = "" THEN 
            daBook:CreateBook (INPUT-OUTPUT DATASET dsBook BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).        
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates and validates the new changes for books from the given dataset
    @param   the dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateBook (INPUT-OUTPUT DATASET dsBook):
         DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBook NO-LOCK
             WHERE ROW-STATE(ttBook) = ROW-MODIFIED:
             IF NOT src.utils.ValidateClass:validateString(ttBook.BookTitle) THEN
                    cErrors = cErrors + "The title of the book cannot be empty!".
             IF NOT src.utils.ValidateClass:validateString(ttBook.Author) THEN
                    cErrors = cErrors + "The author of the book cannot be empty!".
             IF NOT src.utils.ValidateClass:validateString(ttBook.Publisher) THEN
                    cErrors = cErrors + "The publisher of the book cannot be empty!".
             IF NOT daBookType:CheckBookTypeId(INPUT ttBook.BookTypeId) THEN
                    cErrors = cErrors + "The book type must belong to the existing types!". 
             IF daBook:CanFindBook(ttBook.BookTitle, ttBook.Author, ttBook.Publisher, ttBook.BookTypeId) THEN
                    cErrors = cErrors + "The book already exist !".
         END.
         IF cErrors = "" THEN 
            daBook:UpdateBook (INPUT-OUTPUT DATASET dsBook BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).       
         
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the books with rent status finished all of theirs bookstocks(if possible)
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID DeleteBook (INPUT-OUTPUT DATASET dsBook):
         DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         DEFINE VARIABLE cCurrentErrors AS CHARACTER NO-UNDO.
         
         DEFINE BUFFER bufRentBook FOR ttRentBook.
         FOR EACH bttBook NO-LOCK
                  WHERE ROW-STATE(bttBook) = ROW-DELETED :
                  beRentBook:ReadRentBook(SUBSTITUTE("WHERE BookId = &1", QUOTER(bttBook.BookId)), OUTPUT DATASET dsRentBook).
                  DO TRANSACTION:
                      FOR EACH ttRentBook NO-LOCK:
                          beRent:ReadRent(SUBSTITUTE("WHERE RentId = &1", QUOTER(ttRentBook.RentId)), OUTPUT DATASET dsRent).
                          TEMP-TABLE ttRent:TRACKING-CHANGES = TRUE.
                          FOR EACH ttRent NO-LOCK:
                               DELETE ttRent.                     
                          END.
                          TEMP-TABLE ttRent:TRACKING-CHANGES = FALSE.
                          beRent:DeleteRent(INPUT-OUTPUT DATASET dsRent).
                      END.
                      beBookStock:ReadBookStocks(SUBSTITUTE("WHERE BookId = &1", QUOTER(bttBook.BookId)), OUTPUT DATASET dsBookStock).
                      TEMP-TABLE ttBookStock:TRACKING-CHANGES = TRUE.
                      FOR EACH ttBookStock NO-LOCK:
                          DELETE ttBookStock.
                      END.
                      TEMP-TABLE ttBookStock:TRACKING-CHANGES = FALSE.
                      beBookStock:DeleteBookStock(INPUT-OUTPUT DATASET dsBookStock).
                      daBook:DeleteBook(INPUT-OUTPUT DATASET dsBook).
                  END.
         END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: counts how many records records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CountBooks( INPUT filter AS CHARACTER,OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBook:CountGeneric(cWhere, OUTPUT numRecs).
    END METHOD.
    
    METHOD PUBLIC LOGICAL CheckBook(INPUT ipcId AS CHARACTER):
        daBook:CheckBookId(INPUT ipcId).
    END METHOD.
    
    METHOD PUBLIC LOGICAL CheckBookType(INPUT ipcId AS CHARACTER):
        daBook:CheckBookTypeId(INPUT ipcId).
    END METHOD.
END CLASS.