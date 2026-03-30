== "One Stone, Three Birds: Finer-Grained Encryption with Apache Parquet @ Large Scale"

Shang et.al. 2022 @uberpaper proposed a system for Uber Technologies, which is very similar to the "FGRBAC by Encryption"#footnote[@sec:fgrbac-by-encryption] solution.
In the paper, they also find that the modern "data lakehouse"#footnote[@sec:datalake defines lakehouse] has an issue in terms of the underlying data not necessarily being secured, and also describe access being governed at the engine or catalogue level as problematic.

Similarly, they describe using Parquet#footnote[@sec:parquet defines Parquet] file encryption to achieve column-level access control by creating column-specific encryption keys and storing these in a Key Management Service#footnote[@sec:kms also defines Key Management Service].
In their system, the writers tag the datasets at the column level if encryption is needed, and when writing the Parquet data, they encrypt the tagged columns using the specified keys.
The encrypted data is then written to the data lake#footnote[@sec:datalake defines data lakes], and on read, the readers decrypt the data if they have access to the necessary keys.
This solves encryption-at-rest and access control just like our proposed solution.
However, a key difference is that their system relies on an extension of the Parquet library to handle encryption and decryption, as the cryptographic operations are performed by the readers and writers.
They propose adding a plugin to handle this, but the responsibility would still be at the query engine level, even for readers.
This is in contrast to the proposed solution, where readers will be able to fetch the data through the Object Store Wrapper Service#footnote[@sec:osws-decrypt defines Object Store Wrapper Service (OSWS)] that automatically decrypts data if the necessary keys are accessible.

