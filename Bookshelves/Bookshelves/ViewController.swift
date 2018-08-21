//
//  ViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/20/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestAuth(_ sender: Any) {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Error requesting authorization: \(error)")
                return
            }
            print("access granted :)")
        }
    }
    
}

