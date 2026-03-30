== Data Lakes
<sec:datalake>

A "data lake" is a centralized repository of data, which could be structured, semi-structured or unstructured.@ibm-what-datalake
It differs from a traditional database in that a data lake separates compute and storage layers.
The data itself is stored in object stores like Amazon S3@amazon-s3, in file formats like CSV, Parquet#footnote[@sec:parquet defines Parquet], etc.
The compute nodes are simply any query engine, such as Apache Spark @apache-spark, that connects to the object store and uses the data. 
This could be a data scientist working on their own machine, who connects to a data lake and runs queries; or it could be a part of a managed all-in-one platform like Snowflake#footnote[@sec:snowflake defines Snowflake].
As the object store just contains raw data, both structured and unstructured, this can make it more complicated to query, especially for large data lakes. One approach to querying is "schema on read", in which the query engine infers a schema at query time based on the files in the data lake.
This is in contrast to "schema-on-write" used in traditional relational databases, where the schema is strictly enforced when writing.
This doesn't work well for data lakes due to the nature of storing raw data in object stores. 
Typically, data lakes introduce a _catalogue_ on top of the object store that manages file schemas, metadata and snapshots, allowing for structured reads and more performant querying through techniques like partitioning, i.e. filtering unnecessary data.
This has also been referred to as a _data lakehouse_ .@Databricks2021Lakehouse
