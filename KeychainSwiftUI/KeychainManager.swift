//
//  KeychainManager.swift
//  KeychainSwiftUI
//
//  Created by Vasichko Anna on 04.05.2023.
//

import Foundation

enum KeychainError: Error {
    case duplicateItem
    case unknown(status: OSStatus)
}

class KeychainManager {
    static func save(password: Data, andAccount account: String) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account as AnyObject,
            kSecValueData: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return "Saved"
    }
    
    static func getPassword(for account: String) throws -> Data? {
        let query: [CFString : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account as AnyObject,
            kSecReturnData: kCFBooleanTrue
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return result as? Data
    }
}
