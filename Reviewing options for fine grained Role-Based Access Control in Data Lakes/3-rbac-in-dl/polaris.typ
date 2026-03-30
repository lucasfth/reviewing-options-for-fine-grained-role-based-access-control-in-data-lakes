== Apache Polaris
<sec:polaris>
Apache Polaris is a catalogue implementation for Apache Iceberg.
@fig:polaris-rbac shows the model of RBAC used, and Apache Iceberg supports REST-compatible query engines, which include platforms like Apache Spark.

To access data, the client/query engine is authenticated through either the default IdP or a configured external IdP, which uses OpenID Connect.
The obtained token is then verified by Polaris, and the principal role is resolved based on the token.

It can then check the roles allowed to the user and provides credential vending, which "allow the query engine to run the query without requiring access to your cloud storage for Iceberg tables"@apache-polaris-1.2.0-docs.

Apache Polaris offers a granularity level starting at the catalogue, namespace level, and continues at the Iceberg Table, View, and Policy level, which "is a structured entity that defines rules governing actions on specified resources under predefined conditions"@apache-polaris-policy.

Same as with Lakekeeper, Polaris does not offer encryption-at-rest.
But as it is also an Iceberg-based catalogue, Parquet files are supported.
Parquets encryption can thus be used to ensure encryption-at-rest, but would need a separate cryptographic system in place to work.@apache-polaris-1.2.0-docs

#figure(
  placement: top,
  scope: "parent",
  image("polaris-rbac.png", width: 70%),
  caption: [RBAC model in Apache Polaris, from @apache-polaris-1.2.0-rbac-docs]
)<fig:polaris-rbac>
