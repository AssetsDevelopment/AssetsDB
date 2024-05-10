-----------------------------------------------------------------------------------------------
-- USER
-----------------------------------------------------------------------------------------------
INSERT INTO "user" ("user_fk", "name", "email", "password", "rol", "is_active")
VALUES 
  (1,'Alice Smith', 'alice@gmail.com', 'hashedpassword1', 'coordinador', true),
  (1,'Bob Johnson', 'bob@yahoo.com', 'hashedpassword2', 'asistente', true),
  (1,'Charlie Brown', 'charlie@hotmail.com', 'hashedpassword3', 'profesional', false),
  (1,'David Garcia', 'david@outlook.com', 'hashedpassword4', 'profesional', true),
  (1,'Nacho', 'nacho@icloud.com', 'hashedpassword4', 'profesional', true);

-----------------------------------------------------------------------------------------------
-- COMPANY
-----------------------------------------------------------------------------------------------
INSERT INTO "company" ("user_fk", "name", "cuit", "note", "is_active")
VALUES 
  (1,'Company ABC', '12345678901', 'Note for Company 1', true),
  (2,'TechCorp', '98765432109', 'Note for Company 2', true),
  (3,'Service Solutions', '23456789012', 'Note for Company 3', false),
  (4,'Innovative Industries', '34567890123', 'Note for Company 4', true),
  (5,'Company XYZ', '11111111111', 'Note for Company 5', true),
  (1,'Global Enterprises', '22222222222', 'Note for Company 6', true),
  (2,'Startup Innovators', '33333333333', 'Note for Company 7', false),
  (3,'Future Solutions', '44444444444', 'Note for Company 8', true);

-----------------------------------------------------------------------------------------------
-- PATIENT
-----------------------------------------------------------------------------------------------
INSERT INTO "patient" ("user_fk", "company_fk", "name", "healthcare_provider", "gender", "age", "note", "is_active")
VALUES 
  (1,1, 'John Doe', 'Healthcare Provider 1', 'M', 25, 'Note for John Doe', true),
  (2,1, 'Jane Smith', NULL, 'F', NULL, 'Note for Jane Smith', true),
  (3,2, 'Alice Johnson', 'Healthcare Provider 2', 'M', 35, 'Note for Alice Johnson', false),
  (4,2, 'Emily Brown', 'Healthcare Provider 3', 'F', 45, 'Note for Emily Brown', true),
  (5,3, 'Michael Johnson', 'Healthcare Provider X', 'M', 30, 'Note for Michael Johnson', true),
  (1,3, 'Sophia Williams', NULL, 'F', NULL, 'Note for Sophia Williams', true),
  (2,4, 'Robert Garcia', 'Healthcare Provider Y', 'M', 40, 'Note for Robert Garcia', false),
  (3,4, 'Isabella Martinez', 'Healthcare Provider Z', 'F', 50, 'Note for Isabella Martinez', true),
  (4,5, 'Emma Anderson', 'Healthcare Provider A', 'F', 28, 'Note for Emma Anderson', true),
  (5,5, 'William Thompson', NULL, 'M', NULL, 'Note for William Thompson', true),
  (1,6, 'Ava Davis', 'Healthcare Provider B', 'F', 32, 'Note for Ava Davis', false),
  (2,6, 'James Wilson', 'Healthcare Provider C', 'M', 42, 'Note for James Wilson', true),
  (3,7, 'Olivia Moore', 'Healthcare Provider D', 'F', 26, 'Note for Olivia Moore', true),
  (4,7, 'Ethan Clark', NULL, 'M', NULL, 'Note for Ethan Clark', true),
  (5,8, 'Chloe Baker', 'Healthcare Provider E', 'F', 29, 'Note for Chloe Baker', false),
  (1,8, 'Liam Mitchell', 'Healthcare Provider F', 'M', 38, 'Note for Liam Mitchell', true);

-----------------------------------------------------------------------------------------------
-- TREATMENT
-----------------------------------------------------------------------------------------------
INSERT INTO "treatment" ("user_fk", "name", "abbreviation", "description", "is_active")
VALUES 
  (1,'Physical Therapy', 'PT', 'Treatment involving physical exercises', true),
  (2,'Dental Cleaning', 'DC', 'Routine dental cleaning and checkup', true),
  (3,'Eye Examination', 'EE', 'Eye checkup and vision assessment', false),
  (4,'Massage Therapy', 'MT', 'Therapeutic massage sessions', true);

