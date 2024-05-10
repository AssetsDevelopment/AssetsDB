-- TRIGGER PARA HASHEAR PASSWORD ANTES DE INSERT O UPDATE
CREATE TRIGGER trg_hash_password
BEFORE INSERT OR UPDATE OF password ON "user"
FOR EACH ROW
EXECUTE FUNCTION hash_password();


create or replace function hash_password()
returns trigger as 
$$

begin 

    NEW.password = crypt(NEW.password, gen_salt('bf'));
    
    RETURN NEW;

end;

$$ LANGUAGE plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CHECK IS ACTIVE

-- IS_ACTIVE_USER - ejecutado
CREATE OR REPLACE FUNCTION is_active_user()
RETURNS TRIGGER AS $$
declare 
	user_name varchar(100);
BEGIN
    SELECT name INTO user_name
    FROM "user"
    WHERE user_id = NEW.user_fk AND is_active = false;

    IF user_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El usuario referenciado (%) no está activo.', user_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- IS_ACTIVE_COMPANY - ejecutado
CREATE OR REPLACE FUNCTION is_active_company()
RETURNS TRIGGER AS $$
declare 
	company_name varchar(100);
BEGIN
    SELECT name INTO company_name
    FROM company
    WHERE company_id = NEW.company_fk AND is_active = false;

    IF company_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La empresa referenciada (%) no está activa.', company_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- IS_ACTIVE_SCREEN - ejecutado
CREATE OR REPLACE FUNCTION is_active_screen()
RETURNS TRIGGER AS $$
declare 
	screen_name varchar(100);
BEGIN
    SELECT name INTO screen_name 
    FROM screen
    WHERE screen_id = NEW.screen_fk AND is_active = false;

    IF screen_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La vista referenciada (%) no está activa.', screen_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- IS_ACTIVE_TREATMENT - ejecutado
CREATE OR REPLACE FUNCTION is_active_treatment()
RETURNS TRIGGER AS $$
declare 
	treatment_name varchar(100);
BEGIN
    SELECT name INTO treatment_name 
    FROM treatment
    WHERE treatment_id = NEW.treatment_fk AND is_active = false;

    IF treatment_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La prestacion referenciada (%) no está activa.', treatment_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- IS_ACTIVE_PROFESIONAL - ejecutado
CREATE OR REPLACE FUNCTION is_active_profesional()
RETURNS TRIGGER AS $$
declare 
	profesional_name varchar(100);
BEGIN
    SELECT name INTO profesional_name 
    FROM profesional
    WHERE profesional_id = NEW.profesional_fk AND is_active = false;

    IF profesional_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El profesional referenciado (%) no está activo.', profesional_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- IS_ACTIVE_PATIENT - ejecutado
CREATE OR REPLACE FUNCTION is_active_patient()
RETURNS TRIGGER AS $$
declare 
	patient_name varchar(100);
BEGIN
    SELECT name INTO patient_name 
    FROM patient
    WHERE patient_id = NEW.patient_fk AND is_active = false;

    IF patient_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El paciente referenciado (%) no está activo.', patient_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- prevent_update_history - ejecutado
CREATE OR REPLACE FUNCTION prevent_update_history()
RETURNS TRIGGER AS $$
DECLARE
    date_difference INTERVAL;
    user_rol int;
BEGIN
    date_difference := CURRENT_DATE - OLD.created_at;

	SELECT 1 INTO user_rol 
	FROM "user"
	WHERE user_id = NEW.user_fk AND rol = 'coordinador';

    IF date_difference > interval '31 days' AND user_rol IS NULL THEN
        RAISE EXCEPTION 'No se permite actualizar o eliminar registros del historial con una diferencia mayor a 31 días desde la fecha de creación';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- check_status_order - ejecutado
CREATE OR REPLACE FUNCTION check_status_order()
RETURNS TRIGGER AS $$
DECLARE

BEGIN

	if EXISTS (
		SELECT 1 
		FROM "order"
		WHERE order_id = NEW.order_fk AND "state" = 'finalizado'
	) then

        RAISE EXCEPTION 'No se permite crear un reclamo de una orden finalizada';
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- validate_email - ejecutado
CREATE OR REPLACE FUNCTION validate_email()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email IS NOT NULL THEN
        IF NEW.email !~ '[A-Za-z0-9._%-]+@(gmail|yahoo|outlook|hotmail|aol|icloud|protonmail)\.(com|net|org)' THEN
            RAISE EXCEPTION 'El email es invalido o no pertence a un dominio conocido.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- actualizar updated_at - ejecutado
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-----------------------------------------------------------------------------------------------
-- proteger created_at - ejecutado
CREATE OR REPLACE FUNCTION prevent_created_at_update()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'No se permite modificar el campo "created_at"';
END;
$$ LANGUAGE plpgsql;










-- TRIGGER COMPANY -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_company
BEFORE INSERT OR UPDATE ON company
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER COMPANY -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_company
BEFORE UPDATE ON company
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER COMPANY -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_company
BEFORE UPDATE ON company
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER PATIENT -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_patient
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER PATIENT -> COMPANY - ejecutado
CREATE TRIGGER trg_is_active_company_for_patient
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION is_active_company();

-- TRIGGER PATIENT -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_patient
BEFORE UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER PATIENT -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_patient
BEFORE UPDATE ON patient
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER TREATMENT -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_treatment
BEFORE INSERT OR UPDATE ON treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER TREATMENT -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_treatment
BEFORE UPDATE ON treatment
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER TREATMENT -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_treatment
BEFORE UPDATE ON treatment
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER PROFESIONAL -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_profesional
BEFORE INSERT OR UPDATE ON profesional
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER PROFESIONAL -> validate_email - ejecutado
CREATE TRIGGER trg_validate_email_for_profesional
BEFORE INSERT OR UPDATE ON profesional
FOR EACH ROW
EXECUTE FUNCTION validate_email();

