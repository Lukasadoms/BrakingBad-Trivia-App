//
//  AccountManager.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import Foundation

struct AccountManager {

    enum AccountManagerError: Error {
        case missingValues
        case accountAlreadyExists
        case wrongPassword
        case accountNotFound

        var errorDescription: String {
            switch self {
            case .missingValues:
                return "Missing required values, or passwords don`t match!"
            case .accountAlreadyExists:
                return "This username is already taken!"
            case .wrongPassword:
                return "Password is incorrect!"
            case .accountNotFound:
                return "Account with this username is not found!"
            }
        }
    }

    static var loggedInAccount: Account?
}

// MARK: - Main functionality
extension AccountManager {

    static func registerAccount(username: String?, password: String?, reenterPassword: String?) throws {
        guard
            let username = username,
            let password = password,
            reenterPassword == password,
            username.isNotEmpty,
            password.isNotEmpty
        else {
            throw AccountManagerError.missingValues
        }

        guard !isUsernameTaken(username) else {
            throw AccountManagerError.accountAlreadyExists
        }
        var account = Account(username: username, password: password, isloggedIn: true)
        UserDefaultsManager.saveAccount(&account)
        loggedInAccount = account
    }

    static func login(username: String?, password: String?) throws {
        guard let accounts = UserDefaultsManager.accounts else {
            throw AccountManagerError.accountNotFound
        }
        for var account in accounts where account.username == username {
            guard password == UserDefaultsManager.getPassword(username: account.username) else {
                throw AccountManagerError.wrongPassword
            }
            loggedInAccount = account
            UserDefaultsManager.updateLoginStatus(&account)
            return
        }
        
        throw AccountManagerError.accountNotFound
    }
    
    static func checkLogInStatus() -> Bool {
        if let accounts = UserDefaultsManager.accounts {
            for account in accounts {
                if account.isloggedIn == true {
                    loggedInAccount = account
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - Helpers
private extension AccountManager {

    static func isUsernameTaken(_ username: String) -> Bool {
        guard let accounts = UserDefaultsManager.accounts else { return false }
        return accounts.contains { account -> Bool in
            account.username == username
        }
    }
}
