DEFINE TEMP-TABLE ttTopTen NO-UNDO
    BEFORE-TABLE bttTopTen
    FIELD Description AS CHARACTER 
    FIELD Number AS INTEGER 
    
    INDEX idxNumber IS PRIMARY Number DESCENDING
    .
