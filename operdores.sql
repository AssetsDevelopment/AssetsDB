select * from users;

-- Nombre, apellido e IP, donde la ultima conexion se dio de 221.XXX.XXX.XXX

select 	u.first_name, u.last_name, u.last_connection 
from 	users u
WHERE 	u.last_connection like '221.%';

-- Nombre, apellido y seguidores(followers) de todos a los que lo siguen mas de 4600 personas 
select 	u.first_name, u.last_name, u.followers
from 	users u 
where 	u.followers > 4600;

-- Operador Between
select 	u.first_name, u.last_name, u.followers
from 	users u 
where 	u.followers BETWEEN 4600 and 4700;

-- Operador COUNT
select count(*) from users;

-- Operador MIN
select MIN(followers) from users;

-- Operador MAX 
select MAX(followers) from users;

-- Operador AVG (Promedio) y ROUND (Redondear)
select ROUND(AVG(followers)) from users;

-- Operador SUM
select SUM(followers) from users;

-- Operador GROUP BY
select count(*), followers
from users
where followers = 4 or followers = 4999
group by followers;

/*
	Terminologia SQL
	
		- DDL (Data Definition Language): Create, Alter, Drop, Truncate
		
		- DML (Data Manipulation Language): Insert, Delete, Update
		
		- TCL (Transaction Control Language): Commit, Rollback
		
		- DQL (Data Query Language): Select		
*/

/*
	Aggregate Functions
	
		. Count
		. Sum
		. Max
		. Min
		. Order By
		. Group By
		. Having
		
	Filtering
	
		. Like
		. In
		. Is Null
		. Is Not Null
		. Where
		. And
		. Or
		. Between
*/

-- Operador Having
select 		count(*), country
from 		users
group by 	country
having 		count(*) BETWEEN 1 and 5
order by 	count(*) desc;

-- Operador Distinct
select 	DISTINCT country
from users;

-- Group By con otras funciones
select 		count(*) as cant, SUBSTRING(email, POSITION('@' in email) + 1) as domain
from 		users
group by 	domain
having 		count(*) > 1
order by 	count(*) desc;

-- Constrain

-- Añadir llave primaria
Alter table country add primary key (code);

-- Añadir un check, un constrain es especial
alter table country add CHECK(
	surfacearea >= 0
);

-- Anñadir UNIQUE, el text es para aclarar que recibira un string
alter table country add CHECK(
	(continent = 'Asia'::text) or
	(continent = 'South America'::text) or
	(continent = 'Central America'::text) or
	(continent = 'North America'::text) or
	(continent = 'Oceania'::text) or
	(continent = 'Antarctica'::text) or
	(continent = 'Africa'::text) or
	(continent = 'Europe'::text) 
);

-- drop constrain
alter table country drop CONSTRAINT "country_continent_check";

-- crear un indice unique
create unique index "unique_country_name" on country (
	name
);

-- crear un indice
create index "country_continent" on country (
	continent
);

-- crear indicie unico compuesto
create unique index "unique_name_countrycode_district" on city (
	name,
	countrycode,
	district
);

create index "indexdistrict" on city (
	district
);

-- crear fk 1:n
alter table 	city
add CONSTRAINT 	fk_country_code
FOREIGN key 	(countrycode)
REFERENCES 		country(code);

-- insercion masiva
insert into continent (name) 
select DISTINCT continent
from country
order by continent asc;

-- actualizacion masiva
update country ctry 
set continent = ( select "code" from continent ct where "name" = ctry.continent );

-- cambiar el tipo a una columna
alter table country 
alter COLUMN continent type int4
using continent::INTEGER;

-- clausula UNION
-- los query de union deben tener la misma cant de columnas y del mismo tipo
select * from continent where name like '%America%'
union 
select * from continent where code in (3,5)
order by name asc;

-- union con where
select a.name as country, b.name as continent 
from country a, continent b
where a.continent = b.code
order by a.name asc;

-- union con inner join
select a.name, a.continent
from country a
inner join continent on continent.code = a.continent
order by a.name asc;

