//
//  APIResource.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import Foundation
import Networking

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

enum APIResource {
    case nasaAPOD

    var method: HTTPMethod {
        switch self {
        case .nasaAPOD:
            return .get
        }
    }
    
    func url(with config: APIConfiguration) async throws -> URL {
        var urlComponents = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true)!
        
        switch self {
        case .nasaAPOD:
            urlComponents.path = "/planetary/apod"
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: config.apiKey)
            ]
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        return url
    }
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct APIConfiguration {
    let baseURL: URL
    let apiKey: String

    static let nasaAPI = APIConfiguration(
        baseURL: URL(string: "https://api.nasa.gov")!,
        apiKey: "soZMS79c6Px6Kn8qnRou8wKSMhvBWgN1YrBurmeF"
    )
}


