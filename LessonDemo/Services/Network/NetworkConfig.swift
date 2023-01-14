//
//  NetworkConfig.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation

/// This helps in set up network configuration
public protocol NetworkConfig {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: HTTPHeaders? { get }
    var httpBody: Parameters? { get }
    var httpEncoding: ParameterEncoding { get }
}
