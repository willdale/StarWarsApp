//
//  StarWarsApp.swift
//  StarWars
//
//  Created by Will Dale on 15/02/2026.
//

import SwiftUI

@main
struct StarwarsApp: App {
    @State private var repo = Repository()
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environment(repo)
        }
    }
}

import StarWarsLibrary

