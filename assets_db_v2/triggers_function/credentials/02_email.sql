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

-- PROFESIONAL
CREATE TRIGGER trg_insert_profesional_validate_email
BEFORE INSERT ON "professional"
FOR EACH ROW
EXECUTE FUNCTION validate_email();

CREATE TRIGGER trg_update_profesional_validate_email
BEFORE UPDATE ON "professional"
FOR EACH ROW
WHEN (NEW.email <> OLD.email)
EXECUTE FUNCTION validate_email();

-- USER
CREATE TRIGGER trg_insert_user_validate_email
BEFORE INSERT ON "user"
FOR EACH ROW
EXECUTE FUNCTION validate_email();

CREATE TRIGGER trg_update_user_validate_email
BEFORE UPDATE ON "user"
FOR EACH ROW
WHEN (NEW.email <> OLD.email)
EXECUTE FUNCTION validate_email();