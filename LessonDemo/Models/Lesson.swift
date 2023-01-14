//
//  Lesson.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import RealmSwift

/*
struct Lesson: Codable, Identifiable {
    let id: Int
    let name: String
    let videoDescription: String
    let thumbnail: String
    let videoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case videoDescription = "description"
        case videoUrl = "video_url"
        case id, name, thumbnail
    }
    
    static let example = Lesson.init(id: 0, name: "", videoDescription: "", thumbnail: "", videoUrl: "")
}

struct FetchLessonsResponse: Codable, Identifiable {
    var id: Int? = 0
    let lessons : [Lesson]
}

// Define your models like regular Swift classes
class Dog: Object, Codable, Identifiable {
    @Persisted(primaryKey: true) var name: String
    @Persisted var thumbnail: String
}
class Person: Object, Codable, Identifiable {
    @Persisted(primaryKey: true) var _id: String?
    @Persisted var lessons: List<Dog>
}*/

 class Lesson: Object, Codable, ObjectKeyIdentifiable {
     @Persisted(primaryKey: true) var id: Int
     @Persisted var name: String
     @Persisted var videoDescription: String
     @Persisted var thumbnail: String
     @Persisted private var videoUrl: String
     
     static let example = Lesson()

     override init() { }
     
     // MARK: Codable support
     enum CodingKeys: String, CodingKey {
         case videoDescription = "description"
         case videoUrl = "video_url"
         case id, name, thumbnail
     }
     
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(id, forKey: .id)
         try container.encode(name, forKey: .name)
         try container.encode(videoUrl, forKey: .videoUrl)
         try container.encode(videoDescription, forKey: .videoDescription)
         try container.encode(thumbnail, forKey: .thumbnail)
     }
     
     required init(from decoder: Decoder) throws {
         super.init()
         let container = try decoder.container(keyedBy: CodingKeys.self)
         id = try container.decode(Int.self, forKey: .id)
         name = try container.decode(String.self, forKey: .name)
         videoUrl = try container.decode(String.self, forKey: .videoUrl)
         videoDescription = try container.decode(String.self, forKey: .videoDescription)
         thumbnail = try container.decode(String.self, forKey: .thumbnail)
     }
        
     func getVideoUrl() -> URL? {
         return URL(string: videoUrl)
     }
     
     func fileExists() -> Bool {
         
         guard let filePath = getFilePath() else {
             return false
         }

         if FileManager.default.fileExists(atPath: filePath.path()){
             return true
         }
         
         return false
     }
     
     func getFilePath() -> URL? {
         guard let url = getVideoUrl(), let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
             return nil
         }
         let fileName = url.lastPathComponent
         return docsUrl.appendingPathComponent(fileName)
     }
 }

 class FetchLessonsResponse: Object, Codable, ObjectKeyIdentifiable {
     @Persisted var lessons : List<Lesson>
 }
