# Commits

Este repositorio se encuentra vinculado a un repositorio de GitHub, el mismo posee una configuracion de GitHub Actions que se encarga de construir y pushear la imagen de Docker a Docker Hub, ademas de controlar el versionado de la imagen.

- Para realizar un commit se debe seguir el siguiente formato:
  - *Mayor:* `git commit -m "major: [nombre de la funcionalidad]"` formato para incrementar la version mayor.
  - *Minor:* `git commit -m "feat: [nombre de la funcionalidad]"` formato para incrementar la version minor.
  - *Patch:* `git commit -m "[nombre de la funcionalidad]"` formato para incrementar la version patch.

---

# Docker

## Construir la imagen
```bash
docker compose build --no-cache
```

## Correr los contenedores
```bash
docker compose up -d
```

---

# Modelo de Base de Datos Centralizada con Lógica de Invitación

En este modelo, se sigue un enfoque centralizado donde se almacenan los datos de todos los clientes en una sola base de datos compartida. La lógica de invitación se implementa para controlar el acceso de cada cliente a sus datos específicos. Cada entidad en la base de datos tiene un atributo que asocia los datos con el cliente al que pertenecen.

Este enfoque es eficiente en términos de gestión y mantenimiento, ya que solo se necesita una base de datos para todos los clientes. La escalabilidad puede ser más manejable, ya que se puede gestionar un solo conjunto de recursos. Sin embargo, es crucial implementar una sólida lógica de invitación y seguridad para garantizar que cada cliente acceda solo a sus datos autorizados.

***

# Estructura de la Base de Datos

## Tabla "client"

### Estructura
La tabla "client" tiene la siguiente estructura:

| Columna       | Tipo              | Restricciones              |
|---------------|-------------------|----------------------------|
| `client_id`   | **PRIMARY KEY**   |                            |
| `name`        | **VARCHAR(100)**  | NOT NULL                   |
| `user_type`   | **CHAR(6)**       | NOT NULL DEFAULT 'client'  |
| `is_active`   | **BOOLEAN**       | NOT NULL DEFAULT TRUE      |
| `created_at`  | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'   |
| `updated_at`  | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'   |

### Descripción
La tabla "client" almacena información detallada sobre los coordinadores de interacción domiciliaria que tienen acceso a la dashboard. Cada registro en esta tabla representa un cliente (coordinador) y desempeña un papel central al ser el punto de conexión para vincular información relacionada en otras tablas.

Esta tabla actúa como el núcleo fundamental de la base de datos, ya que posibilita la vinculación de información específica de cada coordinador con otras tablas. Su presencia simplifica la obtención de datos completos relacionados con un coordinador en particular, estableciendo así una base sólida para la estructura de la base de datos.

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                         |
|---------------------|---------------------------|-----------------------------------------------------|
| `user_type`         | **[U]**                   | Valida que el valor no pueda ser modificado.        |
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.        |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                 |

***

## Tabla "user"

### Estructura
La tabla "user" tiene la siguiente estructura:

| Llave Compuesta                                                           |
|---------------------------------------------------------------------------|
| `PRIMARY KEY ("client_fk", "user_id")`                                    |

| Columna      | Tipo              | Restricciones                              |
|--------------|-------------------|--------------------------------------------|
| `user_id`    | **INTEGER**       |                                            |
| `client_fk`  | **FOREIGN KEY**   | NOT NULL REFERENCES "client"(client_id)    |
| `name`       | **VARCHAR(100)**  | NOT NULL                                   |
| `email`      | **VARCHAR(255)**  | NOT NULL UNIQUE                            |
| `password`   | **VARCHAR(255)**  | NOT NULL                                   |
| `is_admin`   | **BOOLEAN**       | NOT NULL DEFAULT FALSE                     |
| `is_active`  | **BOOLEAN**       | NOT NULL DEFAULT TRUE                      |
| `created_at` | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                   |
| `updated_at` | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                   |

### Descripción
La tabla "user" almacena información de los usuarios del sistema, como nombres, correos electrónicos, contraseñas, roles y estados de activación. Su función principal es gestionar y mantener registros de los usuarios.

