-----------------------------------------------------------------------------------------------
-- CLIENT
-----------------------------------------------------------------------------------------------
INSERT INTO "client" ("name", "last_name")
VALUES 
  ('Julio', 'Barros');
-----------------------------------------------------------------------------------------------
-- USER
-----------------------------------------------------------------------------------------------
INSERT INTO "user" ("client_fk", "name", "last_name", "email", "password", "is_admin")
VALUES 
  (1, 'Julio', 'Barros', 'user1@gmail.com', 'pppppppp', true),
  (1, 'user2', 'apellido', 'user2@gmail.com', 'pppppppp', false),
  (1, 'user3', 'apellido', 'user3@gmail.com', 'pppppppp', false),
  (1, 'user4', 'apellido', 'user4@gmail.com', 'pppppppp', false);
-----------------------------------------------------------------------------------------------
-- SCREEN
-----------------------------------------------------------------------------------------------
INSERT INTO "screen" ("name")
VALUES 
  ('Screen 1'),
  ('Screen 2'),
  ('Screen 3'),
  ('Screen 4'),
  ('Screen 5');
-----------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------
INSERT INTO "permission" ("user_fk", "client_fk", "screen_fk")
VALUES 
  (2,1,1),
  (2,1,2),
  (2,1,3),
  (2,1,4),
  (2,1,5),
  (3,1,1),
  (3,1,2),
  (3,1,3),
  (3,1,4),
  (3,1,5);
-----------------------------------------------------------------------------------------------
-- PROFESSIONAL
-----------------------------------------------------------------------------------------------
INSERT INTO "professional" ("name", "last_name", "gender", "cuit", "fiscal_status", "phone", "email", "password", "birthdate", "bank", "bank_account", "cbu", "alias", "note")
VALUES 
  ('Mayra', 'Gonzalez', 'F', '11111111111', 'monotributista', '1111111111', 'profesional1@yahoo.com', 'pppppppp', '1975-05-15', 'Banco Santander', '123456789', '123456789', 'alias1', 'note1'),
  ('Juan', 'Gonzalez', 'M', '22222222222', 'monotributista', '1122222222', 'profesional2@yahoo.com', 'pppppppp', '1980-05-15', 'Banco Santander', '123456789', '123456789', 'alias2', 'note2'),
  ('Pedro', 'Gonzalez', 'M', '33333333333', 'monotributista', '1133333333', 'profesional3@yahoo.com', 'pppppppp', '1985-05-15', 'Banco Santander', '123456789', '123456789', 'alias3', 'note3');
-----------------------------------------------------------------------------------------------
-- WORK_INVITATION
-----------------------------------------------------------------------------------------------
INSERT INTO "work_invitation" ("client_fk", "professional_fk", "sender")
VALUES 
  (1,1,'coordinador'),
  (1,2,'profesional'),
  (1,3,'profesional');
-----------------------------------------------------------------------------------------------
-- CLIENT_HAS_PROFESSIONAL
-----------------------------------------------------------------------------------------------
INSERT INTO "client_has_professional" ("client_fk", "professional_fk")
VALUES 
  (1,1),
  (1,2),
  (1,3);
-----------------------------------------------------------------------------------------------
-- COMPANY
-----------------------------------------------------------------------------------------------
INSERT INTO "company" ("client_fk", "user_fk", "name", "cuit", "note")
VALUES 
  (1,1,'Company 1', '11111111111', 'note1'),
  (1,2,'Company 2', '22222222222', 'note2'),
  (1,3,'Company 3', '33333333333', 'note3');
-----------------------------------------------------------------------------------------------
-- PATIENT
-----------------------------------------------------------------------------------------------
INSERT INTO "patient" ("client_fk", "user_fk", "company_fk", "name", "healthcare_provider", "gender", "age", "phone", "note")
VALUES 
  (1,1,1,'Patient 1', 'OSDE', 'F', 30, '1111111111', 'note1'),
  (1,2,2,'Patient 2', 'OSDE', 'M', 35, '2222222222', 'note2'),
  (1,3,3,'Patient 3', 'OSDE', 'F', 40, '3333333333', 'note3');
-----------------------------------------------------------------------------------------------
-- TREATMENT
-----------------------------------------------------------------------------------------------
INSERT INTO "treatment" ("client_fk", "user_fk", "name", "abbreviation", "description")
VALUES 
  (1,1,'Treatment 1', 't1', 'description1'),
  (1,2,'Treatment 2', 't2', 'description2'),
  (1,3,'Treatment 3', 't3', 'description3');
