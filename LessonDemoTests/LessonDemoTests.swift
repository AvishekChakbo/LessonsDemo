//
//  LessonDemoTests.swift
//  LessonDemoTests
//
//  Created by Avishek Chakraborty on 13/01/23.
//

import XCTest
import RealmSwift
import Combine

@testable import LessonDemo

final class LessonDemoTests: XCTestCase {

    func testIsInternetAvailable(){
        let value = MockReachability.isConnectedToNetwork()
        XCTAssertTrue(value)
    }
    
    func testBuildRequest() throws {
        let manager = MockNetworkManager()
        let request = try? manager.buildRequest(from: .apiWithJsonEncoing)
        XCTAssertNotNil(request)
    }
    
    func testBodyNil() throws {
        let manager = MockNetworkManager()
        guard let request = try? manager.buildRequest(from: .apiWithBodyNil) else{
            XCTFail("Unable to create request")
            return
        }
        XCTAssertNil(request.httpBody)
    }
    
    func testHeaderNil() throws {
        let manager = MockNetworkManager()
        guard let request = try? manager.buildRequest(from: .apiWithHeaderNil) else{
            XCTFail("Unable to create request")
            return
        }
        XCTAssertNil(request.allHTTPHeaderFields?["token"])
    }
    
    func testHttpMethod() throws {
        let manager = MockNetworkManager()
        guard let request = try? manager.buildRequest(from: .apiWithGetMethod) else{
            XCTFail("Unable to create request")
            return
        }
        XCTAssertEqual(request.httpMethod, MockConfiguration.apiWithGetMethod.httpMethod.rawValue)
    }
    
    func testConfigureRequestHeaders() throws {
        let manager = MockNetworkManager()
        guard let request = try? manager.buildRequest(from: .apiWithJsonEncoing) else{
            XCTFail("Unable to create request")
            return
        }
        XCTAssertEqual(request.allHTTPHeaderFields?["token"], MockConfiguration.apiWithJsonEncoing.httpHeaders?["token"])
    }
    
    func testParameterJsonEncoding() throws {
        let manager = MockNetworkManager()
        guard let request = try? manager.buildRequest(from: .apiWithJsonEncoing) else{
            XCTFail("Unable to create request")
            return
        }
        XCTAssertNotNil(request.httpBody)
    }
    
    
    func testMockApiCall(){
        
        let expectation = self.expectation(description: #function)
        
        let mockData = getMockJsonData()
        let mockError = NSError(domain: "MockDomain", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid access token"]) as Error
        let mockResponse = MockConfiguration.apiWithJsonEncoing.getURlResponse()

        let manager = MockNetworkManager()
        manager.data = mockData
        manager.response = mockResponse


        let cancelable = manager.request12(Lesson.self, .apiWithJsonEncoing)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in

            }, receiveValue: { response in
                XCTAssertEqual(response.id, 950)
                XCTAssertEqual(response.name, "Dummy name")
                XCTAssertEqual(response.videoDescription, "description 123")
                XCTAssertEqual(response.thumbnail, "thumbnail url")
                XCTAssertEqual(response.getVideoUrl(), URL(string: "https://test.com"))
                expectation.fulfill()
            })
        
        XCTAssertNotNil(cancelable)
        wait(for: [expectation], timeout: 3)
    }
    
    func testLessonDetailsViewModelCancel(){
        let model = MockLessonDetailsViewModel()
        model.cancelDownload()
        XCTAssertTrue(model.isCancelledCalled)
        XCTAssertFalse(model.isDownloading)
    }
    
    func testLessonDetailsViewModelDownloadVido(){
        do {
            let decoder = JSONDecoder()
            let lesson = try decoder.decode(Lesson.self, from: getMockJsonData()!)
            let model = MockLessonDetailsViewModel()
            model.downloadVideo(lesson)
            XCTAssertTrue(model.isDownloadVideoCalled)
        }
        catch{
            assertionFailure()
        }
    }

    private func getMockJsonData() -> Data?{
        return "{\"id\": 950, \"name\": \"Dummy name\",\"description\": \"description 123\",\"thumbnail\": \"thumbnail url\",\"video_url\": \"https://test.com\"}".data(using: .utf8)
    }
}

private class MockDatabaseManager: DatabaseManager {
    
    var isSaveCalled = false
    var isfetchCalled = false
    
    override func save<T: Object>(_ objects: List<T>){
        isSaveCalled = true
    }
    
    override func fetch<T: Object>(_ type: T.Type) -> [T] {
        isfetchCalled = true
        return []
    }
}


private class MockLessonDetailsViewModel: LessonDetailsViewModel{
    
    var isCancelledCalled = false
    var isDownloadVideoCalled = false
    
    override func cancelDownload() {
        super.cancelDownload()
        isCancelledCalled = true
    }
    
    override func downloadVideo(_ lesson: Lesson) {
        super.downloadVideo(lesson)
        isDownloadVideoCalled = true
    }
}


private class MockNetworkManager: NetworkManager<MockConfiguration>{
        
    var data: Data?
    var response: HTTPURLResponse?
    
    func request12<T: Codable>(_ type: T.Type, _ config: MockConfiguration) -> AnyPublisher<T, NetworkError> {
        return Just((data: self.data!, response: response)).tryMap { (data, response) -> Data in
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                return NetworkError.transportError(error)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    override func request<T>(_ config: MockConfiguration) -> AnyPublisher<T, NetworkError> where T : Decodable, T : Encodable {
        return Just((data: self.data!, response: response)).tryMap { (data, response) -> Data in
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                return NetworkError.transportError(error)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

class MockModel: Codable {
    var id: Int
}

private enum MockConfiguration {
    case apiWithHeaderNil
    case apiWithBodyNil
    case apiWithGetMethod
    case apiWithJsonEncoing
}

extension MockConfiguration: NetworkConfig {
    
    var url: URL {
        guard let url =  URL.init(string: "https://test.com") else { fatalError("url cannot be created")}
        return url
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var httpHeaders: HTTPHeaders? {
        switch self {
        case .apiWithHeaderNil:
            return nil
        default:
            return ["token" : "XXXX"]
        }
    }
    
    var httpBody: Parameters? {
        
        switch self {
        case .apiWithGetMethod, .apiWithBodyNil:
            return nil
        default:
            return ["itemId" : "123"]
        }
    }
    
    var httpEncoding: ParameterEncoding {
        switch self {
        case .apiWithJsonEncoing, .apiWithGetMethod, .apiWithBodyNil, .apiWithHeaderNil:
            return .json
        }
    }
    
    var enableDebugPrint: Bool {
        return true
    }
    
    func getMockStatusCode() -> Int{
        return 200
    }
    
    func getMockVersion() -> String{
        return "1.0.0"
    }
    
    func getURlResponse() -> HTTPURLResponse?{
        return HTTPURLResponse.init(url: url, statusCode: getMockStatusCode(), httpVersion: getMockVersion(), headerFields: httpHeaders)
    }
}


private class MockReachability: Reachability {
    override class func isConnectedToNetwork() -> Bool {
        let _ = super.isConnectedToNetwork()
        return true
    }
}
