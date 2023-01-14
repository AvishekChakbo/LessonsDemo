//
//  LandscapeView.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI

struct LandscapeView: View {
    
    var body: some View {
        VideoPlayerView()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .padding(8)
    }
}