Esta tabla facilita la gestión y autenticación de los usuarios que interactúan con la dashboard. La relación con la tabla "client" garantiza que cada usuario esté asociado a un coordinador específico. Es importante destacar que solo puede existir un usuario con privilegios de administrador por cada coordinador, asegurando así un control preciso de los accesos y roles.

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                                                                            |
|---------------------|---------------------------|--------------------------------------------------------------------------------------------------------|
| `email`             | **[I][U][<>][email]**     | Valida contra una "regex" que el valor tenga un formato correcto y pertenezca a un dominio reconocido. |
| `password`          | **[I][U][<>][password]**  | Valida que el valor >= 8 y luego lo hashea.                                                            |
| `is_admin`          | **[I][U][<>][is_admin]**  | Valida que exista un solo usuario administrador por cliente.                                           |
| `client.is_active`  | **[I][U]**                | Valida que el cliente referenciado este activo.                                                        |
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.                                                           |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                                                                    |

***

## Tabla "screen"

### Estructura
La tabla "screen" tiene la siguiente estructura:

| Columna        | Tipo              | Restricciones                        |
|----------------|-------------------|--------------------------------------|
| `screen_id`    | **PRIMARY KEY**   |                                      |
| `name`         | **VARCHAR(100)**  | NOT NULL                             |
| `is_active`    | **BOOLEAN**       | NOT NULL DEFAULT TRUE                |
| `created_at`   | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'             |
| `updated_at`   | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'             |

### Descripción
La tabla "screen" almacena información sobre las vistas de la dashboard. Cada registro en esta tabla representa una pantalla o vista, proporcionando control sobre su activación y asignación de permisos.

Su función principal es la gestión de las vistas de la dashboard, permitiendo controlar la activación o desactivación de cada pantalla según las necesidades del sistema. Cada registro de la tabla representa una pantalla que puede ser configurada de manera independiente, brindando flexibilidad en la administración de las opciones disponibles en la interfaz del sistema.

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                       |
|---------------------|---------------------------|---------------------------------------------------|
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.      |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.               |

***

## Tabla "permission"

### Estructura
La tabla "permission" tiene la siguiente estructura:

