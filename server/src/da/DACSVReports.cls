 
/*------------------------------------------------------------------------
   File        : DACSVReports
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Fri Aug 13 16:29:59 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DACSVReports: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsTopTen.i}
    CONSTRUCTOR PUBLIC DACSVReports (  ):
        SUPER ().
        OS-CREATE-DIR VALUE(SESSION:TEMP-DIRECTORY + "reports").
        
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DACSVReports ( ):

    END DESTRUCTOR. 
    
    METHOD PUBLIC VOID TopTenBooks(INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
        DEFINE VARIABLE iBookType AS INTEGER NO-UNDO.
        DEFINE VARIABLE iBooks AS INTEGER NO-UNDO.
        DEFINE VARIABLE iFirstTen AS INTEGER NO-UNDO.
        DEFINE BUFFER bufBook  FOR Book.
        DEFINE BUFFER bufBookType  FOR BookType.

        DATASET dsTopTen:EMPTY-DATASET ().
        
        FOR EACH bufBookType NO-LOCK:
            iBooks = 0.
            FOR EACH bufBook NO-LOCK 
                WHERE bufBookType.BookTypeId = bufBook.BookTypeId:
                iBooks = iBooks + 1.
            END.
            CREATE ttTopTen.
            ASSIGN ttTopTen.Description = "Book Type: " + bufBookType.Description 
                ttTopTen.Number = iBooks.  
        END.
        
        IF iplSendCSV THEN 
        DO:
            OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "reports\TopTenBooks" + STRING(DAY(TODAY)) + "_" + STRING(MONTH(TODAY)) + "_" + STRING(YEAR(TODAY)) + ".csv").
            PUT UNFORMATTED "Book Type,Number of Books" SKIP.
        END.
        FOR EACH ttTopTen:
            iFirstTen = iFirstTen + 1.
            IF iFirstTen <= 10 AND iplSendCSV THEN 
                EXPORT DELIMITER "," ttTopTen.Description ttTopTen.Number SKIP.
            IF iFirstTen > 10 THEN 
                DELETE ttTopTen.
        END.
        FINALLY:
            IF iplSendCSV THEN
                OUTPUT CLOSE.
        END.
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Sends the dataset filled with 10 books that are the most rented and, 
    if the parameter iplSendCSV is true, then it also creates and saves a CSV file
    @param   a dataset and a parameter 
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID TopTenRentedBooks(INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
    
        DEFINE BUFFER bBook FOR Book.
        DEFINE BUFFER bRentBook FOR RentBook.
        DEFINE BUFFER bBookType FOR BookType.
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE nrRents AS INTEGER NO-UNDO.
        DEFINE VARIABLE dtDate AS DATETIME.
        DEFINE VARIABLE cDate AS CHARACTER EXTENT 3.

        DATASET dsTopTen:EMPTY-DATASET ().

        FOR EACH bBook NO-LOCK:
            nrRents = 0.

            FOR EACH bRentBook NO-LOCK
                WHERE bRentBook.BookId = bBook.BookId:
                nrRents += 1.
            END.

            FOR FIRST bBookType NO-LOCK
                WHERE bBookType.BookTypeId = bBook.BookTypeId:

                CREATE ttTopTen.
                ASSIGN ttTopTen.Number = nrRents
                    ttTopTen.Description = "Title: " + bBook.BookTitle + " | Author: " + bBook.Author + " | Type: " + bBookType.Description.
            END.
        END.
        
        //if the iplSendCSV is true, we create a csv file
        IF iplSendCSV THEN 
        DO:
        //get the current hour and minute for the name of the csv
            dtDate  = DATETIME( TODAY, MTIME ).
            cDate[1] = SUBSTRING(STRING( INTEGER( TRUNCATE( MTIME( dtDate) / 1000, 0 ) ), "HH:MM:SS" ), 1, 2).
            cDate[2] = SUBSTRING(STRING( INTEGER( TRUNCATE( MTIME( dtDate) / 1000, 0 ) ), "HH:MM:SS" ), 4, 2).
        
            OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY 
                + "reports\TopTenRentedBooks" 
                + STRING(YEAR(dtDate)) + "_" 
                + STRING(MONTH(dtDate)) + "_" 
                + STRING(DAY(dtDate)) + "_"  
                + cDate[1] + "-"
                + cDate[2] + ".csv").
            
            PUT UNFORMATTED "Nr, Description" SKIP.
        END.
        
        iIndex = 0.
        FOR EACH ttTopTen:
            IF iIndex < 10 THEN DO:
                //if the iplSendCSV is true, we export the record
                IF iplSendCSV THEN
                    EXPORT DELIMITER "," ttTopTen.Number ttTopTen.Description SKIP.
                iIndex += 1.
            END.
            ELSE
                DELETE ttTopTen.
        END.
        FINALLY:
            //if the iplSendCSV is true, we close the output, otherwise we have nothing to close
            IF iplSendCSV THEN
                OUTPUT CLOSE.
        END FINALLY.

    END METHOD.
    
    METHOD PUBLIC VOID TopTenActiveUsers(INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
        
        DEFINE VARIABLE daRent AS src.da.DARent NO-UNDO.
       
        DEFINE VARIABLE iNrOfRents AS INTEGER NO-UNDO.
        DEFINE VARIABLE iNrOfRecords AS INTEGER NO-UNDO.
        DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
        DEFINE BUFFER bufAppUser FOR AppUser.

        daRent =  NEW src.da.DARent().
      
        DATASET dsTopTen:EMPTY-DATASET ().
         
       
        
        FOR EACH bufAppUser NO-LOCK:
            iNrOfRents = daRent:getNumberOfRents(bufAppUser.AppUserId).
            
            CREATE ttTopTen.
            ASSIGN ttTopTen.Number = iNrOfRents
                ttTopTen.Description = "Name: " + bufAppUser.Name + " | Username: " + bufAppUser.UserName.
        
        END.
        
        IF iplSendCSV THEN 
        DO:
            cFileName = SESSION:TEMP-DIRECTORY + "reports\TopTenActiveUsers" + STRING(DAY(TODAY)) + "_" + STRING(MONTH(TODAY)) + "_" + STRING(YEAR(TODAY)) + ".csv".
        
            DISPLAY cFileName FORMAT "x(60)".
        
            OUTPUT  TO  VALUE (cFilename).
            EXPORT DELIMITER "," "Name" "Number of rents".
        END.
        
        FOR EACH ttTopTen BY ttTopTen.Number DESCENDING:
            
            IF iNrOfRecords < 10 AND iplSendCSV THEN DO:
                EXPORT DELIMITER "," ttTopTen.Description ttTopTen.Number.
            END.
            iNrOfRecords =  1 + iNrOfRecords.
            IF iNrOfRecords > 10 THEN DO:
                DELETE ttTopTen.
                
            END.
           
        END.
        
        
        FINALLY:
            IF iplSendCSV THEN 
                OUTPUT CLOSE.
            DELETE OBJECT daRent NO-ERROR.  
        END FINALLY.
        
    END METHOD.
    
    
    
    METHOD PUBLIC VOID TopTenLibrariesByUsers(INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
        DEFINE VARIABLE iUsers AS INTEGER NO-UNDO.
        DEFINE VARIABLE iAgencies AS INTEGER NO-UNDO.
        DEFINE VARIABLE iFirstTen AS INTEGER NO-UNDO.
        DEFINE BUFFER bufRoleType  FOR RoleType.
        DEFINE BUFFER bufUserRole  FOR UserRole.
        DEFINE BUFFER bufLibraryy  FOR Libraryy.
        DEFINE BUFFER bufLibraryAgency  FOR LibraryAgency.
        
        DATASET dsTopTen:EMPTY-DATASET ().
        
        FOR EACH bufLibraryy NO-LOCK:
            iUsers = 0.
            iAgencies = 0.
            
            FOR EACH bufLibraryAgency NO-LOCK
                WHERE bufLibraryAgency.LibraryId = bufLibraryy.LibraryId:
                iAgencies = iAgencies + 1.
            END.
            
            FOR EACH bufUserRole NO-LOCK 
                WHERE bufUserRole.LibraryId = bufLibraryy.LibraryId:
                iUsers = iUsers + 1.
            END. 
             
            CREATE ttTopTen.
            ASSIGN ttTopTen.Description = "LibraryName: " + bufLibraryy.LibraryName + " | Number of Agencies: " + string(iAgencies)
                ttTopTen.Number = iUsers.
            
        END.
        
        IF iplSendCSV THEN
        DO:
            OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "reports\TopTenLibrariesByUsers" + STRING(DAY(TODAY)) + "_" + STRING(MONTH(TODAY)) + "_" + STRING(YEAR(TODAY)) + ".csv").
            PUT UNFORMATTED "LibraryName,Number of Agencies,Number of Users" SKIP.
        END.
        FOR EACH ttTopTen:
            iFirstTen = iFirstTen + 1.
            IF iFirstTen <= 10 AND iplSendCSV THEN 
                EXPORT DELIMITER "," ttTopTen.Description ttTopTen.Number SKIP.
            IF iFirstTen > 10 THEN 
                DELETE ttTopTen.
        END.
        FINALLY:
            IF iplSendCSV THEN
                OUTPUT CLOSE.
        END.
    END METHOD.

END CLASS.