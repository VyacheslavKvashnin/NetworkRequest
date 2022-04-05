//
//  NetworkManager.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPosts(from urlString: String, completed: @escaping (Result<[Post], NetworkError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    completed(.success(posts))
                }
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
    
    func fetchComment(from urlString: String, completed: @escaping (Result<[Comment], NetworkError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.badURL))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                DispatchQueue.main.async {
                    completed(.success(comments))
                }
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
}
