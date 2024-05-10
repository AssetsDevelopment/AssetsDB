CREATE OR REPLACE FUNCTION is_active_treatment()
RETURNS TRIGGER AS $$
DECLARE 
	treatment_name VARCHAR(100);
BEGIN
    SELECT "name" INTO treatment_name 
    FROM treatment
    WHERE treatment_id = NEW.treatment_fk AND is_active = false;

    IF treatment_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La prestacion referenciada (%) no está activa.', treatment_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- TREATMENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_treatment_for_treatment_has_professional
BEFORE INSERT OR UPDATE ON treatment_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();

-- COMPANY_HAS_TREATMENT
CREATE TRIGGER trg_is_active_treatment_for_company_has_treatment
BEFORE INSERT OR UPDATE ON company_has_treatment
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();

-- ORDER
CREATE TRIGGER trg_is_active_treatment_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_treatment();