# Modelo de Base de Datos para Cada Cliente

Este modelo de base de datos adopta un enfoque descentralizado, donde cada cliente tiene su propia base de datos exclusiva. Cada base de datos actúa como una "burbuja" aislada para un cliente específico, almacenando de manera independiente sus datos y proporcionando un alto nivel de separación entre los diferentes clientes. Cada vez que se incorpora un nuevo cliente, se crea una nueva base de datos dedicada para él.

Este enfoque ofrece ventajas en términos de aislamiento y seguridad, ya que los datos de cada cliente están completamente separados de los demás. Sin embargo, puede requerir más recursos en términos de gestión y mantenimiento, ya que cada base de datos debe administrarse individualmente. Además, la escalabilidad puede ser más desafiante, ya que el crecimiento de clientes puede resultar en un mayor número de bases de datos a administrar.

***

# Estructura de la Base de Datos

## Tabla "user"

### Estructura
La tabla "user" tiene la siguiente estructura:

| Columna      | Tipo          | Restricciones                        |
|--------------|---------------|--------------------------------------|
| "user_id"    | PRIMARY KEY   |                                      |
| "user_fk"    | FOREIGN KEY   | NOT NULL                             |
| "name"       | varchar(100)  | NOT NULL                             |
| "email"      | varchar(255)  | NOT NULL, UNIQUE                     |
| "password"   | varchar(255)  | NOT NULL                             |
| "rol"        | rol_options   | NOT NULL                             |
| "is_active"  | boolean       | NOT NULL, DEFAULT true               |
| "created_at" | timestamp     | NOT NULL, DEFAULT 'now()'            |
| "updated_at" | timestamp     | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "user" almacena información de los usuarios del sistema, incluyendo sus nombres, correos electrónicos, contraseñas, roles y estado de activación. Esta tabla permite gestionar y mantener registros de los usuarios.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "user_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "user_fk" establece una relación 1:1 referencial con el "user_id" de otro usuario.
- **Validacion de Email**: Al hacer un "INSERT" o "UPDATE", valida contra la siguiente expresion regular: "[A-Za-z0-9._%-]+@(gmail|yahoo|outlook|hotmail|aol|icloud|protonmail)\.(com|net|org)".
- **Hash de Password**: Al hacer un "INSERT" o "UPDATE", el password se encripta automáticamente.
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "company"

### Estructura
La tabla "company" tiene la siguiente estructura:

| Columna        | Tipo          | Restricciones                        |
|----------------|---------------|--------------------------------------|
| "company_id"   | PRIMARY KEY   |                                      |
| "user_fk"      | FOREIGN KEY   | NOT NULL                             |
| "name"         | varchar(100)  | NOT NULL                             |
| "cuit"         | varchar(20)   |                                      |
| "note"         | text          |                                      |
| "is_active"    | boolean       | NOT NULL, DEFAULT true               |
| "created_at"   | timestamp     | NOT NULL, DEFAULT 'now()'            |
| "updated_at"   | timestamp     | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "company" almacena información relacionada con empresas. Esta tabla contiene detalles como el nombre de la empresa, CUIT, notas adicionales y su estado de activación en el sistema.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "company_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "user_fk" establece una relación referencial con el "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "patient"

### Estructura
La tabla "patient" tiene la siguiente estructura:

| Columna              | Tipo              | Restricciones              |
|----------------------|-------------------|----------------------------|
| "patient_id"         | PRIMARY KEY       |                            |
| "company_fk"         | FOREIGN KEY       | NOT NULL                   |
| "user_fk"            | FOREIGN KEY       | NOT NULL                   |
| "name"               | varchar(100)      | NOT NULL                   |
| "healthcare_provider"| varchar(100)      |                            |
| "gender"             | gender_options    | NOT NULL                   |
| "age"                | smallint          |                            |
| "phone"              | varchar(30)       |                            |
| "note"               | text              |                            |
| "is_active"          | boolean           | NOT NULL, DEFAULT true     |
| "created_at"         | timestamp         | NOT NULL, DEFAULT 'now()'  |
| "updated_at"         | timestamp         | NOT NULL, DEFAULT 'now()'  |

