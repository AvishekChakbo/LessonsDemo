//
//  NetworkHeaders.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation

public typealias HTTPHeaders = [String: String]

extension HTTPHeaders {
    
    /// Configures the HTTPHeaderField
    /// - Parameter request: URLRequest
    func configureRequest(request: inout URLRequest) {
        for (key, value) in self {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}
