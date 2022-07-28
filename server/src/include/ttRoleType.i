DEFINE TEMP-TABLE ttRoleType NO-UNDO
    BEFORE-TABLE bttRoleType
    FIELD RoleTypeId      AS CHARACTER FORMAT "x(36)"
    FIELD Description   AS CHARACTER FORMAT "x(60)"
    FIELD seq AS INTEGER 
    
    INDEX PKRoleType IS PRIMARY UNIQUE seq
    .
