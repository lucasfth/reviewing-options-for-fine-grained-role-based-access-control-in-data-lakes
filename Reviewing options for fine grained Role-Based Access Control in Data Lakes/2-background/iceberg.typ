== Iceberg
#label("sec:iceberg")

Iceberg @apache_iceberg is an open-source "table format" for large analytical tables.
It provides query engines with a standardized way of understanding tables in data lakes and enables performant and reliable querying.
Iceberg organizes data in an object store into tables with formal schemas, provides partitioning using file metadata and provides version snapshots of these tables.
This allows query engines to query the data lake in a structured, reliable way with standard SQL, and allows for fast reads even in petabyte-scale tables, due to partitioning using the metadata.
It also allows for _time travel_ queries with help from the versioned snapshots, which allows analysts to make reproducible queries as they were at some point in time.

While Iceberg is not in itself a catalogue, it provides a REST API Specification which can be used to implement an Iceberg-based catalogue, like Lakekeeper (@sec:lakekeeper) or Polaris (@sec:polaris).
