#bin/bash
set -e

tar -xzvf /var/lib/postgresql/rawdata/out_290220.gz -C /var/lib/postgresql/rawcsvs

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY customers
    FROM '/var/lib/postgresql/rawcsvs/customers.csv' DELIMITER ',' CSV HEADER;
EOSQL

