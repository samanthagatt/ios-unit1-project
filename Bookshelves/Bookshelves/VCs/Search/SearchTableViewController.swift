//
//  SearchTableViewController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    // MARK: - Properties
    
    let volumeController = VolumeController()
    var volumeReps: [VolumeRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Search Bar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else { return }
        
        self.searchBar.endEditing(true)
        
        volumeController.search(for: searchTerm) { (volumeReps, error) in
            
            if let error = error {
                NSLog("Error retrieving data: \(error)")
                return
            }
            
            self.volumeReps = volumeReps ?? []
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return volumeReps?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVolumeCell", for: indexPath)

        guard let volumes = volumeReps else { fatalError("volumeReps is nil") }
        let volume = volumes[indexPath.row]
        cell.textLabel?.text = volume.volumeInfo.title
        cell.detailTextLabel?.text = volume.volumeInfo.authors

        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    
}
