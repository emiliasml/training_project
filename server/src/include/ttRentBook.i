
/*------------------------------------------------------------------------
    File        : ttRentBook.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 21:06:57 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttRentBook NO-UNDO
    BEFORE-TABLE bttRentBook
    FIELD RentBookId AS CHARACTER FORMAT "x(36)"
    FIELD RentId   AS CHARACTER FORMAT "x(36)"
    FIELD BookId   AS CHARACTER FORMAT "x(36)"
    FIELD seq AS INTEGER 
    
    INDEX PKRentBookId IS PRIMARY UNIQUE seq.