| Llave Compuesta                                                                   |
|-----------------------------------------------------------------------------------|
| `PRIMARY KEY ("user_fk", "screen_fk")`                                            |
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`  |

| Columna         | Tipo              | Restricciones                                   |
|---------------- |-------------------|-------------------------------------------------|
| `client_fk`     | **FOREIGN KEY**   | NOT NULL                                        |
| `user_fk`       | **FOREIGN KEY**   | NOT NULL                                        |
| `screen_fk`     | **FOREIGN KEY**   | NOT NULL REFERENCES screen(screen_id)           |
| `created_at`    | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                        |
| `updated_at`    | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                        |

### Descripción
La tabla pivot "permission" establece relaciones entre usuarios, vistas y clientes, definiendo qué usuarios tienen acceso a qué vistas en el contexto de un cliente específico.

Su función principal es determinar qué usuarios tienen permisos para acceder a determinadas vistas dentro del contexto de un cliente específico. La existencia de un registro en esta tabla indica que un usuario tiene autorización para acceder a una vista asociada a un cliente determinado.

Esta tabla facilita la gestión de las vistas de la dashboard, permitiendo controlar la activación y asignación de permisos. Cada registro representa una pantalla que puede ser activada o desactivada según las necesidades del sistema, garantizando así un control preciso sobre los accesos de los usuarios en relación con las vistas disponibles.

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                         |
|---------------------|---------------------------|-----------------------------------------------------|
| `client.is_active`  | **[I][U]**                | Valida que el cliente referenciado este activo.     |
| `user.is_active`    | **[I][U]**                | Valida que el usuario referenciado este activo.     |
| `screen.is_active`  | **[I][U]**                | Valida que la vista referenciada este activa.       |
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.        |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                 |

***

## Tabla "professional"

### Estructura
La tabla "professional" tiene la siguiente estructura:

| Columna           | Tipo            | Restricciones                     |
|-------------------|---------------------|-----------------------------------|
| `professional_id` | **PRIMARY KEY**     |                                   |
| `name`            | **VARCHAR(100)**    | NOT NULL                          |
| `last_name`       | **VARCHAR(100)**    | NOT NULL                          |
| `gender`          | **gender_options**  | NOT NULL                          |
| `cuit`            | **VARCHAR(20)**     |                                   |
| `fiscal_status`   | **fiscal_status**   |                                   |
| `phone`           | **VARCHAR(30)**     | NOT NULL                          |
| `email`           | **VARCHAR(255)**    |                                   |
| `password`        | **VARCHAR(255)**    | NOT NULL                          |
| `birthdate`       | **DATE**            |                                   |
| `bank`            | **VARCHAR(255)**    |                                   |
| `bank_account`    | **VARCHAR(50)**     |                                   |
| `cbu`             | **VARCHAR(23)**     |                                   |
| `alias`           | **VARCHAR(50)**     |                                   |
| `note`            | **TEXT**            |                                   |
| `user_type`       | **CHAR(12)**        | NOT NULL DEFAULT 'professional'   |
| `created_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'          |
| `updated_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'          |

| Índice Único                                                            |
|-------------------------------------------------------------------------|
| `UNIQUE INDEX ((CASE WHEN email IS NOT NULL THEN email END))`           |
| `UNIQUE INDEX ((CASE WHEN phone IS NOT NULL THEN phone END))`           |

### Descripción
La tabla "professional" almacena información sobre los profesionales que tienen acceso a la aplicación móvil. Cada registro en esta tabla representa un profesional independiente con la capacidad de establecer vínculos con distintos coordinadores.

Su función principal es gestionar la información detallada de los profesionales que utilizan la aplicación móvil. Estos profesionales pueden registrarse de manera independiente y luego tienen la flexibilidad de vincularse con varios coordinadores, lo que proporciona un enfoque descentralizado y versátil para la gestión de profesionales en la plataforma.

### Restricciones (CHECK)
| Campo        | Descripción                                                                                |
|--------------|--------------------------------------------------------------------------------------------|
| `email`      | Verifica que al menos uno de los campos 'email' o 'phone' esté presente.                   |
| `email`      | Verifica que el campo 'email' no esté vacío.                                               |
| `birthdate`  | Verifica que el profesional tenga entre 18 y 85 años según su fecha de nacimiento.         |
| `phone`      | Valida el formato del número de teléfono según una "regex".                                |

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                                                                            |
|---------------------|---------------------------|--------------------------------------------------------------------------------------------------------|
| `email`             | **[I][U][<>][email]**     | Valida contra una "regex" que el valor tenga un formato correcto y pertenezca a un dominio reconocido. |
| `password`          | **[I][U][<>][password]**  | Valida que el valor >= 8 y luego lo hashea.                                                            |
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.                                                           |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                                                                    |

***

## Tabla "work_invitation"

### Estructura
La tabla "work_invitation" tiene la siguiente estructura  

| Llave Compuesta                                                                           |
|-------------------------------------------------------------------------------------------|
| `PRIMARY KEY ("client_fk", "professional_fk")`                                            |

| Columna           | Tipo                | Restricciones                                       |
|-------------------|---------------------|-----------------------------------------------------|
| `client_fk`       | **FOREIGN KEY**     | NOT NULL REFERENCES "client"(client_id)             |
| `professional_fk` | **FOREIGN KEY**     | NOT NULL REFERENCES "professional"(professional_id) |
| `sender`          | **profile_options** | NOT NULL                                            |
| `is_accept`       | **BOOLEAN**         | NOT NULL DEFAULT FALSE                              |
| `created_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                            |
| `updated_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                            |

### Descripción
La tabla pivot "work_invitation" gestiona las invitaciones entre clientes y profesionales, marcando el primer paso para la creación de una relación laboral. Cada registro en esta tabla representa una invitación enviada por un cliente a un profesional, y se indica si la invitación ha sido aceptada.

Su función principal es facilitar la gestión de las invitaciones entre clientes y profesionales, registrando información clave como el remitente de la invitación, el estado de aceptación y otros detalles relevantes en el proceso de establecimiento de una relación laboral. Esta tabla proporciona una visión clara y organizada del flujo de invitaciones, simplificando la administración de las relaciones laborales en la plataforma.

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `professional.is_active`  | **[I][U]**                | Valida que el profesional referenciado este activo.         |
| `is_accept`               | **[I]**                   | Valida que no se pueda insertar una invitacion ya aceptada. |
| `is_accept`               | **[U][<>][is_accept]**    | Se ejecuta: `process_professional_assignment_change`.       |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

### Procedimiento Almacenado
* `process_professional_assignment_change`: Este procedimiento en caso de que se acepte una invitación, se encarga de verificar en la tabla "client_has_professional" si la relacion entre profesional y cliente ya existe. En caso de que no tengan un registro, se crea uno con `TRUE` en la columna `is_active`. En caso de que ya tengan una relación, se actualiza el campo `is_active` de la tabla "client_has_professional" a `TRUE`. En caso de que se cancele una relación, se ejecuta un proceso destructivo, donde se eliminan los registros de las tabla "treatment_has_professional" que referencien los valores que el profesional tenia con ese cliente, luego se desvincula al profesional de todos los pedidos asignados en la tabla "order" y finalmente se `desactiva` el registro de la tabla "client_has_professional". Nunca se elimina un registro de la tabla "client_has_professional", ya que se necesita para mantener la integridad referencial de la tabla "order" con los pedidos que tuvo asignados y ya finalizaron.

***

## Tabla "client_has_professional"

### Estructura
La tabla "client_has_professional" tiene la siguiente estructura  

| Llave Compuesta                                                                                            |
|------------------------------------------------------------------------------------------------------------|
| `PRIMARY KEY ("client_fk", "professional_fk")`                                                             |
| `FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "work_invitation"("client_fk","professional_fk")` |

| Columna           | Tipo                | Restricciones                                                        |
|-------------------|---------------------|----------------------------------------------------------------------|
| `client_fk`       | **FOREIGN KEY**     | NOT NULL                                                             |
| `professional_fk` | **FOREIGN KEY**     | NOT NULL                                                             |
| `is_accept`       | **BOOLEAN**         | NOT NULL DEFAULT FALSE                                               |
| `created_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                                             |
| `updated_at`      | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                                             |

