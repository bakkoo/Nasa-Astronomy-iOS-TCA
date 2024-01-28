//
//  APIResource.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import Foundation

public enum APIResource {
    case nasaApod
    case nasaApodBy(startDate: String, endDate: String)
    case nasaRandomApod(count: String)

    public var method: HTTPMethod {
        switch self {
        case .nasaApod:
            return .get
        case .nasaApodBy(startDate: _, endDate: _):
            return .get
        case .nasaRandomApod(count: _):
            return .get
        }
    }
    
    public func url(with config: APIConfiguration) async throws -> URL {
        var urlComponents = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: true)!
        
        switch self {
        case .nasaApod:
            urlComponents.path = "/planetary/apod"
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: config.apiKey)
            ]
        case let .nasaApodBy(startDate, endDate):
            urlComponents.path = "/planetary/apod"
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: config.apiKey),
                URLQueryItem(name: "start_date", value: startDate),
                URLQueryItem(name: "end_date", value: endDate),
            ]
        case let .nasaRandomApod(count):
            urlComponents.path = "/planetary/apod"
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: config.apiKey),
                URLQueryItem(name: "count", value: count)
            ]
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        return url
    }
}

