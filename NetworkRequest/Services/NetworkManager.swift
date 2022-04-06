//
//  NetworkManager.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import Foundation

enum Link: String {
    case postsURL = "https://jsonplaceholder.typicode.com/posts"
    case commentsURL = "https://jsonplaceholder.typicode.com/comments"
}

enum NetworkError: String, Error {
    case badURL = "No connection to url address."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was invalid. Please try again."
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, from urlString: String, completed: @escaping (Result<[T], NetworkError>) -> Void) {
        
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
                let type = try JSONDecoder().decode([T].self, from: data)
                
                DispatchQueue.main.async {
                    completed(.success(type))
                }
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
}