-- Reiniciar la secuencia en un numero particular
alter SEQUENCE continent_code_seq RESTART WITH 8;

-- FULL OUTER JOIN
select 
	a.name as country, 
	a.continent as continentCode,
	b.name as continentName
from country a
full outer join continent b
on a.continent = b.code
order BY a.name DESC;

-- RIGHT OUTER JOIN
select 
	a.name as country, 
	a.continent as continentCode,
	b.name as continentName
from country a
RIGHT join continent b on a.continent = b.code
where a.continent is NULL
order BY a.name DESC;

-- group by con inner join 
select count(*), cn.name
from country cu
inner join continent cn on cn.code = cu.continent
GROUP by cn.name
order by count(*);

-- group by con full outer join 
select count(*), cn.name
from country cu
full outer join continent cn on cn.code = cu.continent
GROUP by cn.name
order by count(*);

-- traer la cantidad de todos, incluyendo a los que no tienen (0)
(
	select count(*) as count, b.name 
	from country a
	inner join continent b on a.continent = b.code
	GROUP by b.name
)
union 
(
	select 0 as count, b.name 
	from country a
	RIGHT join continent b on a.continent = b.code
	WHERE a.continent is NULL
	GROUP by b.name
)
ORDER by count;

-- Quiero que me muestren el pais con mas ciudades 
-- Campos: total de coidades y el nombre del pais 
-- usar inner join

select count(*) as ciudades, b.name as pais
from city a
inner join country b on b.code = a.countrycode
GROUP by b.name
order by count(*) desc
limit 1;

-- obtener los idiomas oficiales que se hablan por continente

select DISTINCT l.name, cn.name
from countrylanguage cl
inner join country cu on cu.code = cl.countrycode
inner join continent cn on cn.code = cu.continent
inner join "language" l on l.code = cl.languagecode
where cl.isofficial = true
order by cn.name;

-- cuantos idiomas oficiales se hablan por continente

select count(*), continent
from (
	select DISTINCT a."language", c."name" as continent
	from countrylanguage a
	inner join country b on b.code = a.countrycode
	inner join continent c on c.code = b.continent
	where a.isofficial = true
) as totales
GROUP by continent
order by continent;

-- ¿Cual es el idioma (y codigo del idioma) oficial mas hablado por diferentes paises en Europa?

select count(*) as country, cl."language", cl.languagecode
from country cu
inner join countrylanguage cl on cl.countrycode = cu.code
where cu.continent = 5
and cl.isofficial = true
group by cl."language", cl.languagecode
order by country desc
limit 1;

-- Listado de todos los paises cuyo idioma oficial es el mas hablado de Europa (no hacer subquery, tomar el codigo anterior)

select cu.name
from country cu
inner join countrylanguage cl on cl.countrycode = cu.code
where cl.languagecode = 135
and cu.continent = 5
and cl.isofficial = true
order by cu.name;

-- funcion "now()", timestamp actual del servidor donde se encuentra la base de datos 

select now();

-- funcion "CURRENT_DATE", fecha actual del servidor donde se encuentra la base de datos 

select CURRENT_DATE;

-- funcion "CURRENT_TIME", horas, minutos y segundos actuales del servidor donde se encuentra la base de datos 

select CURRENT_TIME;

-- funcion "date_part('dato', fecha)", para extraer algun dato especifico de alguna fecha en particular 

select 
	date_part('hours'	, now()) as hours,
	date_part('minutes'	, now()) as minutes,
	date_part('seconds'	, now()) as seconds,
	date_part('days'	, now()) as days,
	date_part('months'	, now()) as months,
	date_part('years'	, now()) as years;

--intervalos 

select 
	max(hire_date),
	max(hire_date) + INTERVAL '1 days' as "day", -- sumar 1 dia
	max(hire_date) + INTERVAL '1 month' as "month", -- sumar 1 mes
	max(hire_date) + INTERVAL '1 year' as "year", -- sumar 1 año,
	max(hire_date) + INTERVAL '1.1 year' as "year-month", -- sumar 1 año y 1 mes
	max(hire_date) + INTERVAL '1 year' + INTERVAL '1 month' + INTERVAL '1 day' as "year-month-day", -- sumar 1 año, 1 mes y 1 dia
	date_part('year', now()),
	make_interval(years := 2023),
	make_interval(years := date_part('year', now())::integer), 
	max(hire_date) + make_interval(years := 23)
