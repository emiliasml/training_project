 
 /*------------------------------------------------------------------------
    File        : BEBookType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 10:36:32 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BEBase.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BEBookType INHERITS BEBase: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsBookType.i}
    {src/include/dsBook.i}
    DEFINE PRIVATE VARIABLE daBookType AS src.da.DABookType NO-UNDO.
    DEFINE PRIVATE VARIABLE daBook AS src.da.DABook NO-UNDO.
    CONSTRUCTOR PUBLIC BEBookType (  ):
        daBookType = NEW src.da.DABookType(). 
        daBook = NEW src.da.DABook().     
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BEBookType ( ):
        DELETE OBJECT daBookType NO-ERROR.
        DELETE OBJECT daBook NO-ERROR.
    END DESTRUCTOR.
    
    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID ReadBookTypes( INPUT filter AS CHARACTER,OUTPUT DATASET dsBookType):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBookType:ReadGeneric(cWhere, iMaxRows, iSkipRows,OUTPUT DATASET dsBookType BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the book types from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateBookType (INPUT-OUTPUT DATASET dsBookType):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBookType NO-LOCK
             WHERE ROW-STATE(ttBookType) = ROW-CREATED:
             IF NOT src.utils.ValidateClass:validateString(ttBookType.Description) THEN
                    cErrors = cErrors + "The description of the book type cannot be empty!".
             IF daBookType:CanFindBookType(ttBookType.Description) THEN
                    cErrors = cErrors + "The description already exist!".
         END.
         IF cErrors = "" THEN 
            daBookType:CreateBookType (INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).        
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Updates and validates the new changes for book types from the given dataset
    @param   the dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateBookType (INPUT-OUTPUT DATASET dsBookType):
        DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH ttBookType NO-LOCK
             WHERE ROW-STATE(ttBookType) = ROW-MODIFIED:
             IF NOT src.utils.ValidateClass:validateString(ttBookType.Description) THEN
                    cErrors = cErrors + "The description of the book type cannot be empty!".
             IF daBookType:CanFindBookType(ttBookType.Description) THEN
                    cErrors = cErrors + "The description already exist!".
         END.
         IF cErrors = "" THEN 
            daBookType:UpdateBookType (INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).          
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the book types (if possible)
    @param   a dataset  
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID DeleteBookType (INPUT-OUTPUT DATASET dsBookType):
         DEFINE VARIABLE cErrors AS CHARACTER NO-UNDO.
         
         FOR EACH bttBookType NO-LOCK
                  WHERE ROW-STATE(bttBookType) = ROW-DELETED:
                  IF daBook:CheckBookTypeId(INPUT bttBookType.BookTypeId) THEN
                        cErrors = cErrors + "The book type cannot be deleted because there are books with this type!".
         END.
         IF cErrors = "" THEN 
            daBookType:DeleteBookType (INPUT-OUTPUT DATASET dsBookType BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(cErrors, 100).        
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: counts how many records records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CountBookTypes( INPUT filter AS CHARACTER,OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        ExtractABLFilter(filter,cWhere,iMaxRows,iSkipRows).
        daBookType:CountGeneric(cWhere, OUTPUT numRecs).
    END METHOD.

    METHOD PUBLIC LOGICAL CheckBookType(INPUT ipcId AS CHARACTER):
        daBookType:CheckBookTypeId(INPUT ipcId).
    END METHOD.
END CLASS.