-----------------------------------------------------------------------------------------------
-- PROFESIONAL
-----------------------------------------------------------------------------------------------
INSERT INTO "profesional" ("user_fk", "name", "gender", "cuit", "fiscal_status", "phone", "email", "birthdate", "bank", "bank_account", "cbu", "alias", "note", "is_active")
VALUES 
  (1,'Dr. Smith', 'M', '20345678901', 'responsable_inscripto', '541146574632', 'drsmith@gmail.com', '1975-05-15', 'Bank X', '12345678', '0123456789012345678901', 'DrS', 'Note for Dr. Smith', true),
  (2,'Dr. Johnson', 'M', '30987654321', 'monotributista', '541146574632', 'drjohnson@gmail.com', '1982-08-22', 'Bank Y', '87654321', '9876543210987654321098', 'DrJ', 'Note for Dr. Johnson', true),
  (3,'Dr. Williams', 'F', '40987654322', 'responsable_inscripto', '541146574632', 'drwilliams@gmail.com', '1978-03-10', 'Bank Z', '11111111', '1111111111111111111111', 'DrW', 'Note for Dr. Williams', false),
  (4,'Dr. Brown', 'M', '50987654323', 'monotributista', '541146574632', 'drbrown@gmail.com', '1990-12-05', 'Bank A', '99999999', '9999999999999999999999', 'DrB', 'Note for Dr. Brown', true),
  (5,'Dr. Garcia', 'M', '60987654324', 'responsable_inscripto', '541146574632', 'drgarcia@gmail.com', '1985-07-20', 'Bank B', '76543210', '7654321076543210765432', 'DrG', 'Note for Dr. Garcia', true),
  (1,'Dr. Martinez', 'F', '70987654325', 'monotributista', '541146574632', 'drmartinez@gmail.com', '1970-10-18', 'Bank C', '65432109', '6543210965432109654321', 'DrM', 'Note for Dr. Martinez', true),
  (2,'Dr. Lopez', 'M', '80987654326', 'responsable_inscripto', '541146574632', 'drlopez@gmail.com', '1988-04-25', 'Bank D', '54321098', '5432109854321098543210', 'DrL', 'Note for Dr. Lopez', false),
  (3,'Dr. Gonzalez', 'F', '90987654327', 'monotributista', '541146574632', 'drgonzalez@gmail.com', '1983-01-12', 'Bank E', '43210987', '4321098743210987432109', 'DrGo', 'Note for Dr. Gonzalez', true);

-----------------------------------------------------------------------------------------------
-- SCREEN
-----------------------------------------------------------------------------------------------
INSERT INTO "screen" ("name", "is_active")
VALUES 
  ('Screen 1', true),
  ('Screen 2', true),
  ('Screen 3', false),
  ('Screen 4', true);

-----------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------
INSERT INTO "permission" ("user_fk", "screen_fk")
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4);

-----------------------------------------------------------------------------------------------
-- TREATMENT_HAS_PROFESIONAL
-----------------------------------------------------------------------------------------------
INSERT INTO "treatment_has_profesional" ("user_fk", "company_fk", "treatment_fk", "profesional_fk", "value")
VALUES 
  (1,1, 1, 1, 100.50),
  (2,2, 2, 2, 75.25),
  (3,3, 3, 3, 150.75),
  (4,4, 4, 4, 200.00);

-----------------------------------------------------------------------------------------------
-- COMPANY_HAS_TREATMENT
-----------------------------------------------------------------------------------------------
INSERT INTO "company_has_treatment" ("user_fk", "company_fk", "treatment_fk", "value")
VALUES 
  (1,1, 1, 50.25),
  (2,2, 2, 75.50),
  (3,3, 3, 100.75),
  (4,4, 4, 120.00);

