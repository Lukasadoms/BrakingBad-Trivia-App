//
//  UserDefaultsManager.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import Foundation

struct UserDefaultsManager {
    
    private enum UserDefaultsManagerKey {
        static let accounts = "Accounts"
        static let quotes = "Quotes"
    }
    
    private static var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    private static var keyChain: KeychainSwift {
        KeychainSwift()
    }
    
    static func saveAccount(_ account: inout Account) {
        var savedAccounts = [Account]()
        
        if let accounts = accounts {
            savedAccounts = accounts
        }
        savePassword(account.password, username: account.username)
        account.password = ""
        savedAccounts.append(account)
        accounts = savedAccounts
    }
    
    static func updateLoginStatus(_ updatingAccount: inout Account) {
        var oldAccounts = [Account]()
        var newAccounts = [Account]()
        
        if let accounts = accounts {
            oldAccounts = accounts
        }
        
        for var account in oldAccounts {
            if account.username == updatingAccount.username {
                account.isloggedIn = !account.isloggedIn
            }
            newAccounts.append(account)
        }
        accounts = newAccounts
    }
    
    static func saveLikedQuote(quote: Quote) {
        var savedQuotes = [Quote]()
        
        if let quotes = likedQuotes {
            savedQuotes = quotes
        }
        
        savedQuotes.append(quote)
        likedQuotes = savedQuotes
    }
    
    static func deleteLikedQuote(quote: Quote) {
        var savedQuotes = [Quote]()
        
        if let quotes = likedQuotes {
            savedQuotes = quotes
        }
        savedQuotes.removeAll { $0.quote.quoteText == quote.quote.quoteText }
        savedQuotes.append(quote)
        likedQuotes = savedQuotes
    }
 }

// MARK: - Helpers
extension UserDefaultsManager {
    
    static var accounts: [Account]? {
        get {
            guard let encodedAccounts = userDefaults.object(forKey: UserDefaultsManagerKey.accounts) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode([Account].self, from: encodedAccounts)
        } set {
            let encodedAccounts = try? JSONEncoder().encode(newValue)
            userDefaults.set(encodedAccounts, forKey: UserDefaultsManagerKey.accounts)
        }
    }
    
    static var likedQuotes: [Quote]? {
        get {
            guard let encodedQuotes = userDefaults.object(forKey: UserDefaultsManagerKey.quotes) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode([Quote].self, from: encodedQuotes)
        } set {
            let encodedQuotes = try? JSONEncoder().encode(newValue)
            userDefaults.set(encodedQuotes, forKey: UserDefaultsManagerKey.quotes)
        }
    }
    
    private static func savePassword(_ password: String, username: String) {
        keyChain.set(password, forKey: username)
    }
    
    static func getPassword(username: String) -> String? {
        keyChain.get(username)
    }
}
