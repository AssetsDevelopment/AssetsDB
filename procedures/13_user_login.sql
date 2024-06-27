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
$function$;

CREATE OR REPLACE FUNCTION public.professional_login(
	professional_email character varying DEFAULT NULL,
	professional_phone character varying DEFAULT NULL,
	professional_password character varying DEFAULT NULL
)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    was_found INTEGER;
BEGIN 
    SELECT p.professional_id INTO was_found
    FROM "professional" p 
    WHERE (p.email = professional_email OR p.phone = professional_phone)
    AND p.password = crypt(professional_password, password);
    
    IF was_found IS NULL THEN RETURN 0; END IF;

    RETURN was_found;
END;
$function$;

-- SELECT user_login('baig', '43721804');