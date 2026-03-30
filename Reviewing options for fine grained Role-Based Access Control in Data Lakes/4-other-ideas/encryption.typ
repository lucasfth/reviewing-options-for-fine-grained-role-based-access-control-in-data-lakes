// ATRO: "could be the solution"... maybe word it more like, "is our proposal? " seems a bit bold
Fine-grained role-based access control (FGRBAC) by encryption is our proposal for a solution that ensures a more varied choice of query engines can be used by encrypting the data-at-rest, and all authenticated access to the object store.
This can be done by leveraging the supported encryption with Parquet.
Resulting in (given a separate system which can help decrypt the data) users being able to access columns only meant to be read by them, whilst the whole system does not have to trust the query engine implementations itself.

In the next subsections, we will describe the logic behind reading and writing using our proposed solution.

=== Encrypting (create/update)
<sec:osws-encrypt>

On insert/update, cryptographic keys are generated for each column, where RBAC is required, and the data is encrypted, together with their respective column metadata in the footer.
The reasoning for encrypting the column metadata was discussed in @sec:parquet-encryption, but it is mainly due to being able to contain sensitive information.
Then the cryptographic keys will get an ID, the ID will be stored in the footer metadata for its column, and the key ID and key will be stored as a pair in the KMS.

\ _Example:_ 
Suppose Alice wants to create/update a new table with the following columns: `names`, `ages`, and `CPR`.
Alice might want to ensure that only users with the role `manager` can access `names` and `CPR`, whilst ages can be accessed by everyone who has access to the S3 object store.
Then Alice will create two cryptographic keys, one for `names` (`name_key`) and one for `CPR` (`cpr_key`).
Alice can now encrypt the columns and their respective footer column metadata, with their respective key, and leave the `ages` column decrypted.
In the Parquet footer metadata, Alice will add the IDs of `name_key` and `cpr_key`.
The key ID and the key itself are then added as a pair to the KMS and linked to the role `manager`.

=== Decrypting (read)
<sec:osws-decrypt>

On read, the Parquet file, which contains the wanted data, might be partially encrypted.
The cryptographic keys will need to be retrieved from the KMS to then decrypt the data and return the decrypted file.
Though it might still be partially encrypted.

\ _Example:_ Suppose Bob wants to read from a table with a role which is not `manager`, Bob can retrieve the Parquet file (which now has two encrypted columns).
Bob then ask the KMS for the key IDs of the columns `name_key` and `cpr_key`, but as Bob's current role is not linked to those keys Bob does not get them.
Thus, Bob can only read the `ages` column.
If, however, Bob had the `manager` role, then the KMS would return the keys, and Bob would be able to decrypt the columns, allowing Bob to see all the data.

Though there is now an issue.
How do we ensure that current data lake solutions do not need to make changes to support encryption and decryption, as most already handle authorization and AC in their own ways?

Our proposal includes an Object Store Wrapper Service (OSWS).
This will essentially mock S3 and ensure that current data lake solutions just have to change the connection string related to S3 to the OSWS one, meaning that it will use the S3 API, but not be an actual S3 object store internally.

To read from the object store, you are then provided with two options.

\ *Option 1:* Go through the provided OSWS.
\ *Option 2:* Connect directly to the KMS, which is served through the OSWS, and add a decryption step to your query engine.

The idea of the OSWS *Option 1* can be seen in @fig-wrapper and its steps.
The Query Engine will fetch an authentication token from the IdP, steps 1 to 3.
It will then make its request to the OSWS, step 4, where the OSWS can then validate the token against the IdP, step 5 and 6.
OSWS will then request the data from the object store, and on return, it can figure out which cryptographic keys are needed to decrypt the columns, steps 7 and 8.
It then requests the keys, together with the provided identity, from the KMS, which only returns the keys available for the specific user, and allows to decrypt the columns the user has access to, steps 9 to 12.
The OSWS is now able to decrypt the columns, provided the user's access, and can return the file where the  columns the user has access to have been decrypted, steps 13 and 14.
In short, given the user's authentication token, it can request the KMS for the keys needed to decrypt the entire file, and the KMS will only return the keys for which the specific user has authorization.
Thus, regardless of the data lake's own authorization implementation, the OSWS will ensure that all unauthorized data remains encrypted.

A potential issue with this approach is the overhead introduced by cryptographic operations on potentially large Parquet files.
This will have to be benchmarked thoroughly in an implementation.

Another issue is that it might only be a single column in the given Parquet file that the client is interested in, thus the OSWS will end up doing more work than necessary, and this is not something which can be addressed due to the limitations in the S3 API.

