-- https://en.wikibooks.org/wiki/SQL_Exercises/The_Hospital

CREATE TABLE Physician (
    EmployeeID INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Position TEXT NOT NULL,
    SSN INTEGER NOT NULL
);

CREATE TABLE Department (
    DepartmentID INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Head INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID)
);

CREATE TABLE Affiliated_With (
    Physician INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
    Department INTEGER NOT NULL
    CONSTRAINT Fk_Department_DepartmentID REFERENCES Department(DepartmentID),
    PrimaryAffiliation BOOLEAN NOT NULL,
    PRIMARY KEY(Physician, Department)
);

CREATE TABLE Procedure (
    Code INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Cost REAL NOT NULL
);

CREATE TABLE Trained_In (
    Physician INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
    Treatment INTEGER NOT NULL
    CONSTRAINT Fk_Procedure_Code REFERENCES Procedure(Code),
    CertificationDate TIMESTAMP NOT NULL,
    CertificationExpires TIMESTAMP NOT NULL,
    PRIMARY KEY(Physician, Treatment)
);

CREATE TABLE Patient (
    SSN INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Address TEXT NOT NULL,
    Phone TEXT NOT NULL,
    InsuranceID INTEGER NOT NULL,
    PCP INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID)
);

CREATE TABLE Nurse (
    EmployeeID INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Position TEXT NOT NULL,
    Registered BOOLEAN NOT NULL,
    SSN INTEGER NOT NULL
);

CREATE TABLE Appointment (
    AppointmentID INTEGER PRIMARY KEY NOT NULL,
    Patient INTEGER NOT NULL
    CONSTRAINT Fk_Patient_SSN REFERENCES Patient(SSN),
    PrepNurse INTEGER
    CONSTRAINT Fk_Nurse_EmployeeID REFERENCES Nurse(EmployeeID),
    Physician INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL,
    ExaminationRoom TEXT NOT NULL
);

CREATE TABLE Medication (
    Code INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Brand TEXT NOT NULL,
    Description TEXT NOT NULL
);

CREATE TABLE Prescribes (
    Physician INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
    Patient INTEGER NOT NULL
    CONSTRAINT Fk_Patient_SSN REFERENCES Patient(SSN),
    Medication INTEGER NOT NULL
    CONSTRAINT Fk_Medication_Code REFERENCES Medication(Code),
    Date TIMESTAMP NOT NULL,
    Appointment INTEGER
    CONSTRAINT Fk_Appointment_AppointmentID REFERENCES Appointment(
        AppointmentID
    ),
    Dose TEXT NOT NULL,
    PRIMARY KEY(Physician, Patient, Medication, Date)
);

CREATE TABLE Block (
    Floor INTEGER NOT NULL,
    Code INTEGER NOT NULL,
    PRIMARY KEY(Floor, Code)
);

CREATE TABLE Room (
    Number INTEGER PRIMARY KEY NOT NULL,
    Type TEXT NOT NULL,
    BlockFloor INTEGER NOT NULL,
    BlockCode INTEGER NOT NULL,
    Unavailable BOOLEAN NOT NULL,
    FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block
);

CREATE TABLE On_Call (
    Nurse INTEGER NOT NULL
    CONSTRAINT Fk_Nurse_EmployeeID REFERENCES Nurse(EmployeeID),
    BlockFloor INTEGER NOT NULL,
    BlockCode INTEGER NOT NULL,
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL,
    PRIMARY KEY(Nurse, BlockFloor, BlockCode, Start, "End"),
    FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block
);

CREATE TABLE Stay (
    StayID INTEGER PRIMARY KEY NOT NULL,
    Patient INTEGER NOT NULL
    CONSTRAINT Fk_Patient_SSN REFERENCES Patient(SSN),
    Room INTEGER NOT NULL
    CONSTRAINT Fk_Room_Number REFERENCES Room(Number),
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL
);

CREATE TABLE Undergoes (
    Patient INTEGER NOT NULL
    CONSTRAINT Fk_Patient_SSN REFERENCES Patient(SSN),
    Procedure INTEGER NOT NULL
    CONSTRAINT Fk_Procedure_Code REFERENCES Procedure(Code),
    Stay INTEGER NOT NULL
    CONSTRAINT Fk_Stay_StayID REFERENCES Stay(StayID),
    Date TIMESTAMP NOT NULL,
    Physician INTEGER NOT NULL
    CONSTRAINT Fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
    AssistingNurse INTEGER
    CONSTRAINT Fk_Nurse_EmployeeID REFERENCES Nurse(EmployeeID),
    PRIMARY KEY(Patient, Procedure, Stay, Date)
);

