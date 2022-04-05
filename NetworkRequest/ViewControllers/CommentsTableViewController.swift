//
//  PhotosTableViewController.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    private var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().fetchComment { comment in
            self.comments = comment
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = comments[indexPath.row].name
        content.secondaryText = comments[indexPath.row].email
        cell.contentConfiguration = content
        return cell
    }
}