### Descripción
La tabla "client_has_professional" juega un papel fundamental como vínculo entre clientes y profesionales, permitiendo la colaboración, asignación de pedidos y trabajo conjunto. Cada registro en esta tabla representa una relación establecida entre un cliente y un profesional, originada a partir de una invitación aceptada en "work_invitation".

Su función principal es ser esencial para establecer y gestionar relaciones activas entre clientes y profesionales. Actúa como el punto de conexión central para asignar pedidos, colaborar y trabajar de manera conjunta en el sistema, proporcionando una estructura sólida para la cooperación efectiva entre ambas partes.

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `professional.is_active`  | **[I][U]**                | Valida que el profesional referenciado este activo.         |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "company"

### Estructura
La tabla "company" tiene la siguiente estructura:

| Llave Compuesta                                                                   |
|-----------------------------------------------------------------------------------|
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`  |

| Columna        | Tipo              | Restricciones                                    |
|----------------|-------------------|--------------------------------------------------|
| `company_id`   | **PRIMARY KEY**   |                                                  |
| `client_fk`    | **FOREIGN KEY**   | NOT NULL                                         |
| `user_fk`      | **FOREIGN KEY**   | NOT NULL                                         |
| `name`         | **VARCHAR(100)**  | NOT NULL                                         |
| `cuit`         | **VARCHAR(20)**   |                                                  |
| `note`         | **TEXT**          |                                                  |
| `is_active`    | **BOOLEAN**       | NOT NULL DEFAULT TRUE                            |
| `created_at`   | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                         |
| `updated_at`   | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                         |

### Descripción
La tabla "company" registra las empresas asociadas a un cliente específico y permite distinguir qué usuario las creó. Estos registros representan "clientes de mis clientes", siendo un vínculo entre el coordinador que terceriza los pedidos de las empresas. En esta relación, cada coordinador puede establecer sus propias empresas, incluso si se repiten entre coordinadores.

Su función principal es permitir a cada coordinador establecer sus propias empresas asociadas a un cliente en particular, independientemente de otras empresas establecidas por diferentes coordinadores. Actúa como un registro central para gestionar y organizar las relaciones entre clientes y sus empresas correspondientes, proporcionando flexibilidad en la gestión de la información empresarial en la plataforma.

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "patient"

### Estructura
La tabla "patient" tiene la siguiente estructura:

| Llave Compuesta                                                                       |
|---------------------------------------------------------------------------------------|
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`      |

