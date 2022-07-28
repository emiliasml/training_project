 
/*------------------------------------------------------------------------
   File        : Validate
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 10 17:27:52 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.utils.ValidateClass:  
 
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC ValidateClass (  ):
        SUPER ().
        
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC ValidateClass ( ):

    END DESTRUCTOR.
    
    METHOD PUBLIC STATIC LOGICAL validateString(INPUT ipcString AS CHARACTER):
        
        RETURN ipcString NE "" OR ipcString NE ?.
        
    END METHOD.
    
     METHOD PUBLIC STATIC LOGICAL validateInteger(INPUT ipcInteger AS INTEGER):
        
        RETURN ipcInteger NE ?.
        
    END METHOD.
        
    METHOD PUBLIC STATIC LOGICAL validateDate(INPUT ipdaDate AS DATE):
        
        DEFINE VARIABLE daDate AS DATE NO-UNDO.
        
        daDate = DATE(ipdaDate) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN  
            RETURN FALSE.
        ELSE
            RETURN TRUE. 
    END METHOD.
        
    METHOD PUBLIC STATIC LOGICAL validateDates(INPUT ipdaDateBefore AS DATE, INPUT ipdaDateAfter AS DATE):
        
        RETURN ipdaDateBefore > ipdaDateAfter.
        
   END METHOD.

END CLASS.