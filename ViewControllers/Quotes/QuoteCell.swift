//
//  QuoteCell.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var likedButtonLabel: UIButton!
    
    func configureQuoteCell(quoteTitle: String) {
        quoteLabel.text = quoteTitle
        quoteLabel.sizeToFit()
        if let likedQuotes = QuotesManager.getUserLikedQuotes() {
            if likedQuotes.contains(where: { $0.quoteText == quoteTitle }) {
                likedButtonLabel.isHidden = false
            }
        }
    }
}
