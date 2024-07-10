CREATE DATABASE Library;
USE Library;

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    publication_year INT,
    isbn VARCHAR(20),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100),
    nationality VARCHAR(50)
);


INSERT INTO authors (author_id, author_name, nationality)
VALUES
    (1, 'Jane Austen', 'British'),
    (2, 'Fyodor Dostoevsky', 'Russian'),
    (3, 'Ernest Hemingway', 'American'),
    (4, 'Leo Tolstoy', 'Russian'),
    (5, 'Charles Dickens', 'British'),
    (6, 'Mark Twain', 'American'),
    (7, 'Gabriel Garcia Marquez', 'Colombian'),
    (8, 'Agatha Christie', 'British'),
    (9, 'Haruki Murakami', 'Japanese'),
    (10, 'J.K. Rowling', 'British'),
    (11, 'George Orwell', 'British'),
    (12, 'Toni Morrison', 'American'),
    (13, 'J.R.R. Tolkien', 'British'),
    (14, 'Virginia Woolf', 'British'),
    (15, 'Albert Camus', 'French');

INSERT INTO books (book_id, title, author_id, publication_year, isbn)
VALUES
    (1, 'Pride and Prejudice', 1, 1813, '9780141439518'),
    (2, 'Crime and Punishment', 2, 1866, '9780143107637'),
    (3, 'The Old Man and the Sea', 3, 1952, '9780684801223'),
    (4, 'War and Peace', 4, 1869, '9781427030202'),
    (5, 'Great Expectations', 5, 1861, '9780141439563'),
    (6, 'The Adventures of Huckleberry Finn', 6, 1884, '9780486280615'),
    (7, 'One Hundred Years of Solitude', 7, 1967, '9780060883287'),
    (8, 'Murder on the Orient Express', 8, 1934, '9780062073501'),
    (9, 'Norwegian Wood', 9, 1987, '9780375704024');

SELECT * FROM books;
SELECT * FROM authors;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM authors INNER JOIN books ON  authors.author_id = books.author_id;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM authors LEFT JOIN books ON  authors.author_id = books.author_id;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM books RIGHT JOIN authors ON  books.author_id = authors.author_id;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM books LEFT JOIN authors ON books.author_id = authors.author_id;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM books RIGHT JOIN authors ON books.author_id = authors.author_id;

SELECT books.title,books.publication_year,authors.author_name,authors.nationality 
FROM books LEFT JOIN authors ON books.author_id = authors.author_id;


-- FULL JOIN (JUST USE UNION)

SELECT books.title,books.publication_year,author_name,authors.nationality FROM books LEFT JOIN authors ON books.author_id = authors.author_id 
UNION
SELECT books.title,books.publication_year,author_name,authors.nationality FROM books RIGHT JOIN authors ON books.author_id = authors.author_id;


-- INNER JOIN: Selects records that have matching values in both tables.

-- LEFT JOIN (LEFT OUTER JOIN): Selects all records from the left table and the matched records from the right table,
-- unmatched records from the right table will have NULLs.

-- RIGHT JOIN (RIGHT OUTER JOIN): Selects all records from the right table and the matched records from the left table,
-- unmatched records from the left table will have NULLs.

-- FULL JOIN (FULL OUTER JOIN): Not directly available in some SQL databases,
-- can be simulated by combining LEFT JOIN and RIGHT JOIN using UNION.