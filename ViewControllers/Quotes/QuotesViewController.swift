//
//  QuotesViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/7/21.
//

import UIKit

class QuotesViewController: ParentViewController {

    @IBOutlet weak var quotesTableView: UITableView!
    var apiManager = APIManager()
    var randomQuote: QuoteResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
        getRandomQuote()
        
    }
}

// MARK: - UITableViewDataSource Methods

extension QuotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Top3 Liked Quotes"
        case 1:
            return "My Liked Quotes"
        case 2:
            return "Random Quote"
        default:
            return "Error"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let mappedQuotes = QuotesManager.mappedQuotes {
                if mappedQuotes.count > 2 {
                    return 3
                }
                return mappedQuotes.count
            }
            return 0
        case 1:
            if let userLikedQuotes = QuotesManager.getUserLikedQuotes() {
                return userLikedQuotes.count
            } else { return 0 }
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        guard let quoteCell = cell as? QuoteCell else { return cell }
        switch indexPath.section {
        case 0:
            if let mappedQuotes = QuotesManager.mappedQuotes {
                quoteCell.configureQuoteCell(quoteTitle: mappedQuotes[indexPath.row].quote.quoteText)
            }
            return quoteCell
        case 1:
            if let userLikedQuotes = QuotesManager.getUserLikedQuotes() {
                quoteCell.configureQuoteCell(quoteTitle: userLikedQuotes[indexPath.row].quote.quoteText)
                return quoteCell
            }
        case 2:
            if let randomQuote = randomQuote {
                quoteCell.configureQuoteCell(quoteTitle: randomQuote.quoteText)
            }
        default:
            return quoteCell
        }
        return quoteCell
    }
}

// MARK: - UITableViewDelegate Methods

extension QuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let mappedQuotes = QuotesManager.mappedQuotes {
                let likedQuote = mappedQuotes[indexPath.row]
                QuotesManager.quotesAction(quote: likedQuote.quote)
                quotesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let userLikedQuotes = QuotesManager.getUserLikedQuotes() {
                if editingStyle == .delete {
                    QuotesManager.quotesAction(quote: userLikedQuotes[indexPath.row].quote)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    quotesTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Helpers

extension QuotesViewController {
    func updateUI() {
        let cellNib = UINib(nibName: "QuoteCell", bundle: nil)
        quotesTableView.register(cellNib, forCellReuseIdentifier: "QuoteCell")
        quotesTableView.dataSource = self
        quotesTableView.delegate = self
        quotesTableView.reloadData()
        removeSpinnerView()
    }
}

// MARK: - API Calls

extension QuotesViewController {
    func getRandomQuote() {
        apiManager.getRandomQuote { [weak self] result in
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self?.randomQuote = quote
                    self?.updateUI()
                }
            case .failure(let error):
                self?.showAlert(message: error.errorDescription)
            }
        }
    }
}
