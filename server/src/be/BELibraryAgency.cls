 
/*------------------------------------------------------------------------
   File        : BELibraryAgency
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Tue Aug 03 10:00:20 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BELibraryAgency INHERITS src.be.BEBase: 
    {src/include/dsLibraryAgency.i}
    {src/include/dsBookStock.i}
    {src/include/dsRent.i}
    DEFINE PRIVATE VARIABLE daLibraryAgency AS src.da.DALibraryAgency.
    DEFINE PRIVATE VARIABLE daLibraryy AS src.da.DALibraryy.
    DEFINE PRIVATE VARIABLE beBookStock AS src.be.BEBookStock.
    DEFINE PRIVATE VARIABLE beRent AS src.be.BERent.

    CONSTRUCTOR PUBLIC BELibraryAgency (  ):
        SUPER ().
        daLibraryy = NEW src.da.DALibraryy().
        daLibraryAgency = NEW src.da.DALibraryAgency().
        beBookStock = NEW src.be.BEBookStock().   
        beRent = NEW src.be.BERent().
    END CONSTRUCTOR.
    


    DESTRUCTOR PUBLIC BELibraryAgency ( ):
        DELETE OBJECT daLibraryAgency NO-ERROR.
        DELETE OBJECT daLibraryy NO-ERROR.
        DELETE OBJECT beBookStock NO-ERROR.    
        DELETE OBJECT beRent NO-ERROR.    
    END DESTRUCTOR.
    
     
    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadLibraryAgency(INPUT filter AS CHARACTER, OUTPUT DATASET dsLibraryAgency): 
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daLibraryAgency:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsLibraryAgency BY-REFERENCE). 
        
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: counts how many records records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC VOID CountLibraryAgency(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE cWhere      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daLibraryAgency:CountGeneric(INPUT cWhere, OUTPUT numRecs).
        
    END METHOD.



    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the agencies from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        DEFINE VARIABLE opcError AS CHARACTER NO-UNDO.
        
        IF ValidateLibraryAgencyForCreateUpdate(INPUT DATASET dsLibraryAgency BY-REFERENCE, OUTPUT opcError) THEN
            daLibraryAgency:CreateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(opcError).
            
         
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the agencies from the given dataset
    @param   a dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):
        
        DEFINE VARIABLE opcError AS CHARACTER NO-UNDO.
        
        IF ValidateLibraryAgencyForCreateUpdate(INPUT DATASET dsLibraryAgency BY-REFERENCE, OUTPUT opcError) THEN
            daLibraryAgency:UpdateLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(opcError).
            
    END METHOD.
 
 
 
    /*------------------------------------------------------------------------------
     Purpose: Deletes all the agencies from the given dataset and all of its rents (if
     possible) and bookstocks 
     @param   a dataset  
     ------------------------------------------------------------------------------*/   
    METHOD PUBLIC VOID DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency):

        FOR EACH bttLibraryAgency WHERE
            ROW-STATE(bttLibraryAgency) = ROW-DELETED:
                //delete all stocks
            MESSAGE "start delete bookstocks".
            DO TRANSACTION:
                beBookStock:ReadBookStocks(SUBSTITUTE("WHERE LibraryAgencyId = &1", QUOTER(bttLibraryAgency.LibraryAgencyId)),OUTPUT DATASET dsBookStock BY-REFERENCE).
                TEMP-TABLE ttBookStock:TRACKING-CHANGES = TRUE.
                FOR EACH ttBookStock:
                    DELETE ttBookStock.
                END.
                TEMP-TABLE ttBookStock:TRACKING-CHANGES = FALSE.
                beBookStock:DeleteBookStock(INPUT-OUTPUT DATASET dsBookStock BY-REFERENCE).
            
            //delete all rents if possible
                MESSAGE "start delete rents".
                beRent:ReadRent(SUBSTITUTE("WHERE LibraryAgencyId = &1", QUOTER(bttLibraryAgency.LibraryAgencyId)), OUTPUT DATASET dsRent BY-REFERENCE).
                TEMP-TABLE ttRent:TRACKING-CHANGES = TRUE.
                FOR EACH ttRent:
                    DELETE ttRent.
                END.
                TEMP-TABLE ttRent:TRACKING-CHANGES = FALSE.
                beRent:DeleteRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE).
            END.
        END.        
        MESSAGE "start delete agency".
        daLibraryAgency:DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        MESSAGE "END DELETE AGENCY".
        
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Check if there exists an agency in database with the given id
    @param    ipcLibraryAgencyId as char
    @return   true if the agency exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindLibraryAgency(INPUT ipcLibraryAgencyId AS CHARACTER):
        
        RETURN daLibraryAgency:CanFindLibraryAgency(INPUT ipcLibraryAgencyId).
        
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Validates agencies for create or update
    @param    dsLibraryAgency as dataset
    @return   true if we allow the agencies to be created, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateLibraryAgencyForCreateUpdate(INPUT DATASET dsLibraryAgency, OUTPUT opcError AS CHARACTER):
        
        DEFINE VARIABLE lIsOk AS LOGICAL NO-UNDO INITIAL TRUE.
        
        FOR EACH ttLibraryAgency WHERE ROW-STATE(ttLibraryAgency)= ROW-CREATED
            OR ROW-STATE(ttLibraryAgency)= ROW-MODIFIED:
            IF (NOT src.utils.ValidateClass:validateString(ttLibraryAgency.Address)) THEN 
            DO:
                opcError += "The address cannot be empty \n".
                lIsOk = FALSE.
            END.
            IF (NOT daLibraryy:CanFindLibraryy(ttLibraryAgency.LibraryId)) THEN
            DO:
                opcError += "The library does not exist\n".
                lIsOk= FALSE.
            END.
        END.
        RETURN lIsOk.
        
    END METHOD.
    
END CLASS.

