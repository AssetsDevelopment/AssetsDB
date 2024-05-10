FROM postgres:15.3 as dev

ARG POSTGRES_USER=myuser
ARG POSTGRES_PASSWORD=mypassword
ARG POSTGRES_DB=mydb

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

COPY assets_db_v2/01_creation_tables.sql /docker-entrypoint-initdb.d
COPY assets_db_v2/14_insertion_script.sql /docker-entrypoint-initdb.d
COPY assets_db_v2/triggers_function/credentials /docker-entrypoint-initdb.d
COPY assets_db_v2/triggers_function/is_active /docker-entrypoint-initdb.d
COPY assets_db_v2/procedures /docker-entrypoint-initdb.d
COPY assets_db_v2/procedures /docker-entrypoint-initdb.d

USER postgres

CMD ["postgres"]

EXPOSE 5432