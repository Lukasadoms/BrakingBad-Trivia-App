//
//  HomeViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction func episodesButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func charactersButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func quotesButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        AccountManager.loggedInAccount = nil
        dismiss(animated: true)
    }
    
    private func configureView() {
        if let loggedInAccount = AccountManager.loggedInAccount {
            titleLabel.text = "Breaking Bad fan: " + loggedInAccount.username
        }
    }
}
