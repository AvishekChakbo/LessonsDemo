//
//  DatabaseManager.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Combine
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let realm: Realm?
    
    private init() {
        realm = try? Realm()
    }
    
    func save<T: Object>(_ objects: List<T>){
        try? self.realm?.write {
            self.realm?.add(objects, update: .all)
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> [T] {
        guard let data = self.realm?.objects(T.self) else {
            return []
        }
        return Array(data)
    }
    
}
