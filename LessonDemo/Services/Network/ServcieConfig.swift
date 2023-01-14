//
//  ServcieConfig.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation


enum ServcieConfig {
    case fetchLessons
}

extension ServcieConfig: NetworkConfig{
    var url: URL {
        guard let url = URL(string: "https://iphonephotographyschool.com/test-api/") else { fatalError("baseURL could not be configured.")}
        
        switch self {
        case .fetchLessons:
            return url.appendingPathComponent("lessons")
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchLessons:
            return .get
        }
    }
    
    var httpHeaders: HTTPHeaders? {
        switch self {
        case .fetchLessons:
            return nil
        }
    }
    
    var httpBody: Parameters? {
        switch self {
        case .fetchLessons:
            return nil
        }
    }
    
    var httpEncoding: ParameterEncoding {
        switch self {
        case .fetchLessons:
            return .json
        }
    }
    
}
