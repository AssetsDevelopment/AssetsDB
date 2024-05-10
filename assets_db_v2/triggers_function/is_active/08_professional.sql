CREATE OR REPLACE FUNCTION is_active_professional()
RETURNS TRIGGER AS $$
DECLARE 
	professional_name VARCHAR(100);
BEGIN

    -- Esta funcion tambien verifica que el profesional pertenezca al coordinador 

    SELECT      p."name" INTO professional_name 
    FROM        client_has_professional chp
    INNER JOIN  professional p ON p.professional_id = chp.professional_fk
    WHERE       chp.professional_fk = NEW.professional_fk 
    AND         chp.client_fk = NEW.client_fk
    AND         chp.is_active = false;

    IF professional_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El profesional referenciado (%) no está activo.', professional_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- TREATMENT_HAS_PROFESSIONAL
CREATE TRIGGER trg_is_active_professional_for_treatment_has_professional
BEFORE INSERT OR UPDATE ON treatment_has_professional
FOR EACH ROW
EXECUTE FUNCTION is_active_professional();

-- ORDER -- VERIFICAR QUE SI EL PROFESIONAL QUE TENIA ASIGNADO ESTA INACTIVO, SE PUEDA REASIGNAR A OTRO PROFESIONAL Y QUE NO SE PUEDA REASIGNAR A UN PROFESIONAL INACTIVO 
CREATE TRIGGER trg_is_active_professional_for_order
BEFORE INSERT OR UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION is_active_professional();