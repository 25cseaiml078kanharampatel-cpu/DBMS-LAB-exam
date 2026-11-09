/*
====================================================================
DEPARTMENT OF COMPUTER SCIENCE & ENGINEERING
B.Tech AIML — 3rd Semester | DBMS Lab Examination
SET A Solutions [Total: 20 Marks]
====================================================================
*/

-- =================================================================
-- PREREQUISITE TABLES (Referenced by Enrollments)
-- =================================================================
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    branch VARCHAR(50) NOT NULL
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);


-- =================================================================
-- QUESTION 1 [4 Marks]
-- Create the table Enrollments(enroll_id INT, student_id INT, course_id INT, marks INT) 
-- with enroll_id as Primary Key, Foreign Keys referencing Students(student_id) 
-- and Courses(course_id), and a CHECK constraint ensuring marks is between 0 and 100.
-- =================================================================

CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT chk_marks_range CHECK (marks >= 0 AND marks <= 100)
    -- Alternative: CHECK (marks BETWEEN 0 AND 100)
);


-- =================================================================
-- QUESTION 2 [3 Marks]
-- Write a query to display all students from the 'AIML' branch whose names start 
-- with the letter 'A' or 'S'.
-- =================================================================

SELECT *
FROM Students
WHERE branch = 'AIML'
  AND (student_name LIKE 'A%' OR student_name LIKE 'S%');


-- =================================================================
-- QUESTION 3 [4 Marks]
-- Write an SQL query to retrieve student_name, course_name, and marks 
-- for all students who scored more than 75 marks.
-- =================================================================

SELECT 
    s.student_name,
    c.course_name,
    e.marks
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE e.marks > 75;


-- =================================================================
-- QUESTION 4 [4 Marks]
-- Find the average marks obtained in each course. Display course_name 
-- and Average_Marks, but only include courses where the average mark 
-- is strictly greater than 60.
-- =================================================================

SELECT 
    c.course_name,
    AVG(e.marks) AS Average_Marks
FROM Courses c
INNER JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING AVG(e.marks) > 60;


-- =================================================================
-- QUESTION 5 [5 Marks]
-- Write an SQL query using a subquery to find the name of the student(s) 
-- who scored the highest marks in the course 'Machine Learning'.
-- =================================================================

SELECT s.student_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Machine Learning'
  AND e.marks = (
      SELECT MAX(e2.marks)
      FROM Enrollments e2
      INNER JOIN Courses c2 ON e2.course_id = c2.course_id
      WHERE c2.course_name = 'Machine Learning'
  );
