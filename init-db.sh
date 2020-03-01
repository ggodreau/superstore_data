#bin/bash
set -e

# extract data archive (all csvs) into uncompressed csvs
tar -xzvf /var/lib/postgresql/rawdata/out_290220.gz -C /var/lib/postgresql/rawcsvs

# create customers table
echo Creating customers table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE customers
    (
      customer_id varchar(50) PRIMARY KEY,
      customer_name varchar(50),
      segment varchar(50)
    );
EOSQL

# populate customers table
echo Populating customers table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY customers
    FROM '/var/lib/postgresql/rawcsvs/customers.csv' DELIMITER ',' CSV HEADER;
EOSQL

# create orders table
echo Creating orders table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE orders
    (
      id integer PRIMARY KEY,
      order_id varchar(20) NOT NULL UNIQUE,
      order_date date,
      ship_date date,
      ship_mode varchar(20),
      customer_id varchar(8) NOT NULL,
      product_id varchar(16) NOT NULL,
      sales money,
      quantity integer,
      discount real,
      profit money,
      region_id integer NOT NULL
    );
EOSQL

# populate orders table
echo Populating orders table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY customers
    FROM '/var/lib/postgresql/rawcsvs/orders.csv' DELIMITER ',' CSV HEADER;
EOSQL
