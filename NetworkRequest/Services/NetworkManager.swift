//
//  NetworkManager.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import Alamofire
import UIKit

enum Link: String {
    case postsURL = "https://jsonplaceholder.typicode.com/posts"
    case commentsURL = "https://jsonplaceholder.typicode.com/comments"
    case usersURL = "https://jsonplaceholder.typicode.com/users"
}

enum NetworkError: String, Error {
    case badURL = "No connection to url address."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was invalid. Please try again."
}

enum UserAction: String, CaseIterable {
    case posts = "Posts"
    case comments = "Comments"
    case postDict = "POST with Dict"
    case postModel = "POST with Model"
    case alamofireGet = "Alamofire GET"
    case alamofirePost = "Alamofire POST"
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
    
    func postRequest(with data: [String: Any], to url: String, completed: @escaping (Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completed(.failure(.badURL))
            return
        }
        
        guard let dataPost = try? JSONSerialization.data(withJSONObject: data) else {
            completed(.failure(.invalidData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = dataPost
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completed(.failure(.invalidData))
                print(error?.localizedDescription ?? "No error description!")
                return
            }
            print(response)
            
            do {
                let dataPost = try JSONSerialization.jsonObject(with: data)
                completed(.success(dataPost))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
    
    func postRequest(with data: User, to url: String, completed: @escaping (Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completed(.failure(.badURL))
            return
        }
        
        guard let dataPost = try? JSONEncoder().encode(data) else {
            completed(.failure(.invalidData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = dataPost
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completed(.failure(.invalidData))
                print(error?.localizedDescription ?? "No error description!")
                return
            }
            print(response)
            
            do {
                let dataPost = try JSONDecoder().decode(User.self, from: data)
                completed(.success(dataPost))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
    
    func alamofireGet(from url: String, completion: @escaping(Result<[Comment], NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let comment = Comment.getComments(from: value)
                    
                    DispatchQueue.main.async {
                        completion(.success(comment))
                    }
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
    }
    
    func alamofirePost(from url: String, data: CommentTwo, completion: @escaping(Result<Comment, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: CommentTwo.self) { dataResponse in
                switch dataResponse.result {
                case .success(let commentTwo):
                    let comment = Comment(
                        name: commentTwo.name ?? "",
                        email: commentTwo.email ?? "")
                    DispatchQueue.main.async {
                        completion(.success(comment))
                    }
                    
                case .failure:
                    completion(.failure(.invalidData))
                }
            }
    }
}
