
/*------------------------------------------------------------------------
    File        : ttBook.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 16:38:10 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttBook NO-UNDO
    BEFORE-TABLE bttBook
    FIELD BookId AS CHARACTER
    FIELD BookTypeId AS CHARACTER
    FIELD Author AS CHARACTER
    FIELD BookTitle AS CHARACTER
    FIELD Publisher AS CHARACTER
    FIELD seq AS INTEGER
    FIELD id AS CHARACTER
    
    INDEX idxBook IS UNIQUE BookId
    INDEX seq IS PRIMARY UNIQUE seq.