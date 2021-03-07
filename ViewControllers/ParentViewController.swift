//
//  ParentViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/7/21.
//

import UIKit

class ParentViewController: UIViewController {
    
    let child = SpinnerViewController()
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        DispatchQueue.main.async() {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Uh-oh", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func proceedToHomeViewController() {
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true, completion: nil)
    }
}
