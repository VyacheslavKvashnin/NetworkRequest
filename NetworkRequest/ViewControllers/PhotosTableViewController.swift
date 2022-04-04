//
//  PhotosTableViewController.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import UIKit

class PhotosTableViewController: UITableViewController {
    
    private var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager().fetchPhotos { photo in
            self.photos = photo
            self.tableView.reloadData()
            print(self.photos)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = photos[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
}
