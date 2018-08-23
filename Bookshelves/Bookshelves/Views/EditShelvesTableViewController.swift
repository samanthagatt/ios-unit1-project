//
//  EditShelvesTableViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import CoreData

class EditShelvesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
    let bookshelfController = BookshelfController()
    let volumeController = VolumeController()
    var volume: Volume?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Bookshelf> = {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    // MARK: - Actions
    
    @IBAction func dismissEditView(_ sender: Any) {
        self.parent?.dismiss(animated: true)
    }
    
    
    // Shouldn't need the fetched results delegate methods since the table view should never change?
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditBookshelfCell", for: indexPath)

        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).title

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let volume = volume else { return nil }
        let bookshelf = fetchedResultsController.object(at: indexPath)
        
        if bookshelf.volumes?.contains(volume) == true {
            let title = "Remove from shelf"
            let removeAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
                self.volumeController.addOrRemove(volume: volume, toOrfrom: bookshelf, method: .remove, context: CoreDataStack.moc, presenter: self)
                handler(true)
            }
            removeAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [removeAction])
        } else {
            let title = "Add to shelf"
            let addAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
                self.volumeController.addOrRemove(volume: volume, toOrfrom: bookshelf, method: .add, context: CoreDataStack.moc, presenter: self)
                handler(true)
            }
            addAction.backgroundColor = .green
            return UISwipeActionsConfiguration(actions: [addAction])
        }
    }
}
