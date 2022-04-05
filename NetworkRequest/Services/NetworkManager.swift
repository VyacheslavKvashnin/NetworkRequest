//
//  NetworkManager.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPosts(completion: @escaping ([Post]) -> ()) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    completion(posts)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchComment(completion: @escaping ([Comment]) -> ()) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                
                DispatchQueue.main.async {
                    completion(comments)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
