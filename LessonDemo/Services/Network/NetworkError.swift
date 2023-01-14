//
//  NetworkError.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

/// Errors
public enum NetworkError: Error {
    case invalidRequestError(Error)
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
}