| Columna              | Tipo                  | Restricciones                              |
|----------------------|-----------------------|--------------------------------------------|
| `patient_id`         | **PRIMARY KEY**       |                                            |
| `client_fk`          | **FOREIGN KEY**       | NOT NULL                                   |
| `user_fk`            | **FOREIGN KEY**       | NOT NULL                                   |
| `company_fk`         | **FOREIGN KEY**       | NOT NULL REFERENCES company(company_id)    |
| `name`               | **VARCHAR(100)**      | NOT NULL                                   |
| `healthcare_provider`| **VARCHAR(100)**      |                                            |
| `gender`             | **gender_options**    | NOT NULL                                   |
| `age`                | **SMALLINT**          |                                            |
| `phone`              | **VARCHAR(30)**       |                                            |
| `note`               | **TEXT**              |                                            |
| `is_active`          | **BOOLEAN**           | NOT NULL DEFAULT TRUE                      |
| `created_at`         | **TIMESTAMP**         | NOT NULL DEFAULT 'now()'                   |
| `updated_at`         | **TIMESTAMP**         | NOT NULL DEFAULT 'now()'                   |

### Descripción
La tabla "patient" almacena información detallada sobre los pacientes asociados a una empresa específica. Cada registro en esta tabla representa un paciente y está vinculado a un usuario y cliente particular. Se destaca que los pedidos se generan a partir de los pacientes, lo que facilita la distinción y seguimiento de los pacientes y sus pedidos asociados.

Su función principal es permitir la gestión y organización de información sobre los pacientes asociados a una empresa específica. Al generar pedidos a partir de los pacientes, se simplifica la distinción y seguimiento de la información relacionada con cada paciente y sus pedidos correspondientes, proporcionando así una visión integral de la actividad asociada a los servicios de atención domiciliaria.

### Restricciones (CHECK)
| Campo          | Descripción                                                            |
|----------------|------------------------------------------------------------------------|
| `age`          | Verifica que la edad del paciente sea entre 0 y 85.                    |
| `phone`        | Valida el formato del número de teléfono según una "regex".            |

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `company.is_active`       | **[I][U]**                | Valida que la empresa referenciada este activa.             |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "treatment"

### Estructura
La tabla "treatment" tiene la siguiente estructura:

| Llave Compuesta                                                                  |
|----------------------------------------------------------------------------------|
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")` |

| Columna         | Tipo              | Restricciones                                  |
|-----------------|-------------------|------------------------------------------------|
| `treatment_id`  | **PRIMARY KEY**   |                                                |
| `client_fk`     | **FOREIGN KEY**   | NOT NULL                                       |
| `user_fk`       | **FOREIGN KEY**   | NOT NULL                                       |
| `name`          | **VARCHAR(100)**  | NOT NULL                                       |
| `abbreviation`  | **VARCHAR(10)**   | NOT NULL                                       |
| `description`   | **TEXT**          |                                                |
| `is_active`     | **BOOLEAN**       | NOT NULL DEFAULT TRUE                          |
| `created_at`    | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                       |
| `updated_at`    | **TIMESTAMP**     | NOT NULL DEFAULT 'now()'                       |

