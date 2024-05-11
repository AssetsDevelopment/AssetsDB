CREATE OR REPLACE FUNCTION public.user_login(user_email character varying, user_password character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    was_found INTEGER;
BEGIN 
    SELECT u.user_id INTO was_found
    FROM "user" u 
    WHERE u.email = user_email
    AND u.password = crypt(user_password, password);
    
    IF was_found IS NULL THEN RETURN 0; END IF;

    RETURN was_found;
END;
$function$


-- SELECT user_login('baig', '43721804');