### Descripción
La tabla "patient" registra información sobre pacientes asociados a empresas y usuarios. Contiene datos personales como nombre, proveedor de atención médica, género, edad, número de teléfono, notas adicionales y estado de activación.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "patient_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: Las columnas company_fk y "user_fk" establece una relación referencial con el "company_id" de la tabla ("company") y "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **Validacion de Empresa**: Al hacer un "INSERT" o "UPDATE", valida que la empresa referenciada este activada {is_active = TRUE}.
- **age**: Al hacer un "INSERT" o "UPDATE", valida que la edad ingresada este entre 0 y 130 años.
- **phone**: Al hacer un "INSERT" o "UPDATE", valida contra la siguiente expresion regular: "^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$".
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "treatment"

### Estructura
La tabla "treatment" tiene la siguiente estructura:

| Columna         | Tipo          | Restricciones                        |
|-----------------|---------------|--------------------------------------|
| "treatment_id"  | PRIMARY KEY   |                                      |
| "user_fk"       | FOREIGN KEY   | NOT NULL                             |
| "name"          | varchar(100)  | NOT NULL                             |
| "abbreviation"  | varchar(10)   | NOT NULL                             |
| "description"   | text          |                                      |
| "is_active"     | boolean       | NOT NULL, DEFAULT true               |
| "created_at"    | timestamp     | NOT NULL, DEFAULT 'now()'            |
| "updated_at"    | timestamp     | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "treatment" almacena información sobre tratamientos. Contiene datos como el nombre del tratamiento, su abreviatura, una descripción, y su estado de activación en el sistema.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "treatment_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "user_fk" establece una relación referencial con el "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "profesional"

### Estructura
La tabla "profesional" tiene la siguiente estructura:

| Columna           | Tipo            | Restricciones                     |
|-------------------|-----------------|-----------------------------------|
| "profesional_id"  | PRIMARY KEY     |                                   |
| "user_fk"         | FOREIGN KEY     | NOT NULL                          |
| "name"            | varchar(100)    | NOT NULL                          |
| "gender"          | gender_options  | NOT NULL                          |
| "cuit"            | varchar(20)     |                                   |
| "fiscal_status"   | fiscal_status   |                                   |
| "phone"           | varchar(30)     | NOT NULL                          |
| "email"           | varchar(255)    | NOT NULL, UNIQUE                  |
| "birthdate"       | date            |                                   |
| "bank"            | varchar(255)    |                                   |
| "bank_account"    | varchar(50)     |                                   |
| "cbu"             | varchar(23)     |                                   |
| "alias"           | varchar(50)     |                                   |
| "note"            | text            |                                   |
| "is_active"       | boolean         | NOT NULL, DEFAULT true            |
| "created_at"      | timestamp       | NOT NULL, DEFAULT 'now()'         |
| "updated_at"      | timestamp       | NOT NULL, DEFAULT 'now()'         |

### Descripción
La tabla "profesional" registra información detallada sobre profesionales, incluyendo nombre, género, datos fiscales, contacto, detalles bancarios y notas adicionales.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "profesional_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "user_fk" establece una relación referencial con el "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **Validacion de Email**: Al hacer un "INSERT" o "UPDATE", valida contra la siguiente expresion regular: "[A-Za-z0-9._%-]+@(gmail|yahoo|outlook|hotmail|aol|icloud|protonmail)\.(com|net|org)".
- **birthdate**: Al hacer un "INSERT" o "UPDATE", valida que la fecha tenga una antiguedad entre 18 y 130 años.
- **phone**: Al hacer un "INSERT" o "UPDATE", valida contra la siguiente expresion regular: "^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$".
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "screen"

### Estructura
La tabla "screen" tiene la siguiente estructura:

