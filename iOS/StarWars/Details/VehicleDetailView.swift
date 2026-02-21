//
//  VehicleDetailView.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct VehicleDetailView: View {
    let vehicle: Vehicle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(vehicle.name)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text(vehicle.model)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(vehicle.vehicleClass.capitalized)
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
                    
                    InfoRow(label: "Manufacturer", value: vehicle.manufacturer)
                    InfoRow(label: "Cost", value: vehicle.costInCredits)
                    InfoRow(label: "Length", value: vehicle.length)
                    InfoRow(label: "Consumables", value: vehicle.consumables)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Performance
                VStack(alignment: .leading, spacing: 12) {
                    Label("Performance", systemImage: "gauge.with.needle")
                        .font(.headline)
                    
                    InfoRow(label: "Max Speed", value: vehicle.maxAtmospheringSpeed)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Capacity
                VStack(alignment: .leading, spacing: 12) {
                    Label("Capacity", systemImage: "person.3")
                        .font(.headline)
                    
                    InfoRow(label: "Crew", value: vehicle.crew)
                    InfoRow(label: "Passengers", value: vehicle.passengers)
                    InfoRow(label: "Cargo Capacity", value: vehicle.cargoCapacity)
                }
                .padding(.horizontal)
                
                // List Sections
                if !vehicle.pilots.isEmpty {
                    SelectableRow(title: "Pilots", icon: "person.bust", items: .people(vehicle.pilots))
                }
                
                if !vehicle.films.isEmpty {
                    SelectableRow(title: "Films", icon: "film", items: .films(vehicle.films))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
