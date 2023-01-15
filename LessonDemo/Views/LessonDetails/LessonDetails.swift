//
//  LessonDetails.swift
//  Lessons
//
//  Created by Avishek Chakraborty on 12/01/23.
//

import SwiftUI
import AVKit

struct LessonDetails: View {
    
    @EnvironmentObject var lessonsVidewModel: LessonViewModel
    
    @StateObject private var viewModel = LessonDetailsViewModel()
    
    @StateObject private var model = Model()
    
    @State var lesson: Lesson

    var body: some View {
        ScrollView(){
            DetailsBody(lesson: lesson){
                if let index = lessonsVidewModel.lessons.firstIndex(of: lesson), index < lessonsVidewModel.lessons.count - 1 {
                    lesson = lessonsVidewModel.lessons[index + 1]
                    
                    if index + 1 < lessonsVidewModel.lessons.count - 1 {
                        model.showNext = true
                    }
                    else{
                        model.showNext = false
                    }
                }
                else{
                    model.showNext = false
                }
            }
            .background(.black)
            .accessibility(identifier: "LessonDetailsBody")
        }
        .accessibility(identifier: "LessonDetailsScrollView")
        .background(Color(.black))
        .if(lesson.fileExists() == false) { content in
            content.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            viewModel.downloadVideo(lesson)
                        } label: {
                            HStack {
                                if viewModel.isDownloading {
                                    ProgressView().foregroundColor(.white).tint(.white).padding(8)
                                    Button(action: {
                                        viewModel.cancelDownload()
                                    }) {
                                        Text("Cancel")
                                    }
                                }
                                else{
                                    Image(systemName: "icloud.and.arrow.down")
                                    Text("Download")
                                }
                            }
                        }
                    }
                }
        }
        .environmentObject(model)
        .environmentObject(lesson)
        .alert("Internet is not available.\nTo view file offline, download the file when connected to internet.", isPresented: $viewModel.showNoInternetAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear(){
            /*if Reachability.isConnectedToNetwork() == false {
                viewModel.showNoInternetAlert = true
            }*/
            
            if let index = lessonsVidewModel.lessons.firstIndex(of: lesson), index < lessonsVidewModel.lessons.count - 1 {
                model.showNext = true
            }
            else{
                model.showNext = false
            }
        }
    }
}

struct LessonDetails_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetails(lesson: Lesson.example)
    }
}


struct DetailsBody: View {
    
    let lesson: Lesson
    let action: ()->()
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        Group {
            if orientation.isLandscape {
                LandscapeView()
            } else {
                PotraitView(action: action)
            }
        }
        .onAppear(){
            orientation = UIDevice.current.orientation
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}


struct LessonFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content.font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}