| Columna         | Tipo          | Restricciones                        |
|-----------------|---------------|--------------------------------------|
| "screen_id"     | PRIMARY KEY   |                                      |
| "name"          | varchar(100)  | NOT NULL                             |
| "is_active"     | boolean       | NOT NULL, DEFAULT true               |
| "created_at"    | timestamp     | NOT NULL, DEFAULT 'now()'            |
| "updated_at"    | timestamp     | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "screen" almacena información sobre pantallas (screens). Contiene detalles como el nombre de la pantalla y su estado de activación en el sistema.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "screen_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "permission"

### Estructura
La tabla "permission" tiene la siguiente estructura:

| Columna      | Tipo               | Restricciones                  |
|--------------|--------------------|--------------------------------|
| "user_fk"    | FOREIGN KEY (PK)   | NOT NULL                       |
| "screen_fk"  | FOREIGN KEY (PK)   | NOT NULL                       |
| "created_at" | timestamp          | NOT NULL, DEFAULT 'now()'      |
| "updated_at" | timestamp          | NOT NULL, DEFAULT 'now()'      |

### Descripción
La tabla "permission" gestiona los permisos asociados a los usuarios en determinadas pantallas (screens). Contiene la referencia del usuario, la referencia de la pantalla y los timestamps de creación y actualización de los permisos.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "user_fk" y "screen_fk" conforman la clave primaria de la tabla.
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **Validacion de Pantalla**: Al hacer un "INSERT" o "UPDATE", valida que la pantalla referenciada este activada {is_active = TRUE}.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "treatment_has_profesional"

### Estructura
La tabla "treatment_has_profesional" tiene la siguiente estructura:

| Columna           | Tipo                | Restricciones                        |
|-------------------|---------------------|--------------------------------------|
| "company_fk"      | FOREIGN KEY (PK)    | NOT NULL                             |
| "treatment_fk"    | FOREIGN KEY (PK)    | NOT NULL                             |
| "profesional_fk"  | FOREIGN KEY (PK)    | NOT NULL                             |
| "user_fk"         | FOREIGN KEY         | NOT NULL                             |
| "value"           | decimal(8,2)        | NOT NULL                             |
| "created_at"      | timestamp           | NOT NULL, DEFAULT 'now()'            |
| "updated_at"      | timestamp           | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "treatment_has_profesional" establece la relación entre tratamientos, profesionales, empresas y usuarios, junto con un valor asociado a esa relación. Esta relación indica qué tratamiento es llevado a cabo por qué profesional, en qué empresa, que usuario ingreso el registro junto con un valor específico para esa relación.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "company_fk", "treatment_fk" y "profesional_fk" conforman la clave primaria de la tabla.
- **Validacion de Empresa**: Al hacer un "INSERT" o "UPDATE", valida que la empresa referenciada este activada {is_active = TRUE}.
- **Validacion de Tratamiento**: Al hacer un "INSERT" o "UPDATE", valida que el tratamiento referenciado este activado {is_active = TRUE}.
- **Validacion de Profesional**: Al hacer un "INSERT" o "UPDATE", valida que el profesional referenciado este activado {is_active = TRUE}.
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **value**: Al hacer un "INSERT" o "UPDATE", valida que el valor no sea negativo.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "company_has_treatment"

### Estructura
La tabla "company_has_treatment" tiene la siguiente estructura:

| Columna           | Tipo               | Restricciones                        |
|-------------------|---------------     |--------------------------------------|
| "company_fk"      | FOREIGN KEY (PK)   | NOT NULL                             |
| "treatment_fk"    | FOREIGN KEY (PK)   | NOT NULL                             |
| "user_fk"         | FOREIGN KEY        | NOT NULL                             |
| "value"           | decimal(7,2)       | NOT NULL                             |
| "created_at"      | timestamp          | NOT NULL, DEFAULT 'now()'            |
| "updated_at"      | timestamp          | NOT NULL, DEFAULT 'now()'            |

