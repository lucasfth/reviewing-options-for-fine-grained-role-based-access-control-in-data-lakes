== Snowflake
<sec:snowflake>

The "Snowflake Elastic Data Warehouse", or Snowflake for short, @sigmod-snowflake is a fully cloud-based Software-as-a-Service (SaaS) solution for data analysis.

It is built upon three architectural layers of independent services: the _data storage_ layer, which handles data storage in an object store such as S3, the _virtual warehouse_ layer, which handles query execution through an elastic cluster of worker nodes, and the _cloud services_ layer, a collection of services for managing the platform. As a fully managed cloud platform, it supports storing and querying data through Snowflake's own proprietary SQL execution engine, with security features including RBAC and full end-to-end encryption using industry-standard encryption. Snowflake supports column- and row-level granular access control through the use of *column masking policies* and *row access policies*.

/ Column masking policy: Used to transform the values of a column to an unreadable, "masked" format, to redact protected information. An example could be replacing all values of a column with an asterisk, "\*". With this, queries that return information from columns the user does not have access to will have their values masked at query time. @snowflake-column-security
/ Row access policy:  Used to govern access to entire rows by filtering out rows the user does not have permission to at query time. Unlike column masks, none of the protected data is returned to the user, even in a masked format, but instead filtered out by the query engine. @snowflake-row-security

On top of being a fully managed "all-in-one" platform, Snowflake also supports querying _external tables_ instead of data stored in Snowflake-managed tables, to enable querying of data lakes built on open file formats like Parquet and Iceberg, and allowing for other query engines to operate on the same data.
There are many options for how to configure this, but for the scope of this paper, we will focus on the following two options.

/ Snowflake Horizon Catalog: With this, Snowflake creates and manages external Iceberg tables and acts as the catalogue of the data lake, managing all metadata.
Using the Snowflake UI, Iceberg tables can be queried as regular Snowflake tables, with column- or row-level granularity by the use of masking policies and row access policies.
External query engines must go through the Horizon catalog, by authenticating using Snowflake access tokens or an External IdP and then querying using the catalogue.
However, querying Iceberg tables with column- or row-level security is not supported using external query engines.@snowflake-horizon-catalog

/ Snowflake Open Catalog: a managed, cloud-based version of Apache Polaris (@sec:polaris), supporting the same interface and access control policies as Polaris. @snowflake-open-catalog
