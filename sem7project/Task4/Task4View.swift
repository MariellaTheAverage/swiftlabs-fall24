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
    
    // search controls
    @State private var srchName = ""
    @State private var srchDesc = ""
    @State private var srchTag: Int? = nil
    
    private var cols: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
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
            List {
                TextField("Search by name", text: $srchName)
                TextField("Search by description", text: $srchDesc)
                Picker(selection: $srchTag) {
                    Text("None").tag(Optional<Int>(nil))
                    ForEach(photoLoader.TagList) { atag in
                        Text("\(atag.Name)").tag(Optional(atag.id))
                    }
                } label: {
                    Text("Tag")
                }
                // .onChange (of: srchTag, perform: {newValue in
                //     filterAllPhotos()
                // })
                HStack {
                    Button {
                        photoLoader.filterCollection(srchName: srchName, srchDesc: srchDesc, srchTag: srchTag)
                    } label: {
                        Text("Search")
                    }
                    .buttonStyle(.borderless)
                    .padding()
                    
                    Button {
                        srchName = ""
                        srchDesc = ""
                        srchTag = nil
                        photoLoader.resetFiltering()
                    } label: {
                        Text("Clear")
                    }
                    .buttonStyle(.borderless)
                    .padding()
                }
            }
            ScrollView {
                LazyVGrid(
                    columns: cols,
                    alignment: .center,
                    spacing: 20
                ) {
                    ForEach(photoLoader.FilteredCollection, id: \.self) { id in
                        Button {
                            handleCameraClosing(photo: photoLoader.Collection[id])
                        } label: {
                            Image(uiImage: (photoLoader.Collection[id].Image ?? UIImage(systemName: "photo"))!)
                                .resizable()
                                .scaledToFit()
                        }
                        /*
                        Image(uiImage: (photoLoader.Collection[id].Image ?? UIImage(systemName: "photo"))!)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                handleCameraClosing(photo: photoLoader.Collection[id])
                            }
                            .background(
                                NavigationLink(
                                    destination: PhotoDetailView(
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
                                    ),
                                    isActive: Binding(
                                        get: { showingDetails == true },
                                        set: { _ in }
                                    )
                                ) {
                                    EmptyView()
                                }.hidden()
                            )
                         */
                    }
                }
            }
            /*
            NavigationLink(
                destination: PhotoDetailView(
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
                ),
                isActive: Binding(
                    get: { freshPhoto == true },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }.hidden()
             */
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