### Descripción
La tabla "company_has_treatment" gestiona la relación entre empresas y tratamientos junto con un valor asociado a esa relación. Indica qué tratamiento está disponible en qué empresa, que usuario ingreso el registro y el valor relacionado.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "company_fk" y "treatment_fk" conforman la clave primaria de la tabla.
- **Validacion de Empresa**: Al hacer un "INSERT" o "UPDATE", valida que la empresa referenciada este activada {is_active = TRUE}.
- **Validacion de Tratamiento**: Al hacer un "INSERT" o "UPDATE", valida que el tratamiento referenciado este activado {is_active = TRUE}.
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **value**: Al hacer un "INSERT" o "UPDATE", valida que el valor no sea negativo.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "order"

### Estructura
La tabla "order" tiene la siguiente estructura:

| Columna             | Tipo            | Restricciones                   |
|---------------------|-----------------|---------------------------------|
| "order_id"          | PRIMARY KEY     |                                 |
| "patient_fk"        | FOREIGN KEY     | NOT NULL                        |
| "user_fk"           | FOREIGN KEY     | NOT NULL                        |
| "treatment_fk"      | FOREIGN KEY     | NOT NULL                        |
| "profesional_fk"    | FOREIGN KEY     |                                 |
| "start_date"        | timestamp       | NOT NULL                        |
| "finish_date"       | timestamp       | NOT NULL                        |
| "has_medical_order" | boolean         | NOT NULL, DEFAULT false         |
| "frequency"         | smallint        | NOT NULL                        |
| "total_sessions"    | smallint        | NOT NULL                        |
| "sessions"          | smallint        | NOT NULL                        |
| "coinsurance"       | decimal(7,2)    | NOT NULL                        |
| "special_value"     | decimal(7,2)    | DEFAULT 0                       |
| "special_cost"      | decimal(7,2)    | DEFAULT 0                       |
| "diagnosis"         | TEXT            |                                 |
| "requirements"      | varchar(300)    |                                 |
| "state"             | order_status    | NOT NULL                        |
| "created_at"        | timestamp       | NOT NULL, DEFAULT 'now()'       |
| "updated_at"        | timestamp       | NOT NULL, DEFAULT 'now()'       |

### Descripción
La tabla "order" registra los pedidos relacionados con tratamientos para pacientes. Contiene información sobre fechas de inicio y finalización, sesiones, costos, diagnósticos y requerimientos asociados a un tratamiento para un paciente específico.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "order_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "patient_fk", "user_fk", "treatment_fk", "profesional_fk" establece una relación referencial con el "patient_id" de la tabla ("patient"), "user_id" de la tabla ("user"), "treatment_id" de la tabla ("treatment") y "profesional_id" de la tabla ("profesional").
- **Validacion de Paciente**: Al hacer un "INSERT" o "UPDATE", valida que el paciente referenciado este activado {is_active = TRUE}.
- **Validacion de Tratamiento**: Al hacer un "INSERT" o "UPDATE", valida que el tratamiento referenciado este activado {is_active = TRUE}.
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **start_date**: Al hacer un "INSERT" o "UPDATE", valida que la fecha este dentro de un intervalo de 1 año.
- **finish_date**: Al hacer un "INSERT" o "UPDATE", valida que la fecha este dentro de un intervalo de 1 año.
- **finish_date - start_date**: Al hacer un "INSERT" o "UPDATE", valida que exista un intervalo entre 0 y 31 dias entre ambas fechas.
- **frequency**: Al hacer un "INSERT" o "UPDATE", valida que el dato este entre 1 y 7.
- **total_sessions**: Al hacer un "INSERT" o "UPDATE", valida que el dato este entre 0 y 31.
- **sessions**: Al hacer un "INSERT" o "UPDATE", valida que el dato este entre 0 y no supere "total_sessions".
- **coinsurance**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **special_value**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **special_cost**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "history"

### Estructura
La tabla "history" tiene la siguiente estructura:

