# DB Template

This repository is intended to maintain the persistence layer of the application. 
The solution will require [PostgresSQL](https://www.postgresql.org) and 
[FlywayDB](https://flywaydb.org) database versioning tool in order to carry out 
seamless DDL/DML versioning operations against a database.

## Rule of Thumb!

> **Never** change a migration once it has been applied to the database!
> **Always** create another version file. **DO NOT** update an already migrated
> version.

## Requirements

Testing is primarily on **OSX** but the binary requirements should be the same
for other platforms.

1. [Docker For Mac](https://docs.docker.com/v17.12/docker-for-mac/install/)
2. [Flyway CLI via Homebrew](https://flywaydb.org/blog/homebrew)
    ```
    brew install flyway
    ```
3. Install [GPG Tool](https://gpgtools.org) for easier key management.

## Quick Start

Getting some help.

```
make help

# simply just 

make
```

Clean slate using dev (local) environment.

```
make env=dev clean decrypt build up apply
```

## Testing

Note that data are persisted in local storage via volume. Running
`clean` target will effectively delete Postgres data files.

## Notes

Good to remember...

1. Currently uses Flyway Community Edition.
2. Only `flyway` schema will be deleted on `flyway clean`.
3. Audit table is declaratively partitioned by range yearly upto year 2030.
4. A table is considered large is when the size of the table exceeds the size of of
   the physical memory of the database server.


## References

1. [Postgres 11 Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
2. [Postgres 11 File Locations](https://www.postgresql.org/docs/11/runtime-config-file-locations.html)