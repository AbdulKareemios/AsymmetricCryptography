# AsymmetricCryptography

The AsymmetricCryptoManager class handles the key generation, encryption, and decryption.
The keys are stored in the Keychain with specified tags.
The generateKeyPair() function generates a public-private key pair and stores them in the Keychain.
The encrypt(data:) function encrypts data using the public key.
The decrypt(data:) function decrypts data using the private key.
The ViewController demonstrates how to use this class to encrypt and decrypt a message.

## Key Features:
Error Handling:
Comprehensive error handling with custom error enums for different failure scenarios.
## Key Existence Check:
Checks if keys already exist in the Keychain before generating new ones to avoid duplication.
## Result Type:
Uses the Result type to provide a more robust way of handling success and error cases in asynchronous operations.
## Keychain Operations:
Saves and retrieves keys from the Keychain, ensuring secure storage.


Asymmetric cryptography, also known as public-key cryptography, is called "asymmetric" because it uses two different keys for encryption and decryption: a public key and a private key. Here's why it is called asymmetric:

Different Keys for Encryption and Decryption:
Public Key: This key is used for encryption and is shared publicly. Anyone can use the public key to encrypt a message.
Private Key: This key is used for decryption and is kept secret. Only the owner of the private key can decrypt the messages encrypted with the corresponding public key.
Key Pair Relationship:
The public and private keys are mathematically related, but it is computationally infeasible to derive the private key from the public key. This ensures that even though the public key is widely distributed, the private key remains secure.
Security and Confidentiality:
Asymmetric cryptography provides a way to securely exchange information even when the public key is known to everyone. The security relies on the difficulty of certain mathematical problems (like factoring large prime numbers or computing discrete logarithms), which makes it practically impossible to derive the private key from the public key.
Digital Signatures:
Asymmetric cryptography also enables the creation of digital signatures. The private key can be used to sign a message, and anyone with the corresponding public key can verify the authenticity of the signature, ensuring the message's integrity and origin.
In contrast, symmetric cryptography uses the same key for both encryption and decryption, which requires the key to be shared and kept secret among the communicating parties. This sharing can pose a challenge in terms of key distribution and management, especially in large networks.