| Columna        | Tipo          | Restricciones                   |
|----------------|---------------|---------------------------------|
| "history_id"   | PRIMARY KEY   |                                 |
| "order_fk"     | FOREIGN KEY   | NOT NULL                        |
| "user_fk"      | FOREIGN KEY   | NOT NULL                        |
| "sessions"     | smallint      | NOT NULL                        |
| "coinsurance"  | decimal(7,2)  | NOT NULL                        |
| "value"        | decimal(7,2)  | NOT NULL, DEFAULT 0             |
| "cost"         | decimal(7,2)  | NOT NULL, DEFAULT 0             |
| "created_at"   | timestamp     | NOT NULL, DEFAULT 'now()'       |
| "updated_at"   | timestamp     | NOT NULL, DEFAULT 'now()'       |

### Descripción
La tabla "history" almacena el historial de sesiones de un pedido (order). Registra la cantidad de sesiones, el valor y costo asociados a esas sesiones, junto con la información del usuario relacionado.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "history_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "order_fk" y "user_fk" establece una relación referencial con el "order_id" de la tabla ("order") y "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **Validacion de Fecha**: Al hacer un "UPDATE", valida que el pedido haya sido creado entre un intervalo de 0 y 31 días.
- **sessions**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **coinsurance**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **value**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **cost**: Al hacer un "INSERT" o "UPDATE", valida que el dato sea positivo".
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "claim"

### Estructura
La tabla "claim" tiene la siguiente estructura:

| Columna         | Tipo            | Restricciones                                   |
|-----------------|-----------------|-------------------------------------------------|
| "claim_id"      | PRIMARY KEY     |                                                 |
| "order_fk"      | FOREIGN KEY     | NOT NULL                                        |
| "user_fk"       | FOREIGN KEY     | NOT NULL                                        |
| "cause"         | text            | NOT NULL                                        |
| "urgency"       | urgency_options | NOT NULL                                        |
| "reported_date" | timestamp       | NOT NULL                                        |
| "is_active"     | boolean         | NOT NULL, DEFAULT true                          |
| "created_at"    | timestamp       | NOT NULL, DEFAULT 'now()'                       |
| "updated_at"    | timestamp       | NOT NULL, DEFAULT 'now()'                       |

### Descripción
La tabla "claim" registra reclamaciones asociadas a un pedido (order), indicando la causa, urgencia, fecha de reporte, estado activo o inactivo y detalles del usuario relacionado.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "claim_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "order_fk" y "user_fk" establece una relación referencial con el "order_id" de la tabla ("order") y "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **Validacion de Pedido**: Al hacer un "INSERT", valida que el pedido referenciado no este finalizado.
- **reported_date**: Al hacer un "INSERT" o "UPDATE", valida que la columna contenga una fecha con un intervalo de 31 días asi el pasado.
- **updated_at**: Al hacer un "UPDATE", la fecha de la columna se actualiza automáticamente.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.

***

## Tabla "token"

### Estructura
La tabla "token" tiene la siguiente estructura:

| Columna      | Tipo           | Restricciones                   |
|--------------|-------------   |---------------------------------|
| "token_id"   | PRIMARY KEY    |                                 |
| "user_fk"    | FOREIGN KEY    | NOT NULL                        |
| "token"      | varchar(255)   | NOT NULL                        |
| "created_at" | timestamp      | NOT NULL, DEFAULT 'now()'       |

### Descripción
La tabla "token" almacena tokens de autenticación asociados a usuarios. Contiene información sobre el token generado y la fecha de creación.

### Restricciones y Validaciones
- **Clave Primaria**: La columna "token_id" es la clave primaria de la tabla, generada automáticamente. La secuencia de este campo no es modificable.
- **Clave Externa**: La columna "user_fk" establece una relación referencial con el "user_id" de la tabla ("user").
- **Validacion de Usuario**: Al hacer un "INSERT" o "UPDATE", valida que el usuario referenciado este activado {is_active = TRUE}.
- **created_at**: Al hacer un "UPDATE", lanza una EXCEPTION. Restringido su modificacion.