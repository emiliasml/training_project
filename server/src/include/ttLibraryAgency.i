
DEFINE TEMP-TABLE ttLibraryAgency NO-UNDO
    BEFORE-TABLE bttLibraryAgency
    FIELD LibraryAgencyId AS CHARACTER 
    FIELD LibraryAgencyName AS CHARACTER 
    FIELD LibraryId AS CHARACTER
    FIELD Address AS CHARACTER
    FIELD seq AS INTEGER 
    
    INDEX PKLibraryy IS PRIMARY UNIQUE seq
    INDEX LibraryAgencyId IS UNIQUE LibraryAgencyId
    .
