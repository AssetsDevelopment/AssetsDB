CREATE OR REPLACE FUNCTION is_active_patient()
RETURNS TRIGGER AS $$
DECLARE 
	patient_name varchar(100);
BEGIN
    SELECT "name" INTO patient_name 
    FROM patient
    WHERE patient_id = NEW.patient_fk AND is_active = false;

    IF patient_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El paciente referenciado (%) no está activo.', patient_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- ORDER 
CREATE TRIGGER trg_is_active_patient_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_patient();