CREATE OR REPLACE FUNCTION is_active_screen()
RETURNS TRIGGER AS $$
DECLARE 
	screen_name VARCHAR(100);
BEGIN
    SELECT "name" INTO screen_name 
    FROM screen
    WHERE screen_id = NEW.screen_fk AND is_active = false;

    IF screen_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. La vista referenciada (%) no está activa.', screen_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- PERMISSION
CREATE TRIGGER trg_is_active_screen_for_permission
BEFORE INSERT OR UPDATE ON permission
FOR EACH ROW
EXECUTE FUNCTION is_active_screen();

