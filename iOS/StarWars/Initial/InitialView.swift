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
                case .planets: PlanetsView(urls: nil)
                case .people: PeopleView(urls: nil)
                case .films: FilmsView(urls: nil)
                case .species: SpeciesView(urls: nil)
                case .starships: StarshipsView(urls: nil)
                case .vehicles: VehiclesView(urls: nil)
                }
            }
            .navigationDestination(for: Selected.self) { selected in
                switch selected {
                case .film(let film):
                    FilmDetailView(film: film)
                case .person(let person):
                    PersonDetailView(person: person)
                case .planet(let planet):
                    PlanetDetailView(planet: planet)
                case .species(let species):
                    SpeciesDetailView(species: species)
                case .starship(let starship):
                    StarshipDetailView(starship: starship)
                case .vehicle(let vehicle):
                    VehicleDetailView(vehicle: vehicle)
                }
            }
            .navigationDestination(for: ListItems.self) { selected in
                switch selected {
                case .planets(let urls): PlanetsView(urls: urls)
                case .people(let urls): PeopleView(urls: urls)
                case .films(let urls): FilmsView(urls: urls)
                case .species(let urls): SpeciesView(urls: urls)
                case .starships(let urls): StarshipsView(urls: urls)
                case .vehicles(let urls): VehiclesView(urls: urls)
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
