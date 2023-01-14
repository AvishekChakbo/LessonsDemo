//
//  VideoPlayerView.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    @EnvironmentObject var lesson: Lesson
    //@State var player: AVPlayer? = nil

    var body: some View {
        if lesson.fileExists(){
            VideoPlayer(player: AVPlayer(url:  lesson.getFilePath()!))
        }
        else{
            VideoPlayer(player: AVPlayer(url:  lesson.getVideoUrl()!))
        }
        
        
        
//        VideoPlayer(player: player)
//            .background(.black)
//            .onAppear() {
//                if lesson.fileExists(){
//                    guard let url = lesson.getFilePath() else {
//                        return
//                    }
//                    player = AVPlayer(url: url)
//                }
//                else{
//                    guard let url = lesson.getVideoUrl() else {
//                        return
//                    }
//                    player = AVPlayer(url: url)
//                }
//            }
    }
}