#figure(
placement: top,
scope: "parent",
(```pintora
sequenceDiagram
    title: No modification (read data)
    autonumber
    participant qe as "Query Engine"
    box "Object Store Wrapper Service"
      participant kms as "Key Management System"
      participant osw as "Object Store Wrapper"
    endbox
    participant idp as "Identity Provider"
    participant [<database> os] as "Object Store"

    qe ->> idp : request id
    activate idp
      alt Valid identifier
          idp -->> qe : return identity
      else Invalid identifier
          idp -->> qe : return error
    end
    qe ->> osw : request data (unique identifier)
    osw ->> idp : validate identity
    idp -->> osw : identity validity
    osw ->> os : request data
    os -->> osw : return data with encrypted columns
    osw ->> kms : request key
    kms ->> kms : find role given identity
    kms ->> kms : find keys based on role
    kms -->> osw : return keys
    osw ->> osw : decrypt columns
    osw -->> qe : return data
```),
kind: image,
caption: [Sequence Diagram showing how an unmodified data lake query engine gets data from the object store],
)<fig-wrapper>

We propose *Option 2* to address the overhead, which needs more logical steps in the query engine by the user, which can be seen by the steps on @fig:unwrapped.
The query engine will authenticate itself against the IdP and then query S3 directly, and it will return the possibly partially encrypted Parquet files, steps 1 to 5.
Given the metadata of the Parquet files' footers and which columns it needs to read, it can then request the OSWS extra endpoint for the KMS, step 6.
The endpoint then first validates the identity against the IdP and then requests the KMS for the specified keys, which, given the user has the correct roles for the given keys, will be returned to the OSWS, steps 7 to 12.
Lastly, the OSWS returns the keys to the user and enables them to decrypt the columns, steps 13 and 14.

\ Both options 1 and 2 then ensure RBAC regardless of which option you choose, and which query engine you might have.
Regardless of which data lake system you choose, or if you create your own implementation, you will be able to retrieve data from the object store.
The data will, if needed, be encrypted at rest, and the encryption will be part of ensuring RBAC in the system.

#figure(
placement: top,
scope: "parent",
(```pintora
sequenceDiagram
    title: Modification (read data)
    autonumber
    participant qe as "Query Engine"
    box "Object Store Wrapper Service"
      participant kms as "Key Management System"
      participant osw as "Object Store Wrapper"
    endbox
    participant idp as "Identity Provider"
    participant [<database> os] as "Object Store"
    qe ->> idp : request id
    activate idp
      alt Valid identifier
          idp -->> qe : return identity
      else Invalid identifier
          idp -->> qe : return error
    end
    qe ->> os : request data
    os -->> qe : return data with encrypted columns
    qe ->> osw : request keys (unique identifier)
    osw ->> idp : validate identity
    idp -->> osw : identity validity
    osw ->> kms : request keys (unique identifier)
    kms ->> kms : find role given id
    kms ->> kms : find keys based on role
    kms -->> osw : return keys
    osw -->> qe : return keys
    qe ->> qe : decrypt columns
```),
kind: image,
caption: [Sequence Diagram showing how a modified data lake query engine gets data from the object store],
)<fig:unwrapped>

=== Issues

There are a few issues with this approach.
These include the safety of the encryption, as well as how we manage `Create` and `Update` to the object store.
`Delete` is managed as usual; if you have the given permissions, you can make the call to delete through the OSWS, though the KMS will not be needed for this, but only the authorizations in S3 itself.

For the encryption part, we refer to the Parquet documentation #footnote[https://parquet.apache.org/docs/file-format/data-pages/encryption/#44-additional-authenticated-data], which specifies that the Parquet files support AES.
This might be a potential security vulnerability, since nothing stops a malicious actor with authorization to the object store, but not the columns, from downloading the whole object store and then trying to decrypt it.
Though this is slightly out of scope, and currently, AES#footnote[AES being the abbreviation for "Advanced Encryption Standard"] is considered safe and is one of the industry standards for encryption, and it is always possible to increase its key size.

The other issue regarding `Create` and `Update` is how to handle which cryptographic keys to use.
The easier one to handle is `Update`.
When _updating_ a table, the OSWS create new cryptographic keys that have the same roles as the previous cryptographic keys used to encrypt the columns.
It ensures that if some cryptographic keys are leaked, it is limited to only a specific version of a table, while also ensuring that the same roles can still access the data.

Calling `Create` through the OSWS will, by default, not encrypt the columns, though given that the admin wants to ensure all files are encrypted, a default role can be created and all columns without `GRANT`s can be encrypted with said role.
If the user uses the `GRANT` keyword for columns, the OSWS will encrypt the columns with newly generated cryptographic keys, seen on steps 4 to 7 in @fig:osws-insert.
The Parquet files will be added to S3, and the keys will then be added to the KMS and put under the role which was specified in the `GRANT`, thus ensuring that they can be read by others who have the given role, as seen on steps 8 and 9.

#figure(
placement: top,
scope: "parent",
(```pintora
sequenceDiagram
    title: Insert data
    autonumber
    participant qe as "Query Engine"
    participant idp as "Identity Provider"
    box "Object Store Wrapper Service"
      participant kms as "Key Management System"
      participant osw as "Object Store Wrapper"
    endbox
    participant [<database> os] as "Object Store"
    qe ->> idp : request id
    activate idp
      alt Valid identifier
          idp -->> qe : return identity
      else Invalid identifier
          idp -->> qe : return error
    end
    qe ->> osw : insert data (unique identifier + GRANTs)
    osw ->> osw : generate keys (foreach encrypted col)
    osw ->> osw : encrypt all cols with given keys
    osw ->> osw : encrypt footer with given keys
    osw ->> os : insert data
    osw ->> kms : upload keys (with role ids)
    osw -->> qe : success
```),
kind: image,
caption: [Sequence Diagram showing how an unmodified data lake query engine inserts data into the object store],
)<fig:osws-insert>

