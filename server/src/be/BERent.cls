 
/*------------------------------------------------------------------------
   File        : BERent
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 21:28:08 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/


USING Progress.Lang.*.
 
BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BERent INHERITS src.be.BEBase: 
    {src/include/dsRent.i} 
    {src/include/dsRentBook.i}
    
    DEFINE PRIVATE VARIABLE daRent AS src.da.DARent NO-UNDO.
  
    
    CONSTRUCTOR PUBLIC BERent():
        
        daRent = NEW src.da.DARent().
     
    END.
    
    DESTRUCTOR PUBLIC BeRent():
        
        DELETE OBJECT daRent NO-ERROR.
       
          
    END DESTRUCTOR.    
    
     /*------------------------------------------------------------------------------
    Purpose: Fills the dataset with records based on a given filter
    @param   a filter for read and a dataset 
    ------------------------------------------------------------------------------*/       
    
    METHOD PUBLIC VOID ReadRent(INPUT filter AS CHARACTER, OUTPUT DATASET dsRent): 
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRent:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsRent BY-REFERENCE).
       
    END METHOD.
    
    
    
    METHOD PUBLIC CHARACTER checkErros(INPUT-OUTPUT DATASET dsRent):

        DEFINE VARIABLE dToday AS DATE NO-UNDO.
        dToday = TODAY.
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.

        FOR EACH ttRent NO-LOCK WHERE ROW-STATE(ttRent) = ROW-CREATED OR ROW-STATE(ttRent) = ROW-MODIFIED  :
            
            
            IF ttRent.DateFrom = ?  THEN  
                cErrorMessage = cErrorMessage + "DateFrom cannot be empty".
            
            IF ttRent.DateTo = ? THEN
                cErrorMessage = cErrorMessage + "DateTo cannot be empty".
                
            IF NOT (src.utils.ValidateClass:validateDate(ttRent.DateFrom)) THEN
                cErrorMessage = cErrorMessage + "Format of DateFrom is incorrect".

            IF NOT (src.utils.ValidateClass:validateDate(ttRent.DateTo)) THEN
                cErrorMessage = cErrorMessage + "Format of DateTo is incorrect".

            IF  (src.utils.ValidateClass:validateDates(ttRent.DateFrom, ttRent.DateTo)) THEN
                cErrorMessage = cErrorMessage + "DateTo cannot be earlier than DateFrom".
            
            IF (ttRent.DateFrom < dToday) THEN 
                cErrorMessage = cErrorMessage + "Cannot create a rent in the past".

              
                      
        END.
        
        RETURN cErrorMessage.
        
    END METHOD.
    
    METHOD PUBLIC VOID CreateRent(INPUT-OUTPUT DATASET dsRent):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.

        cErrorMessage = checkErros(INPUT-OUTPUT DATASET dsRent).

        IF cErrorMessage <> "" THEN
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage).
               
        daRent:CreateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
        
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        DEFINE VARIABLE beRentBook AS src.be.BERentBook NO-UNDO.
        
        cErrorMessage = checkErros(INPUT-OUTPUT DATASET dsRent).
        
        beRentBook =  NEW src.be.BERentBook().
        
        FOR EACH ttRent NO-LOCK WHERE ROW-STATE(ttRent) = ROW-MODIFIED:
        
            IF NOT(beRentBook:checkNewDataForUpdateRent(INPUT DATASET dsRentBook, INPUT ttRent.RentId, INPUT ttRent.LibraryAgencyId, INPUT ttRent.DateFrom, INPUT ttRent.DateTo)) THEN
                cErrorMessage = cErrorMessage + "Please select other period because during selected period stock for rented books is unavailable".
        
        END. 
        
        
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage).
            
        daRent:UpdateRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
        
        FINALLY:
           
            DELETE OBJECT beRentBook NO-ERROR.  
             
        END FINALLY.
        
    END.
    
    
    
    
    
    METHOD PUBLIC VOID DeleteRent(INPUT-OUTPUT DATASET dsRent):
        
        DEFINE VARIABLE beRentBook AS src.be.BERentBook NO-UNDO.
        beRentBook = NEW src.be.BERentBook().
        DO TRANSACTION:
        FOR EACH bttRent WHERE
            ROW-STATE(bttRent) = ROW-DELETED:
            IF bttRent.RentStatus <> 1 THEN 
                UNDO, THROW NEW Progress.Lang.AppError("Rent Status is not finished").
            ELSE DO:
                beRentBook:ReadRentBook(INPUT SUBSTITUTE("WHERE RentId = &1", QUOTER(bttRent.RentId)), OUTPUT DATASET dsRentBook BY-REFERENCE).
                TEMP-TABLE ttRentBook:TRACKING-CHANGES = TRUE.
                FOR EACH ttRentBook: 
                    DELETE ttRentBook.
                END.
                TEMP-TABLE ttRentBook:TRACKING-CHANGES = FALSE.
                beRentBook:DeleteRentBook(INPUT-OUTPUT DATASET dsRentBook BY-REFERENCE).
            END.
        END.
        
        daRent:DeleteRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
        END.
         FINALLY:
            
            DELETE OBJECT beRentBook NO-ERROR.  
           
        END FINALLY.
        
    END.
    
    METHOD PUBLIC VOID CountRent(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daRent:CountGeneric(INPUT cWhere, OUTPUT numRecs).
        
    END.
    
    METHOD PUBLIC VOID getDataByRentId(INPUT ipcRentId AS CHARACTER, OUTPUT opcLibraryAgencyId AS CHARACTER, OUTPUT opdDateFrom AS DATE ,  OUTPUT opdDateTo AS DATE ):
        daRent:getDataByRentId(INPUT ipcRentId, OUTPUT opcLibraryAgencyId , OUTPUT opdDateFrom , OUTPUT opdDateTo ).
    END METHOD.
    
    
    
    
          
END CLASS.
