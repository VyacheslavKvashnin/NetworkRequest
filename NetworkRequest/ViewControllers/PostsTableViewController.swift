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
        
        NetworkManager.shared.fetch(dataType: Post.self, from: Link.postsURL.rawValue) { result in
            
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
