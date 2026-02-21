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
                
                // List Sections (use Rust helper to centralize related items)
                let related = personRelatedItems(person: person)
                ForEach(related, id: \.self) { item in
                    switch item {
                    case .films:
                        SelectableRow(title: "Films", icon: "film", items: item)
                    case .species:
                        SelectableRow(title: "Species", icon: "pawprint", items: item)
                    case .starships:
                        SelectableRow(title: "Starships", icon: "airplane", items: item)
                    case .vehicles:
                        SelectableRow(title: "Vehicles", icon: "car", items: item)
                    case .planets:
                        SelectableRow(title: "Planets", icon: "globe", items: item)
                    case .people:
                        SelectableRow(title: "People", icon: "person.2", items: item)
                    case .homeworld(let urlStr):
                        SelectableRow(title: "Homeworld", icon: "house", items: item)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
