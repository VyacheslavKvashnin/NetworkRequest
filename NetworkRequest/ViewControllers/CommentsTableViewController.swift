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
        
        NetworkManager.shared.fetchComment(from: Link.commentsURL.rawValue) { result in
            
            switch result {
            case .success(let comments):
                self.comments = comments
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
