== Encryption-at-Rest
<sec:encryption-at-rest>

Encryption-at-rest is another fundamental part of data security in databases.
While access control methods like RBAC govern access to the data, encryption-at-rest protects the data itself by encrypting the data as it is stored on storage devices.
This ensures that even if leaks occur, due to, for example, mis-configured permissions in RBAC, attackers would also need to decrypt the data to access any information.
Encryption is typically performed using a strong symmetric key encryption algorithm like AES-256.
@azure-encryption