//
//  HomeViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var apiManager = APIManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction func episodesButtonTapped(_ sender: UIButton) {
        let episodesViewController = EpisodesViewController()
        show(episodesViewController, sender: nil)
    }
    
    @IBAction func charactersButtonTapped(_ sender: UIButton) {
        let charactersViewController = CharactersViewController()
        show(charactersViewController, sender: nil)
        
    }
    
    @IBAction func quotesButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        var account = AccountManager.loggedInAccount!
        UserDefaultsManager.updateLoginStatus(&account)
        dismiss(animated: true)
    }
    
    private func configureView() {
        if let loggedInAccount = AccountManager.loggedInAccount {
            titleLabel.text = "Breaking Bad fan: " + loggedInAccount.username
        }
    }
}
