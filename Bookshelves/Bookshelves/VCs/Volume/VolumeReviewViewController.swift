//
//  VolumeReviewViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/23/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class VolumeReviewViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateViews()
    }
    
    
    // MARK: - Properties
    
    let volumeController = VolumeController()
    var volume: Volume?
    
    // MARK: - Outlets
    
    @IBOutlet weak var reviewStringTextField: UITextField!
    
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    // MARK: - Functions
    
    func updateViews() {
        reviewStringTextField.contentVerticalAlignment = .top
    }
}