### Descripción
La tabla "treatment" se utiliza para distinguir las prestaciones con las que trabaja o cubre un coordinador. Cada registro en esta tabla representa una prestación y está vinculado a un usuario y cliente específico. Importante destacar que no importa si se repiten los registros entre clientes, ya que cada uno es libre de crear las prestaciones que desee.

Su función principal es permitir a cada coordinador distinguir las prestaciones con las que trabaja, facilitando la gestión y organización de la información específica para cada cliente. La flexibilidad en la creación de prestaciones, sin restricciones sobre la repetición de registros entre clientes, proporciona a los coordinadores la libertad de adaptar sus servicios según las necesidades individuales de cada cliente.

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "company_has_treatment"

### Estructura
La tabla "company_has_treatment" tiene la siguiente estructura:

| Llave Compuesta                                                                   |
|-----------------------------------------------------------------------------------|
| `PRIMARY KEY ("company_fk", "treatment_fk")`                                      |
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`  |

| Columna           | Tipo                   | Restricciones                            |
|-------------------|------------------------|------------------------------------------|
| `client_fk`       | **FOREIGN KEY**        | NOT NULL                                 |
| `user_fk`         | **FOREIGN KEY**        | NOT NULL                                 |
| `company_fk`      | **FOREIGN KEY**        | NOT NULL                                 |
| `treatment_fk`    | **FOREIGN KEY**        | NOT NULL                                 |
| `value`           | **DECIMAL(7,2)**       | NOT NULL                                 |
| `created_at`      | **TIMESTAMP**          | NOT NULL DEFAULT 'now()'                 |
| `updated_at`      | **TIMESTAMP**          | NOT NULL DEFAULT 'now()'                 |

### Descripción
La tabla "company_has_treatment" controla la relación financiera entre una empresa específica (asociada a un coordinador) y una prestación en particular. Cada registro en esta tabla indica cuánto le paga la empresa al cliente (coordinador) por una prestación específica y registra quién fue el usuario que creó esta relación financiera.

Su objetivo principal es registrar las tarifas acordadas entre el coordinador y una empresa por servicios o prestaciones específicas. Proporciona una trazabilidad clara de los valores asociados a cada prestación y quién fue el responsable de establecer dicha tarifa, brindando así un control detallado sobre las transacciones financieras en el contexto de los servicios prestados.

### Restricciones (CHECK)
| Campo          | Descripción                                      |
|----------------|--------------------------------------------------|
| `value`        | Verifica que el campo 'value' sea positivo.      |

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `company.is_active`       | **[I][U]**                | Valida que la empresa referenciada este activa.             |
| `treatment.is_active`     | **[I][U]**                | Valida que la prestación referenciada este activa.          |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "treatment_has_professional"

### Estructura
La tabla "treatment_has_professional" tiene la siguiente estructura:

| Llave Compuesta                                                                                                     |
|---------------------------------------------------------------------------------------------------------------------|
| `PRIMARY KEY ("company_fk", "treatment_fk", "professional_fk")`                                                     |
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`                                    |
| `FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "client_has_professional"("client_fk", "professional_fk")` |

| Columna           | Tipo                    | Restricciones                                                             |
|-------------------|-------------------------|---------------------------------------------------------------------------|
| `client_fk`       | **FOREIGN KEY**         | NOT NULL                                                                  |
| `user_fk`         | **FOREIGN KEY**         | NOT NULL                                                                  |
| `professional_fk` | **FOREIGN KEY**         | NOT NULL                                                                  |
| `company_fk`      | **FOREIGN KEY**         | NOT NULL REFERENCES company(company_id)                                   |
| `treatment_fk`    | **FOREIGN KEY**         | NOT NULL REFERENCES treatment(treatment_id)                               |
| `value`           | **DECIMAL(7,2)**        | NOT NULL                                                                  |
| `created_at`      | **TIMESTAMP**           | NOT NULL DEFAULT 'now()'                                                  |
| `updated_at`      | **TIMESTAMP**           | NOT NULL DEFAULT 'now()'                                                  |