By only allowing `Create`, `Update`, and `Delete` through the OSWS, we can ensure that the object store is used only as an immutable storage.
When updating a Parquet file, deleting it or similar, the OSWS will make new versions.
It will ensure that authorized malicious actor can break or delete data, and it will always be possible to roll back.

As we use RBAC, the KMS needs to map several IDs, which map to roles, roles can map to other roles, which then map to a large number of tuples of cryptographic key IDs and the cryptographic keys themselves.
#ref(<fig:kms-relations>) displays are a more precise version of the internal relations, and they are not hierarchical. 
It is also important to note that the KMS will serve as the authorization manager.

#figure(
placement: top,
(```pintora
erDiagram
  title: KMS internal relations
  IDENTITY {
    ⠀ identity_token
    ⠀ roles
  }
  ROLE {
    ⠀ name
    ⠀ permissions
  }
  KEY {
    ⠀ key_id
    ⠀ cryptographic_key
  }
  IDENTITY }o--o{ ROLE : "many to many"
  ROLE }o--o{ KEY : "many to many"
  ROLE }o--o{ ROLE : "many to many"
```),
kind: image,
caption: [How the relations internally are mapped in the KMS]
)<fig:kms-relations>

=== Functional Requirements

+ Authentication and ID verification
  \ The OSWS validates the user, and it supports common standards, e.g. OpenID Connect (OIDC).
+ KMS
  \ The KMS must serve as authorization manager and map a user's identity to their roles, which map to the available keys.
+ Enforcement of Access Control
  \ Access control is ensured by that the KMS only returns the cryptographic keys to the columns that the user is allowed to read.
+ Data Decryption
  \ Option 1: If using an unmodified query engine, the OSWS must handle the decryption of the requested file before returning the file to the unmodified query engine.
+ Lazy Data Decryption
  \ Option 2: The system must support that the query engine fetches directly from the object store, to later fetch the cryptographic keys through the OSWS to decrypt the available columns.
+ Encrypted metadata
  \ The system must, on encryption of columns, encrypt the related statistical metadata, as it might contain sensitive information.
+ Key Generation
  \ For updates, OSWS must create new cryptographic keys for the columns and link the keys in the KMS to the same previous roles.
+ Conditional Encryption on `Create`
  \ The OSWS should only encrypt columns, and their respective statistical metadata, given the user has specified a role in the `GRANT`for the column.
+ Write authorization and cryptographic key storage
  \ If a `GRANT` is specified during the `Create` operation, the OSWS must encrypt the columns with a generated cryptographic key.
  It then has to be stored in the KMS under the role specified in the `GRANT`
+ Parquet Metadata
  \ Given a column is encrypted, its column-specific metadata in the Parquet footer must contain the cryptographic key ID, so it is known which cryptographic key is needed to decrypt the column.
+ Object Store Mocking
  \ The OSWS has to mock S3, so existing data lake solutions only have to change their connection string to the OSWS one.
+ Immutability
  \ The OSWS has to ensure the object store is used as it is immutable.
  Thus allowing for roll-backs in case of wrong modifications to the stored data.

=== Non-functional Requirements

+ FGAC
  \ OSWS has to enable FGAC on a column-level granularity level, by using RBAC and leveraging the Parquet encryption.
+ Security (encryption-at-rest)
  \ OSWS has to enable encryption-at-rest for the data stored in the object store, regardless of which data lake solution is used.
+ Security (key policy management)
  \ The KMS in the OSWS has to enforce key policies.
+ Compatibility
  \ The OSWS should allow for the solution to be catalogue agnostic, meaning that only the object store layer needs to be changed, thus allowing current Lakekeeper and Databricks to use the solution.
+ Performance
  \ The solution should prioritize performance by making others choose to modify their query engine to use _Option 2_, specified in @sec:osws-decrypt, to allow for lazy decryption of the columns, thus reducing the overhead for the user.
+ Security (Vulnerability)
  \ The encryption scheme should use a strong symmetric encryption, like AES, supported by Parquet.
  // Future analysis should ensure that the encryption stays post-quantum, and if not, find an alternative.
+ Scalability
  \ The KMS has to be able to handle the potentially large complexity of many interlinked users, roles, and tuples of cryptographic key IDs and their cryptographic keys.

=== OSWS conclusion

It is important to reiterate that OSWS does not solve all the issues that exist with data lake systems.
Its main advantage is to enforce column-level AC, even when query engines which do not implement RBAC themselves connect to it, while still allowing existing data lakes to use the system.

The proposed OSWS does not address AC on row-/cell-level.
This was a result of wanting to use a pre-existing file format, to ensure as easy an adoption as possible.
In the future, this could be explored to see if the Parquet file format could be extended or if another proposed file format could support finer granularity.
