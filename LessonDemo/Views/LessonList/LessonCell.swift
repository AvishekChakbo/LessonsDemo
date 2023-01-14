//
//  LessonCell.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI
import Kingfisher

struct LessonCell: View {
    
    let lesson: Lesson
    @State var show = true
    
    var body: some View {
        HStack {
            ZStack {
                KFImage.url(URL(string: lesson.thumbnail)!)
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly(false)
                    .resizable()
                    .onSuccess { result in
                        show = false
                    }
                    .onFailure { error in
                        show = false
                    }
                    .aspectRatio(contentMode: .fill)
                    .padding(8)

                if(show) {
                    ProgressView().frame(width: 120, height: 60)
                }
            }
            .frame(width: 120, height: 60)
            Text(lesson.name).foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 7, alignment: .trailing)
                .foregroundColor(.blue)
        }
    }
}
