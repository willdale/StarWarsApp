//
//  FilmDetailView.swift
//  StarWars
//
//  Created by Will Dale on 16/02/2026.
//

import StarWarsLibrary
import SwiftUI

struct FilmDetailView: View {
    let film: Film
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(film.title)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text("Episode \(film.episodeId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(film.releaseDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Opening Crawl
                VStack(alignment: .leading, spacing: 8) {
                    Label("Opening Crawl", systemImage: "text.alignleft")
                        .font(.headline)
                    
                    Text(film.openingCrawl)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Production Info
                VStack(alignment: .leading, spacing: 12) {
                    Label("Production", systemImage: "film")
                        .font(.headline)
                    
                    InfoRow(label: "Director", value: film.director)
                    InfoRow(label: "Producer", value: film.producer)
                }
                .padding(.horizontal)
                
                // List Sections
                if !film.characters.isEmpty {
                    SelectableRow(title: "Characters", icon: "person.2", items: .people(film.characters))
                }
                
                if !film.planets.isEmpty {
                    SelectableRow(title: "Planets", icon: "globe", items: .planets(film.planets))
                }
                
                if !film.starships.isEmpty {
                    SelectableRow(title: "Starships", icon: "airplane", items: .starships(film.starships))
                }
                
                if !film.vehicles.isEmpty {
                    SelectableRow(title: "Vehicles", icon: "car", items: .vehicles(film.vehicles))
                }
                
                if !film.species.isEmpty {
                    SelectableRow(title: "Species", icon: "pawprint", items: .species(film.species))
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
