//
//  ParameterEncoding.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation

public enum ParameterEncoding {
    case json
}

extension ParameterEncoding {
    
    /// Helps in setting content type in URLRequest & add data as body
    /// - Parameters:
    ///   - request: URLRequest
    ///   - body: Parameters
    func encode(request: inout URLRequest, body: Parameters?) throws {
        switch self {
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try body?.data(encoding: self)
        }
    }

}
