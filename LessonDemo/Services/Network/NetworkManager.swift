//
//  NetworkManager.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import Combine

class NetworkManager<Configuration: NetworkConfig> {
        
    func request<T: Codable>(_ config: Configuration) -> AnyPublisher<T, NetworkError> {

        do {
            let request = try self.buildRequest(from: config)
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    if let httpResponse = response as? HTTPURLResponse {
                        guard (200..<300) ~= httpResponse.statusCode else {
                            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                        }
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error -> NetworkError in
                    if let decodingError = error as? DecodingError {
                        return NetworkError.decodingError(decodingError)
                    }
                    return NetworkError.transportError(error)
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        catch {
            return Fail(error: NetworkError.invalidRequestError(error)).eraseToAnyPublisher()
        }
    }
    
    /// Helps building URLRequest with given Configuration
    /// - Parameter config: Configuration
    /// - Returns: URLRequest
    func buildRequest(from config: Configuration) throws -> URLRequest {
        var request = URLRequest(url: config.url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        request.httpMethod = config.httpMethod.rawValue
        config.httpHeaders?.configureRequest(request: &request)
        try config.httpEncoding.encode(request: &request, body: config.httpBody)
        return request
    }
}
