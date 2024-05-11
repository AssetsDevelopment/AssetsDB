CREATE OR REPLACE FUNCTION is_active_user()
RETURNS TRIGGER AS $$
DECLARE 
	user_name VARCHAR(100);
BEGIN
    SELECT "name" INTO user_name
    FROM "user"
    WHERE user_id = NEW.user_fk AND is_active = false;

    IF user_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El usuario referenciado (%) no está activo.', user_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- COMPANY
CREATE TRIGGER trg_is_active_user_for_company
BEFORE INSERT OR UPDATE ON company
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- PATIENT
CREATE TRIGGER trg_is_active_user_for_patient
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TREATMENT
CREATE TRIGGER trg_is_active_user_for_treatment
BEFORE INSERT OR UPDATE ON treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- PERMISSION
CREATE TRIGGER trg_is_active_user_for_permission
BEFORE INSERT OR UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- TREATMENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_user_for_treatment_has_professional
BEFORE INSERT OR UPDATE ON treatment_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- COMPANY_HAS_TREATMENT
CREATE TRIGGER trg_is_active_user_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- ORDER
CREATE TRIGGER trg_is_active_user_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_user();

-- CLAIM
CREATE TRIGGER trg_is_active_user_for_claim
BEFORE INSERT OR UPDATE ON claim
FOR EACH ROW
EXECUTE FUNCTION is_active_user();