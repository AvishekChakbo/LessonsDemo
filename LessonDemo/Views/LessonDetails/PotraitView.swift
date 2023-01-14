//
//  PotraitView.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI

struct PotraitView: View {
    
    let action: ()->()
    
    var body: some View {
        ScrollView {
            VideoPlayerView().frame(height: 250)
            LessonInfoView(action: action)
        }
    }
}

