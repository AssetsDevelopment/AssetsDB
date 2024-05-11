CREATE OR REPLACE FUNCTION is_active_order()
RETURNS TRIGGER AS $$
DECLARE 
	order_name varchar(100);
BEGIN
    SELECT p."name" INTO order_name 
    FROM "order" o
    INNER JOIN patient p ON p.patient_id = o.patient_fk
    WHERE o.order_id = NEW.order_fk AND o.is_active = false;

    IF order_name IS NOT NULL THEN
        RAISE EXCEPTION 'No se puede INSERT, UPDATE o DELETE el registro. El pedido referenciado de (%) no está activo.', order_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- CLAIM
CREATE TRIGGER trg_is_active_order_for_claim
BEFORE INSERT OR UPDATE ON claim
FOR EACH ROW
EXECUTE FUNCTION is_active_order();
