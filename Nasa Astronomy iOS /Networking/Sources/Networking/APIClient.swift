import Foundation

public protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: APIResource, apiConfiguration: APIConfiguration, type: T.Type) async throws -> T
}

public final class APIClient: APIClientProtocol {
    public init () { }
    
    public func request<T: Decodable>(endpoint: APIResource, apiConfiguration: APIConfiguration, type: T.Type) async throws -> T {
        let url = try await buildRequest(for: endpoint, apiConfiguration: apiConfiguration)
        do {
            let (data, response) = try await URLSession.shared.data(for: url)
            print("Request - \(url.debugDescription)")
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(nil)
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
            }
            print("Response - \(response)")
            print("HTTP Response - \(httpResponse)")
            
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
