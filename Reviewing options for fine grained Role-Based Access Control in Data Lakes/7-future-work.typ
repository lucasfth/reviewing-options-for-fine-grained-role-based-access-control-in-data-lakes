= Future Work

For future work, we propose to create an MVP for the OSWS system, described in @sec:fgrbac-by-encryption, as well as describe in detail the standard used to handle the RBAC-aware column-level granularity decryption.

Afterwards we would integrate the following two systems: *System 1*, being an unmodified query engine, thus it has to use _Option 1_ and fetch its requested data through the OSWS, and *System 2* being a system using _Option 2_ and thus handles decryption locally and communicates only with the KMS in the OSWS and directly with the object store.
_System 1_ should add the OSWS as the intermediate between a previously set-up data lake, between the query engine layer and the object store layer.
_System 2_ should, instead of adding the OSWS as the intermediate, extend its query engine with the extra decryption step.

It is important that both _System 1_ and _System 2_ are based on the same data lake, as this will allow for direct benchmarking between the unmodified data lake and the modified one, and see what trade-offs each system offers.

While this is being developed, the documentation will be important.
This allows for future development by third parties and ensures that the standard can be adopted.
The more that implement the system, the more likely it will be that existing and future data lakes will directly implement the use of _Option 2_, thus ensuring the OSWS has to handle as little work as possible.
