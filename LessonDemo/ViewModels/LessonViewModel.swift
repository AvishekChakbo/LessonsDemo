//
//  LessonViewModel.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import Combine
import SwiftLoader
import RealmSwift

class LessonViewModel: ObservableObject {
    
    @Published var lessons: [Lesson] = []
    @Published var error: NetworkError?
    
    private let networkManager = ServcieManager()
    private let databaseManager = DatabaseManager.shared
    
    func fetchLessons() {
        if Reachability.isConnectedToNetwork(){
            SwiftLoader.show(animated: true)
            let _ = lessonsPublisher
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .failure(let error):
                        self.error = error
                    case .finished: break
                        
                    }
                }, receiveValue: { response in
                    self.lessons = Array(response.lessons)
                    self.databaseManager.save(response.lessons)
                    SwiftLoader.hide()
                })
        }
        else{
            self.lessons = self.databaseManager.fetch(Lesson.self)
        }
    }
    
    private lazy var lessonsPublisher: AnyPublisher<FetchLessonsResponse, NetworkError> = {
        self.networkManager.fetchLessons().eraseToAnyPublisher()
    }()
}
