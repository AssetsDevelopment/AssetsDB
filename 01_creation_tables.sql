DROP TYPE IF EXISTS "gender_options";
CREATE TYPE "gender_options" AS ENUM (
  'm',
  'f',
  'M',
  'F'
);
DROP TYPE IF EXISTS "urgency_options";
CREATE TYPE "urgency_options" AS ENUM (
  'baja',
  'media',
  'alta'
);
DROP TYPE IF EXISTS "fiscal_status";
CREATE TYPE "fiscal_status" AS ENUM (
  'monotributista',
  'responsable_inscripto'
);
DROP TYPE IF EXISTS "profile_options";
CREATE TYPE "profile_options" AS ENUM (
  'coordinador',
  'profesional'
);

-----------------------------------------------------------------------------------------------
-- CLIENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "client" CASCADE;
CREATE TABLE "client" (
  "client_id" 	    INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
    "name" 		    VARCHAR(100) 	                  NOT NULL,
  "is_active" 	    BOOLEAN 		                  NOT NULL DEFAULT true,
  "user_type"       CHAR(6)                           NOT NULL DEFAULT 'client',
  "created_at" 	    TIMESTAMP 		                  NOT NULL DEFAULT now(),
  "updated_at" 	    TIMESTAMP 		                  NOT NULL DEFAULT now()
);
-----------------------------------------------------------------------------------------------
-- USER
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "user" CASCADE;
CREATE TABLE "user" (
  "user_id" 	  INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "client_fk"   INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "name"        VARCHAR(100) 	NOT NULL,
  "email" 		  VARCHAR(255) 	NOT NULL UNIQUE ,
  "password" 	  VARCHAR(255) 	NOT NULL,
  "is_admin" 	  BOOLEAN 		  NOT NULL DEFAULT false,
  "is_active" 	BOOLEAN 		  NOT NULL DEFAULT true,
  "created_at" 	TIMESTAMP 		NOT NULL DEFAULT now(),
  "updated_at" 	TIMESTAMP 		NOT NULL DEFAULT now()
);
-----------------------------------------------------------------------------------------------
-- SCREEN
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "screen" CASCADE;
CREATE TABLE "screen" (
  "screen_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "name" 		    VARCHAR(100) 	NOT NULL,
  "is_active" 	BOOLEAN 		  NOT NULL DEFAULT true,
  "created_at" 	TIMESTAMP 		NOT NULL DEFAULT now(),
  "updated_at" 	TIMESTAMP 		NOT NULL DEFAULT now()
);
-----------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "permission" CASCADE;
CREATE TABLE "permission" (
  "user_fk" 	  INTEGER 	  NOT NULL REFERENCES "user"(user_id),
  "client_fk" 	INTEGER 	  NOT NULL REFERENCES "client"(client_id),
  "screen_fk" 	INTEGER 	  NOT NULL REFERENCES screen(screen_id),
  "created_at" 	TIMESTAMP 	NOT NULL DEFAULT now(),
  "updated_at" 	TIMESTAMP 	NOT NULL DEFAULT now(),

  PRIMARY KEY ("user_fk", "screen_fk")
);
-----------------------------------------------------------------------------------------------
-- PROFESSIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "professional" CASCADE;
CREATE TABLE "professional" (
  "professional_id" INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "name" 		    VARCHAR(100)                    NOT NULL,
  "last_name" 		VARCHAR(100)                    NOT NULL,
  "gender" 		    gender_options                  NOT NULL,
  "cuit" 		    VARCHAR(20),
  "fiscal_status"   fiscal_status,
  "phone" 		    VARCHAR(30),         
  "email" 		    VARCHAR(255),        
  "password" 	    VARCHAR(255)                    NOT NULL,
  "birthdate" 	    date,
  "bank" 		    VARCHAR(255),
  "bank_account"    VARCHAR(50),
  "cbu" 		    VARCHAR(23),
  "alias"           VARCHAR(50),
  "note" 		    TEXT,
  "user_type"       CHAR(12)                        NOT NULL DEFAULT 'professional',
  "created_at" 	    TIMESTAMP 	                    NOT NULL DEFAULT now(),
  "updated_at" 	    TIMESTAMP 	                    NOT NULL DEFAULT now()
  
  -- Verifica que el registro tenga al menos el phone o el email
  CHECK (email IS NOT NULL OR phone IS NOT NULL)

  CHECK (email <> '')

  -- Verifica que el profesional tenga entre 18 y 85 años 
  CHECK (birthdate <= CURRENT_DATE - INTERVAL '18 years' AND birthdate >= CURRENT_DATE - INTERVAL '85 years')

  -- Valida el formato del celular
  --   CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$')
  CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$' OR phone IS NULL)
);

DROP INDEX IF EXISTS unique_email_exclude_empty;
CREATE UNIQUE INDEX unique_email_exclude_empty ON "professional" ((CASE WHEN email IS NOT NULL THEN email END));

