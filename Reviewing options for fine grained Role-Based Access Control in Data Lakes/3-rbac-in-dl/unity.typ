== Databricks (Unity Catalog)
#label("sec:databricks")

Unity Catalog is an open-sourced catalogue initially created by Databricks.
Unity Catalog is limited in its access control, and only when using it through Databricks, finer granularity than file-level is enforced.#cite(<databricks-open-sourcing-unity-catalog>)

The flow in Databricks differs from, e.g. Lakekeeper, as by default it does not use vended credentials, but it is supported.
Instead, all access is routed through Databricks itself.
Meaning that no temporary access is given to the object store from the client's perspective.

This allows Databricks to offer granularity levels at the object, catalogue, schema, table, view, volume, column, and row levels.
Row and column level access control are enforced by row filters and column masks #cite(<databricks-manage-privileges>)#cite(<databricks-fgac>), which are defined in @sec:snowflake.

Databricks also supports encryption-at-rest.
This is handled by using something similar to envelope encryption, though not specified in detail.
#cite(<databricks-vague-encryption-desc>)#cite(<databricks-encryption-type>)

For IdP, Databricks relies on its own internal IdP.
Though it does support synchronizing an externally managed IdP with its own internal one.
Its internal IdP relies on attribute-based access control (ABAC) and not RBAC.#cite(<databricks-ext-idp>)#cite(<databricks-abac>)
