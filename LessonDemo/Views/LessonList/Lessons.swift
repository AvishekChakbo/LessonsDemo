//
//  Lessons.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI
import Kingfisher

struct Lessons: View {

    @StateObject var viewModel = LessonViewModel()

    @State var show = true
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.viewModel.lessons) { lesson in
                    NavigationLink {
                        LessonDetails(lesson: lesson)
                    } label: {
                        LessonCell(lesson: lesson)
                    }
                }
                .listRowBackground(Color.black)
                .accessibility(identifier: "LesssonCell")
            }
            .background(.black)
            .listRowSeparatorTint(Color.clear)
            .listSectionSeparatorTint(Color.clear)
            .listStyle(.plain)
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.large)
            .accessibility(identifier: "LesssonList")
            .onAppear(){
                self.viewModel.fetchLessons()
            }
        }
        .environmentObject(viewModel)
        .accessibility(identifier: "LesssonNavigationView")
    }
}

struct Lessons_Previews: PreviewProvider {
    static var previews: some View {
        Lessons()
    }
}
