//
//  PhotosTableViewController.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var comments: [Comment] = []
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.isEmpty ? users.count : comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if comments.isEmpty {
            content.text = users[indexPath.row].name
            content.secondaryText = users[indexPath.row].email
            cell.contentConfiguration = content
        } else {
            content.text = comments[indexPath.row].name
            content.secondaryText = comments[indexPath.row].email
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CommentsTableViewController {
    
    func getComments() {
        NetworkManager.shared.fetch(dataType: Comment.self, from: Link.commentsURL.rawValue) { result in
            
            switch result {
            case .success(let comments):
                self.comments = comments
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.tableView.reloadData()
        }
    }
    
    func getUsers() {
        NetworkManager.shared.fetch(dataType: User.self, from: Link.usersURL.rawValue) { result in
            switch result {
            case .success(let users):
                self.users = users
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.tableView.reloadData()
        }
    }
    
    func alamofireGetButton() {
        NetworkManager.shared.alamofireGet(from: Link.commentsURL.rawValue) { result in
            switch result {
            case .success(let comments):
                print(comments)
                self.comments = comments
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func alamofirePostButton() {
        
        let comment = CommentTwo(
            name: "Name",
            email: "Email"
        )
        
        NetworkManager.shared.alamofirePost(from: Link.postsURL.rawValue, data: comment) { result in
            switch result {
            case .success(let comment):
                self.comments.append(comment)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
