//
//  InitialView.swift
//  StarWars
//
//  Created by Will Dale on 15/02/2026.
//

import SwiftUI
import StarWarsLibrary

struct InitialView: View {
    @State private var naviation = Navigation()
    
    var body: some View {
        NavigationStack(path: $naviation.path) {
            List {
                ForEach(allFetchable()) { fetchable in
                    NavigationLink(fetchable.displayName(), value: fetchable)
                }
            }
            .navigationTitle("Star Wars API")
            .navigationDestination(for: Fetchable.self) { fetchable in
                switch fetchable {
                case .planets: DataListView(urls: nil, fetcher: .planets)
                case .people: DataListView(urls: nil, fetcher: .people)
                case .films: DataListView(urls: nil, fetcher: .films)
                case .species: DataListView(urls: nil, fetcher: .species)
                case .starships: DataListView(urls: nil, fetcher: .starships)
                case .vehicles: DataListView(urls: nil, fetcher: .vehicles)
                }
            }
            .navigationDestination(for: Selected.self) { selected in
                switch selected {
                case .film(let film): FilmDetailView(film: film)
                case .person(let person): PersonDetailView(person: person)
                case .planet(let planet): PlanetDetailView(planet: planet)
                case .species(let species): SpeciesDetailView(species: species)
                case .starship(let starship): StarshipDetailView(starship: starship)
                case .vehicle(let vehicle): VehicleDetailView(vehicle: vehicle)
                }
            }
            .navigationDestination(for: ListItems.self) { selected in
                switch selected {
                case .planets(let urls): DataListView(urls: urls, fetcher: .planets)
                case .people(let urls): DataListView(urls: urls, fetcher: .people)
                case .films(let urls): DataListView(urls: urls, fetcher: .films)
                case .species(let urls): DataListView(urls: urls, fetcher: .species)
                case .starships(let urls): DataListView(urls: urls, fetcher: .starships)
                case .vehicles(let urls): DataListView(urls: urls, fetcher: .vehicles)
                case .homeworld(let url): HomeworldDetailView(url: url)
                }
            }
        }
        .environment(naviation)
    }
}

#Preview {
    InitialView()
}
