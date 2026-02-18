//
//  StarWarsApp.swift
//  StarWars
//
//  Created by Will Dale on 15/02/2026.
//

import SwiftUI

@main
struct StarwarsApp: App {
    @State private var repo = Repository()
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environment(repo)
        }
    }
}

import StarWarsLibrary

@Observable
final class Repository {
    let apiClient: ApiClient
    var fetched: Set<Fetchable> = []
    
    init() {
        self.apiClient = ApiClient(httpClient: SwiftHttpClient(), repository: DataRepository())
    }
}


final class SwiftHttpClient: HttpClient {
    func fetch(url: String) async throws -> Data {
        guard let requestUrl = URL(string: url) else {
            throw NetworkError.RequestFailed(reason: "Invalid URL")
        }
        let (data, _) = try await URLSession.shared.data(from: requestUrl)
        return data
    }
}
