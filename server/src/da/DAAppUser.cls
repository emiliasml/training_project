 
/*------------------------------------------------------------------------
   File        : DAAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 02 19:11:04 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

     
BLOCK-LEVEL ON ERROR UNDO, THROW.
ROUTINE-LEVEL ON ERROR UNDO, THROW.


CLASS src.da.DAAppUser INHERITS src.da.DAGeneric: 
    {src/include/dsAppUser.i} 
    
    CONSTRUCTOR PUBLIC DAAppUser():
        TableName = "AppUser".
        TempTableName = "ttAppUser".
    END CONSTRUCTOR. 

    DESTRUCTOR PUBLIC DAAppUser():
    END DESTRUCTOR.
   
    /*------------------------------------------------------------------------------
    Purpose: fills the dataset with the users that have roles on the given library
    @param   ipcAppUserId as char and a dataset 
    ------------------------------------------------------------------------------*/       
    METHOD PUBLIC VOID ReadUsersFromLibrary(INPUT ipcLibraryId AS CHARACTER, OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE iSeq AS INTEGER NO-UNDO.
        DATASET dsAppUser:EMPTY-DATASET ().
        
        DEFINE BUFFER bufAppUser FOR AppUser.
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        FOR EACH bufUserRole NO-LOCK 
            WHERE bufUserRole.LibraryId = ipcLibraryId OR bufUserRole.LibraryId = "all":
            FIND FIRST bufAppUser WHERE bufAppUser.AppUserId = bufUserRole.AppUserId NO-ERROR.
            IF AVAILABLE bufAppUser THEN DO:
                CREATE ttAppUser.
                BUFFER-COPY bufAppUser TO ttAppUser.
                iSeq = iSeq + 1.
                ASSIGN ttAppUser.seq = iSeq.
            END.
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Creates the users from the given dataset in the database
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.   
                
        DEFINE VARIABLE cEncryptedPassword AS CHARACTER NO-UNDO.
        
        FOR EACH ttAppUser NO-LOCK
            WHERE ROW-STATE(ttAppUser) = ROW-CREATED: 
            
            RUN src/proc/encrypt.p (INPUT ttAppUser.Password, OUTPUT cEncryptedPassword).
            
            CREATE bufAppUser.
            BUFFER-COPY ttAppUser EXCEPT AppUserId Password TO bufAppUser. 
            
            ASSIGN 
                bufAppUser.AppUserId = STRING(NEXT-VALUE(NextAppUserId))
                bufAppUser.Password = cEncryptedPassword.
                
            BUFFER-COPY ttAppUser EXCEPT AppUserId Password TO bufAppUser . 
        END.
    END METHOD.
     
    /*------------------------------------------------------------------------------
    Purpose: Updates the users from the given dataset in the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/ 
    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        DEFINE VARIABLE cEncryptedPassword AS CHARACTER NO-UNDO.
        
        FOR EACH ttAppUser NO-LOCK
            WHERE ROW-STATE(ttAppUser) = ROW-MODIFIED:
            
            FIND FIRST bufAppUser EXCLUSIVE-LOCK
                WHERE bufAppUser.AppUserId = ttAppUser.AppUserId NO-ERROR.
            
            IF AVAILABLE bufAppUser THEN DO:
                IF ttAppUser.Password = bufAppUser.Password THEN DO:
                    BUFFER-COPY ttAppUser EXCEPT AppUserId TO bufAppUser. 
                END.
                ELSE DO:
                    RUN src/proc/encrypt.p (INPUT ttAppUser.Password, OUTPUT cEncryptedPassword).
                
                    BUFFER-COPY ttAppUser EXCEPT AppUserId Password TO bufAppUser. 
                
                    ASSIGN bufAppUser.Password = cEncryptedPassword.
                END.    
            END.       
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the app user").
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Deletes the users from the given dataset from the database 
    @param   a dataset  
    ------------------------------------------------------------------------------*/     
    METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FOR EACH bttAppUser NO-LOCK
            WHERE ROW-STATE(bttAppUser) = ROW-DELETED:
            
            FIND FIRST bufAppUser EXCLUSIVE-LOCK
                WHERE bufAppUser.AppUserId = bttAppUser.AppUserId NO-ERROR.
                    
            IF AVAILABLE bufAppUser THEN
                DELETE bufAppUser.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the app user").
        END.
    END METHOD.   
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a user with the given username and password exists
    @param    ipcUserName as char, ipcPassword as char and a dataset with the 
    user if it exists
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID Login(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):       
        DEFINE BUFFER bufAppUser FOR AppUser.
          
        DEFINE VARIABLE cEncryptedPassword AS CHARACTER NO-UNDO.
        
        FOR EACH bufAppUser NO-LOCK
            WHERE bufAppUser.UserName = ipcUserName :
            IF AVAILABLE bufAppUser THEN DO:
                IF COMPARE(bufAppUser.UserName, "=" , ipcUserName, "CASE-SENSITIVE") THEN DO:
                
                    RUN src/proc/encrypt.p (INPUT ipcPassword, OUTPUT cEncryptedPassword).
                
                    IF bufAppUser.Password = cEncryptedPassword THEN DO:
                        CREATE ttAppUser.
                        BUFFER-COPY bufAppUser TO ttAppUser.
                    END.
                END.
            END.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Cannot find the app user").
        END.
    END METHOD.
     
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a user with the given id exists
    @param    ipcAppUserId as char
    @return   true if the user exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindAppUser(INPUT ipcAppUserId AS CHARACTER):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        RETURN CAN-FIND(FIRST bufAppUser NO-LOCK
            WHERE bufAppUser.AppUserId = ipcAppUserId).
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose:  Checks if a user with the given username but different id than 
    the given one exists
    @param    ipcUserName as char, ipcAppUserId as char
    @return   true if the user exists, false otherwise
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL CanFindAppUserByUserName(INPUT ipcUserName AS CHARACTER, INPUT ipcAppUserId AS CHARACTER):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        RETURN CAN-FIND(FIRST bufAppUser NO-LOCK
            WHERE bufAppUser.UserName = ipcUserName AND bufAppUser.AppUserId NE ipcAppUserId).
    END METHOD.
END CLASS.
