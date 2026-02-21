//
//  Repository.swift
//  StarWarsApp
//
//  Created by Will Dale on 21/02/2026.
//

import Observation
import StarWarsLibrary

@Observable
final class Repository {
    let apiClient: ApiClient
    var fetched: Set<Fetchable> = []
    
    init() {
        self.apiClient = ApiClient(httpClient: SwiftHttpClient(), repository: DataRepository())
    }
}

