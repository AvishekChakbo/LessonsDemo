//
//  NetworkParameters.swift
//
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import UIKit

public typealias Parameters = [String: Any]

extension Parameters {
    
    /// Returns data from parameters using encoding
    /// - Parameter encoding: ParameterEncoding
    /// - Returns: Data
    func data(encoding: ParameterEncoding, boundary: String? = nil) throws -> Data? {
        switch encoding {
        case .json:
            return try JSONSerialization.data(withJSONObject: self)
        }
    }
}
