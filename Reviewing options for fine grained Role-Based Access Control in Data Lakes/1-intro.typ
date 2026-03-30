= Introduction

// Situation (Context) - Describe the problem and motivate its importance
Today, only a few data lake solutions implement Role-Based Access Control (RBAC) down to individual files, singular columns, and specific entries.
When implemented, access control is often delegated to external services or is part of a proprietary solution.
Databricks#footnote[@sec:databricks defines Databricks] enforces row and column level permissions on a version of Parquet, but is partly a proprietary solution, and Snowflake#footnote[@sec:snowflake defines Snowflake] has its own proprietary solutions as well.~#ref(<governance-aws>)#ref(<microsoft-ac-2024>)
This means that most engines, which do not themselves handle granularity, will have access to whole files at a time, instead of, e.g. a single column of the given file. // TODO Replacement
// Recent efforts have been made to unify and standardize fine-grained RBAC, but no open-source mature solutions exist yet.
Recent efforts like the Lakekeeper#footnote[@sec:lakekeeper defines Lakekeeper] project or Apache Polaris#footnote[@sec:polaris defines Apache Polaris] attempt to address this gap by creating open-source solutions for secure access, but these come with limitations in their ability for fine-grained access control (FGAC), and are still in ongoing development.

// Complication (Gap) - Explain why the problem hasn’t been fully solved yet
This creates an issue for data lakes requiring access control, for example, if they contain financial, personal or GDPR-protected data, as owners of the data must either choose to commit to a single well-defined data lake system, thus ensuring FGAC, or if they also want third-party query engines to access the data, the granularity will now only be on the file level.
Solving this, data lakes could be a tool for more varied applications, as multiple different solutions can share data while still keeping their sensitive information secret.

// Proposal (Innovation) - Propose a new solution that solves (part of) the problem
By reading about current, proposed, and researched solutions, their individual advantages and disadvantages can be identified.
We will review available information on proprietary approaches, but focus on open-source and open-standard proposals to see how authorization might be ensured for everyone with object store access -- such as with encryption.
This will be used for a literature survey on fine-grained RBAC in data lakes, examining at least two open-source systems, including Lakekeeper~#ref(<lakekeeper-docs-concept>) and Apache Iceberg~#ref(<apache-docs>), and comparing their respective feature sets to proprietary solutions.
Afterwards, we will propose a solution which can unify RBAC in data lake solutions, and based on the findings, we will examine the viability of this solution.
This will be ground groundwork for a later minimal viable product (MVP) for a thesis project.

// Contribution
This paper is meant to lay the groundwork and create guidelines as to how to create a data lake system, which allows various query engines to access the data, whilst ensuring that access control is enforced, so trust in how the query engine handles the granularity of said access control is not needed.
