//
//  Task4View.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import SwiftUI

struct Task4View: View {
    // camera controls
    @State private var cameraOpen = false
    @State private var freshPhoto = false
    @State private var image: UIImage? = nil
    @State private var photoTrigger = false
    
    // data controls
    @StateObject private var photoLoader = PhotoLoader()
    
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
                    ForEach(photoLoader.Collection) { photo in
                        // cell view of photo
                        ZStack {
                            if let image = photo.Image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            }
                            else {
                                Image(systemName: "photo")
                            }
                        }
                    }
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .sheet(isPresented: $cameraOpen) {
            ZStack {
                CameraPreview(capturedPhoto: $image, photoTrigger: $photoTrigger, photoTaken: $freshPhoto)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            photoTrigger = true
                            cameraOpen = false
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
        .sheet(isPresented: $freshPhoto) {
            ZStack {
                if let img = image {
                    Image(uiImage: img)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button (action: {
                            SaveNewPhoto(img: image!)
                            freshPhoto = false
                        }) {
                            Text("Save Photo")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                }
            }
        }
    }
    
    func SaveNewPhoto(img: UIImage) {
        do {
            let tmp = try tempPhoto()
            let newPhoto = MetaPhoto(tmplt: tmp, img: img)
            photoLoader.AppendPhoto(img: img, meta: newPhoto)
        }
        catch { print("No Photo Object\n"); return }
    }
}

struct Task4View_Previews: PreviewProvider {
    static var previews: some View {
        Task4View()
    }
}
