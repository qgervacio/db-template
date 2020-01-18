-- Copyright 2020 qgervac.io -  All rights reserved. 

CREATE SCHEMA changeme;

SET search_path TO changeme;

CREATE TABLE changeme.test (
    id   UUID        PRIMARY KEY,
    tst  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    col1 VARCHAR(99) NOT NULL UNIQUE, 
    col2 VARCHAR(99) NOT NULL
);
CREATE INDEX test_col1_idx ON changeme.test (col1);
SELECT audit.audit_table('changeme.test');