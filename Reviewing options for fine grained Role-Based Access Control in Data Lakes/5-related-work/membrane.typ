== Membrane: A Cryptographic Access Control System for Data Lakes
<sec:membrane>

Membrane is a proposal for a data lake system where access control is enforced by encryption, written by Kumer et.al. 2025 @kumaretal2025membraneAC.
The idea is to encrypt all data before storing it in the object stores, thus achieving encryption-at-rest.
It further takes advantage of that the compute resources are both physically and logically distinct.
Thus, if the attacker gains access to the object store, they will not have access to the virtual machine itself, meaning that the symmetrically encrypted data is kept safe.

They propose encrypting all cells individually, thus achieving a much finer-grained access control, compared to Parquet's own supported column-level granularity.
This is achieved by that if a data owner wants to insert data into S3, then they first generate a cryptographic key for each table.
The table key, together with row and column ID, infers a cell cryptographic key.
Then each cell can be encrypted, and the whole table can be inserted into S3.
To then allow read access to others, a cryptographic view is created, allowing for decrypting only the data intended by the data owner.
But this results in a query where each cell needs to be decrypted individually, to get usable data from them.@kumaretal2025membraneAC
