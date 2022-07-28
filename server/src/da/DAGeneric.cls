 
 /*------------------------------------------------------------------------
    File        : DAGeneric
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Jul 27 12:00:41 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PROTECTED PROPERTY TableName AS CHARACTER NO-UNDO
        PROTECTED GET.
        PROTECTED SET.
        
    DEFINE PROTECTED PROPERTY TempTableName AS CHARACTER NO-UNDO
        PROTECTED GET.
        PROTECTED SET.
        
    CONSTRUCTOR PUBLIC DAGeneric (  ):
        SUPER ().
        
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DAGeneric ( ):

    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadGeneric(INPUT cWhere AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET-HANDLE dsHandle):
        DEFINE VARIABLE hTable AS HANDLE NO-UNDO.
        DEFINE VARIABLE hTempTable AS HANDLE NO-UNDO.
        DEFINE VARIABLE hBuff AS HANDLE NO-UNDO.
        DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
        
        DEFINE VARIABLE iRows AS INTEGER NO-UNDO.
        
        dsHandle:EMPTY-DATASET ().
        
        CREATE BUFFER hBuff FOR TABLE TableName.
        CREATE BUFFER hTempTable FOR TABLE dsHandle:GET-BUFFER-HANDLE(TempTableName).
        
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS (hBuff).
        hQuery:QUERY-PREPARE (SUBSTITUTE("FOR EACH &1 NO-LOCK &2 :", TableName, cWhere)).
        hQuery:QUERY-OPEN ().
        
        hQuery:REPOSITION-TO-ROW (iSkipRows + 1).
        hQuery:GET-NEXT (NO-LOCK).
        iRows = iRows + 1.
        
        REPEAT:
            IF hQuery:QUERY-OFF-END THEN
                LEAVE.  
            IF iMaxRows <> 0 THEN
                IF iRows > iMaxRows THEN 
                    LEAVE.
            
            hTempTable:BUFFER-CREATE ().
            hTempTable:BUFFER-COPY (hBuff).
            hTempTable:BUFFER-FIELD("seq"):BUFFER-VALUE = iRows. 
            
            hQuery:GET-NEXT (NO-LOCK).
            iRows = iRows + 1.
        END.
        
        hQuery:QUERY-CLOSE ().
         CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
            VIEW-AS ALERT-BOX.
        END CATCH.
        FINALLY:
            DELETE OBJECT hBuff NO-ERROR.
            DELETE OBJECT hTempTable NO-ERROR.
            DELETE OBJECT hTable NO-ERROR.
            DELETE OBJECT hQuery NO-ERROR.
        END FINALLY.
        
      
    END METHOD.
    
    METHOD PUBLIC VOID CountGeneric(INPUT cWhere AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE hTable AS HANDLE NO-UNDO.
        DEFINE VARIABLE hBuff AS HANDLE NO-UNDO.
        DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
        
        CREATE BUFFER hBuff FOR TABLE TableName.
        
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS (hBuff).
        hQuery:QUERY-PREPARE (SUBSTITUTE("PRESELECT EACH &1 NO-LOCK &2:", TableName, cWhere)).
        hQuery:QUERY-OPEN ().
        
        numRecs = hQuery:NUM-RESULTS.
        
        hQuery:QUERY-CLOSE ().
        
        FINALLY:
            DELETE OBJECT hBuff NO-ERROR.
            DELETE OBJECT hTable NO-ERROR.
            DELETE OBJECT hQuery NO-ERROR.
        END FINALLY.     
    END METHOD. 

END CLASS.