//
//  NetworkManager.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import Foundation

class NetworkManager {
    
    func fetchPosts(completion: @escaping ([Post]) -> ()) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
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
    
    func fetchPhotos(completion: @escaping ([Photo]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let photo = try JSONDecoder().decode([Photo].self, from: data)
                DispatchQueue.main.async {
                    completion(photo)
                    print(photo)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}
