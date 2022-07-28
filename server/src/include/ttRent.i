
/*------------------------------------------------------------------------
    File        : ttRent.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 21:02:16 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttRent NO-UNDO
    BEFORE-TABLE bttRent
    FIELD RentId AS CHARACTER FORMAT "x(36)"
    FIELD AppUserId   AS CHARACTER FORMAT "x(36)"
    FIELD LibraryAgencyId   AS CHARACTER FORMAT "x(36)"
    FIELD DateFrom   AS DATE 
    FIELD DateTo   AS DATE 
    FIELD RentStatus   AS INTEGER 
    FIELD seq AS INTEGER 
    
    INDEX PKRentId IS PRIMARY UNIQUE seq.
