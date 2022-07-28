 
/*------------------------------------------------------------------------
   File        : BELibraryy
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Emilia
   Created     : Tue Aug 03 09:18:24 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BELibraryy INHERITS src.be.BEBase: 
    {src/include/dsLibraryy.i}
    {src/include/dsLibraryAgency.i}
    DEFINE PRIVATE VARIABLE daLibraryy AS src.da.DALibraryy.
    DEFINE PRIVATE VARIABLE beLibraryAgency AS src.be.BELibraryAgency.

    CONSTRUCTOR PUBLIC BELibraryy (  ):
        SUPER ().
        daLibraryy = NEW src.da.DALibraryy().
        beLibraryAgency = NEW src.be.BELibraryAgency().
    END CONSTRUCTOR.


    DESTRUCTOR PUBLIC BELibraryy ( ):
        DELETE OBJECT daLibraryy NO-ERROR.
        DELETE OBJECT beLibraryAgency NO-ERROR.
    END DESTRUCTOR.
    
    
    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with records based on a given filter
    @param  a filter for read and the dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadLibraryy(INPUT filter AS CHARACTER, OUTPUT DATASET dsLibraryy): 
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daLibraryy:ReadGeneric(INPUT cWhere, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsLibraryy BY-REFERENCE).  
  
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: counts how many records records are in table based on a given filter
    @param  a filter for read and the number of records
    ------------------------------------------------------------------------------*/      
    METHOD PUBLIC VOID CountLibraryy(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE cWhere      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daLibraryy:CountGeneric(INPUT cWhere, OUTPUT numRecs).
        
    END METHOD.
    
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Validates and creates all the libraries from the given dataset if the
    records pass the validations 
    @param   a dataset  
    ------------------------------------------------------------------------------*/  
    METHOD PUBLIC VOID CreateLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        DEFINE VARIABLE opcError AS CHARACTER NO-UNDO.
        
        IF ValidateLibraryyForCreateUpdate(INPUT DATASET dsLibraryy BY-REFERENCE, OUTPUT opcError) THEN  
            daLibraryy:CreateLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(opcError).
            
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Updates all the libraries from the given dataset
    @param   the dataset  
    ------------------------------------------------------------------------------*/    
    METHOD PUBLIC VOID UpdateLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        DEFINE VARIABLE opcError AS CHARACTER NO-UNDO.
        
        IF ValidateLibraryyForCreateUpdate(INPUT DATASET dsLibraryy BY-REFERENCE, OUTPUT opcError) THEN  
            daLibraryy:UpdateLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).
        ELSE 
            UNDO, THROW NEW Progress.Lang.AppError(opcError).
            
    END METHOD.
    
   
   
    /*------------------------------------------------------------------------------
    Purpose: Deletes all the libraries from the given dataset and all of its agencies
    and, with them, all of theirs bookstocks and rents (if possible)
    @param   a dataset  
    ------------------------------------------------------------------------------*/   
    METHOD PUBLIC VOID DeleteLibraryy(INPUT-OUTPUT DATASET dsLibraryy):
        
        FOR EACH bttLibraryy WHERE 
            ROW-STATE(bttLibraryy) = ROW-DELETED:
            beLibraryAgency:ReadLibraryAgency(INPUT SUBSTITUTE("WHERE LibraryId = &1", QUOTER(bttLibraryy.LibraryId)),
                OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
            TEMP-TABLE ttLibraryAgency:TRACKING-CHANGES = TRUE.
            FOR EACH ttLibraryAgency: 
                DELETE ttLibraryAgency.
            END.
            TEMP-TABLE ttLibraryAgency:TRACKING-CHANGES = FALSE.
            beLibraryAgency:DeleteLibraryAgency(INPUT-OUTPUT DATASET dsLibraryAgency BY-REFERENCE).
        END.
        daLibraryy:DeleteLibraryy(INPUT-OUTPUT DATASET dsLibraryy BY-REFERENCE).
        
    END METHOD.
    
    

    /*------------------------------------------------------------------------------
     Purpose: Check if there exists a library in database with the given id
    @param    ipcLibraryId as char
    @return   true if the library exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindLibraryy(INPUT ipcLibraryId AS CHARACTER):
        
        RETURN daLibraryy:CanFindLibraryy(INPUT ipcLibraryId).
        
    END METHOD.
    
    
    
    
    /*------------------------------------------------------------------------------
    Purpose: Validates libraries for create or update
    @param    dsLibraryy as dataset
    @return   true if we allow the libraries to be created, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE LOGICAL ValidateLibraryyForCreateUpdate(INPUT DATASET dsLibraryy, OUTPUT opcError AS CHARACTER):      
        DEFINE BUFFER bufttLibrary FOR ttLibraryy.
        DEFINE VARIABLE lIsOk AS LOGICAL NO-UNDO INITIAL TRUE.
        
        FOR EACH bufttLibrary NO-LOCK WHERE ROW-STATE(bufttLibrary)= ROW-CREATED OR
            ROW-STATE(bufttLibrary) = ROW-MODIFIED:
            IF (NOT src.utils.ValidateClass:validateString(bufttLibrary.LibraryName)) THEN 
            DO:
                lIsOk = FALSE.
                opcError += "Library Name cannot be empty".
            END.
            IF (NOT src.utils.ValidateClass:validateString(bufttLibrary.Description))THEN 
            DO:
                opcError += "Description cannot be empty".
                lIsOk = FALSE.
            END.
            IF daLibraryy:ExistsAnotherRecordWithSameName(bufttLibrary.LibraryName, bufttLibrary.LibraryId) THEN
            DO:
                opcError += "There is already a library with this name!".
                lIsOk = FALSE.
            END.
        END.
        RETURN lIsOk.
        
    END METHOD.
    

END CLASS.