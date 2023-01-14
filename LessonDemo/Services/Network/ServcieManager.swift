//
//  ServcieManager.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import Combine


struct ServcieManager {
    
    let manager = NetworkManager<ServcieConfig>()

    func fetchLessons() -> AnyPublisher<FetchLessonsResponse, NetworkError> {
        return manager.request(.fetchLessons)
            .eraseToAnyPublisher()
    }
}

