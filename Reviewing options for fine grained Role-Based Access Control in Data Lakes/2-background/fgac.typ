== Fine-grained Access Control
<sec:fgac>

Access control (AC) is the ability to restrict access to data, while fine-grained access control (FGAC) is the ability to restrict access to some degree finer than a whole table.
This can vary in granularity, but IBM mentions it as a definition that covers row and column level access control.#cite(<ibm-rcac-exp>)
Hence, if a client tries to access or modify some data, then based on some policy, they either have access to the given data or do not.
This is useful for when you want to have a client only be able to perform some sub-scoped CRUD actions on tables, whilst another client has different CRUD permissions.

In this paper, the FGAC will mostly be used to reference granularity on the column level, as this is the most commonly supported granularity, and is also supported by Parquet with encryption, discussed in #ref(<sec:parquet>).
If row granularity is also ensured by some system, then it will be explicitly written, and not referred to as only FGAC.
