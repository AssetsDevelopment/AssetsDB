DROP TYPE IF EXISTS "gender_options";
CREATE TYPE "gender_options" AS ENUM (
  'M',
  'F'
);

DROP TYPE IF EXISTS "urgency_options";
CREATE TYPE "urgency_options" AS ENUM (
  'baja',
  'media',
  'alta'
);

DROP TYPE IF EXISTS "rol_options";
CREATE TYPE "rol_options" AS ENUM (
  'coordinador',
  'asistente',
  'profesional'
);

DROP TYPE IF EXISTS "fiscal_status";
CREATE TYPE "fiscal_status" AS ENUM (
  'monotributista',
  'responsable_inscripto'
);

DROP TYPE IF EXISTS order_status;
CREATE TYPE "order_status" AS ENUM (
  'nuevo',
  'renovacion',
  'finalizado'
);

-----------------------------------------------------------------------------------------------
-- USER
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "user" CASCADE;
CREATE TABLE "user" (
  "user_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "user_fk" 	integer 		NOT NULL REFERENCES "user"(user_id),
  "name" 		varchar(100) 	NOT NULL,
  "email" 		varchar(255) 	NOT NULL UNIQUE ,
  "password" 	varchar(255) 	NOT NULL,
"rol" 		rol_options 	NOT NULL,
  "is_active" 	boolean 		NOT NULL DEFAULT true,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()'
);

-----------------------------------------------------------------------------------------------
-- COMPANY
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company" CASCADE;
CREATE TABLE "company" (
  "company_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "user_fk"     integer 		not null REFERENCES "user"(user_id),
  "name" 		varchar(100) 	NOT NULL,
  "cuit" 		varchar(20),
  "note" 		text,
  "is_active" 	boolean 		NOT NULL DEFAULT true,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()'
);

-----------------------------------------------------------------------------------------------
-- PATIENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "patient" CASCADE;
CREATE TABLE "patient" (
  "patient_id" 			INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "company_fk" 			integer 		NOT NULL REFERENCES company(company_id),
  "user_fk" 			integer 		NOT NULL REFERENCES "user"(user_id),
  "name" 				varchar(100) 	NOT NULL,
  "healthcare_provider" varchar(100),
  "gender" 				gender_options 	NOT NULL,
  "age" 				smallint,
  "phone" 				varchar(30),
  "note" 				text,
  "is_active" 			boolean 		NOT NULL DEFAULT true,
  "created_at" 			timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 			timestamp 		NOT NULL DEFAULT 'now()'
  
  CHECK(age >= 0 AND age <= 130)

  CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$')

  /*
  Toma como opcionales:
  el prefijo internacional (54)
  el prefijo internacional para celulares (9)
  el prefijo de acceso a interurbanas (0)
  el prefijo local para celulares (15)
  Es obligatorio:
  el código de área (11, 2xx, 2xxx, 3xx, 3xxx, 6xx y 8xx)
  (no toma como válido un número local sin código de área como 4444-0000)
  */
);

-----------------------------------------------------------------------------------------------
-- TREATMENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "treatment" CASCADE;
CREATE TABLE "treatment" (
  "treatment_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "user_fk" 		integer 		not null REFERENCES "user"(user_id),
  "name" 			varchar(100) 	NOT NULL,
  "abbreviation" 	varchar(10) 	NOT NULL,
  "description" 	text,
  "is_active" 		boolean 		NOT NULL DEFAULT true,
  "created_at" 		timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 		timestamp 		NOT NULL DEFAULT 'now()'
);

-----------------------------------------------------------------------------------------------
-- PROFESIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "profesional" CASCADE;
CREATE TABLE "profesional" (
  "profesional_id" INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "user_fk" 	   integer 	      NOT NULL REFERENCES "user"(user_id),
  "name" 		   varchar(100)   NOT NULL,
  "gender" 		   gender_options NOT NULL,
  "cuit" 		   varchar(20),
  "fiscal_status"  fiscal_status,
  "phone" 		   varchar(30)    not null,
  "email" 		   varchar(255)   NOT NULL UNIQUE,
  "birthdate" 	   date,
  "bank" 		   varchar(255),
  "bank_account"   varchar(50),
  "cbu" 		   varchar(23),
  "alias" 		   varchar(50),
  "note" 		   text,
  "is_active" 	   boolean 		  NOT NULL DEFAULT true,
  "created_at" 	   timestamp 	  NOT NULL DEFAULT 'now()',
  "updated_at" 	   timestamp 	  NOT NULL DEFAULT 'now()'
  
  CHECK (birthdate <= CURRENT_DATE - INTERVAL '18 years' AND birthdate >= CURRENT_DATE - INTERVAL '130 years')

  CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$')
);

-----------------------------------------------------------------------------------------------
-- SCREEN
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "screen" CASCADE;
CREATE TABLE "screen" (
  "screen_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "name" 		varchar(100) 	NOT NULL,
  "is_active" 	boolean 		NOT NULL DEFAULT true,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()'
);

-----------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "permission" CASCADE;
CREATE TABLE "permission" (
  "user_fk" 	integer 	not null REFERENCES "user"(user_id),
  "screen_fk" 	integer 	not null REFERENCES screen(screen_id),
  "created_at" 	timestamp 	NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 	NOT NULL DEFAULT 'now()',
  
  PRIMARY KEY ("user_fk", "screen_fk")
);

