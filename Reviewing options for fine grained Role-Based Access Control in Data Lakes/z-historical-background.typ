= Historical Background
#label("sec:historical-background")

Access control (AC) for data management systems (DMS) originated from access matrix models, originally meant to protect operating systems (OS), and relies on discretionary-access-control (DAC).
DAC means that access is controlled through a mapping between subjects and objects.
The matrix model is a matrix which contains current authorizations represented as a triple, S.O.M.
\ _S_ representing a set of _authorization subjects_, _O_ for the set of objects to be protected, and _M_ is the access matrix.
So the matrix has a row for each user, columns for objects, and then a cell is the permission for a specific user for a given object, visual representation in #ref(<fig:access-matrix>).

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    table.header(
      [],
      [*marc.doc*],
      [*edit.exe*],
      [*games.dir*],
    ),
    [*Marc*],
      [read,write],
      [execute],
      [execute],
    [*Ann*],
      [-],
      [Execute],
      [Execute,read,write]
  ),
  caption: [Example of how an access matrix could look, from Ferrari #cite(<ferrari2010accesscontrol>)],
)<fig:access-matrix>

The matrix solution would not be a viable solution, mainly due to the size needed for complex systems, as well as the many cells that would remain empty.

A big milestone was when _System R_ chose to use its version of DAC for relational data management.
Meaning that authorization is now ownership-based, and when a user creates a relation, they will receive all defined privileges, and can grant other authorization as well.
In short, System R implemented an ownership-based administration.

The commands for changing the relational DAC by System R, `GRANT` and `REVOKE`, were then used to create the commands for AC in SQL.
The main difference for SQL is that its AC foundation is in DAC and RBAC (see #ref(<sec:rbac>) was later added.

With Oracle Virtual Private Database (VPD), FGAC (see #ref(<sec:fgac>)) was included, though they specifically chose fine-grained attribute-based access control, and they based their AC on context-dependent access control.
This ensured that whatever users had access to of data was enforced from the server-side.
Thus, less trust in the user is needed, as they do not have direct access to the data, meaning that we do not have to trust that they filter the data themselves.#cite(<ferrari2010accesscontrol>)

\ In Datalakes, RBAC can be a big issue as the systems can be big and unmanageable.
An example of this was the 2019 Capital One breach, where personal information from S3 was leaked for around 100 million individuals.
Capital One used encryption-at-rest, but due to an over-provisioned Identity and Access Management (IAM) role, the attacker was able to retrieve the cryptographic keys and decrypt the data.#cite(<khanetal2022capitalone>)
Here, the over-provisioning could be a direct result of the size of the system, but it is also a violation of the principle of least privilege. 
Thus, for data lakes containing different data types and varying levels of sensitivity for their data, it is very important to follow security standards and also ensure that if a leak happens, it only exposes the smallest possible portion of data.