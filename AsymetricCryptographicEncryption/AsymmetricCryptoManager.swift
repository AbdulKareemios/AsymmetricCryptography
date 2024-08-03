//
//  AsymmetricCryptoManager.swift
//  AsymetricCryptographicEncryption
//
//  Created by AK on 8/4/24.
//

import Foundation
import Security


enum CryptoError: Error {
    case keyGenerationFailed(OSStatus)
    case keyAlreadyExists
    case keyNotFound
    case encryptionFailed(Error)
    case decryptionFailed(Error)
    case keySaveFailed(OSStatus)
    case keyRetrievalFailed(OSStatus)
}

class AsymmetricCryptoManager {
    static let shared = AsymmetricCryptoManager()
    
    private let publicTag = "com.abdulkareem.keys.public"
    private let privateTag = "com.abdulkareem.keys.private"
    
    private init() {
        generateKeyPair { result in
            
        }
    }
    
    func generateKeyPair(completion: @escaping (Result<Void, CryptoError>) -> Void) {
        // Check if keys already exist
        if getPublicKey() != nil || getPrivateKey() != nil {
            completion(.failure(.keyAlreadyExists))
            return
        }
        
        // Public key attributes
        let publicKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag: publicTag as NSObject
        ]
        
        // Private key attributes
        let privateKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag: privateTag as NSObject
        ]
        
        // Key pair attributes
        var keyPairAttr: [NSObject: NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048 as NSObject,
            kSecPublicKeyAttrs: publicKeyAttr as NSObject,
            kSecPrivateKeyAttrs: privateKeyAttr as NSObject
        ]
        
        // Generate key pair
        var publicKey: SecKey?
        var privateKey: SecKey?
        let status = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)
        
        guard status == errSecSuccess else {
            completion(.failure(.keyGenerationFailed(status)))
            return
        }
        
        completion(.success(()))
    }
    
    func encrypt(data: Data, completion: @escaping (Result<Data, CryptoError>) -> Void) {
        guard let publicKey = getPublicKey() else {
            completion(.failure(.keyNotFound))
            return
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionPKCS1, data as CFData, &error) as Data? else {
            completion(.failure(.encryptionFailed(error!.takeRetainedValue() as Error)))
            return
        }
        
        completion(.success(encryptedData))
    }
    
    func decrypt(data: Data, completion: @escaping (Result<Data, CryptoError>) -> Void) {
        guard let privateKey = getPrivateKey() else {
            completion(.failure(.keyNotFound))
            return
        }
        
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionPKCS1, data as CFData, &error) as Data? else {
            completion(.failure(.decryptionFailed(error!.takeRetainedValue() as Error)))
            return
        }
        
        completion(.success(decryptedData))
    }
    
    private func getPublicKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: publicTag,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        return (item as! SecKey)
    }
    
    private func getPrivateKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: privateTag,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        return (item as! SecKey)
    }
}
