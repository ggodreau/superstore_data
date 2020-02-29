#bin/bash
set -e

# extract data archive into csvs
tar -xzvf /var/lib/postgresql/rawdata/out_290220.gz -C /var/lib/postgresql/rawcsvs

# create customers table
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE persons
    (
      customer_id character varying(50),
      customer_name character varying(50),
      segment character varying(50)
    );
EOSQL

# populate customers table
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY customers
    FROM '/var/lib/postgresql/rawcsvs/customers.csv' DELIMITER ',' CSV HEADER;
EOSQL

