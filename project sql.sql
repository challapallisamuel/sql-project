CREATE DATABASE P1;
USE P1;
SELECT * FROM publisher;
SELECT * FROM library_branch;
SELECT * FROM borrower;
SELECT * FROM books;
SELECT * FROM book_loans;
SELECT * FROM book_copies;
SELECT * FROM authors;

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? 
  
SELECT sum(bc.book_copies_No_Of_Copies) as total_copies
FROM book_copies bc , books b, library_branch lb
WHERE b.book_Title = 'The Lost Tribe'
  AND lb.library_branch_BranchName = 'Sharpstown';
  
-- 2.how many copies of the book titled "The Lost Tribe" are owned by each library branch? 

SELECT bc.book_copies_BranchID AS Branch, SUM(bc.book_copies_No_Of_Copies) AS Total_Copies
FROM book_copies bc
JOIN books b ON bc.ï»¿book_copies_BookID = b.ï»¿book_BookID
WHERE b.book_Title LIKE '%Lost Tribe%'
GROUP BY bc.book_copies_BranchID;

-- 3. Retrieve the names of all borrowers who do not have any books checked out. 

SELECT borrower_BorrowerName
FROM borrower
WHERE borrower_CardNo NOT IN (SELECT book_loans_CardNo FROM book_loans);

-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

SELECT
  (SELECT b.book_Title 
   FROM books b 
   WHERE b.ï»¿book_BookID = bl.ï»¿book_loans_BookID) AS BookTitle,
  (SELECT br.borrower_BorrowerName 
   FROM borrower br 
   WHERE br.borrower_CardNo = bl.book_loans_CardNo) AS BorrowerName,
  (SELECT br.borrower_BorrowerAddress 
   FROM borrower br 
   WHERE br.borrower_CardNo = bl.book_loans_CardNo) AS BorrowerAddress
FROM book_loans bl
WHERE bl.book_loans_BranchID = 'Sharpstown'
  AND bl.book_loans_DueDate = '2018-02-03';

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch. 

SELECT 
    bl.book_loans_BranchID AS BranchName,
    COUNT(*) AS TotalBooksLoaned
FROM book_loans bl
GROUP BY bl.book_loans_BranchID;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out. 

SELECT 
    br.borrower_BorrowerName AS Name,
    br.borrower_BorrowerAddress AS Address,
    COUNT(bl.ï»¿book_loans_BookID) AS BooksCheckedOut
FROM borrower br
JOIN book_loans bl
    ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING COUNT(bl.ï»¿book_loans_BookID) > 5;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select book_Title from books b,library_branch lb,authors a,
(select book_copies_No_Of_Copies from book_copies bc where lb.library_branch_BranchName = 'Central' ) as no_of_copies
where a.book_authors_AuthorName = 'Stephen King';
  
  SELECT b.book_Title,
(SELECT bc.book_copies_No_Of_Copies FROM book_copies bc WHERE bc.ï»¿book_copies_BookID = b.ï»¿book_BookID AND bc.book_copies_BranchID = 'Central' LIMIT 1) AS CopiesOwned
FROM books b
WHERE b.ï»¿book_BookID IN ( SELECT a.ï»¿book_authors_BookID FROM authors a WHERE a.book_authors_AuthorName = 'Stephen King'
);