CREATE OR REPLACE FUNCTION is_active_client()
RETURNS TRIGGER AS $$
DECLARE 
	client_name varchar(100);
BEGIN
    SELECT "name" INTO client_name 
    FROM client
    WHERE client_id = NEW.client_fk AND is_active = false;

    IF client_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El coordinador referenciado (%) no está activo.', client_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- USER
CREATE TRIGGER trg_is_active_client_for_user
BEFORE INSERT OR UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- COMPANY
CREATE TRIGGER trg_is_active_client_for_company
BEFORE INSERT OR UPDATE ON company
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- PATIENT
CREATE TRIGGER trg_is_active_client_for_patient
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- TREATMENT
CREATE TRIGGER trg_is_active_client_for_treatment
BEFORE INSERT OR UPDATE ON treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- PERMISSION
CREATE TRIGGER trg_is_active_client_for_permission
BEFORE INSERT OR UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- TREATMENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_client_for_treatment_has_professional
BEFORE INSERT OR UPDATE ON treatment_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- COMPANY_HAS_TREATMENT
CREATE TRIGGER trg_is_active_client_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- ORDER
CREATE TRIGGER trg_is_active_client_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- CLAIM
CREATE TRIGGER trg_is_active_client_for_claim
BEFORE INSERT OR UPDATE ON claim
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- WORK_INVITATION
CREATE TRIGGER trg_is_active_client_for_work_invitation
BEFORE INSERT OR UPDATE ON work_invitation
FOR EACH ROW
EXECUTE FUNCTION is_active_client();

-- CLIENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_client_for_client_has_professional
BEFORE INSERT OR UPDATE ON client_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_client();