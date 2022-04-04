//
//  PostsTableViewController.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import UIKit

class PostsTableViewController: UITableViewController {

    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().fetchPosts { post in
            self.posts = post
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = posts[indexPath.row].title
        content.secondaryText = posts[indexPath.row].body
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