-----------------------------------------------------------------------------------------------
-- TREATMENT_HAS_PROFESIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "treatment_has_profesional" CASCADE;
CREATE TABLE "treatment_has_profesional" (
  "company_fk" 		integer 		not null REFERENCES company(company_id),
  "treatment_fk" 	integer 		not null REFERENCES treatment(treatment_id),
  "profesional_fk" 	integer 		not null REFERENCES profesional(profesional_id),
  "user_fk" 		integer 		not null REFERENCES "user"(user_id),
  "value" 			decimal(8,2) 	NOT NULL,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  
  PRIMARY KEY ("company_fk", "treatment_fk", "profesional_fk"),

  CHECK ("value" >= 0)
);

-----------------------------------------------------------------------------------------------
-- COMPANY_HAS_TREATMENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company_has_treatment" CASCADE;
CREATE TABLE "company_has_treatment" (
  "company_fk" 		integer 		not null REFERENCES company(company_id),
  "treatment_fk" 	integer 		not null REFERENCES treatment(treatment_id),
  "user_fk" 		integer 		not null REFERENCES "user"(user_id),
  "value" 			decimal(7,2) 	NOT NULL,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  
  PRIMARY KEY ("company_fk", "treatment_fk"),
    
  CHECK ("value" >= 0)
);

-----------------------------------------------------------------------------------------------
-- ORDER
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "order" CASCADE;
CREATE TABLE "order" (
  "order_id" 			INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "patient_fk" 			integer 	 NOT NULL REFERENCES patient(patient_id),
  "user_fk" 			integer 	 NOT NULL REFERENCES "user"(user_id),
  "treatment_fk" 		integer 	 NOT NULL REFERENCES treatment(treatment_id),
  "profesional_fk" 		integer 		 	  REFERENCES profesional(profesional_id),
  "start_date" 			timestamp 	 NOT NULL,
  "finish_date" 		timestamp 	 NOT NULL,
  "has_medical_order" 	boolean 	 NOT NULL DEFAULT false,
  "frequency" 			smallint 	 NOT NULL,
  "total_sessions" 		smallint 	 NOT NULL,
  "sessions" 			smallint 	 NOT NULL,
  "coinsurance" 		decimal(7,2) NOT NULL,
  "special_value" 		decimal(7,2) 		  DEFAULT 0,
  "special_cost" 		decimal(7,2) 		  DEFAULT 0,
  "diagnosis" 			TEXT,
  "requirements" 		varchar(300),
  "state" 				order_status NOT NULL,
  "created_at" 			timestamp 	 NOT NULL DEFAULT 'now()',
  "updated_at" 			timestamp 	 NOT NULL DEFAULT 'now()'
  
  -- Validacion de "start_date" y "finish_date"
  CHECK (start_date >= CURRENT_DATE - INTERVAL '1 year' AND start_date <= CURRENT_DATE + INTERVAL '1 year')

  CHECK (finish_date >= CURRENT_DATE - INTERVAL '1 year' AND finish_date <= CURRENT_DATE + INTERVAL '1 year')

  -- verificar si esto valida tambien que una fecha no puede ser mas grande que la otra
  CHECK (finish_date - start_date >= interval '0 days' and finish_date - start_date <= interval '31 days')

  CHECK (frequency BETWEEN 1 AND 7)

  CHECK (total_sessions 	>= 0 AND total_sessions <= 31)
  CHECK (sessions 		>= 0 AND sessions 		<= total_sessions)
  CHECK (coinsurance 		>= 0)
  CHECK (special_value 	>= 0)
  CHECK (special_cost 	>= 0)
);

-----------------------------------------------------------------------------------------------
-- HISTORY
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "history" CASCADE;
CREATE TABLE "history" (
  "history_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "order_fk" 	integer 		not null REFERENCES "order"(order_id),
  "user_fk" 	integer 		not null REFERENCES "user"(user_id),
  "sessions" 	smallint 		NOT NULL,
  "coinsurance" decimal(7,2) 	NOT NULL,
  "value" 		decimal(7,2) 	NOT NULL DEFAULT 0,
  "cost" 		decimal(7,2) 	NOT NULL DEFAULT 0,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 	timestamp 		NOT NULL DEFAULT 'now()'
  
CHECK (sessions 	>= 0)
CHECK (coinsurance 	>= 0)
CHECK ("value" 		>= 0)
CHECK (cost 		>= 0)

);

-----------------------------------------------------------------------------------------------
-- CLAIM
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "claim" CASCADE;
CREATE TABLE "claim" (
  "claim_id" 		INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "order_fk" 		integer 		not null REFERENCES "order"(order_id),
  "user_fk" 		integer 		not null REFERENCES "user"(user_id),
  "cause" 			text 			NOT NULL,
  "urgency" 		urgency_options NOT NULL,
  "reported_date" 	timestamp 		NOT NULL,
  "is_active" 		boolean 		NOT NULL DEFAULT true,
  "created_at" 		timestamp 		NOT NULL DEFAULT 'now()',
  "updated_at" 		timestamp 		NOT NULL DEFAULT 'now()'
  
  CHECK (reported_date <= CURRENT_DATE and reported_date >= CURRENT_DATE - INTERVAL '31 days')
);

-----------------------------------------------------------------------------------------------
-- TOKEN
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "token" CASCADE;
CREATE TABLE "token" (
  "token_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "user_fk" 	integer 		not null REFERENCES "user"(user_id),
  "token" 		varchar(255) 	NOT NULL,
  "created_at" 	timestamp 		NOT NULL DEFAULT 'now()'
);