from employees;

-- diferencias entre fechas 

select 
	hire_date,
	make_interval(years := 2023 - EXTRACT(years from hire_date)::INTEGER) as manual,
	make_interval(years := date_part('years', CURRENT_DATE)::INTEGER - EXTRACT(years from hire_date)::INTEGER) as dinamic
from employees
order by hire_date desc;

update 
	employees
set 
	hire_date = hire_date + INTERVAL '23 years';

-- clausula "CASE"

select 
	first_name,
	last_name,
	hire_date,
	case 
		when hire_date > now() - interval '1 year' then '1 año o menos'
		when hire_date > now() - interval '3 year' then '1 a 3 años'
		when hire_date > now() - interval '6 year' then '3 a 6 años'
		else '+ de 6 años'
	end as rango_antiguedad
from employees
order by hire_date DESC;

-- llave primaria serial, pueden ocurrir errores
create table "users" (
	"user_id" serial primary key,
	"username" varchar
);

-- evita que se haga una insercion manual en el campo ID, esto es para prevenir errores
create table "users3" (
	"user_id" INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
	"username" varchar 
);

-- evita que se haga una insercion manual en el campo ID y comienza en 100 aumentando en 2 por cada insercion, esto es para prevenir errores
-- hay que difinir manualmente o aparte el indice de que "user_id" es una clave primaria
create table "users4" (
	"user_id" INTEGER generated ALWAYS as IDENTITY (start with 100 INCREMENT by 2),
	"username" varchar 
);

-- llave primaria compuesta
create table userDual (
	id1 int,
	id2 int,
	PRIMARY key (id1, id2)
);

-- llave primaria UUIDs
select gen_random_uuid();

-- instalar extension de uuid
create EXTENSION if not EXISTS "uuid-ossp";

select gen_random_uuid(), uuid_generate_v4();

-- desinstalar la extension uuid
drop EXTENSION "uuid-ossp";

-- para ver las extensiones instaladas
select * from pg_extension

-- tabla con uuid
create table users5 (
	"user_id" uuid DEFAULT uuid_generate_v4() PRIMARY key,
	"username" varchar 
);

-- crear una secuencia. ctrol + p "sequence" para ver las secuencias
create sequence user_sequence;

-- eliminar una secuencia 
drop SEQUENCE user_sequence;

-- obtiene el siguiente valor de la secuencia
select nextval('user_sequence');

-- obtiene el valor actual de la secuencia
select currval('user_sequence');

-- comparacion entre currval y nextval
select currval('user_sequence'), nextval('user_sequence'), currval('user_sequence');

-- creamos una tabla donde la clave primaria esta regida por una secuencia. Esto permite la manipulacion manual, por lo que se pueden ocasionar errores.
create table users6 (
	"user_id" integer primary key default nextval('user_sequence'),
	"username" varchar
);

-- json_agg y json_build_object
select c.comment_id from "comments" c WHERE c.comment_parent_id = 1;

select json_agg(c.comment_id) from "comments" c WHERE c.comment_parent_id = 1;

select json_build_object(
	'user',c.comment_id,
	'content',c."content"
) from "comments" c WHERE c.comment_parent_id = 1;

select json_agg(json_build_object(
	'user',c.comment_id,
	'content',c."content"
)) from "comments" c WHERE c.comment_parent_id = 1;


-- crear funciones personalizadas

create or REPLACE FUNCTION public.comment_replies(id INTEGER)
RETURNS json
LANGUAGE plpgsql;
AS $function$

-- sector para declarar variables

DECLARE result json;

BEGIN

	select 
		json_agg( json_build_object(
		  'user', comments.user_id,
		  'comment', comments.content
		)) into result
	from comments where comment_parent_id = id;

	return result;

END;
$function$;

