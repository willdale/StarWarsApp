//
//  URLIdentifiable.swift
//  StarWarsLibrary
//
//  Created by Will Dale on 21/02/2026.
//

public protocol URLIdentifiable {
    var url: String { get }
}

extension Planet: URLIdentifiable {}
extension Person: URLIdentifiable {}
extension Film: URLIdentifiable {}
extension Species: URLIdentifiable {}
extension Starship: URLIdentifiable {}
extension Vehicle: URLIdentifiable {}
