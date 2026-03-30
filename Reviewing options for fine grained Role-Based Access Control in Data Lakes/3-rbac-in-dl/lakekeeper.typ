== Lakekeeper
#label("sec:lakekeeper")

Lakekeeper @lakekeeper-docs-concept is an open-source implementation of the Apache Iceberg REST catalogue API.
Like with other Iceberg-based catalogues, see @sec:iceberg, it acts as the metadata store for the data lake, with the data itself residing in a remote object store like Amazon S3.
Lakekeeper adds a security layer on top of the data lake by adding dependencies on several external services, which it uses for authentication and authorization.
While Lakekeeper _can_ be used without authentication enabled, the following assumes it is enabled.

/ Persistence backend: Lakekeeper requires a persistence backend for the catalogue metadata.
It currently only supports a PostgreSQL database.

/ Object store: An object store is required for a Lakekeeper-based data lake, as this is where the data resides.
A key difference is that access to the object store is governed only by Lakekeeper; i.e. no one other than Lakekeeper itself can have "direct" access to the object store without permission by Lakekeeper.
/ Identity provider: Lakekeeper requires an external Identity Provider to authenticate users.
The recommended approach is to use any identity provider supporting OpenID Connect (OIDC)#footnote[OIDC is an identity protocol which extends OAuth 2.0@oidc-auth0].

/ Authorization System: Lakekeeper requires an authorization system to manage permissions and perform authorization checks. An example is OpenFGA @openfga-docs.
_OpenFGA_ is an open-source _relationship-based_ fine-grained authorization system based on Google Zanzibar, Google's internal authorization system, first described by Pang. et. al @zanzibar.

=== OpenFGA
OpenFGA provides a platform for modelling authorization using an "authorization model", a schema that defines existing types in the system, like objects or users.
To define permissions, _relationship tuples_ are added to the system, which define a relationship between a user and an entity -- the collection of relationships then acts as the permissions in the system.
Later, to check permissions, a "check request" can be sent to the API.
This request asks: "Does _some user_ have _some relationship_ with _some entity_?". 

The following describes the flow of authentication and authorization in Lakekeeper.
When a query engine then connects to Lakekeeper, it uses the above components to evaluate whether or not the request is permitted. @fig:lakekeeper-flow shows a sequence diagram of this flow, using Vended Credentials.
// TODO: how to reference the figure nicely?
To perform a query, the client/query engine obtains a JWT token from some OIDC-capable identity provider, like Microsoft Entra ID#footnote[Microsoft Entra ID being an Identity and Access Management System@microsoft-entra-id] or Keycloak.@lakekeeper-docs-auth, steps 1 to 2 in @fig:lakekeeper-flow.
The query engine then provides the acquired token together with its call to Lakekeeper, step 3.
Lakekeeper proceeds to verify the token against the configured IdP, steps 4 and 5.

Given Lakekeeper was provided a valid token, the user is added to its internal database if the user did not already exist.
Lakekeeper now contacts OpenFGA, the default permission system, to check if the user has the required relation to the requested object, to authorize the request, steps 6 and 7.
If the request is authorized, it will return an access mode to the client.
This will enable them to do the required operation on the store, and they get access to the store through an access mode, steps 8 to 10.
For Amazon S3, Lakekeeper supports _remote request signing_ or _vended credentials_ @lakekeeper-docs-storage.
/ Remote Signing: The query engine sends an unsigned or self-signed S3 request to Lakekeeper, which then checks if the request is permitted. If so, Lakekeeper signs it with its secure credentials and returns it to the client, who can then use it to access the permitted files in S3 directly.
/ Vended credentials: Vended credentials are a way to give an entity access to a location using temporary credentials. Lakekeeper uses Amazon Secure Token Service (STS) @amazon-sts, to create temporary, fine-grained credentials that the query engine can use to access S3.

#figure(
  placement: top,
  scope: "parent",
  (```pintora
  sequenceDiagram
    title: Lakekeeper auth
    autonumber
    participant UserApp as "Query Engine"
    participant OIDC as "Identity Provider"
    participant Lakekeeper
    participant OpenFGA as "OpenFGA"
    participant Storage as "Object Storage"
  
    %% Authentication
    UserApp->>OIDC: Authenticate (OIDC Flow)
    OIDC-->>UserApp: ID Token + Access Token
  
    %% Request to Lakekeeper
    UserApp->>Lakekeeper: Request + OIDC Token
    Lakekeeper->>OIDC: Validate Token
    OIDC-->>Lakekeeper: Token Valid
  
    %% Authorization
    Lakekeeper->>OpenFGA: Check Permission
    OpenFGA-->>Lakekeeper: allow/deny
  
    %% Credentials issued if authorized
    Lakekeeper-->>UserApp: Vended Credentials (if allowed)
  
    %% Data access
    UserApp->>Storage: Read Data using credentials
    Storage-->>UserApp: Data
  ```),
  kind: image,
  caption: [Authentication & Authorization flow in Lakekeeper]
)<fig:lakekeeper-flow>

Lakekeeper offers a hierarchical granularity system, starting at the _server_ level; a Server refers to a single, or a cluster of, Lakekeeper pod(s), that is, individual running instances of the application, with common state.
A _server_ can contain one or more _projects_, which in turn contain _warehouses_.
A warehouse refers to the data lake itself; it is the entity that query engines connect to.
A warehouse contains _namespaces_, which contain _tables_, _views_ or other namespaces.
Access to each of these levels can be controlled using the permission system. Tables and views are thus the "finest" level of granularity supported by Lakekeeper. @fig:lakekeeper-hierarchy shows the hierarchy.

#figure(
  placement: top,
  image("lakekeeper_hierarchy.png", width: 70%),
  caption: [
    The hierarchy of Lakekeeper entities. From @lakekeeper-docs-concept.
  ],
)<fig:lakekeeper-hierarchy>

Using OpenFGA, Lakekeeper supports data access control, but it offers no mechanism for encryption-at-rest.
However, due to Lakekeeper being an Iceberg catalogue and thus supporting Parquet files for storage, encryption-at-rest can be achieved using encryption of the stored Parquet files (@sec:parquet-encryption).
This would, however, require a manual intervention or a separate system to manage cryptographic operations on the data at rest and the handling of the cryptographic keys.

