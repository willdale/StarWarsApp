//
//  PlanetDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct PlanetDetailView: View {
    let planet: Planet
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(planet.name)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text(planet.climate.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Pop. \(planet.population)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Geography
                VStack(alignment: .leading, spacing: 12) {
                    Label("Geography", systemImage: "map")
                        .font(.headline)
                    
                    InfoRow(label: "Terrain", value: planet.terrain.capitalized)
                    InfoRow(label: "Diameter", value: planet.diameter)
                    InfoRow(label: "Surface Water", value: planet.surfaceWater)
                    InfoRow(label: "Gravity", value: planet.gravity)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Orbital Data
                VStack(alignment: .leading, spacing: 12) {
                    Label("Orbital Data", systemImage: "circle.dotted")
                        .font(.headline)
                    
                    InfoRow(label: "Rotation Period", value: planet.rotationPeriod)
                    InfoRow(label: "Orbital Period", value: planet.orbitalPeriod)
                }
                .padding(.horizontal)
                
                // List Sections
                if !planet.residents.isEmpty {
                    SelectableRow(title: "Residents", icon: "person.2", items: .people(planet.residents.compactMap(URL.init)))
                }
                
                if !planet.films.isEmpty {
                    SelectableRow(title: "Films", icon: "film", items: .films(planet.films.compactMap(URL.init)))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
