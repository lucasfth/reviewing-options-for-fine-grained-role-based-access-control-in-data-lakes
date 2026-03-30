= Conclusion

We set out to find a way to unify access control in data lakes, as it is currently enforced in different ways depending on the solution chosen and how it handles its granularity.
Thus, the main motivation behind the project was to ensure that the concept of data lakes could be used by a wider array of systems and ensure fine-grained access control, regardless of the implementation on the user's system.

// What did we provide? Summary of solutions, theory of encryption, comparison
We reviewed existing and proposed solutions as well as the theory used within the space of data lakes.
The systems were compared to ensure a varied understanding of the trade-offs.
Both papers discussed in @sec:related-work also showed how encryption-at-rest might be used to ensure fine-grained access control, meaning that the idea of fine-grained access control by encryption is not a completely new and novel idea.

// What do we propose? Fgac by encryption
We propose a new standard and system, which is role-based access control aware and has fine-grained access control to a column-level granularity. It should have interoperability with existing systems, but can be more efficient with a bit of custom implementation.
We call this "Fine-grained role-based access control by encryption"

Further work will include implementing this system in a well-documented and open-sourced manner to ensure that it can easily be adopted.
Furthermore, the system should be benchmarked both in terms of speed and security to determine its usability.
The possibility of row-level and cell-level access control should also be explored further, as it would result in even more use cases for data lake systems.