-- TRIGGER PROFESIONAL -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_profesional
BEFORE UPDATE ON profesional
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER PROFESIONAL -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_profesional
BEFORE UPDATE ON profesional
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER USER -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_user
BEFORE INSERT OR UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER USER -> validate_email - ejecutado
CREATE TRIGGER trg_validate_email_for_user
BEFORE INSERT OR UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION validate_email();

-- TRIGGER USER -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_user
BEFORE UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER USER -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_user
BEFORE UPDATE ON "user"
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER SCREEN -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_screen
BEFORE UPDATE ON screen
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER SCREEN -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_screen
BEFORE UPDATE ON screen
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER PERMISSION -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_permission
BEFORE INSERT OR UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER PERMISSION -> SCREEN - ejecutado
CREATE TRIGGER trg_is_active_screen_for_permission
BEFORE INSERT OR UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION is_active_screen();

-- TRIGGER PERMISSION -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_permission
BEFORE UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER PERMISSION -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_permission
BEFORE UPDATE ON permission
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER TREATMENT_HAS_PROFESIONAL -> COMPANY - ejecutado
CREATE TRIGGER trg_is_active_company_for_treatment_has_profesional
BEFORE INSERT OR UPDATE ON treatment_has_profesional
FOR EACH ROW
EXECUTE FUNCTION is_active_company();

-- TRIGGER TREATMENT_HAS_PROFESIONAL -> TREATMENT - ejecutado
CREATE TRIGGER trg_is_active_treatment_for_treatment_has_profesional
BEFORE INSERT OR UPDATE ON treatment_has_profesional
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();

-- TRIGGER TREATMENT_HAS_PROFESIONAL -> PROFESIONAL - ejecutado
CREATE TRIGGER trg_is_active_profesional_for_treatment_has_profesional
BEFORE INSERT OR UPDATE ON treatment_has_profesional
FOR EACH ROW
EXECUTE FUNCTION is_active_profesional();

-- TRIGGER TREATMENT_HAS_PROFESIONAL -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_treatment_has_profesional
BEFORE INSERT OR UPDATE ON treatment_has_profesional
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER TREATMENT_HAS_PROFESIONAL -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_treatment_has_profesional
BEFORE UPDATE ON treatment_has_profesional
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER TREATMENT_HAS_PROFESIONAL -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_treatment_has_profesional
BEFORE UPDATE ON treatment_has_profesional
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER COMPANY_HAS_TREATMENT -> COMPANY - ejecutado
CREATE TRIGGER trg_is_active_company_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_company();

-- TRIGGER COMPANY_HAS_TREATMENT -> TREATMENT - ejecutado
CREATE TRIGGER trg_is_active_treatment_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();

-- TRIGGER COMPANY_HAS_TREATMENT -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER COMPANY_HAS_TREATMENT -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_company_has_treatment
BEFORE UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER COMPANY_HAS_TREATMENT -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_company_has_treatment
BEFORE UPDATE ON company_has_treatment
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER ORDER -> PATIENT - ejecutado
CREATE TRIGGER trg_is_active_patient_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_patient();

-- TRIGGER ORDER -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER ORDER -> TREATMENT - ejecutado
CREATE TRIGGER trg_is_active_treatment_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();

-- TRIGGER ORDER -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_order
BEFORE UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER ORDER -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_order
BEFORE UPDATE ON "order"
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();

-- TRIGGER ORDER -> PROFESIONAL - ESTE NO VA PORQUE ESTO SI PUEDO CAMBIAR 
-- (NO PERMITIRIA REASIGNAR UN PROFESIONAL)
-- CREATE TRIGGER trg_is_active_profesional_for_order
-- BEFORE INSERT OR UPDATE ON "order"
-- FOR EACH ROW
-- EXECUTE FUNCTION is_active_profesional();
----------------------------------------------------------------------
-- TRIGGER HISTORY INTERVAL 31 DAYS - ejecutado
CREATE TRIGGER prevent_history_update
BEFORE UPDATE ON history
FOR EACH ROW
EXECUTE FUNCTION prevent_update_history();

-- TRIGGER HISTORY -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_history
BEFORE INSERT OR UPDATE ON history
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER HISTORY -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_history
BEFORE UPDATE ON history
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER HISTORY -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_history
BEFORE UPDATE ON history
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER CLAIM -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_claim
BEFORE INSERT OR UPDATE ON claim
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER CLAIM - ejecutado
CREATE TRIGGER trg_check_status_order_for_claim
BEFORE INSERT ON claim
FOR EACH ROW
EXECUTE FUNCTION check_status_order();

-- TRIGGER CLAIM -> updated_at - ejecutado
CREATE TRIGGER trg_update_updated_at_for_claim
BEFORE UPDATE ON claim
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER CLAIM -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_claim
BEFORE UPDATE ON claim
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();
----------------------------------------------------------------------
-- TRIGGER TOKEN -> USER - ejecutado
CREATE TRIGGER trg_is_active_user_for_token
BEFORE INSERT OR UPDATE ON token
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TRIGGER TOKEN -> created_at - ejecutado
CREATE TRIGGER tr_prevent_created_at_update_for_token
BEFORE UPDATE ON token
FOR EACH ROW
WHEN (NEW.created_at <> OLD.created_at)
EXECUTE FUNCTION prevent_created_at_update();