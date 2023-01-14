//
//  LessonDetailsViewModel.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import Foundation
import Photos
import SwiftUI
import Combine


class LessonDetailsViewModel: ObservableObject {
    
    @Published var showNoInternetAlert = false
    @Published var isDownloading = false
    
    private var operation: URLSessionDataTask?
    
    func cancelDownload(){
        self.operation?.cancel()
        self.isDownloading = false
    }
    
    func downloadVideo(_ lesson: Lesson) {
        
        guard let filePath = lesson.getFilePath(), let url = lesson.getVideoUrl() else {
            return
        }
        
        if !lesson.fileExists(){
            
            if Reachability.isConnectedToNetwork() {
                
                isDownloading = true
               
                let urlRequest = URLRequest(url: url)
                
                operation = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let _ = error {
                        DispatchQueue.main.async { self.isDownloading = false }
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let data = data else {
                            DispatchQueue.main.async { self.isDownloading = false }
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: filePath, options: Data.WritingOptions.atomic)
                                self.saveFileToPhotoLibrary(from: filePath)
                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                }
                            } catch {
                                DispatchQueue.main.async { self.isDownloading = false }
                            }
                        }
                    }
                }
                operation?.resume()
            }
            else {
                self.showNoInternetAlert = true
            }
        }
    }
    
    private func saveFileToPhotoLibrary(from: URL){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: from)}) {
                success, error in
                if success {
                    print("Succesfully Saved")
                } else {
                    print(error?.localizedDescription ?? "Download Error")
                }
            }
    }
}
