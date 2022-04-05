//
//  NetworkError.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 05.04.2022.
//

enum NetworkError: String, Error {
    case badURL = "No connection to url address."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was invalid. Please try again."
}
