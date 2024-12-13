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
    @State private var newTemp: tempPhoto? = nil
    @State private var newMeta: MetaPhoto? = nil
    @State private var photoTrigger = false
    
    // data controls
    @StateObject private var photoLoader = PhotoLoader()
    @State private var selectedMetaPhoto: MetaPhoto? = nil
    @State private var showingDetails: Bool = false
    @State private var selectedTags: [Bool] = []
    
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
                        Button (action: {
                            handleCameraClosing(photo: photo)
                        }) {
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
                            do {
                                newTemp = try tempPhoto()
                                newMeta = MetaPhoto(tmplt: newTemp!)
                                for _ in 0..<photoLoader.TagList.count {
                                    selectedTags.append(false)
                                }
                                
                            }
                            catch {}
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
            PhotoDetailView(
                image: $image,
                photo: $newMeta,
                new: $freshPhoto,
                allTags: photoLoader.TagList,
                selectedTags: $selectedTags,
                onSave: {
                    if let img = image {
                        SaveNewPhoto(img: img, meta: newMeta!)
                    }
                    image = nil
                    newTemp = nil
                    newMeta = nil
                    freshPhoto = false
                }
            )
        }
        .sheet(isPresented: $showingDetails) {
            PhotoDetailView(
                image: $image,
                photo: $selectedMetaPhoto,
                new: $freshPhoto,
                allTags: photoLoader.TagList,
                selectedTags: $selectedTags,
                onSave: {
                    updatePhotoMetadata(meta: selectedMetaPhoto!)
                    selectedMetaPhoto = nil
                    showingDetails = false
                }
            )
        }
    }
    
    func handleCameraClosing(photo: Photo) {
        selectedMetaPhoto = photo.Meta
        image = photo.Image
        var j = 0
        for i in 0..<photoLoader.TagList.count {
            if j < selectedMetaPhoto?.Tags.count ?? 0 && photoLoader.TagList[i].id == selectedMetaPhoto?.Tags[j].id {
                selectedTags.append(true)
                j += 1
            }
            else {selectedTags.append(false)}
        }
        showingDetails = true
    }
    
    func SaveNewPhoto(img: UIImage, meta: MetaPhoto) {
        print("Saving photo and metadata...")
        photoLoader.AppendPhoto(img: img, meta: meta)
        selectedTags = []
    }
    
    func updatePhotoMetadata(meta: MetaPhoto) {
        // find by id and reinsert into file
        print(meta)
        let idx = photoLoader.getIdxByPhotoID(id: meta.id)
        selectedTags = []
        if idx != -1 {
            photoLoader.Collection[idx].Meta.Name = meta.Name
            photoLoader.Collection[idx].Meta.Description = meta.Description
            photoLoader.Collection[idx].Meta.Tags = []
            meta.Tags.forEach { tag in
                photoLoader.Collection[idx].Meta.Tags.append(tag)
            }
        }
        Task {
            print("Saving metadata...")
            do { try await photoLoader.SavePhotos() }
            catch { print("Error updating metadata: \(error)") }
        }
    }
}

/*
struct Task4View_Previews: PreviewProvider {
    static var previews: some View {
        Task4View()
    }
}
*/
