//
//  LessonInfoView.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI

struct LessonInfoView: View {
    
    @EnvironmentObject var lesson: Lesson
    @EnvironmentObject var model: Model
    
    let action: ()->()

    
    var body: some View {
        VStack {
            Text(lesson.name)
                .padding(8)
                .modifier(LessonFontModifier())
                .foregroundColor(.white)
            
            Text(lesson.videoDescription)
                .padding([.bottom, .leading, .trailing], 8)
                .font(.body)
                .foregroundColor(.white)
            
            if (model.showNext){
                HStack {
                    Button {
                        action()
                    } label: {
                        Text("Next Lesson")
                            .foregroundColor(.blue)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 7, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