-----------------------------------------------------------------------------------------------
-- ORDER
-----------------------------------------------------------------------------------------------
INSERT INTO "order" ("patient_fk", "user_fk", "treatment_fk", "start_date", "finish_date", "has_medical_order", "frequency", "total_sessions", "sessions", "coinsurance", "special_value", "special_cost", "diagnosis", "requirements", "state")
VALUES 
  (1, 1, 1, '2024-01-01', '2024-01-31', false, 3, 20, 5, 50.25, 0, 0, 'Diagnosis for Order 1', 'Requirements for Order 1', 'nuevo'),
  (2, 2, 2, '2024-02-01', '2024-02-28', true, 5, 15, 10, 75.50, 10.00, 5.00, 'Diagnosis for Order 2', 'Requirements for Order 2', 'nuevo'),
  (3, 3, 3, '2024-03-01', '2024-03-31', false, 7, 25, 20, 100.75, 20.00, 15.00, 'Diagnosis for Order 3', 'Requirements for Order 3', 'renovacion'),
  (4, 4, 4, '2024-04-01', '2024-04-30', true, 2, 10, 5, 120.00, 5.00, 0, 'Diagnosis for Order 4', 'Requirements for Order 4', 'finalizado'),
  (5, 1, 1, '2024-01-15', '2024-02-15', false, 2, 10, 5, 60.75, 0, 0, 'Diagnosis for Order 5', 'Requirements for Order 5', 'nuevo'),
  (6, 2, 2, '2024-02-01', '2024-02-29', true, 3, 15, 10, 85.50, 10.00, 5.00, 'Diagnosis for Order 6', 'Requirements for Order 6', 'nuevo'),
  (7, 3, 3, '2024-03-10', '2024-04-10', false, 5, 20, 15, 110.25, 20.00, 15.00, 'Diagnosis for Order 7', 'Requirements for Order 7', 'renovacion'),
  (8, 4, 4, '2024-04-05', '2024-04-25', true, 4, 8, 4, 130.00, 5.00, 0, 'Diagnosis for Order 8', 'Requirements for Order 8', 'finalizado'),
    (9, 1, 1, '2024-09-01', '2024-09-30', false, 3, 15, 7, 70.25, 0, 0, 'Diagnosis for Order 13', 'Requirements for Order 13', 'nuevo'),
  (10, 2, 2, '2024-10-01', '2024-10-31', true, 5, 20, 14, 95.50, 10.00, 5.00, 'Diagnosis for Order 14', 'Requirements for Order 14', 'renovacion'),
  (11, 3, 3, '2024-11-01', '2024-11-30', false, 4, 10, 8, 120.75, 20.00, 15.00, 'Diagnosis for Order 15', 'Requirements for Order 15', 'finalizado'),
  (12, 4, 4, '2024-12-01', '2024-12-31', true, 2, 5, 3, 145.00, 5.00, 0, 'Diagnosis for Order 16', 'Requirements for Order 16', 'nuevo');

-----------------------------------------------------------------------------------------------
-- HISTORY
-----------------------------------------------------------------------------------------------
INSERT INTO "history" ("user_fk", "order_fk", "sessions", "coinsurance", "value", "cost")
VALUES 
  (1,1, 5, 60.25, 0, 0),
  (2,2, 10, 85.50, 10.00, 5.00),
  (3,3, 15, 110.75, 20.00, 15.00),
  (4,4, 3, 120.00, 5.00, 0);

-----------------------------------------------------------------------------------------------
-- CLAIM
-----------------------------------------------------------------------------------------------
INSERT INTO "claim" ("user_fk", "order_fk", "cause", "urgency", "reported_date", "is_active")
VALUES 
  (1,1, 'Claim cause 1', 'baja', '2024-01-01', true),
  (2,2, 'Claim cause 2', 'media', '2024-01-01', true),
  (3,3, 'Claim cause 3', 'alta', '2024-01-01', true),
  (4,4, 'Claim cause 4', 'alta', '2024-01-01', true);

-----------------------------------------------------------------------------------------------
-- TOKEN
-----------------------------------------------------------------------------------------------
INSERT INTO "token" ("user_fk", "token")
VALUES 
  (1, md5(random()::text)),
  (2, md5(random()::text)),
  (3, md5(random()::text)),
  (4, md5(random()::text));
