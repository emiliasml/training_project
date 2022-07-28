DEFINE TEMP-TABLE ttLibraryUserRole NO-UNDO 
    BEFORE-TABLE bttLibraryUserRole
    FIELD LibraryId         AS CHARACTER 
    FIELD LibraryName       AS CHARACTER
    FIELD AppUserId         AS CHARACTER
    FIELD RoleDescription   AS CHARACTER.