DROP INDEX IF EXISTS unique_phone_exclude_empty;
CREATE UNIQUE INDEX unique_phone_exclude_empty ON "professional" ((CASE WHEN phone IS NOT NULL THEN phone END));
-----------------------------------------------------------------------------------------------
-- WORK_INVITATION
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "work_invitation" CASCADE;
CREATE TABLE "work_invitation" (
  "client_fk"       INTEGER         NOT NULL REFERENCES "client"(client_id),
  "professional_fk" INTEGER         NOT NULL REFERENCES "professional"(professional_id),
  "sender"          profile_options NOT NULL,     
  "is_accept"       BOOLEAN         NOT NULL DEFAULT false,
  "created_at"      TIMESTAMP       NOT NULL DEFAULT now(),
  "updated_at" 	    TIMESTAMP 	    NOT NULL DEFAULT now(),

  PRIMARY KEY ("client_fk", "professional_fk")
);
-----------------------------------------------------------------------------------------------
-- CLIENT_HAS_PROFESSIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "client_has_professional" CASCADE;
CREATE TABLE "client_has_professional" (
  "client_fk"       INTEGER         NOT NULL,
  "professional_fk" INTEGER         NOT NULL,
  "is_active"       BOOLEAN         NOT NULL DEFAULT true,
  "created_at"      TIMESTAMP       NOT NULL DEFAULT now(),
  "updated_at" 	    TIMESTAMP 	    NOT NULL DEFAULT now(),

  CONSTRAINT "client_has_professional_fkey" FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "work_invitation"("client_fk", "professional_fk"),

  PRIMARY KEY ("client_fk", "professional_fk")
);
-----------------------------------------------------------------------------------------------
-- COMPANY
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company" CASCADE;
CREATE TABLE "company" (
  "company_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "client_fk"   INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "user_fk"     INTEGER 		  NOT NULL REFERENCES "user"(user_id),
  "name" 		VARCHAR(100) 	  NOT NULL,
  "cuit" 		VARCHAR(20),
  "note" 		TEXT,
  "is_active" 	BOOLEAN 		  NOT NULL DEFAULT true,
  "created_at" 	TIMESTAMP 		  NOT NULL DEFAULT now(),
  "updated_at" 	TIMESTAMP 		  NOT NULL DEFAULT now()

);
-----------------------------------------------------------------------------------------------
-- PATIENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "patient" CASCADE;
CREATE TABLE "patient" (
  "patient_id" 			    INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "client_fk" 			    INTEGER 		    NOT NULL REFERENCES "client"(client_id),
  "user_fk" 			    INTEGER 		    NOT NULL REFERENCES "user"(user_id),
  "company_fk" 			    INTEGER 		    NOT NULL REFERENCES company(company_id),
  "name" 				    VARCHAR(100) 	    NOT NULL,
  "healthcare_provider" VARCHAR(100),
  "gender" 				      gender_options 	NOT NULL,
  "age" 				        SMALLINT,
  "phone" 				      VARCHAR(30),
  "note" 				        TEXT,
  "is_active" 			    BOOLEAN 		    NOT NULL DEFAULT true,
  "created_at" 			    TIMESTAMP 		  NOT NULL DEFAULT now(),
  "updated_at" 			    TIMESTAMP 		  NOT NULL DEFAULT now(),

  CHECK(age >= 0 AND age <= 85),

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
  "client_fk" 		INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "user_fk" 		  INTEGER 		  NOT NULL REFERENCES "user"(user_id),
  "name" 			    VARCHAR(100) 	NOT NULL,
  "abbreviation" 	VARCHAR(10) 	NOT NULL,
  "description" 	TEXT,
  "is_active" 		BOOLEAN 		  NOT NULL DEFAULT true,
  "created_at" 		TIMESTAMP 		NOT NULL DEFAULT now(),
  "updated_at" 		TIMESTAMP 		NOT NULL DEFAULT now()

);
-----------------------------------------------------------------------------------------------
-- COMPANY_HAS_TREATMENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company_has_treatment" CASCADE;
CREATE TABLE "company_has_treatment" (
  "client_fk" 		INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "user_fk" 		  INTEGER 		  NOT NULL REFERENCES "user"(user_id),
  "company_fk" 		INTEGER 		  NOT NULL REFERENCES company(company_id),
  "treatment_fk" 	INTEGER 		  NOT NULL REFERENCES treatment(treatment_id),
  "value" 			  DECIMAL(7,2) 	NOT NULL,
  "created_at" 	  TIMESTAMP 		NOT NULL DEFAULT now(),
  "updated_at" 	  TIMESTAMP 		NOT NULL DEFAULT now(),

  PRIMARY KEY ("company_fk", "treatment_fk"),
    
  CHECK ("value" >= 0)
);
-----------------------------------------------------------------------------------------------
-- TREATMENT_HAS_PROFESSIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "treatment_has_professional" CASCADE;
CREATE TABLE "treatment_has_professional" (
  "client_fk" 		  INTEGER 		  NOT NULL,
  "user_fk" 		    INTEGER 		  NOT NULL REFERENCES "user"(user_id),
  "company_fk" 		  INTEGER 		  NOT NULL REFERENCES company(company_id),
  "treatment_fk" 	  INTEGER 		  NOT NULL REFERENCES treatment(treatment_id),
  "professional_fk" INTEGER 		  NOT NULL,
  "value" 			    DECIMAL(7,2) 	NOT NULL,
  "created_at" 	    TIMESTAMP 		NOT NULL DEFAULT now(),
  "updated_at" 	    TIMESTAMP 		NOT NULL DEFAULT now(),

  -- profesional_fkey es una FK compuesta
  CONSTRAINT "treatment_has_professional_professional_fkey" FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "client_has_professional"("client_fk", "professional_fk"),
  
  PRIMARY KEY ("company_fk", "treatment_fk", "professional_fk"),

  CHECK ("value" >= 0)
);
-----------------------------------------------------------------------------------------------
-- ORDER
-- ORDER
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "order" CASCADE;
CREATE TABLE "order" (
  "order_id" 			    INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "order_fk"          INTEGER                 REFERENCES "order"(order_id),
  "client_fk" 			  INTEGER 	    NOT NULL,
  "user_fk" 			    INTEGER 	    NOT NULL REFERENCES "user"(user_id),
  "patient_fk" 			  INTEGER 	    NOT NULL  REFERENCES patient(patient_id),
  "treatment_fk" 		  INTEGER 	    NOT NULL  REFERENCES treatment(treatment_id),
  "professional_fk" 	INTEGER,
  "start_date" 			  TIMESTAMP 	  NOT NULL,
  "finish_date" 		  TIMESTAMP     NOT NULL,
  "has_medical_order" BOOLEAN 	    NOT NULL  DEFAULT false,
  "frequency" 			  SMALLINT 	    NOT NULL,
  "total_sessions" 		SMALLINT 	    NOT NULL,
  "sessions" 			    SMALLINT 	    NOT NULL,
  "coinsurance" 		  DECIMAL(7,2)  NOT NULL  DEFAULT 0,
  "value" 		        DECIMAL(7,2)  NOT NULL,
  "cost" 		          DECIMAL(7,2)  NOT NULL,
  "diagnosis" 			  TEXT,
  "requirements" 		  VARCHAR(300),
  "is_active" 		    BOOLEAN       NOT NULL  DEFAULT true,
  "created_at" 			  TIMESTAMP 	  NOT NULL  DEFAULT now(),
  "updated_at" 			  TIMESTAMP 	  NOT NULL  DEFAULT now(),
    
  -- profesional_fkey es una FK compuesta
  CONSTRAINT "order_professional_fkey" FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "client_has_professional"("client_fk", "professional_fk"),
  
  -- Validacion de "start_date" y "finish_date", intervalo 1 year
  CHECK (start_date >= CURRENT_DATE - INTERVAL '1 year' AND start_date <= CURRENT_DATE + INTERVAL '1 year'),
  CHECK (finish_date >= CURRENT_DATE - INTERVAL '1 year' AND finish_date <= CURRENT_DATE + INTERVAL '1 year'),

  -- verificar si ambas fechas pertenecen al mismo mes y que la fecha de inicio no sea mas reciente que la de fin
  CHECK (start_date <= finish_date 
    AND
      EXTRACT(MONTH FROM start_date) = EXTRACT(MONTH FROM finish_date) 
    AND
      EXTRACT(YEAR FROM start_date) = EXTRACT(YEAR FROM finish_date)
  ),

  CHECK (frequency BETWEEN 1 AND 7),

  CHECK (total_sessions 	>= 0 AND total_sessions <= 31),
  CHECK ("sessions" 		>= 0 AND sessions 		<= total_sessions),
  CHECK (coinsurance 		>= 0),
  CHECK ("value" 	>= 0),
  CHECK (cost 	>= 0)
);
-----------------------------------------------------------------------------------------------
-- CLAIM
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "claim" CASCADE;
CREATE TABLE "claim" (
  "claim_id" 		  INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "order_fk" 		  INTEGER 		    NOT NULL REFERENCES "order"(order_id),
  "client_fk" 		INTEGER 		    NOT NULL REFERENCES "client"(client_id),
  "user_fk" 		  INTEGER 		    NOT NULL REFERENCES "user"(user_id),
  "cause" 			  TEXT 			      NOT NULL,
  "urgency"       urgency_options NOT NULL,
  "reported_date" TIMESTAMP 		  NOT NULL,
  "is_active" 		BOOLEAN 		    NOT NULL DEFAULT true,
  "created_at" 		TIMESTAMP 		  NOT NULL DEFAULT now(),
  "updated_at" 		TIMESTAMP 		  NOT NULL DEFAULT now(),

  CHECK (reported_date >= CURRENT_DATE - INTERVAL '31 days')
);