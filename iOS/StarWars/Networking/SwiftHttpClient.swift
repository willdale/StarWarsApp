//
//  SwiftHttpClient.swift
//  StarWarsApp
//
//  Created by Will Dale on 21/02/2026.
//

import Foundation
import StarWarsLibrary

final class SwiftHttpClient: HttpClient {
    func fetch(url: String) async throws -> Data {
        guard let requestUrl = URL(string: url) else {
            throw NetworkError.RequestFailed(reason: "Invalid URL")
        }
        let (data, _) = try await URLSession.shared.data(from: requestUrl)
        return data
    }
}
