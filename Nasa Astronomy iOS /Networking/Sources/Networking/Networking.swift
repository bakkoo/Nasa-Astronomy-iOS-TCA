// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: APIResource, apiConfiguration: APIConfiguration, type: T.Type) async throws -> T
}

public final class APIClient: APIClientProtocol {
    public init () { }
    
    public func request<T: Decodable>(endpoint: APIResource, apiConfiguration: APIConfiguration, type: T.Type) async throws -> T {
        let url = try await endpoint.url(with: apiConfiguration)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedObject = try decoder.decode(type, from: data)
            return decodedObject
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    private func buildRequest(for endpoint: APIResource, apiConfiguration: APIConfiguration) async throws -> URLRequest {
        let url = try await endpoint.url(with: apiConfiguration)
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        return request
    }
}