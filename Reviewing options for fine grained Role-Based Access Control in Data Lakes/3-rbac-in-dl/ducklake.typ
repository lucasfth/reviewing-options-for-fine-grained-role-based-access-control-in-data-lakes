== DuckLake

DuckLake is an "integrated data lake and catalog format"@ducklake-docs.
It uses a relational SQL database as its catalogue database, and an object store such as S3 as a data store, storing data using the Parquet file format.@ducklake-intro-docs
While DuckLake itself does _not_ support access control out of the box, it can leverage the access control systems from its catalogue database and object store to provide access control.
Using, for example, PostgreSQL and S3, access control can be achieved by using PostgreSQL roles along with AWS IAM roles.@ducklake-ac-docs

Since access control is not native to DuckLake, the granularity of the permission system depends on the permission system provided by the "building blocks"; i.e., the catalogue database and object store.
For example, PostgreSQL can enforce permissions at the schema or table level by using PostgreSQL's roles and `GRANT`s@postgresql-grant.
Then, by using AWS Identity and Access Manager@aws-iam, it can be defined that, given some credentials, you are enabled to create, read, update, and delete the given Parquet files. 

By doing the above, DuckLake can rely on object-store encryption (e.g., S3 SSE‑KMS) and/or Parquet file‑level encryption.
