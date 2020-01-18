# Copyright 2020 qgervac.io -  All rights reserved.

FROM postgres:11.5

LABEL maintainer="Quirino Gervacio <qgervacio@gmail.com>"

ARG ENV

RUN apt-get update

COPY env/$ENV/pg_hba.conf     /etc/pg/pg_hba.conf
COPY env/$ENV/pg_ident.conf   /etc/pg/pg_ident.conf
COPY env/$ENV/postgresql.conf /etc/pg/postgresql.conf
RUN chmod -R 555 /etc/pg

CMD ["postgres", "-c", "config_file=/etc/pg/postgresql.conf", "-c", "hba_file=/etc/pg/pg_hba.conf", "-c", "ident_file=/etc/pg/pg_ident.conf"]   