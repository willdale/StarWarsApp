//
//  Fetchable.swift
//  StarWarsLibrary
//
//  Created by Will Dale on 21/02/2026.
//

extension Fetchable: Identifiable {
    public var id: String {
        displayName()
    }
}
