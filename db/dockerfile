FROM postgres
ENV POSTGRES_PASSWORD=example
ADD https://raw.githubusercontent.com/ggodreau/superstore_data/master/init-db.sh /docker-entrypoint-initdb.d
RUN mkdir /var/lib/postgresql/rawdata \
  && mkdir /var/lib/postgresql/rawcsvs \
  && chmod 777 /docker-entrypoint-initdb.d/init-db.sh \
  && chmod -R 777 /var/lib/postgresql/rawdata \
  && chmod -R 777 /var/lib/postgresql/rawcsvs
ADD https://raw.githubusercontent.com/ggodreau/superstore_data/master/out_290220.gz /var/lib/postgresql/rawdata
RUN chmod 777 /var/lib/postgresql/rawdata/out_290220.gz
