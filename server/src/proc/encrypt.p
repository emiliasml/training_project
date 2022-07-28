
/*------------------------------------------------------------------------
    File        : encrypt.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 09 19:17:48 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE INPUT PARAMETER ipcText      AS CHARACTER NO-UNDO.
DEFINE VARIABLE rBinaryKey      AS RAW       NO-UNDO.
DEFINE VARIABLE rEncryptedValue AS RAW       NO-UNDO.
DEFINE OUTPUT PARAMETER cEncryptedText  AS CHARACTER NO-UNDO.

FILE-INFO:FILE-NAME = "src/utils/encrypt_key.txt".

INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
        
IMPORT rBinaryKey.
        
INPUT CLOSE.

ASSIGN
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "AES_OFB_128"
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = rBinaryKey
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV = ?
    rEncryptedValue = ENCRYPT (ipcText)
    cEncryptedText = BASE64-ENCODE(rEncryptedValue).