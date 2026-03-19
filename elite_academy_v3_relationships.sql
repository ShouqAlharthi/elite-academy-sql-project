/* Project: Elite Academy - Level 3 (Relationships & Advanced SQL)
   Author: Shouq Alharthi
   Description: Implementing table relationships, stored procedures, views, and indexing
                to enhance database structure and querying capabilities.
   Version: 3
*/

-- 1. Database Usage
USE elite_academy;

-- 2. Teacher-Student Relationship (Many-to-Many)
-- Creating a junction table to connect teachers and students
-- A teacher can teach multiple students and a student can have multiple teachers
CREATE TABLE teacher_students (
    teacher_id INT,
    student_id INT,

    -- Composite primary key to prevent duplicate relationships
    PRIMARY KEY (teacher_id, student_id),

    -- Foreign key references
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Sample relationship data
INSERT INTO teacher_students (teacher_id, student_id)
VALUES
(1,1),
(1,2),
(2,1),
(2,3),
(3,2);

-- 3. Subject-Teacher Relationship (One-to-Many)
-- A teacher teaches only one subject
-- A subject can be taught by multiple teachers
ALTER TABLE teachers
ADD subject_id INT;

-- Linking teachers table with subjects table
ALTER TABLE teachers
ADD CONSTRAINT fk_teacher_subject
FOREIGN KEY (subject_id)
REFERENCES subjects(subject_id);

-- Assigning subjects to teachers
UPDATE teachers
SET subject_id = 1
WHERE teacher_id = 1;

UPDATE teachers
SET subject_id = 2
WHERE teacher_id = 2;

UPDATE teachers
SET subject_id = 3
WHERE teacher_id = 3;

-- 4. Student-Subject Relationship (Many-to-Many)
-- Creating a junction table representing subjects studied by students
-- A student can study multiple subjects and a subject can have multiple students
CREATE TABLE student_subjects (
    student_id INT,
    subject_id INT,

    -- Composite primary key
    PRIMARY KEY (student_id, subject_id),

    -- Foreign key references
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Sample enrollment data
INSERT INTO student_subjects (student_id, subject_id)
VALUES
(1,1),
(1,2),
(2,1),
(3,3),
(4,2);

-- 5. Stored Procedure Creation
-- Procedure Name: student_info
-- Purpose: Display student names along with the subjects they study
DELIMITER //

CREATE PROCEDURE student_info()
BEGIN

SELECT 
    s.student_name AS student,
    sub.subject_name AS subject

FROM students s

JOIN student_subjects ss
ON s.student_id = ss.student_id

JOIN subjects sub
ON ss.subject_id = sub.subject_id;

END //

DELIMITER ;

-- 6. Procedure Execution
-- Calling the stored procedure to display student-subject relationships
CALL student_info();

-- 7. View Creation
-- View Name: teacher_info
-- Purpose: Display teacher name, office number, and subject taught
CREATE VIEW teacher_info AS

SELECT
    t.teacher_name AS teacher,
    t.office_number AS office_number,
    s.subject_name AS subject

FROM teachers t

JOIN subjects s
ON t.subject_id = s.subject_id;

-- 8. View Display
-- Retrieving data from the teacher_info view
SELECT * FROM teacher_info;

-- 9. View Removal
DROP VIEW teacher_info;

-- 10. Index Creation
-- Creating an index to improve alphabetical search performance for student names
CREATE INDEX idx_student_name
ON students(student_name);

-- 11. Index Display
-- Displaying index details for the students table
SHOW INDEX FROM students;

-- 12. Index Removal 
DROP INDEX idx_student_name ON students;