-- funcion date_trunc
-- si una fecha es: "2023-09-18 02:40:41.449", esto la convierte a "2023-01-0100:00:00.000"
-- y esto dependiendo del primer parametro ('year', 'week', 'day')
-- en este caso estamos agrupando la cantidad de registros que hubo en cada año
select date_trunc('year', created_at) as years, count(*) 
from posts
GROUP by years
order by years desc;

-- por semana, trunca la fecha a cada lunes de la semana, 
-- es decir, si una fecha es "2024-05-17 09:04:13:004", 
-- lo trunca a "2024-05-13 00:00:00" donde 13 cae un lunes.
select date_trunc('week', created_at) as weeks, count(*) 
from posts
GROUP by weeks
order by weeks desc;

-- crear una vista que me traiga la suma de claps(aplausos)
-- y post por semana 
create or REPLACE view claps_per_week as 
select  date_trunc('week', posts.created_at) as semanas,
		count(distinct posts.post_id) as cantidad_post,
		SUM(claps.counter) as total_claps
from posts
inner join claps on claps.post_id = posts.post_id
group by semanas 
order by semanas desc;

select * from claps_per_week;

select * from claps where post_id = 1;
select * from posts where post_id = 1;

-- la parte de "count(distinct posts.post_id)" causa confusion, ya
-- que uno diria que al filtrar por "posts.post_id", no se repiten
-- los registros, entonces uno supondria que deberia ser asi:
-- "count(posts.post_id)", sin embargo no es asi, porque al hacer
-- un inner join con la tabla "claps" esta trae tantos registros,
-- con el mismo posts.post_id, como claps tenga. En definitiva, si
-- el "post.id = 5" tiene en la tabla claps 4 registros, ya que
-- 4 usuarios diferentes le dieron "aplausos", entonces en esta
-- consulta apareceria 4 veces con el "count(posts.post_id)", por
-- esa razon especificamos que solo cuente los registro con id 
-- distintos.

-- otra aclaracion es que si uno quiere eliminar alguna columna de
-- una vista ya creada, esto tirara error, por lo que debe primero
-- eliminar la vista, y luego volver a crearla con la columna que 
-- se quizo eliminar.

drop VIEW claps_per_week;

-- vistas materializadas
create materialized view claps_per_week_mat as 
select  date_trunc('week', posts.created_at) as semanas,
		count(distinct posts.post_id) as cantidad_post,
		SUM(claps.counter) as total_claps
from posts
inner join claps on claps.post_id = posts.post_id
group by semanas 
order by semanas desc;

-- la diferencia entra una vista y una vista materializada es que la segunda obtiene la informacion la primera vez que se crea y la guarda en memoria para siempre, es decir, si la informacion se actualiza, la vista materializada no cotemplara estos cambios, por lo que estara desactualizada.

-- Esto es muy practico para consultas complejas que se ejecutan muchas veces y su informacion varia muy poco ya que el beneficio de las vistas materializadas es que mejoran el rendimiento ya que devuelven la informacion mas rapido.

-- Para refrescar o actualizar una vista materializada ya creada, se hace con el siguiente comando:

REFRESH MATERIALIZED VIEW claps_per_week_mat;

-- Aqui puede notarse la diferencia pequeña entre consultar una vista o la otra en milisegundos ya que la base de datos es pequeña.

select * from claps_per_week; -- entre 3mm y 17mm
select * from claps_per_week_mat; -- entre 2mm y 5mm

-- un posible ejemplo es guardar una vista materializada para las ganancias totales por mes durante todo el año y refrescarlas una vez por mes

-- de la misma forma una vista materializada para mostrar las ganacias por año y actualizarla una vez por año

-- Cambiar el nombre de una vista
alter view claps_per_week rename to post_per_week;

-- Cambiar el nombre de una vista materializada
alter MATERIALIZED view claps_per_week_mat rename to post_per_week_mat;

-- Common Table Expressions - CTE
-- Esto se utiliza para querys grandes y complejos de leer al que queremos agrear mas filtros y condiciones, por lo que mejora la legibilidad

