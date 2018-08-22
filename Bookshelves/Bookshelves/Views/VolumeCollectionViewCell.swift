//
//  VolumeCollectionViewCell.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class VolumeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    
    // MARK: - Functions
    
    func updateViews() {
        guard let volume = volume else { return }
        
        titleLabel.text = volume.volumeInfo?.title
        authorsLabel.text = volume.volumeInfo?.authors
        
        guard let imageString = volume.volumeInfo?.imageStrings?.thumbnailString,
            let imageURL = URL(string: imageString),
            let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData) else { return }
        
        imageView.image = image
    }
}
