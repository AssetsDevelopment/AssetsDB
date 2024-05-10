-- refresh_updated_at_column: Actualiza el campo updated_at con la fecha actual
CREATE OR REPLACE FUNCTION refresh_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- ejecucion automatica de la funcion refresh_updated_at_column
DO $$ 
    DECLARE
        table_name_var text;
    BEGIN
        FOR table_name_var IN (SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE') LOOP
            EXECUTE 'CREATE TRIGGER "' || table_name_var || '_refresh_trigger"
                    BEFORE UPDATE ON "' || table_name_var || '"
                    FOR EACH ROW EXECUTE FUNCTION refresh_updated_at_column();';
        END LOOP;
END $$;
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
-- proteger created_at - ejecutado
CREATE OR REPLACE FUNCTION prevent_modification_created_at()
    RETURNS TRIGGER AS $$
    BEGIN
        RAISE EXCEPTION 'No se permite modificar el campo "created_at"';
    END;
$$ LANGUAGE plpgsql;

-- ejecucion automatica de la funcion prevent_modification_created_at
DO $$ 
    DECLARE
        table_name_var text;
    BEGIN
        FOR table_name_var IN (SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE') LOOP
            EXECUTE 'CREATE TRIGGER "' || table_name_var || '_prevent_modification"
                    BEFORE UPDATE ON "' || table_name_var || '"
                    FOR EACH ROW WHEN (NEW.created_at <> OLD.created_at)
                    EXECUTE FUNCTION prevent_modification_created_at();';
        END LOOP;
END $$;
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
-- check_admin_exists: Verifica que no exista mas de un usuario administrador por cliente
CREATE OR REPLACE FUNCTION check_admin_exists()
    RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM "user"
            WHERE client_fk = NEW.client_fk AND is_admin = true
        ) AND NEW.is_admin = true THEN
            RAISE EXCEPTION 'Ya existe un usuario administrador para este cliente';
        END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
-- prevent_true_insertion: Verifica que no se inserte el valor true en la columna is_accept
CREATE OR REPLACE FUNCTION prevent_true_insertion()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.is_accept THEN
            RAISE EXCEPTION 'No se permite el valor true en la columna "is_accept" durante la inserción';
        END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
-- process_professional_assignment_change: Si se acepta la invitacion, se crea la relacion entre el profesional y el coordinador en la tabla client_has_professional. Si se borra una relacion entre el profesional y el coordinador, es decir, que el campo is_accept se modifica a false, se borran los registros guardados sobre los valores de ese profesional vinculado a su coordinador en la tabla treatment_has_professional, se desvincula al profesional de todos los pedidos NO FINALIZADOS que tenia asignado en la tabla "order", se borra la relacion entre el coordinador y el profesional en la tabla client_has_professional y se borra la invitacion entre el coordinador y el profesional en la tabla work_invitation
CREATE OR REPLACE FUNCTION process_professional_assignment_change()
    RETURNS TRIGGER AS $$
    DECLARE
        message VARCHAR(1000);
        cantidad_registros_afectados INT;
    BEGIN
        IF NEW.is_accept THEN
    --      verifico que la relacion entre el profesional y el coordinador no exista
            IF EXISTS (
                SELECT 1
                FROM client_has_professional
                WHERE client_fk = NEW.client_fk AND professional_fk = NEW.professional_fk
            ) THEN
    --          si existe, activo la relacion entre el profesional y el coordinador
                UPDATE client_has_professional
                SET is_active = true
                WHERE client_fk = NEW.client_fk AND professional_fk = NEW.professional_fk;
                GET DIAGNOSTICS cantidad_registros_afectados = ROW_COUNT;
                message := 'Se actualizó client_has_professional. Registros afectados: ' || cantidad_registros_afectados;

                RAISE NOTICE '%', message;
                RETURN NEW;
            END IF;

    -- 		creo la relacion entre el profesional y el coordinador
            INSERT INTO client_has_professional (client_fk, professional_fk)
            VALUES (NEW.client_fk, NEW.professional_fk);
            GET DIAGNOSTICS cantidad_registros_afectados = ROW_COUNT;
            message := 'Se insertó en client_has_professional. Registros afectados: ' || cantidad_registros_afectados;
        ELSE 
    --     	borro los registros guardados sobre los valores de ese profesional vinculado a su coordinador
            DELETE FROM treatment_has_professional
            WHERE 		client_fk 		= NEW.client_fk 
            AND 		professional_fk = NEW.professional_fk;
            GET DIAGNOSTICS cantidad_registros_afectados = ROW_COUNT;
            message := 'Se eliminaron registros de treatment_has_professional. Registros afectados: ' || cantidad_registros_afectados;
    -- 		desvinculo al profesional de todos los pedidos NO FINALIZADOS que tenia asignado
            UPDATE 	"order"
            SET 	professional_fk = NULL 
            WHERE 	client_fk 		= NEW.client_fk
            AND 	professional_fk = NEW.professional_fk
            AND     is_active 		= true;
            GET DIAGNOSTICS cantidad_registros_afectados = ROW_COUNT;
            message := message || E'\n' || 'Se actualizó "order". Registros afectados: ' || cantidad_registros_afectados;
    -- 		desactivo la relacion entre el coordinador y el profesional
            UPDATE 	"client_has_professional"
            SET 	is_active       = FALSE 
            WHERE 	client_fk 		= NEW.client_fk
            AND 	professional_fk = NEW.professional_fk;
            GET DIAGNOSTICS cantidad_registros_afectados = ROW_COUNT;
            message := message || E'\n' || 'Se actualizó "client_has_professional". Registros afectados: ' || cantidad_registros_afectados;
        END IF;
        RAISE NOTICE '%', message;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


--########################################################################################################
-- TRIGGERS ##############################################################################################
--########################################################################################################

----------------------------------------------------------------------------------------------------------
-- user --------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CREATE TRIGGER trg_update_check_admin_exists
BEFORE UPDATE ON "user"
FOR EACH ROW
WHEN (NEW.is_admin <> OLD.is_admin)
EXECUTE FUNCTION check_admin_exists();

CREATE TRIGGER trg_insert_check_admin_exists
BEFORE INSERT ON "user"
FOR EACH ROW
EXECUTE FUNCTION check_admin_exists();
----------------------------------------------------------------------------------------------------------
-- work_invitation ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_true_insertion
BEFORE INSERT ON work_invitation
FOR EACH ROW
EXECUTE FUNCTION prevent_true_insertion();

CREATE TRIGGER trg_process_professional_assignment_change
AFTER UPDATE OF is_accept ON work_invitation
FOR EACH ROW
WHEN (NEW.is_accept <> OLD.is_accept)
EXECUTE FUNCTION process_professional_assignment_change();

