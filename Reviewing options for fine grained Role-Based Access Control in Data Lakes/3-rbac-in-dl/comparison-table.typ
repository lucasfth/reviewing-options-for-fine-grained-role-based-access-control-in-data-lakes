== Direct Comparisons of data lake technologies
<sec:comparison>

The different technologies have various advantages and disadvantages.
@tab:comp-table shows the overall differences as well as the finest granularity supported by FGAC, supported by the format.

As Parquet is a file format, it cannot enforce AC to any extent, but it does support encryption, which, if coupled with other systems, can enforce AC.

#figure(
  placement: top,
  scope: "parent",
  table(
    columns: (auto, auto, auto, auto, auto),
    align: left,
    table.header(
      [*Format*],
      [*Type*],
      [*Encryption-at-Rest*],
      [*IdP Support*],
      [*Finest granularity FGAC*]
    ),
    [*Parquet*],
      [File format],
      [Yes],
      [Not applicable],
      [Row level],
    [*Lakekeeper*],
      [Catalogue],
      [Yes (only through Parquet)],
      [External],
      [Table/view],
    [*Apache Polaris*],
      [Catalogue],
      [No],
      [Internal and external (if OIDC)],
      [View],
    [*Databricks*],
      [Data lake],
      [Yes],
      [Internal and external sync],
      [Column/row],
    [*Snowflake Cloud*],
      [Data lake],
      [Yes],
      [Internal],
      [Column/row],
    [*DuckLake*],
      [Data lake and catalogue format],
      [Yes],
      [External],
      [Table]
  ),
  caption: [Comparison of data lakes and related technologies and their finest granularity FGAC support],
)<tab:comp-table>

It is important to note that the encryption-at-rest for the solutions is only supported if the whole system is used; thus, if another data lake system accesses the object store, they will not be able to read decrypted data.
This is a big issue, as whoever wants to access the data is forced to use the data lake system.

From @sec:comparison, we can see that in terms of access control, the solutions generally fall into two categories:

=== Vended credentials from the catalogue
Access control is enforced through the catalogue's vending of scoped credentials pertaining to the permissions of the query engine.

=== Fully managed cloud platform
Access control is managed by the query engine and the catalogue since they are both under the fully managed platform.
This means the query engine is trusted to filter out rows that are not permitted and mask columns that are protected.
This is obviously not possible on external query engines since they cannot be trusted to perform the necessary filters and masks.

Solutions like Lakekeeper and Polaris create vended credentials to S3, but since the Object Store can store Parquet files, which contain many columns, and S3 does not know anything about the contents of the files, Lakekeeper will not be able to govern access to these columns.
On the other hand, all-in-one solutions like Databricks or Snowflake only support the use of their own query engine and proprietary file formats when using their full cloud platform, or when using external tables, or provide a solution that is reminiscent of the "vended credentials" solution, like Lakekeeper or Polaris.

This leaves a gap in the case where column-level access control is wanted, on files in a data lake, but open file formats like Iceberg or Parquet are used.
The solution for enabling this has to somehow enforce AC post-retrieval of the files, so that regardless of the query engine trust level, it is forced to comply with the granularity.
This would allow for anyone trusted to access the file to be able to access the file, even though some columns might not be entrusted to the user.
