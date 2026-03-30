#import "@preview/cetz:0.4.2"

== Parquet
#label("sec:parquet")
Parquet @parquet-file-format is a columnar file format supported by many data processing systems.

A Parquet file is structured using row groups, which contain columns, along with a footer which contains metadata.
The columns are structured as column chunks, which contain several _data pages_.
A data page contains a header, which describes information like the size of the page, and following that, the actual values as bytes. 
The file footer contains metadata that specifies what is stored in the file and where, that is, where a reader should look to find a specific column, or the statistics of a column (e.g. min/max).
@fig:encrypted-parquet shows a visual representation of a Parquet file that also uses encryption, which will be described later.
The left side of the figure shows row groups, columns and data pages, along with their headers.
The right side shows the footer of the file, with the file metadata containing metadata on each row group, which in turn contains metadata on the column chunks in that row group.
The arrows link information about where to read, such as offsets, to where they point the reader.
The objects that hold metadata, like statistics, and structural information, including physical offsets, such as the footer and page headers, are serialized using Apache Thrift @apache-thrift, a language-agnostic serialization framework, and referred to as "Thrift Structs".
Essentially, the object that contains the information, for example, a `PageHeader` object (on the left side of @fig:encrypted-parquet) or a `ColumnMetaData` object (on the right side of @fig:encrypted-parquet), is serialized into bytes using Thrift, which can then later be restored to the same object.#cite(<parquet-modular-encryption-docs>)
Then, to read a Parquet file, the reader de-serializes the Thrift structures to get the necessary metadata, and then reads the actual data values using the information from the metadata. 

=== Encryption in Parquet
#label("sec:parquet-encryption")

Parquet Modular Encryption was introduced to allow granular control of how the Parquet file data and metadata should be encrypted.
It allows the user to either encrypt whole files using a single key, encrypt singular columns using one or more keys, and choose whether or not the file footer should also be encrypted.
If the file footer could reveal sensitive information, e.g. min or max values, encrypting it is likely a good idea.
\ Internally, using encryption means that the serialized Thrift structs are encrypted using the specified key, and the data pages themselves are also encrypted.
If footer encryption is enabled, a new struct is added to the file:
`FileCryptoMetaData`, which specifies the encryption key ID of the footer (for retrieval by a KMS) and the algorithm used. This struct can be seen in @fig:encrypted-parquet, at the top of the right side, i.e. the footer.
The key specified by this struct can be used to decrypt the footer, which in turn stores information about which columns are encrypted using what keys, using the `ColumnCryptoMetaData` struct stored for each row group.
The information in this struct can be used to decrypt the column metadata and the column data itself.
@fig:encrypted-parquet also shows what parts of the file is encrypted with that key; the red key shows what is encrypted using the column key, and the black key what is encrypted using the footer key.
#figure(
  placement: top,
  scope: "parent",
  caption: [
    Illustration of the Parquet file structure using an Encrypted Footer. From @parquet-modular-encryption-docs.
  ],
  image("PME.png", width: 100%)
)<fig:encrypted-parquet>
