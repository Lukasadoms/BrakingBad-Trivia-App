//
//  QuoteManager.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/7/21.
//

import Foundation

struct QuotesManager {
    static var mappedQuotes: [Quote]? {
        if let likedQuotes = UserDefaultsManager.likedQuotes {
            var sortedQuotes = likedQuotes
            sortedQuotes.sort { $0.likedByUsers.count > $1.likedByUsers.count }
            return sortedQuotes
        } else { return nil }
    }


    static func likeQuote(quote: QuoteResponse) {
        if let likedQuotes = UserDefaultsManager.likedQuotes {
            let likedQuote = likedQuotes.filter { $0.quote.quoteText == quote.quoteText }
            if let updatedQuote = likedQuote.first {
                var updatedQuote2 = updatedQuote
                updatedQuote2.likedByUsers.append(AccountManager.loggedInAccount!)
                UserDefaultsManager.deleteLikedQuote(quote: updatedQuote)
                UserDefaultsManager.saveLikedQuote(quote: updatedQuote2)
            } else {
                var firstQuote = Quote(quote: quote)
                firstQuote.likedByUsers.append(AccountManager.loggedInAccount!)
                UserDefaultsManager.saveLikedQuote(quote: firstQuote)
            }
        } else {
            var firstQuote = Quote(quote: quote)
            firstQuote.likedByUsers.append(AccountManager.loggedInAccount!)
            UserDefaultsManager.saveLikedQuote(quote: firstQuote)
        }
    }
    
    static func dislikeQuote(quote: QuoteResponse) {
        if let likedQuotes = UserDefaultsManager.likedQuotes {
            let dislikedQuote = likedQuotes.filter { $0.quote.quoteText == quote.quoteText }
            var updatedQuote = dislikedQuote.first
            updatedQuote!.likedByUsers.removeAll(where: {$0.username == AccountManager.loggedInAccount!.username})
            UserDefaultsManager.deleteLikedQuote(quote: dislikedQuote.first!)
            UserDefaultsManager.saveLikedQuote(quote: updatedQuote!)
        }
    }
    
    static func getUserLikedQuotes() -> [Quote]? {
        var userLikedQuotes: [Quote] = []
        if let likedQuotes = UserDefaultsManager.likedQuotes {
            for likedQuote in likedQuotes {
                for account in likedQuote.likedByUsers {
                    if account.username == AccountManager.loggedInAccount!.username {
                        userLikedQuotes.append(likedQuote)
                    }
                }
            }
        }
        return userLikedQuotes
    }
    
    static func quotesAction(quote: QuoteResponse) {
        if let userLikedQuotes = getUserLikedQuotes() {
            for userLikedQuote in userLikedQuotes {
                if userLikedQuote.quote.quoteText == quote.quoteText {
                    QuotesManager.dislikeQuote(quote: quote)
                    return
                }
            }
            QuotesManager.likeQuote(quote: quote)
        } else {
            QuotesManager.likeQuote(quote: quote)
        }
    }
}
