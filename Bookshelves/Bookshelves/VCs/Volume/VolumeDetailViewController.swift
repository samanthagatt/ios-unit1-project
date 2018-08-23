//
//  VolumeDetailViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class VolumeDetailViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateViews()
    }
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet{
            updateViews()
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookshelvesLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    // MARK: - Functions
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        guard let volume = volume else { return }
        
        titleLabel.text = volume.volumeInfo?.title
        authorsLabel.text = volume.volumeInfo?.authors
        
        var bookshelfTitles: [String] = []
        if let bookshelves = volume.bookshelves {
            for bookshelf in bookshelves {
                // Maybe thisBookshelf is nil?
                guard let thisBookshelf = bookshelf as? Bookshelf else { return }
                bookshelfTitles.append(thisBookshelf.title!)
            }
        }

        // only returns the current bookshelf
        bookshelvesLabel.text = "Bookshelves: \(bookshelfTitles)"
        
        // summarys are truncated not full?? (not an issue with the label)
//        print(volume.volumeInfo?.summary)
        summaryLabel.text = volume.volumeInfo?.summary
        
        guard let imageString = volume.volumeInfo?.imageStrings?.thumbnailString,
            let imageURL = URL(string: imageString),
            let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData) else { return }
        
        imageView.image = image
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVolumeReview" {
            let destinationVC = segue.destination as! VolumeReviewViewController
            guard let thisVolume = volume,
                let volumeTitle = thisVolume.volumeInfo?.title else { return }
            destinationVC.title = "\(volumeTitle) Review"
            destinationVC.volume = thisVolume
        } else if segue.identifier == "PresentEditShelves" {
            let navVC = segue.destination as! UINavigationController
            guard let destinationVC = navVC.childViewControllers.first as? EditShelvesTableViewController else { return }
            destinationVC.volume = volume
        }
    }
}
