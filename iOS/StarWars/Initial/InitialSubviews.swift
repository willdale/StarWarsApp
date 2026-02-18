//
//  InitialSubviews.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import SwiftUI
import StarWarsLibrary

extension InitialView {
    struct PlanetsView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Planet> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let planets) = viewState {
                    ForEach(planets, id: \.url) { planet in
                        NavigationLink(planet.name, value: Selected.planet(planet))
                    }
                }
            }
            .navigationTitle("Planets")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let planets = try await withThrowingTaskGroup(of: Planet.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchPlanet(url: url.absoluteString)
                                }
                            }
                            
                            var results: [Planet] = []
                            for try await planet in group {
                                results.append(planet)
                            }
                            return results
                        }
                        self.viewState = .loaded(planets)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.planets)
                        let planets = try await repo.apiClient.fetchPlanets(ignoreCache: ignoreCache)
                        self.viewState = .loaded(planets)
                        repo.fetched.insert(.planets)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
    
    struct PeopleView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Person> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let people) = viewState {
                    ForEach(people, id: \.url) { person in
                        NavigationLink(person.name, value: Selected.person(person))
                    }
                }
            }
            .navigationTitle("People")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let people = try await withThrowingTaskGroup(of: Person.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchPerson(url: url.absoluteString)
                                }
                            }
                            var results: [Person] = []
                            for try await person in group {
                                results.append(person)
                            }
                            return results
                        }
                        self.viewState = .loaded(people)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.people)
                        let people = try await repo.apiClient.fetchPeople(ignoreCache: ignoreCache)
                        self.viewState = .loaded(people)
                        repo.fetched.insert(.people)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
    
    struct FilmsView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Film> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let films) = viewState {
                    ForEach(films, id: \.url) { film in
                        NavigationLink(film.title, value: Selected.film(film))
                    }
                }
            }
            .navigationTitle("Films")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let films = try await withThrowingTaskGroup(of: Film.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchFilm(url: url.absoluteString)
                                }
                            }
                            var results: [Film] = []
                            for try await film in group {
                                results.append(film)
                            }
                            return results
                        }
                        self.viewState = .loaded(films)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.films)
                        let films = try await repo.apiClient.fetchFilms(ignoreCache: ignoreCache)
                        self.viewState = .loaded(films)
                        repo.fetched.insert(.films)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
    
    struct SpeciesView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Species> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let species) = viewState {
                    ForEach(species, id: \.url) { specie in
                        NavigationLink(specie.name, value: Selected.species(specie))
                    }
                }
            }
            .navigationTitle("Species")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let species = try await withThrowingTaskGroup(of: Species.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchSpecies(url: url.absoluteString)
                                }
                            }
                            var results: [Species] = []
                            for try await specie in group {
                                results.append(specie)
                            }
                            return results
                        }
                        self.viewState = .loaded(species)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.species)
                        let species = try await repo.apiClient.fetchSpeciesList(ignoreCache: ignoreCache)
                        self.viewState = .loaded(species)
                        repo.fetched.insert(.species)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
    
    struct StarshipsView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Starship> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let starships) = viewState {
                    ForEach(starships, id: \.url) { starship in
                        NavigationLink(starship.name, value: Selected.starship(starship))
                    }
                }
            }
            .navigationTitle("Starships")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let starships = try await withThrowingTaskGroup(of: Starship.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchStarship(url: url.absoluteString)
                                }
                            }
                            var results: [Starship] = []
                            for try await starship in group {
                                results.append(starship)
                            }
                            return results
                        }
                        self.viewState = .loaded(starships)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.starships)
                        let starships = try await repo.apiClient.fetchStarships(ignoreCache: ignoreCache)
                        self.viewState = .loaded(starships)
                        repo.fetched.insert(.starships)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
    
    struct VehiclesView: View {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<Vehicle> = .loading
        let urls: [URL]?
        
        var body: some View {
            List {
                if case .loaded(let vehicles) = viewState {
                    ForEach(vehicles, id: \.url) { vehicle in
                        NavigationLink(vehicle.name, value: Selected.vehicle(vehicle))
                    }
                }
            }
            .navigationTitle("Vehicles")
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let vehicles = try await withThrowingTaskGroup(of: Vehicle.self) { group in
                            for url in urls {
                                group.addTask {
                                    try await repo.apiClient.fetchVehicle(url: url.absoluteString)
                                }
                            }
                            var results: [Vehicle] = []
                            for try await vehicle in group {
                                results.append(vehicle)
                            }
                            return results
                        }
                        self.viewState = .loaded(vehicles)
                    } else {
                        let ignoreCache = !repo.fetched.contains(.vehicles)
                        let vehicles = try await repo.apiClient.fetchVehicles(ignoreCache: ignoreCache)
                        self.viewState = .loaded(vehicles)
                        repo.fetched.insert(.vehicles)
                    }
                } catch {
                    self.viewState = .error
                }
            }
        }
    }
}

extension InitialView {
    private struct StateOverlay<T>: View {
        let viewState: ViewState<T>
        
        var body: some View {
            switch viewState {
            case .loading:
                ZStack {
                    Color(uiColor: .systemBackground).opacity(0.6)
                    ProgressView().progressViewStyle(.circular)
                }
            case .loaded(let elements) where elements.isEmpty:
                ZStack {
                    Color(uiColor: .systemBackground).opacity(0.6)
                    Text("No results")
                }
            case .error:
                ZStack {
                    Color(uiColor: .systemBackground).opacity(0.6)
                    Text("Error")
                }
            case .loaded:
                EmptyView()
            }
        }
    }
    
    enum ViewState<T> {
        case loading
        case loaded([T])
        case error
    }
}
