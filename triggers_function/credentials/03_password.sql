CREATE extension pgcrypto; -- biblioteca para encriptar contraseña

CREATE OR REPLACE FUNCTION validate_password()
RETURNS trigger AS 
$$
BEGIN
    -- Validar que la contraseña tenga al menos 8 caracteres
    IF length(NEW.password) < 8 THEN
        RAISE EXCEPTION 'La contraseña debe tener al menos 8 caracteres';
    END IF;

    -- Hashear la contraseña
    NEW.password = crypt(NEW.password, gen_salt('bf'));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- PROFESIONAL 
CREATE TRIGGER trg_insert_profesional_validate_password
BEFORE INSERT ON "professional"
FOR EACH ROW
EXECUTE FUNCTION validate_password();

CREATE TRIGGER trg_update_profesional_validate_password
BEFORE UPDATE ON "professional"
FOR EACH ROW
WHEN (NEW.password <> OLD.password)
EXECUTE FUNCTION validate_password();

-- USER 
CREATE TRIGGER trg_insert_user_validate_password
BEFORE INSERT ON "user"
FOR EACH ROW
EXECUTE FUNCTION validate_password();

CREATE TRIGGER trg_update_user_validate_password
BEFORE UPDATE ON "user"
FOR EACH ROW
WHEN (NEW.password <> OLD.password)
EXECUTE FUNCTION validate_password();
