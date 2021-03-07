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
            var mappedQuotes = likedQuotes.map { ($0, 1) }
            var topQuotes: [Quote] = []
            var topQuote: Quote?
            var quoteMaxCount = 0
            for _ in 1...3 {
                quoteMaxCount = 0
                topQuote = nil
                for quote in mappedQuotes {
                    if quote.1 > quoteMaxCount {
                        quoteMaxCount = quote.1
                        topQuote = quote.0
                    }
                }
                if let topQuote = topQuote {
                    topQuotes.append(topQuote)
                    mappedQuotes.removeAll { $0.quoteText == topQuote.quoteText }
                }
            }
            return topQuotes
        }
        return nil
    }
    
    static func likeQuote(quote: QuoteResponse) {
        var newLikedQuote = Quote(quoteText: quote.quoteText)
        newLikedQuote.likedByUsers.append(AccountManager.loggedInAccount!)
        UserDefaultsManager.saveLikedQuote(quote: newLikedQuote)
    }
    
    static func dislikeQuote(quote: QuoteResponse) {
        var dislikedQuote = Quote(quoteText: quote.quoteText)
        dislikedQuote.likedByUsers.removeAll(where: {$0.username == AccountManager.loggedInAccount!.username})
        UserDefaultsManager.deleteLikedQuote(quote: dislikedQuote)
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
                if userLikedQuote.quoteText == quote.quoteText {
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