-- La query que se mostrara a continuacion para explicar como utilizar un CTE, no es una query que normalmente se utilizaria en un CTE y se haria los filtros y condiciones dentro de la misma

with post_week_2024 as (
	SELECT date_trunc('week'::text, posts.created_at) AS weeks,
	    sum(claps.counter) AS total_claps,
	    count(DISTINCT posts.post_id) AS number_of_posts,
	    count(*) AS number_of_claps
	FROM posts
	JOIN claps ON claps.post_id = posts.post_id
	GROUP BY (date_trunc('week'::text, posts.created_at))
	ORDER BY (date_trunc('week'::text, posts.created_at)) DESC
)
select * from post_week_2024
	where weeks between '2024-01-01' and '2024-12-31' 
	and total_claps >= 600;
	
-- En resumen, este caso de CTE se utiliza para simplicar un query pero tambien se podria hacer tranquilamente creando una vista y haciendo los filtros en ella, preferiblemente esto se hace como segunda opcion, en caso de que no se puedan crear las vistas.

-- Multiples CTEs
with claps_per_post as (
	select post_id, sum(counter) from claps
	group by post_id
), post_from_2023 as (
	select * from posts 
	where created_at BETWEEN '2023-01-01' and '2023-12-31'
)
select * from claps_per_post
WHERE claps_per_post.post_id in (select post_id from post_from_2023);

-- CTE Recursivo
with RECURSIVE countdown(val) as (
		select 5 as val -- tambien se puede: values(5)
	union 
		select val - 1 from countdown where val > 1
)
select * from countdown;

-- CTE Recursivo - Tabla de multiplicar
with RECURSIVE multiplicacion_table(base, val, result) as (
		-- init 
		values(5, 1, 5)
	union 
		-- recursiva
		select 5 as base, val + 1, (val + 1) * base from multiplicacion_table
		where val < 10
)
select * from multiplicacion_table;

-- CTE Recursivo - Estructura organizacional
with recursive boss as (
		-- init
		select e.id, e.name, e.reports_to from employees e where id = 1
	union
		-- recursive
		select e.id, e.name, e.reports_to from employees e
		inner join boss b on e.reports_to = b.id
)
select * from boss;

-- CTE Recursivo - Estructura organizacional con límite
with recursive boss as (
		-- init
		select e.id, e.name, e.reports_to, 1 as val from employees e where id = 1
	union
		-- recursive
		select e.id, e.name, e.reports_to, val + 1 from employees e
		inner join boss b on e.reports_to = b.id
		where val < 2
)
select * from boss;

-- Tarea - Mostrar nombres de los jefes
with recursive boss as (
		-- init
		select e.id, e.name, e.reports_to from employees e where id = 1
	union
		-- recursive
		select e.id, e.name, e.reports_to from employees e
		inner join boss b on e.reports_to = b.id
)
select b.*, e.name as reports_to_name from boss b
left join employees e on e.id = b.reports_to;

-- doble inner join sobre la misma tabla
select f.*, ul.name as leader, uf."name" from followers f
inner join "user" ul on ul.id = f.leader_id
inner join "user" uf on uf.id = f.follower_id;

-- crear funciones
create or replace function greet_employee(employee_name varchar)
RETURNS varchar 
as $$ 
-- declare
begin 

	return 'Hola ' || employee_name;

end;

$$
LANGUAGE plpgsql;

select e.first_name, greet_employee(e.first_name) from employees e;

create or replace function max_raise(empl_id int)
RETURNS numeric(8,2) as $$

	declare 
		selected_employee 	employees%rowtype;
		selected_job 		jobs%rowtype;
		possible_raise 		NUMERIC(8,2);

begin 

	-- tomar el puesto de trabajo y el salario
	select 	* into selected_employee
	from 	employees e
	where 	e.employee_id = empl_id;
	
	-- tomar el max salary, acorde a su job
	select 	* into 	selected_job
	from 	jobs j 
	where 	j.job_id = selected_employee.job_id;
	
	-- calculos
	possible_raise = selected_job.max_salary - selected_employee.salary;
	
	if (possible_raise < 0 ) then 
		
