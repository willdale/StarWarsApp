//
//  PersonDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(person.name)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text("Born \(person.birthYear)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(person.gender.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Physical Attributes
                VStack(alignment: .leading, spacing: 12) {
                    Label("Physical Attributes", systemImage: "person")
                        .font(.headline)
                    
                    InfoRow(label: "Height", value: person.height)
                    InfoRow(label: "Mass", value: person.mass)
                    InfoRow(label: "Eye Color", value: person.eyeColor.capitalized)
                    InfoRow(label: "Hair Color", value: person.hairColor.capitalized)
                    InfoRow(label: "Skin Color", value: person.skinColor.capitalized)
                    InfoRow(label: "Birth Year", value: person.birthYear)
                }
                .padding(.horizontal)
                
                Divider()
                
                // List Sections
                if !person.films.isEmpty {
                    SelectableRow(title: "Films", icon: "film", items: .films(person.films.compactMap(URL.init)))
                }
                
                if !person.species.isEmpty {
                    SelectableRow(title: "Species", icon: "pawprint", items: .species(person.species.compactMap(URL.init)))
                }
                
                if !person.starships.isEmpty {
                    SelectableRow(title: "Starships", icon: "airplane", items: .starships(person.starships.compactMap(URL.init)))
                }
                
                if !person.vehicles.isEmpty {
                    SelectableRow(title: "Vehicles", icon: "car", items: .vehicles(person.vehicles.compactMap(URL.init)))
                }
                
                if let homeworld = person.homeworld, let url = URL(string: homeworld) {
                    SelectableRow(title: "Homeworld", icon: "house", items: .homeworld(url))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
