
/*------------------------------------------------------------------------
    File        : generate_encrypt_key.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Tue Aug 10 12:30:22 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE rBinaryKey AS RAW NO-UNDO.  
        
rBinaryKey = GENERATE-RANDOM-KEY.
                          
OUTPUT TO VALUE ('src/utils/encrypt_key.txt').

EXPORT rBinaryKey.
    
OUTPUT CLOSE.