//
//  BookshelfCollectionViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import CoreData

class BookshelfCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Properties
    
    var bookshelf: Bookshelf?
    var volumeController: VolumeController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Volume> = {
        let fetchRequest: NSFetchRequest<Volume> = Volume.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "volumeInfo.title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            collectionView?.insertSections(IndexSet(integer: sectionIndex))
        case .delete:
            collectionView?.deleteSections(IndexSet(integer: sectionIndex))
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            collectionView?.insertItems(at: [newIndexPath])
        case .delete:
            guard let indexPath = indexPath else { return }
            collectionView?.deleteItems(at: [indexPath])
        case .update:
            guard let indexPath = indexPath else { return }
            collectionView?.reloadItems(at: [indexPath])
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            collectionView?.deleteItems(at: [oldIndexPath])
            collectionView?.insertItems(at: [newIndexPath])
        }
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolumeCell", for: indexPath) as! VolumeCollectionViewCell

        let volume = fetchedResultsController.object(at: indexPath)
        cell.volume = volume
    
        return cell
    }

    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     }
}
