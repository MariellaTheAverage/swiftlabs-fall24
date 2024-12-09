//
//  Task4View.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import SwiftUI

struct Task4View: View {
    // @Binding var photoData: [Photo]
    // var loader: PhotoLoader
    @State private var cameraOpen = false
    @State private var freshPhoto = false
    @State private var image: UIImage? = nil
    
    private var cols: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("Photo gallery")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    cameraOpen = true
                } label: {
                    Image(systemName: "camera")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            ScrollView {
                LazyVGrid(
                    columns: cols,
                    alignment: .center,
                    spacing: 20
                ) {
                    ForEach(0...10, id:\.self) {
                        // cell view of photo
                        index in Color.red
                    }
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .sheet(isPresented: $cameraOpen) {
            ZStack {
                CameraPreview(capturedPhoto: $image, photoTaken: $freshPhoto)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            (UIApplication.shared.windows.first?.rootViewController as? UIHostingController<Task4View>)?.rootView.takePhoto()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct Task4View_Previews: PreviewProvider {
    static var previews: some View {
        Task4View()
    }
}
