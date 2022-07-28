
/*------------------------------------------------------------------------
    File        : populate.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 18:00:45 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
CREATE Book.
ASSIGN
    Book.BookId = STRING(NEXT-VALUE(NextBookId))
    Book.BookTypeId = "1"
    Book.Author = "J.R.R. Tolkien"
    Book.BookTitle = "The Lord of the Rings"
    Book.Publisher = "Allen & Unwin".
    
    
CREATE BookType.
ASSIGN
    BookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId))
    BookType.Description = "Epic high fantasy novel".

CREATE BookStock. 
ASSIGN 
    BookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId))
    BookStock.BookId = "1"
    BookStock.LibraryAgencyId = "1"
    BookStock.StockAmount = 10
    BookStock.ValidFrom = 07/21/2021
    BookStock.ValidTo = 08/30/2021.
    
    
//////////////////////////////////////
    

CREATE Book.
ASSIGN
    Book.BookId = STRING(NEXT-VALUE(NextBookId))
    Book.BookTypeId = "2"
    Book.Author = "John Green"
    Book.BookTitle = "Looking for Alaska"
    Book.Publisher = "Dutton Juvenile".
    
    
CREATE BookType.
ASSIGN
    BookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId))
    BookType.Description = "Young adult novel".

CREATE BookStock. 
ASSIGN 
    BookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId))
    BookStock.BookId = "2"
    BookStock.LibraryAgencyId = "2"
    BookStock.StockAmount = 50
    BookStock.ValidFrom = 08/21/2006
    BookStock.ValidTo = 01/08/2008.
    
    
//////////////////////////////////////
    

CREATE Book.
ASSIGN
    Book.BookId = STRING(NEXT-VALUE(NextBookId))
    Book.BookTypeId = "3"
    Book.Author = "Veronica Roth"
    Book.BookTitle = "Divergent"
    Book.Publisher = "Katherine Tegen Books".
    
    
CREATE BookType.
ASSIGN
    BookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId))
    BookType.Description = "Science fiction".

CREATE BookStock. 
ASSIGN 
    BookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId))
    BookStock.BookId = "3"
    BookStock.LibraryAgencyId = "3"
    BookStock.StockAmount = 70
    BookStock.ValidFrom = 09/21/2011
    BookStock.ValidTo = 04/05/2013.
    
    
//////////////////////////////////////
    

CREATE Book.
ASSIGN
    Book.BookId = STRING(NEXT-VALUE(NextBookId))
    Book.BookTypeId = "4"
    Book.Author = "Jojo Moyes"
    Book.BookTitle = "Me Before You"
    Book.Publisher = "Michael Joseph".
    
    
CREATE BookType.
ASSIGN
    BookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId))
    BookType.Description = "Romance Fiction".

CREATE BookStock. 
ASSIGN 
    BookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId))
    BookStock.BookId = "4"
    BookStock.LibraryAgencyId = "4"
    BookStock.StockAmount = 5
    BookStock.ValidFrom = 03/30/2016
    BookStock.ValidTo = 04/02/2016.
    
    
//////////////////////////////////////
    

CREATE Book.
ASSIGN
    Book.BookId = STRING(NEXT-VALUE(NextBookId))
    Book.BookTypeId = "5"
    Book.Author = "Michelle Obama"
    Book.BookTitle = "Becoming"
    Book.Publisher = "Michael Joseph".
    
    
CREATE BookType.
ASSIGN
    BookType.BookTypeId = STRING(NEXT-VALUE(NextBookTypeId))
    BookType.Description = "Memoir".

CREATE BookStock. 
ASSIGN 
    BookStock.BookStockId = STRING(NEXT-VALUE(NextBookStockId))
    BookStock.BookId = "5"
    BookStock.LibraryAgencyId = "5"
    BookStock.StockAmount = 15
    BookStock.ValidFrom = 03/12/2018
    BookStock.ValidTo = 04/22/2019.
