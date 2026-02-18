//
//  HomeworldDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct HomeworldDetailView: View {
    @Environment(Repository.self) private var repo
    @State private var planet: Planet?
    let url: URL
    
    var body: some View {
        ZStack {
            if let planet {
                PlanetDetailView(planet: planet)
            } else {
                ZStack {
                    Color(uiColor: .systemBackground).opacity(0.6)
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
        .task {
            planet = try? await repo.apiClient.fetchPlanet(url: url.absoluteString)
        }
    }
}
