//
//  OnboardingViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Fix
        // Warning: Attempt to present <UINavigationController: 0x10684bc00> on <Bookshelves.OnboardingViewController: 0x105c0da40> whose view is not in the window hierarchy!
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Error authorizing google books: \(error)")
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
