//
//  Photo.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

// MARK: - POST
struct Post: Codable {
    let title: String?
    let body: String?
}

// MARK: - COMMENTS
struct Comment: Codable {
    let name: String?
    let email: String?
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    init(valueData: [String: Any]) {
        name = valueData["name"] as? String ?? ""
        email = valueData["email"] as? String ?? ""
    }
    
    static func getComments(from value: Any) -> [Comment] {
        guard let valueData = value as? [[String: Any]] else { return [] }
        return valueData.compactMap { Comment(valueData: $0) }
    }
}

// MARK: - COMMENTTWO
struct CommentTwo: Codable {
    let name: String?
    let email: String?
}

// MARK: - USER
struct User: Codable {
    let name: String?
    let username: String?
    let email: String?
}

// MARK: - UserTwo
struct UserTwo: Codable {
    let name: String?
    let username: String?
    let email: String?
}
