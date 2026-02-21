//
//  StarshipDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct StarshipDetailView: View {
    let starship: Starship
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(starship.name)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text(starship.model)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(starship.starshipClass.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Manufacturing
                VStack(alignment: .leading, spacing: 12) {
                    Label("Manufacturing", systemImage: "wrench.and.screwdriver")
                        .font(.headline)
                    
                    InfoRow(label: "Manufacturer", value: starship.manufacturer)
                    InfoRow(label: "Cost", value: starship.costInCredits)
                    InfoRow(label: "Length", value: starship.length)
                    InfoRow(label: "Consumables", value: starship.consumables)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Performance
                VStack(alignment: .leading, spacing: 12) {
                    Label("Performance", systemImage: "gauge.with.needle")
                        .font(.headline)
                    
                    InfoRow(label: "Max Speed", value: starship.maxAtmospheringSpeed)
                    InfoRow(label: "Hyperdrive Rating", value: starship.hyperdriveRating)
                    InfoRow(label: "MGLT", value: starship.mglt)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Capacity
                VStack(alignment: .leading, spacing: 12) {
                    Label("Capacity", systemImage: "person.3")
                        .font(.headline)
                    
                    InfoRow(label: "Crew", value: starship.crew)
                    InfoRow(label: "Passengers", value: starship.passengers)
                    InfoRow(label: "Cargo Capacity", value: starship.cargoCapacity)
                }
                .padding(.horizontal)
                
                // List Sections
                if !starship.pilots.isEmpty {
                    SelectableRow(title: "Pilots", icon: "person.bust", items: .people(starship.pilots))
                }
                
                if !starship.films.isEmpty {
                    SelectableRow(title: "Films", icon: "film", items: .films(starship.films))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
