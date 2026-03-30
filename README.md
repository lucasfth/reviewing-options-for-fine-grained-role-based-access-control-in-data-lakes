# Reviewing options for fine-grained Role-Based Access Control in Data Lakes

Research project made by @duckth and @lucasfth for the Computer Science master's program at the IT University of Copenhagen.

## Abstract

Data lakes today have limitations in only allowing fine-grained access control on fully-managed cloud platforms like Snowflake or Databricks, where open data lakes with potentially many different query engines have to rely on limited catalogue-based access control.

Theory and proposed solutions will be examined to see which options might be able to bridge this gap of ensuring fine-grained access control, and if encryption and role-based access control might be part of solving it.

We propose a system for enforcing fine-grained role-based access control at the object store level as well as creating a wrapper around the object store to allow query engines to access the data without modifications.

Our findings show that the encryption to enforce access control might be a viable solution, as both modified and unmodified query engines are enforced to follow the column-level granularity using the role-based access control if they want to read the data, but will also have to be proven functional by a future MVP.

## BibTex

```bibtex
@misc{2025-trøstrup-hanson-reviewing-options-for-fine-grained-role-based-access-control-in-data-lakes,
  title={Reviewing options for fine-grained Role-Based Access Control in Data Lakes},
  author={Andreas Severin Hauch Trøstrup, Lucas Frey Torres Hanson},
  url={https://github.com/lucasfth/reviewing-options-for-fine-grained-role-based-access-control-in-data-lakes},
  abstractNote={Data lakes today have limitations in only allowing fine-grained access control on fully-managed cloud platforms like Snowflake or Databricks, where open data lakes with potentially many different query engines have to rely on limited catalogue-based access control.
  Theory and proposed solutions will be examined to see which options might be able to bridge this gap of ensuring fine-grained access control, and if encryption and role-based access control might be part of solving it.
  We propose a system for enforcing fine-grained role-based access control at the object store level as well as creating a wrapper around the object store to allow query engines to access the data without modifications.
  Our findings show that the encryption to enforce access control might be a viable solution, as both modified and unmodified query engines are enforced to follow the column-level granularity using the role-based access control if they want to read the data, but will also have to be proven functional by a future MVP.},
  journal={GitHub},
  language={en}
}
```
