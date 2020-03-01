#bin/bash
set -e

# extract data archive (all csvs) into uncompressed csvs
tar -xzvf /var/lib/postgresql/rawdata/out_290220.gz -C /var/lib/postgresql/rawcsvs

###########
# CUSTOMERS
###########

echo Creating customers table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE customers
    (
      customer_id varchar(50) PRIMARY KEY,
      customer_name varchar(50),
      segment varchar(50)
    );
EOSQL

echo Populating customers table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY customers
    FROM '/var/lib/postgresql/rawcsvs/customers.csv' DELIMITER ',' CSV HEADER;
EOSQL

########
# ORDERS
########

echo Creating orders table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE orders
    (
      id integer PRIMARY KEY,
      order_id varchar(20) NOT NULL,
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

echo Populating orders table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY orders
    FROM '/var/lib/postgresql/rawcsvs/orders.csv' DELIMITER ',' CSV HEADER;
EOSQL

##########
# PRODUCTS
##########

echo Creating products table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE products
    (
      product_id varchar(16) PRIMARY KEY,
      category varchar(15),
      sub_category varchar(11),
      product_name varchar(109),
      product_cost_to_consumer money
    );
EOSQL

echo Populating products table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY products
    FROM '/var/lib/postgresql/rawcsvs/products.csv' DELIMITER ',' CSV HEADER;
EOSQL

#########
# REGIONS
#########

echo Creating regions table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE regions
    (
      id integer PRIMARY KEY,
      region varchar(14),
      country varchar(32),
      state varchar(36),
      city varchar(35),
      salesperson varchar(17),
      postal_code varchar(20),
      country_code varchar(20)
    );
EOSQL

echo Populating regions table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY regions
    FROM '/var/lib/postgresql/rawcsvs/regions.csv' DELIMITER ',' CSV HEADER;
EOSQL

#########
# RETURNS
#########

echo Creating returns table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE returns
    (
      order_id varchar(15) PRIMARY KEY,
      return_date date,
      return_quantity integer,
      reason_returned varchar(11)
    );
EOSQL

echo Populating returns table...
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY returns
    FROM '/var/lib/postgresql/rawcsvs/returns.csv' DELIMITER ',' CSV HEADER;
EOSQL
