//
//  ViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordReenterTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureView()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordReenterTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AccountManager.checkLogInStatus() {
            proceedToHomeViewController()
        }
    }

    @IBAction func modeDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            passwordReenterTextField.isHidden = true
            break
        case 1:
            passwordReenterTextField.isHidden = false
            break
        default:
            break
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if passwordReenterTextField.isHidden {
            do{
                try AccountManager.login(
                    username: usernameTextField.text,
                    password: passwordTextField.text
                )
                proceedToHomeViewController()
            }
            catch {
                if let error = error as? AccountManager.AccountManagerError {
                    showAlert(message: error.errorDescription)
                }
            }
        } else {
            do{
                try AccountManager.registerAccount(
                    username: usernameTextField.text,
                    password: passwordTextField.text,
                    reenterPassword: passwordReenterTextField.text
                )
                proceedToHomeViewController()
            }
            catch {
                if let error = error as? AccountManager.AccountManagerError {
                    showAlert(message: error.errorDescription)
                }
            }
        }
    }
    
    private func configureView() {
        passwordReenterTextField.isHidden = true
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        if AccountManager.loggedInAccount != nil {
            proceedToHomeViewController()
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

// MARK: - UITextFieldDelegate methods

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        } else if !passwordReenterTextField.isHidden && passwordReenterTextField.text == "" {
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        } else {
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
