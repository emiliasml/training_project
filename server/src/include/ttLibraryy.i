 
DEFINE TEMP-TABLE ttLibraryy NO-UNDO 
    BEFORE-TABLE bttLibraryy
    FIELD LibraryId AS CHARACTER 
    FIELD LibraryName AS CHARACTER
    FIELD Description AS CHARACTER SERIALIZE-NAME "Description" 
    FIELD seq AS INTEGER 
    
    INDEX PKLibraryy IS PRIMARY UNIQUE seq
    INDEX LibraryId IS UNIQUE LibraryId.