//
//  InitialSubviews.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import SwiftUI
import StarWarsLibrary

extension InitialView {
    struct DataListView<T: URLIdentifiable>: View, Equatable {
        @Environment(Repository.self) private var repo
        @State private var viewState: ViewState<T> = .loading
        
        let urls: [URL]?
        let fetcher: ResourceFetcher<T>
        
        var body: some View {
            List {
                if case .loaded(let items) = viewState {
                    ForEach(items, id: \.url) { item in
                        NavigationLink(fetcher.label(item), value: fetcher.selection(item))
                    }
                }
            }
            .navigationTitle(fetcher.title)
            .overlay { StateOverlay(viewState: viewState) }
            .task {
                do {
                    if let urls {
                        let items = try await withThrowingTaskGroup(of: T.self) { group in
                            for url in urls {
                                group.addTask { try await fetcher.fetchOne(repo, url.absoluteString) }
                            }
                            var results: [T] = []
                            for try await item in group { results.append(item) }
                            return results
                        }
                        viewState = .loaded(items)
                    } else {
                        let ignoreCache = !repo.fetched.contains(fetcher.cacheKey)
                        let items = try await fetcher.fetchAll(repo, ignoreCache)
                        viewState = .loaded(items)
                        repo.fetched.insert(fetcher.cacheKey)
                    }
                } catch {
                    viewState = .error
                }
            }
        }
        
        static func == (lhs: InitialView.DataListView<T>, rhs: InitialView.DataListView<T>) -> Bool {
            lhs.fetcher == rhs.fetcher
            && lhs.urls == rhs.urls
        }
    }
}

typealias ResourceFetcher = InitialView.ResourceFetcher

extension InitialView {
    struct ResourceFetcher<T: Sendable>: Hashable {
        let title: LocalizedStringResource
        let cacheKey: Fetchable
        let label: (T) -> String
        let selection: (T) -> Selected
        let fetchOne: (Repository, String) async throws -> T
        let fetchAll: (Repository, Bool) async throws -> [T]
        
        static func == (lhs: InitialView.ResourceFetcher<T>, rhs: InitialView.ResourceFetcher<T>) -> Bool {
            lhs.title == lhs.title
            && lhs.cacheKey == lhs.cacheKey
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title.key)
            hasher.combine(cacheKey)
        }
    }
}

extension InitialView.ResourceFetcher {
    static var planets: ResourceFetcher<Planet> {
        ResourceFetcher<Planet>(
            title: "Planets",
            cacheKey: .planets,
            label: \.name,
            selection: { .planet($0) },
            fetchOne: { try await $0.apiClient.fetchPlanet(url: $1) },
            fetchAll: { try await $0.apiClient.fetchPlanets(ignoreCache: $1) }
        )
    }

    static var people: ResourceFetcher<Person> {
        ResourceFetcher<Person>(
            title: "People",
            cacheKey: .people,
            label: \.name,
            selection: { .person($0) },
            fetchOne: { try await $0.apiClient.fetchPerson(url: $1) },
            fetchAll: { try await $0.apiClient.fetchPeople(ignoreCache: $1) }
        )
    }

    static var films: ResourceFetcher<Film> {
        ResourceFetcher<Film>(
            title: "Films",
            cacheKey: .films,
            label: \.title,
            selection: { .film($0) },
            fetchOne: { try await $0.apiClient.fetchFilm(url: $1) },
            fetchAll: { try await $0.apiClient.fetchFilms(ignoreCache: $1) }
        )
    }

    static var species: ResourceFetcher<Species> {
        ResourceFetcher<Species>(
            title: "Species",
            cacheKey: .species,
            label: \.name,
            selection: { .species($0) },
            fetchOne: { try await $0.apiClient.fetchSpecies(url: $1) },
            fetchAll: { try await $0.apiClient.fetchSpeciesList(ignoreCache: $1) }
        )
    }

    static var starships: ResourceFetcher<Starship> {
        ResourceFetcher<Starship>(
            title: "Starships",
            cacheKey: .starships,
            label: \.name,
            selection: { .starship($0) },
            fetchOne: { try await $0.apiClient.fetchStarship(url: $1) },
            fetchAll: { try await $0.apiClient.fetchStarships(ignoreCache: $1) }
        )
    }

    static var vehicles: ResourceFetcher<Vehicle> {
        ResourceFetcher<Vehicle>(
            title: "Vehicles",
            cacheKey: .vehicles,
            label: \.name,
            selection: { .vehicle($0) },
            fetchOne: { try await $0.apiClient.fetchVehicle(url: $1) },
            fetchAll: { try await $0.apiClient.fetchVehicles(ignoreCache: $1) }
        )
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
