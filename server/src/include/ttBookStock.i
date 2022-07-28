
/*------------------------------------------------------------------------
    File        : BookStock.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 17:56:12 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttBookStock NO-UNDO
    BEFORE-TABLE bttBookStock
    FIELD BookStockId AS CHARACTER
    FIELD BookId AS CHARACTER
    FIELD LibraryAgencyId AS CHARACTER
    FIELD StockAmount AS INTEGER
    FIELD ValidFrom AS DATE
    FIELD ValidTo AS DATE
    FIELD seq AS INTEGER
    FIELD id AS CHARACTER
    
    INDEX idxBookStock IS UNIQUE BookStockId
    INDEX seq IS PRIMARY UNIQUE seq.