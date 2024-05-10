CREATE OR REPLACE FUNCTION is_active_company()
RETURNS TRIGGER AS $$
DECLARE
	company_name VARCHAR(100);
BEGIN
    SELECT "name" INTO company_name
    FROM company
    WHERE company_id = NEW.company_fk AND is_active = false;

    IF company_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La empresa referenciada (%) no está activa.', company_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- PATIENT
CREATE TRIGGER trg_is_active_company_for_patient
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
EXECUTE FUNCTION is_active_company();

-- TREATMENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_company_for_treatment_has_professional
BEFORE INSERT OR UPDATE ON treatment_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_company();

-- COMPANY_HAS_TREATMENT
CREATE TRIGGER trg_is_active_company_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_company();