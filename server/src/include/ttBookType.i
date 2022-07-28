
/*------------------------------------------------------------------------
    File        : ttBookType.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 17:54:24 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttBookType NO-UNDO
    BEFORE-TABLE bttBookType
    FIELD BookTypeId AS CHARACTER
    FIELD Description AS CHARACTER
    FIELD seq AS INTEGER
    FIELD id AS CHARACTER
    
    INDEX idxBookType IS UNIQUE BookTypeId
    INDEX seq IS PRIMARY UNIQUE seq.