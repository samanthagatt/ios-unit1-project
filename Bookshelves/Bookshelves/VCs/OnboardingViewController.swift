//
//  OnboardingViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Error authorizing google books: \(error)")
                self.button.titleLabel?.text = "Retry Google Books Authorization"
                return
            }
            self.performSegue(withIdentifier: "PresentTabController", sender: nil)
        }
    }

    
    // MARK: - Actions

    @IBAction func signIn(_ sender: Any) {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Error authorizing google books: \(error)")
                return
            }
            self.performSegue(withIdentifier: "PresentTabController", sender: nil)
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var button: UIButton!
}