### Descripción
La tabla "treatment_has_professional" controla los costos que un coordinador (cliente) paga a cada profesional por una empresa y una prestación específica. Cada registro en esta tabla refleja la tarifa acordada entre el coordinador y el profesional por una determinada prestación y empresa, y también se almacena información sobre quién fue el usuario que estableció esta tarifa.

Su objetivo principal es registrar las tarifas acordadas entre el coordinador, la empresa y el profesional por servicios o prestaciones específicas. Proporciona una trazabilidad clara de los costos asociados a cada profesional y quién fue el responsable de establecer dicha tarifa, contribuyendo así a un control detallado de los aspectos financieros en el contexto de los servicios prestados.

### Restricciones (CHECK)
| Campo        | Descripción                                      |
|--------------|--------------------------------------------------|
| `value`      | Verifica que el campo 'value' sea positivo.      |

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `professional.is_active`  | **[I][U]**                | Valida que el profesional referenciado este activo.         |
| `company.is_active`       | **[I][U]**                | Valida que la empresa referenciada este activa.             |
| `treatment.is_active`     | **[I][U]**                | Valida que la prestación referenciada este activa.          |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "order"

### Estructura
La tabla "order" tiene la siguiente estructura:

| Llave Compuesta                                                                                                     |
|---------------------------------------------------------------------------------------------------------------------|
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`                                    |
| `FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "client_has_professional"("client_fk", "professional_fk")` |

| Columna             | Tipo                | Restricciones                                                               |
|---------------------|---------------------|-----------------------------------------------------------------------------|
| `order_id`          | **PRIMARY KEY**     |                                                                             |
| `order_fk`          | **FOREIGN KEY**     | REFERENCES "order"(order_id)                                                |
| `client_fk`         | **FOREIGN KEY**     | NOT NULL                                                                    |
| `user_fk`           | **FOREIGN KEY**     | NOT NULL                                                                    |
| `patient_fk`        | **FOREIGN KEY**     | NOT NULL REFERENCES patient(patient_id)                                     |
| `treatment_fk`      | **FOREIGN KEY**     | NOT NULL REFERENCES treatment(treatment_id)                                 |
| `professional_fk`   | **FOREIGN KEY**     |                                                                             |
| `start_date`        | **TIMESTAMP**       | NOT NULL                                                                    |
| `finish_date`       | **TIMESTAMP**       | NOT NULL                                                                    |
| `has_medical_order` | **BOOLEAN**         | NOT NULL DEFAULT FALSE                                                      |
| `frequency`         | **SMALLINT**        | NOT NULL                                                                    |
| `total_sessions`    | **SMALLINT**        | NOT NULL                                                                    |
| `sessions`          | **SMALLINT**        | NOT NULL                                                                    |
| `coinsurance`       | **DECIMAL(7,2)**    | NOT NULL DEFAULT 0                                                          |
| `value`             | **DECIMAL(7,2)**    | NOT NULL                                                                    |
| `cost`              | **DECIMAL(7,2)**    | NOT NULL                                                                    |
| `diagnosis`         | **TEXT**            |                                                                             |
| `requirements`      | **VARCHAR(300)**    |                                                                             |
|  `is_active`        | **BOOLEAN**         | NOT NULL DEFAULT TRUE                                                       |
| `created_at`        | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                                                    |
| `updated_at`        | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                                                    |

### Descripción
La tabla "order" registra los pedidos gestionados por un coordinador. Cada registro en esta tabla representa un pedido específico, distinguiendo entre "nuevo", "renovación" o "finalizado". Se asocia a un paciente, una prestación y, en caso de ser aplicable, a un profesional asignado. Además, se almacena información detallada sobre las fechas, sesiones, costos y requisitos relacionados con cada pedido.

Su objetivo principal es gestionar y registrar los pedidos realizados por un coordinador, proporcionando información detallada sobre el paciente, la prestación, las fechas, sesiones, costos y otros detalles relevantes. Facilita el seguimiento y la administración eficiente de los servicios prestados por los profesionales asignados a cada pedido, permitiendo una gestión efectiva de las solicitudes y renovaciones de servicios.

### Restricciones (CHECK)
| Campo                       | Descripción                                                                                                      |
|-----------------------------|------------------------------------------------------------------------------------------------------------------|
| `start_date`                | Valida que 'start_date' esté en un intervalo de 1 año desde la fecha actual.                                     |
| `finish_date`               | Valida que 'finish_date' esté en un intervalo de 1 año desde la fecha actual.                                    |
| `start_date`, `finish_date` | Verifica que ambas fechas pertenezcan al mismo mes y que 'start_date' no sea más reciente que 'finish_date'.     |
| `frequency`                 | Verifica que 'frequency' esté entre 1 y 7.                                                                       |
| `total_sessions`            | Verifica que 'total_sessions' tenga un valor entre 0 y 31.                                                       |
| `sessions`                  | Verifica que 'sessions' sea un valor entre 0 y 'total_sessions'.                                                 |
| `coinsurance`               | Verifica que 'coinsurance' sea un valor positivo.                                                                |
| `value`                     | Verifica que 'value' sea un valor positivo.                                                                      |
| `cost`                      | Verifica que 'cost' sea un valor positivo.                                                                       |

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `patient.is_active`       | **[I][U]**                | Valida que el paciente referenciado este activo.            |
| `treatment.is_active`     | **[I][U]**                | Valida que la prestación referenciada este activa.          |
| `professional.is_active`  | **[I][U]**                | Valida que el profesional referenciado este activo.         |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |

***

## Tabla "claim"

### Estructura
La tabla "claim" tiene la siguiente estructura:

| Llave Compuesta                                                                     |
|-------------------------------------------------------------------------------------|
| `FOREIGN KEY ("client_fk", "user_fk") REFERENCES "user"("client_fk", "user_id")`    |

| Columna         | Tipo                | Restricciones                                   |
|-----------------|---------------------|-------------------------------------------------|
| `claim_id`      | **PRIMARY KEY**     |                                                 |
| `order_fk`      | **FOREIGN KEY**     | NOT NULL REFERENCES "order"(order_id)           |
| `client_fk`     | **FOREIGN KEY**     | NOT NULL                                        |
| `user_fk`       | **FOREIGN KEY**     | NOT NULL                                        |
| `cause`         | **TEXT**            | NOT NULL                                        |
| `urgency`       | **urgency_options** | NOT NULL                                        |
| `reported_date` | **TIMESTAMP**       | NOT NULL                                        |
| `is_active`     | **BOOLEAN**         | NOT NULL DEFAULT TRUE                           |
| `created_at`    | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                        |
| `updated_at`    | **TIMESTAMP**       | NOT NULL DEFAULT 'now()'                        |

### Descripción
La tabla "claim" controla los reclamos asociados a un pedido específico de un cliente. Cada registro en esta tabla representa un reclamo registrado por un usuario en relación con un pedido específico. Se registra la causa del reclamo, la urgencia, la fecha de reporte y se identifica quién fue el usuario que registró el reclamo.

Su objetivo principal es registrar y controlar los reclamos asociados a los pedidos de un cliente específico. Proporciona un seguimiento detallado de los reclamos, identificando la causa, urgencia y quién fue el usuario responsable de su registro. Además, facilita la gestión y resolución eficiente de los reclamos asociados a los servicios prestados, contribuyendo a mantener un alto nivel de calidad en la atención y servicio al cliente.

### Restricciones (CHECK)
| Campo            | Descripción                                                                      |
|------------------|----------------------------------------------------------------------------------|
| `reported_date`  | Valida que 'reported_date' tenga una antiguedad máxima de 31 días.               |

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                                                 |
|---------------------------|---------------------------|-------------------------------------------------------------|
| `order.is_active`         | **[I][U]**                | Valida que la orden referenciada este activa.               |
| `client.is_active`        | **[I][U]**                | Valida que el cliente referenciado este activo.             |
| `user.is_active`          | **[I][U]**                | Valida que el usuario referenciado este activo.             |
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.                |
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.                         |