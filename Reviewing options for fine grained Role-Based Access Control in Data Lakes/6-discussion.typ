= Discussion

This leads to what are the general advantages, disadvantages, and points which have to be explored further for the FGRBAC by Encryption @sec:fgrbac-by-encryption to work properly.
The following subsections will address some of these points.

// ATRO: generally, the following reads as written before that section existed. Which is because thats exactly when it was written.
== No lakehouse needed
Many of the discussed data lake solutions use a "lakehouse" structure to govern access to the data itself.
The catalogue acts as the security layer, controlling whether the query engines are allowed to do what they do, and giving out access tokens depending on this. This is the "Vended credentials from the catalogue" category as described in @sec:comparison.
This is the case for Lakekeeper (@sec:lakekeeper) as well as for Databricks with Unity Catalog (@sec:databricks).
This has the downside of _requiring_ query engines to go through the catalogue to get the data they want, which doesn't allow for "schema-on-read" query operations on the raw data.
This is by design -- since the object stores might contain different tables with many columns, and the catalogues can only give access to what files the query engine can read, the catalogue has no way to control what columns the query engine can read. 
Databricks solves this by having the query engine filter out what the reader is not allowed to access, using row filters and column masks @databricks_abac.
However, this is only possible because Databricks is in control of the query engine.
For a reader who wants to query the data lake "directly" with their own query engine, this would not be possible.
With the proposed solution of (@sec:fgrbac-by-encryption), controlling access on the column level would be possible even for "schema-on-read" operations, since the access is governed at the object store, and not the catalogue.
This means a data lake using the proposal does not need a specific, secure catalogue to ensure access control.

== Two birds, one stone
Like with the solution proposed by Shang et.al. @uberpaper, the solution inherently solves both access control and encryption-at-rest, meaning that there is no need for authorization systems like OpenFGA as Lakekeeper (@sec:lakekeeper) uses on top of the encryption. 

\ Next, we discuss some potential shortcomings and downsides of the solution.

== Performance
Since the solution needs to perform cryptographic operations in the OSWS, performance might become an issue.
This can partly be helped by the query engines themselves fetching the decryption keys together with accessing the object store directly -- thus allowing for lazily decrypting the data.
The proposed solution would need to be benchmarked heavily to decide if the overhead of cryptographic operations is significant.

== Security

The status quo for data lakes is typically either to deny access to the entire file due to authorization on the finer-grained data or physically remove the columns or rows that a user is not permitted to see.

Our proposed system would change this, and given that you have access to some of the files, you would see the file.
The difference is that some decryption might be needed to get usable data from the columns.
It might be discussed if this is a safe solution, as the user might get files with encrypted columns (which they are not authorized to read) and then try to hack their way around it.

Furthermore, the OSWS would be the single point of trust, which has to be analyzed to see if this solution is safe.

The proposal further relies on the integrity of the OSWS and the KMS.
Compromising one component would allow unauthorized decryption of protected columns.
This will have to be analyzed in depth to ensure no attack vectors, but should be addressed in future work.

== Shortcomings

The proposed solution only has column-level granularity support.
If cell-level granularity is wanted, two main options are available.
Either the Membrane proposal @sec:membrane could be implemented, though it would need a lot of custom implementation, and would make it difficult for low-level query engines to create a decryption step, due to the extent of the theory behind the proposal.
The other option is that the Parquet file specification gets extended to support cell-level encryption.
This would be simpler for low-level query engines, as it might work the same way the current OSWS proposal works, by saving the cryptographic key IDs in the Parquet files' metadata.