-----------------------------------------------------------------------------------------------
-- COMPANY_HAS_TREATMENT
-----------------------------------------------------------------------------------------------
INSERT INTO "company_has_treatment" ("client_fk", "user_fk", "company_fk", "treatment_fk", "value")
VALUES 
  (1,1,1,1,1000),
  (1,2,2,2,2000),
  (1,3,3,3,3000);
-----------------------------------------------------------------------------------------------
-- TREATMENT_HAS_PROFESSIONAL
-----------------------------------------------------------------------------------------------
INSERT INTO "treatment_has_professional" ("client_fk", "user_fk", "company_fk", "treatment_fk", "professional_fk", "value")
VALUES 
  (1,1,1,1,1,100),
  (1,2,2,2,2,200),
  (1,3,3,3,3,300);
-----------------------------------------------------------------------------------------------
-- ORDER
-----------------------------------------------------------------------------------------------
INSERT INTO "order" ("order_fk", "client_fk", "user_fk", "patient_fk", "treatment_fk", "professional_fk", "start_date", "finish_date", "has_medical_order", "frequency", "total_sessions", "sessions", "coinsurance", "value", "cost", "diagnosis", "requirements")
VALUES 
  (null,1,1,1,1,1,'2024-05-15','2024-05-25',false,1,4,4,100,1100,500,'diagnosis1','requirements1'),
  (1,1,2,2,2,null,'2024-05-01','2024-05-11',false,2,8,6,0,2000,1000,'diagnosis2','requirements2'),
  (1,1,3,3,3,3,'2024-05-02','2024-05-19',false,3,12,9,400,3020,3000,'diagnosis3','requirements3'),

  (null,1,2,1,3,1,'2024-06-03','2024-06-09',true,3,12,9,400,3020,3000,'diagnosis4','requirements4'),
  (4,1,1,2,3,null,'2024-06-13','2024-06-29',true,3,12,9,400,3020,3000,'diagnosis5','requirements5'),
  (4,1,3,3,3,null,'2024-06-01','2024-06-11',true,3,12,9,400,3020,3000,'diagnosis6','requirements6'),

  (null,1,2,1,3,null,'2024-07-01','2024-07-12',false,3,12,9,400,3020,3000,'diagnosis7','requirements7'),
  (7,1,3,2,3,null,'2024-07-01','2024-07-16',false,3,12,9,400,3020,3000,'diagnosis8','requirements8'),
  (7,1,1,3,3,null,'2024-07-01','2024-07-22',false,3,12,9,400,3020,3000,'diagnosis9','requirements9'),

  (null,1,3,1,3,1,'2024-08-01','2024-08-13',true,3,12,9,400,3020,3000,'diagnosis10','requirements10'),
  (10,1,1,2,3,2,'2024-08-01','2024-08-12',true,3,12,9,400,3020,3000,'diagnosis11','requirements11'),
  (10,1,2,3,3,3,'2024-08-01','2024-08-06',true,3,12,9,400,3020,3000,'diagnosis12','requirements12'),
  
  (null,1,3,1,3,1,'2024-09-01','2024-09-19',false,3,12,9,400,3020,3000,'diagnosis13','requirements13'),
  (13,1,2,2,3,2,'2024-09-01','2024-09-25',false,3,12,9,400,3020,3000,'diagnosis14','requirements14'),
  (13,1,1,3,3,null,'2024-09-01','2024-09-15',false,3,12,9,400,3020,3000,'diagnosis15','requirements15');
-----------------------------------------------------------------------------------------------
-- CLAIM
-----------------------------------------------------------------------------------------------
INSERT INTO "claim" ("order_fk", "client_fk", "user_fk", "cause", "urgency", "reported_date")
VALUES 
  (1,1,1,'cause1','baja','2025-05-15'),
  (1,1,2,'cause2','baja','2025-05-15'),
  (1,1,3,'cause3','baja','2025-05-15'),
  (4,1,2,'cause4','media','2025-06-05'),
  (4,1,1,'cause5','media','2025-06-05'),
  (4,1,3,'cause6','media','2025-06-05'),
  (7,1,2,'cause7','alta','2025-07-05'),
  (7,1,3,'cause8','alta','2025-07-05'),
  (7,1,1,'cause9','alta','2025-07-05'),
  (10,1,3,'cause10','baja','2025-08-05'),
  (10,1,1,'cause11','baja','2025-08-05'),
  (10,1,2,'cause12','baja','2025-08-05'),
  (13,1,3,'cause13','media','2025-09-05'),
  (13,1,2,'cause14','media','2025-09-05'),
  (13,1,1,'cause15','media','2025-09-05');