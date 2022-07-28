 
/*------------------------------------------------------------------------
   File        : BECSVReports
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Fri Aug 13 16:30:12 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BECSVReports: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    {src/include/dsTopTen.i}
    
    DEFINE VARIABLE daCSVReports AS src.da.DACSVReports.
     
    CONSTRUCTOR PUBLIC BECSVReports (  ):
        daCSVReports = NEW src.da.DACSVReports(). 
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BECSVReports ( ):
        DELETE OBJECT daCSVReports NO-ERROR.
    END DESTRUCTOR. 
    
    METHOD PUBLIC VOID TopTen(INPUT ipcTopTen AS CHARACTER, INPUT iplSendCSV AS LOGICAL, OUTPUT DATASET dsTopTen):
        IF ipcTopTen = "TopTenBooks" THEN 
            daCSVReports:TopTenBooks(INPUT iplSendCSV,OUTPUT DATASET dsTopTen BY-REFERENCE).
        IF ipcTopTen = "TopTenRentedBooks" THEN 
            daCSVReports:TopTenRentedBooks(INPUT iplSendCSV, OUTPUT DATASET dsTopTen BY-REFERENCE).
        IF ipcTopTen = "TopTenActiveUsers" THEN 
            daCSVReports:TopTenActiveUsers(INPUT iplSendCSV, OUTPUT DATASET dsTopTen BY-REFERENCE).
        IF ipcTopTen = "TopTenLibrariesByUsers" THEN 
            daCSVReports:TopTenLibrariesByUsers(INPUT iplSendCSV, OUTPUT DATASET dsTopTen BY-REFERENCE).
    END METHOD.

END CLASS.