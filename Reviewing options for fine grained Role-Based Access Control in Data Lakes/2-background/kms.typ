== Key Management System
<sec:kms>

A key management system (KMS) is a system that securely stores cryptographic keys and the metadata associated with them.
Along with storing the cryptographic keys, it sometimes also handles, for example, distribution and recovery of the keys.#cite(<nist-kms-def>)
The KMS is often provided as a service, e.g., AWS KMS, where KMS here stands for Key Management Service.#cite(<aws-kms-exp>)

The reason for having a KMS is most often to store symmetric cryptographic keys, but it can also be for asymmetric ones, so data is safe from attacks even if leaked from the store, and also so the keys can be distributed to authorized users.
So its major purpose is to enforce key policies.@ibm-what-is-kms

We will use KMS to refer to "key management system", thus relying on the more lenient definition, and will specify if referring to the KMS service.