INSERT INTO Physician (EmployeeID, Name, Position, SSN)
VALUES (1, 'John Dorian', 'Staff Internist', 111111111),
(2, 'Elliot Reid', 'Attending Physician', 222222222),
(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333),
(4, 'Percival Cox', 'Senior Attending Physician', 444444444),
(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555),
(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666),
(7, 'John Wen', 'Surgical Attending Physician', 777777777),
(8, 'Keith Dudemeister', 'MD Resident', 888888888),
(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO Department (DepartmentID, Name, Head)
VALUES (1, 'General Medicine', 4),
(2, 'Surgery', 7),
(3, 'Psychiatry', 9);

INSERT INTO Affiliated_With (Physician, Department, PrimaryAffiliation)
VALUES (1, 1, TRUE),
(2, 1, TRUE),
(3, 1, FALSE),
(3, 2, TRUE),
(4, 1, TRUE),
(5, 1, TRUE),
(6, 2, TRUE),
(7, 1, FALSE),
(7, 2, TRUE),
(8, 1, TRUE),
(9, 3, TRUE);

INSERT INTO Procedure (Code, Name, Cost)
VALUES (1, 'Reverse Rhinopodoplasty', 1500.0),
(2, 'Obtuse Pyloric Recombobulation', 3750.0),
(3, 'Folded Demiophtalmectomy', 4500.0),
(4, 'Complete Walletectomy', 10000.0),
(5, 'Obfuscated Dermogastrotomy', 4899.0),
(6, 'Reversible Pancreomyoplasty', 5600.0),
(7, 'Follicular Demiectomy', 25.0);

INSERT INTO Patient (SSN, Name, Address, Phone, InsuranceID, PCP)
VALUES (100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1),
(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2),
(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2),
(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO Nurse (EmployeeID, Name, Position, Registered, SSN)
VALUES (101, 'Carla Espinosa', 'Head Nurse', TRUE, 111111110),
(102, 'Laverne Roberts', 'Nurse', FALSE, 222222220),
(103, 'Paul Flowers', 'Nurse', FALSE, 333333330);

INSERT INTO Appointment (
    AppointmentID, Patient, PrepNurse, Physician, Start, "End", ExaminationRoom
)
VALUES (
    13216584, 100000001, 101, 1, '2008-04-24 10:00', '2008-04-24 11:00', 'A'
),
(26548913, 100000002, 101, 2, '2008-04-24 10:00', '2008-04-24 11:00', 'B'),
(36549879, 100000001, 102, 1, '2008-04-25 10:00', '2008-04-25 11:00', 'A'),
(46846589, 100000004, 103, 4, '2008-04-25 10:00', '2008-04-25 11:00', 'B'),
(59871321, 100000004, NULL, 4, '2008-04-26 10:00', '2008-04-26 11:00', 'C'),
(69879231, 100000003, 103, 2, '2008-04-26 11:00', '2008-04-26 12:00', 'C'),
(76983231, 100000001, NULL, 3, '2008-04-26 12:00', '2008-04-26 13:00', 'C'),
(86213939, 100000004, 102, 9, '2008-04-27 10:00', '2008-04-21 11:00', 'A'),
(93216548, 100000002, 101, 2, '2008-04-27 10:00', '2008-04-27 11:00', 'B');

INSERT INTO Medication (Code, Name, Brand, Description)
VALUES (1, 'Procrastin-X', 'X', 'N/A'),
(2, 'Thesisin', 'Foo Labs', 'N/A'),
(3, 'Awakin', 'Bar Laboratories', 'N/A'),
(4, 'Crescavitin', 'Baz Industries', 'N/A'),
(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');


INSERT INTO Prescribes (Physician, Patient, Medication, Date, Appointment, Dose)
VALUES (1, 100000001, 1, '2008-04-24 10:47', 13216584, '5'),
(9, 100000004, 2, '2008-04-27 10:53', 86213939, '10'),
(9, 100000004, 2, '2008-04-30 16:53', NULL, '5');

INSERT INTO Block (Floor, Code)
VALUES (1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(4, 3);

INSERT INTO Room (Number, Type, BlockFloor, BlockCode, Unavailable)
VALUES (101, 'Single', 1, 1, FALSE),
(102, 'Single', 1, 1, FALSE),
(103, 'Single', 1, 1, FALSE),
(111, 'Single', 1, 2, FALSE),
(112, 'Single', 1, 2, TRUE),
(113, 'Single', 1, 2, FALSE),
(121, 'Single', 1, 3, FALSE),
(122, 'Single', 1, 3, FALSE),
(123, 'Single', 1, 3, FALSE),
(201, 'Single', 2, 1, TRUE),
(202, 'Single', 2, 1, FALSE),
(203, 'Single', 2, 1, FALSE),
(211, 'Single', 2, 2, FALSE),
(212, 'Single', 2, 2, FALSE),
(213, 'Single', 2, 2, TRUE),
(221, 'Single', 2, 3, FALSE),
(222, 'Single', 2, 3, FALSE),
(223, 'Single', 2, 3, FALSE),
(301, 'Single', 3, 1, FALSE),
(302, 'Single', 3, 1, TRUE),
(303, 'Single', 3, 1, FALSE),
(311, 'Single', 3, 2, FALSE),
(312, 'Single', 3, 2, FALSE),
(313, 'Single', 3, 2, FALSE),
(321, 'Single', 3, 3, TRUE),
(322, 'Single', 3, 3, FALSE),
(323, 'Single', 3, 3, FALSE),
(401, 'Single', 4, 1, FALSE),
(402, 'Single', 4, 1, TRUE),
(403, 'Single', 4, 1, FALSE),
(411, 'Single', 4, 2, FALSE),
(412, 'Single', 4, 2, FALSE),
(413, 'Single', 4, 2, FALSE),
(421, 'Single', 4, 3, TRUE),
(422, 'Single', 4, 3, FALSE),
(423, 'Single', 4, 3, FALSE);

INSERT INTO On_Call (Nurse, BlockFloor, BlockCode, Start, "End")
VALUES (101, 1, 1, '2008-11-04 11:00', '2008-11-04 19:00'),
(101, 1, 2, '2008-11-04 11:00', '2008-11-04 19:00'),
(102, 1, 3, '2008-11-04 11:00', '2008-11-04 19:00'),
(103, 1, 1, '2008-11-04 19:00', '2008-11-05 03:00'),
(103, 1, 2, '2008-11-04 19:00', '2008-11-05 03:00'),
(103, 1, 3, '2008-11-04 19:00', '2008-11-05 03:00');

INSERT INTO Stay VALUES(3215, 100000001, 111, '2008-05-01', '2008-05-04');
INSERT INTO Stay VALUES(3216, 100000003, 123, '2008-05-03', '2008-05-14');
INSERT INTO Stay VALUES(3217, 100000004, 112, '2008-05-02', '2008-05-03');


INSERT INTO Undergoes (
    Patient, Procedure, Stay, Date, Physician, AssistingNurse
)
VALUES (100000001, 6, 3215, '2008-05-02', 3, 101),
(100000001, 2, 3215, '2008-05-03', 7, 101),
(100000004, 1, 3217, '2008-05-07', 3, 102),
(100000004, 5, 3217, '2008-05-09', 6, NULL),
(100000001, 7, 3217, '2008-05-10', 7, 101),
(100000004, 4, 3217, '2008-05-13', 3, 103);

INSERT INTO Trained_In (
    Physician, Treatment, CertificationDate, CertificationExpires
)
VALUES (3, 1, '2008-01-01', '2008-12-31'),
(3, 2, '2008-01-01', '2008-12-31'),
(3, 5, '2008-01-01', '2008-12-31'),
(3, 6, '2008-01-01', '2008-12-31'),
(3, 7, '2008-01-01', '2008-12-31'),
(6, 2, '2008-01-01', '2008-12-31'),
(6, 5, '2007-01-01', '2007-12-31'),
(6, 6, '2008-01-01', '2008-12-31'),
(7, 1, '2008-01-01', '2008-12-31'),
(7, 2, '2008-01-01', '2008-12-31'),
(7, 3, '2008-01-01', '2008-12-31'),
(7, 4, '2008-01-01', '2008-12-31'),
(7, 5, '2008-01-01', '2008-12-31'),
(7, 6, '2008-01-01', '2008-12-31'),
(7, 7, '2008-01-01', '2008-12-31');
