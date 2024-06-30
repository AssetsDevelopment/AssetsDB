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

## Tabla "user"

### Estructura
La tabla "user" tiene la siguiente estructura:

| Columna      | Tipo              | Restricciones                              |
|--------------|-------------------|--------------------------------------------|
| `user_id`    | **PRIMARY KEY**   |                                            |
| `profile`    | **VARCHAR(100)**  | NOT NULL UNIQUE                            |
| `phone`      | **VARCHAR(30)**   |                                            |
| `email`      | **VARCHAR(255)**  |                                            |
| `password`   | **VARCHAR(255)**  | NOT NULL                                   |
| `is_active`  | **BOOLEAN**       | NOT NULL DEFAULT TRUE                      |
| `user_type`  | **VARCHAR(12)**   | NOT NULL DEFAULT TRUE                      |
| `created_at` | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP         |
| `updated_at` | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP         |

| Índice Único                                                            |
|-------------------------------------------------------------------------|
| `UNIQUE INDEX ((CASE WHEN email IS NOT NULL THEN email END))`           |
| `UNIQUE INDEX ((CASE WHEN phone IS NOT NULL THEN phone END))`           |

### Descripción
[COMPLETAR_DESCRIPCION]

### Restricciones (CHECK)
| Campo        | Descripción                                                                |
|--------------|----------------------------------------------------------------------------|
| `email`      | Verifica que al menos uno de los campos 'email' o 'phone' esté presente.   |
| `email`      | Verifica que el campo 'email' no esté vacío.                               |

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                             |
|---------------------|---------------------------|-----------------------------------------|
| `email`             | **[I][U][<>][email]**     | Valida contra una "regex" que el valor tenga un formato correcto y pertenezca a un dominio reconocido. |
| `password`          | **[I][U][<>][password]**  | Valida que el valor >= 8 y luego lo hashea.                                                            |
| `user_type`         | **[U]**                   | Valida que el valor no pueda ser modificado.                                                           |
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.                                                           |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                                                                    |

***

## Tabla "client"

### Estructura
La tabla "client" tiene la siguiente estructura:

| Columna       | Tipo                | Restricciones                     |
|---------------|---------------------|-----------------------------------|
| `client_id`   | **PRIMARY KEY**     |                                   |
| `client_fk`   | **FOREIGN KEY**     | REFERENCES "client"(client_id)    |
| `user_fk`     | **FOREIGN KEY**     | REFERENCES "user"(user_id)        |
| `name`        | **VARCHAR(100)**    | NOT NULL                          |
| `last_name`   | **VARCHAR(100)**    | NOT NULL                          |
| `gender`      | **gender_options**  | NOT NULL                          |
| `is_admin`    | **BOOLEAN**         | NOT NULL DEFAULT FALSE            |
| `created_at`  | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TI       |
| `updated_at`  | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TI       |

### Descripción
[COMPLETAR_DESCRIPCION]

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                                 |
|---------------------|---------------------------|---------------------------------------------|
| `is_admin`          | **[I][U][<>][is_admin]**  | Valida que exista un solo usuario administrador por cliente.|
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.|
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.         |

***

## Tabla "professional"

### Estructura
La tabla "professional" tiene la siguiente estructura:

| Columna           | Tipo                | Restricciones                     |
|-------------------|---------------------|-----------------------------------|
| `professional_id` | **PRIMARY KEY**     |                                   |
| `user_fk`         | **FOREIGN KEY**     | REFERENCES "user"(user_id)        |
| `name`            | **VARCHAR(100)**    | NOT NULL                          |
| `last_name`       | **VARCHAR(100)**    | NOT NULL                          |
| `gender`          | **gender_options**  | NOT NULL                          |
| `cuit`            | **VARCHAR(20)**     |                                   |
| `fiscal_status`   | **fiscal_status**   |                                   |
| `birthdate`       | **DATE**            |                                   |
| `bank`            | **VARCHAR(255)**    |                                   |
| `bank_account`    | **VARCHAR(50)**     |                                   |
| `cbu`             | **VARCHAR(23)**     |                                   |
| `alias`           | **VARCHAR(50)**     |                                   |
| `created_at`      | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP|
| `updated_at`      | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP|

### Descripción
[COMPLETAR_DESCRIPCION]

### Restricciones (CHECK)
| Campo        | Descripción                                                                |
|--------------|----------------------------------------------------------------------------|
| `birthdate`  | Verifica que el profesional tenga entre 18 y 85 años según su fecha de nacimiento.|

### Validaciones (TRIGGER)
| Campo               | Disparador                | Descripción                             |
|---------------------|---------------------------|-----------------------------------------|
| `created_at`        | **[U]**                   | Valida que el valor no pueda ser modificado.                                                           |
| `updated_at`        | **[U]**                   | Actualiza el valor automaticamente.                                                                    |

***

## Tabla "client_has_professional"

### Estructura
La tabla "client_has_professional" tiene la siguiente estructura  

| Llave Compuesta                                                                           |
|-------------------------------------------------------------------------------------------|
| `PRIMARY KEY ("client_fk", "professional_fk")`                                            |

