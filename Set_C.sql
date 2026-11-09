/*
====================================================================
DEPARTMENT OF COMPUTER SCIENCE & ENGINEERING
B.Tech AIML — 3rd Semester | DBMS Lab Examination
SET C Solutions [Total: 20 Marks]
====================================================================
*/

-- =================================================================
-- PREREQUISITE TABLES (Referenced by Appointments)
-- =================================================================
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    consultation_fee DECIMAL(10, 2)
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT
);


-- =================================================================
-- QUESTION 1 [4 Marks]
-- Create the table Appointments(app_id INT, doctor_id INT, patient_id INT, 
-- app_date DATE, status VARCHAR(20)) with valid Foreign Keys and a CHECK 
-- constraint enforcing that status must only accept values 
-- 'Scheduled', 'Completed', or 'Cancelled'.
-- =================================================================

CREATE TABLE Appointments (
    app_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    app_date DATE,
    status VARCHAR(20),
    CONSTRAINT fk_app_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    CONSTRAINT fk_app_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT chk_app_status CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'))
);


-- =================================================================
-- QUESTION 2 [3 Marks]
-- Write an SQL query to update and increase the consultation_fee by 15% 
-- for all doctors whose specialization is 'Cardiology' or 'Neurology'.
-- =================================================================

UPDATE Doctors
SET consultation_fee = consultation_fee * 1.15
WHERE specialization IN ('Cardiology', 'Neurology');


-- =================================================================
-- QUESTION 3 [4 Marks]
-- List the names of all patients, the doctor they consulted, and appointment 
-- dates where the status is 'Completed', sorted by app_date in descending order.
-- =================================================================

SELECT 
    p.patient_name,
    d.doctor_name,
    a.app_date
FROM Appointments a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed'
ORDER BY a.app_date DESC;


-- =================================================================
-- QUESTION 4 [4 Marks]
-- Find the total number of appointments handled by each doctor. 
-- Display doctor_name, specialization, and Total_Appointments.
-- =================================================================

SELECT 
    d.doctor_name,
    d.specialization,
    COUNT(a.app_id) AS Total_Appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization;


-- =================================================================
-- QUESTION 5 [5 Marks]
-- Write an SQL query to find the details of patients whose age is greater 
-- than the average age of all registered patients.
-- =================================================================

SELECT *
FROM Patients
WHERE age > (
    SELECT AVG(age)
    FROM Patients
);
