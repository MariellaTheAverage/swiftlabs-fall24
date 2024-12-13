//
//  PhotoDetailView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 24.09.2024.
//

import SwiftUI

struct TagSelectionView: View {
    @Binding var taglist: [PhotoTag]
    @Binding var selectedtags: [Bool]
    var body: some View {
        List {
            ForEach(0..<taglist.count) { idx in
                Toggle(isOn: $selectedtags[idx]) {
                    Text(taglist[idx].Name)
                }
            }
        }
    }
}

struct PhotoDetailView: View {
    @Binding var image: UIImage?
    @Binding var photo: MetaPhoto?
    @Binding var new: Bool
    @State var allTags: [PhotoTag]
    @Binding var selectedTags: [Bool]
    var onSave: () -> Void
    
    // @State private var selectedTags: [Bool] = [false, false, false, false]
    
    /*
    constructor to figure out in case of dynamic tag count
    init(image: UIImage? = nil, photo: MetaPhoto? = nil, new: Bool, onSave: @escaping () -> Void, allTags: [PhotoTag]) {
        self.image = image
        self.photo = photo
        self.new = new
        self.onSave = onSave
        self.allTags = allTags
        self.selectedTags = []
        for i in 0..<allTags.count {
            selectedTags.append(false)
        }
    }
     */
    
    var body: some View {
        NavigationStack {
            VStack {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                }
                List {
                    if let unwrappedMeta = photo {
                        TextField("Photo Name", text: Binding(
                            get: { unwrappedMeta.Name },
                            set: { photo?.Name = $0 }
                        ))
                        
                        TextField("Description", text: Binding(
                            get: { unwrappedMeta.Description },
                            set: { photo?.Description = $0 }
                        ))
                        
                        NavigationLink {
                            TagSelectionView(
                                taglist: $allTags,
                                selectedtags: $selectedTags
                            )
                        } label: {
                            Text("Select tags")
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button (action: {
                        photo?.Tags = []
                        for idx in 1..<allTags.count {
                            if selectedTags[idx] {
                                photo?.Tags.append(allTags[idx])
                            }
                        }
                        onSave()
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

/*
struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView()
    }
}
*/