| Columna           | Tipo                | Restricciones                                |
|-------------------|---------------------|----------------------------------------------|
| `client_fk`       | **FOREIGN KEY**     | NOT NULL                                     |
| `professional_fk` | **FOREIGN KEY**     | NOT NULL                                     |
| `sender`          | **profile_options** | NOT NULL                                     |
| `is_accept`       | **BOOLEAN**         | NOT NULL DEFAULT FALSE                       |
| `is_active`       | **BOOLEAN**         | NOT NULL DEFAULT TRUE                        |
| `created_at`      | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP           |
| `updated_at`      | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP           |

### Descripción
[COMPLETAR_DESCRIPCION]

### Validaciones (TRIGGER)
| Campo                     | Disparador                | Descripción                      |
|---------------------------|---------------------------|----------------------------------|
| `created_at`              | **[U]**                   | Valida que el valor no pueda ser modificado.|
| `updated_at`              | **[U]**                   | Actualiza el valor automaticamente.|

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
| `name`         | **VARCHAR(100)**  | NOT NULL                                         |
| `cuit`         | **VARCHAR(20)**   |                                                  |
| `note`         | **TEXT**          |                                                  |
| `is_active`    | **BOOLEAN**       | NOT NULL DEFAULT TRUE                            |
| `created_at`   | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP               |
| `updated_at`   | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP               |

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
| `company_fk`         | **FOREIGN KEY**       | NOT NULL REFERENCES company(company_id)    |
| `name`               | **VARCHAR(100)**      | NOT NULL                                   |
| `healthcare_provider`| **VARCHAR(100)**      |                                            |
| `gender`             | **gender_options**    | NOT NULL                                   |
| `age`                | **SMALLINT**          |                                            |
| `phone`              | **VARCHAR(30)**       |                                            |
| `note`               | **TEXT**              |                                            |
| `is_active`          | **BOOLEAN**           | NOT NULL DEFAULT TRUE                      |
| `created_at`         | **TIMESTAMP**         | NOT NULL DEFAULT CURRENT_TIMESTAMP         |
| `updated_at`         | **TIMESTAMP**         | NOT NULL DEFAULT CURRENT_TIMESTAMP         |

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
| `name`          | **VARCHAR(100)**  | NOT NULL                                       |
| `abbreviation`  | **VARCHAR(10)**   | NOT NULL                                       |
| `description`   | **TEXT**          |                                                |
| `is_active`     | **BOOLEAN**       | NOT NULL DEFAULT TRUE                          |
| `created_at`    | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP             |
| `updated_at`    | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP             |

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
| `PRIMARY KEY ("client_fk", "company_fk", "treatment_fk")`                                      |

| Columna           | Tipo                   | Restricciones                            |
|-------------------|------------------------|------------------------------------------|
| `client_fk`       | **FOREIGN KEY**        | NOT NULL                                 |
| `company_fk`      | **FOREIGN KEY**        | NOT NULL                                 |
| `treatment_fk`    | **FOREIGN KEY**        | NOT NULL                                 |
| `value`           | **DECIMAL(7,2)**       | NOT NULL                                 |
| `created_at`      | **TIMESTAMP**          | NOT NULL DEFAULT CURRENT_TIMESTAMP       |
| `updated_at`      | **TIMESTAMP**          | NOT NULL DEFAULT CURRENT_TIMESTAMP       |

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
| `PRIMARY KEY ("clien_fk", "professional_fk", "company_fk", "treatment_fk")`                                                     |
| `FOREIGN KEY ("client_fk", "professional_fk") REFERENCES "client_has_professional"("client_fk", "professional_fk")` |

| Columna           | Tipo                    | Restricciones                                                             |
|-------------------|-------------------------|---------------------------------------------------------------------------|
| `client_fk`       | **FOREIGN KEY**         | NOT NULL                                                                  |
| `user_fk`         | **FOREIGN KEY**         | NOT NULL                                                                  |
| `professional_fk` | **FOREIGN KEY**         | NOT NULL                                                                  |
| `company_fk`      | **FOREIGN KEY**         | NOT NULL REFERENCES company(company_id)                                   |
| `treatment_fk`    | **FOREIGN KEY**         | NOT NULL REFERENCES treatment(treatment_id)                               |
| `value`           | **DECIMAL(7,2)**        | NOT NULL                                                                  |
| `created_at`      | **TIMESTAMP**           | NOT NULL DEFAULT CURRENT_TIMESTAMP                                        |
| `updated_at`      | **TIMESTAMP**           | NOT NULL DEFAULT CURRENT_TIMESTAMP                                        |

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
| `created_at`        | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP                                          |
| `updated_at`        | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP                                          |

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
| `cause`         | **TEXT**            | NOT NULL                                        |
| `urgency`       | **urgency_options** | NOT NULL                                        |
| `reported_date` | **TIMESTAMP**       | NOT NULL                                        |
| `is_active`     | **BOOLEAN**         | NOT NULL DEFAULT TRUE                           |
| `created_at`    | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP              |
| `updated_at`    | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TIMESTAMP              |

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