-- 		raise EXCEPTION 'Persona con salario mayor id: % - max_salary: %',selected_employee.employee_id, selected_employee.first_name;  
		possible_raise = 0; 
		
	end if;
	
	return possible_raise;

end;

$$ language plpgsql;

select max_raise(206);

select 
	e.employee_id, 
	e.first_name, 
	'$ ' || max_raise(e.employee_id) 
from employees e;

-- funcion que retorna una tabla

create or replace function country_region()
	returns table(
		id 		CHARACTER(2),
		name 	VARCHAR(40),
		region	VARCHAR(25)
	)
as $$

begin 

	return query
		select c.country_id, c.country_name, r.region_name
		from countries c
		inner join regions r on r.region_id = c.region_id;
 
end;
$$ language plpgsql;

select * from country_region();

-- Procedimientos almacenados
-- Todas las funciones siempre retornan algo, en los procedimientos almacenados esto no es totalmente necesario.

create or replace procedure insert_region_proc(int, varchar)
as $$

begin 

	insert into regions(region_id, region_name)
	values($1,$2);

	-- este seria el console.log
	raise notice 'Variable 1: %', $1;

-- 	rollback;
	commit; 

end;
$$ language plpgsql;

call insert_region_proc(5, 'hola');

select * from regions;

-----------------------------------------------------------------------



create or replace procedure controlled_raise(percentage numeric) as
$$
declare 
	real_percentage numeric(8,2);
	total_employees int;

begin 

	real_percentage = percentage / 100;
	
-- 	mantener el historico
	insert into raise_history(date, employee_id, base_salary, amount, percentage)
	select 
		current_date as "date",
		e.employee_id,
		e.salary,
		max_raise(e.employee_id) * real_percentage as amount,
		percentage as "percentage"
	from employees e;

-- 	impactar la tabla de empleados
	update employees
	set salary =  max_raise(employee_id) * real_percentage + salary;
	
	commit; 

	select count(*) into total_employees from employees;

	raise notice 'Afectados % empleados', total_employees;

end;
$$ language plpgsql;

call controlled_raise(1);

select * from employees;
select * from raise_history;

-- encriptar contraseña
create extension pgcrypto; -- biblioteca para encriptar contraseña

insert into "user" (username, password)
values(
	'nacho',
	crypt('123456', gen_salt('bf'))
);



create or replace PROCEDURE user_login(user_name varchar, user_password varchar) as $$

declare 
	was_found BOOLEAN;

begin 

	select count(*) into was_found
	from "user" 
	where username = user_name
	and password = crypt(user_password, password);
	
	if not (was_found) then 
	
		insert into session_failed (username, "when")
		values(
			user_name,
			now()
		);
	
		commit;
-- 		en este caso el commit es necesario porque al lanzar una 			exception se ejecuta un rollback automaticamente, por ende, si 		el commit no estuvise, el insert no impactaria en la base.
		raise EXCEPTION 'Usuario y contraseña incorrectos';
	
	end if;

	update "user" 
	set last_login = now() where username = user_name;
	COMMIT;
	raise notice 'Usuario encontrado %', was_found;

end;
$$ LANGUAGE plpgsql;

call user_login('nacho', '123456');


-- crear un trigger
create or replace TRIGGER create_session_trigger after update on "user"
for each row 
-- aca especificamos que se ejecute solamente si se hace un update en el campo "last_login".
when (OLD.last_login is DISTINCT from NEW.last_login)
execute function create_session_log();

create or replace function create_session_log()
returns trigger as 
$$

begin 

	-- esta funcion se ejecuta cada vez que se realiza un update en la tabla user. Esto es porque se creo un trigger "create_session_trigger", que es un observer, ya que espera un evento en particular, en este caso el update de "user", para ejecurarse.
	
	-- el "new" utilizado en esta funcion, seria el equivalente a un "this", ya que en el trigger, se establecio que se ejecute ante el update de la table "user", por ende, el new hace referenia a user.

	insert into "session" (user_id, last_login)
	values (new.id, now());
	
	return new;

end;

$$ LANGUAGE plpgsql;