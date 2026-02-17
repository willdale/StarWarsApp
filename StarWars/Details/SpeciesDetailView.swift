//
//  SpeciesDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct SpeciesDetailView: View {
    let species: Species
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(species.name)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text(species.classification.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(species.designation.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Biology
                VStack(alignment: .leading, spacing: 12) {
                    Label("Biology", systemImage: "staroflife")
                        .font(.headline)
                    
                    InfoRow(label: "Average Height", value: species.averageHeight)
                    InfoRow(label: "Average Lifespan", value: species.averageLifespan)
                    InfoRow(label: "Skin Colors", value: species.skinColors.capitalized)
                    InfoRow(label: "Hair Colors", value: species.hairColors.capitalized)
                    InfoRow(label: "Eye Colors", value: species.eyeColors.capitalized)
                }
                .padding(.horizontal)
                
                Divider()
                
                // List Sections
                if !species.people.isEmpty {
                    SelectableRow(title: "People", icon: "person.2", items: .people(species.people.compactMap(URL.init)))
                }
                
                if !species.films.isEmpty {
                    SelectableRow(title: "Films", icon: "film", items: .films(species.films.compactMap(URL.init)))
                }
                
                if let homeworld = species.homeworld, let url = URL(string: homeworld) {
                    SelectableRow(title: "Homeworld", icon: "house", items: .homeworld(url))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
