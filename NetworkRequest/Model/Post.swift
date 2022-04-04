//
//  Photo.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

enum UserAction: String, CaseIterable {
    case posts = "Posts"
    case photos = "Photos"
}
