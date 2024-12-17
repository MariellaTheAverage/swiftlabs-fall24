//
//  PhotoGridView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 24.09.2024.
//

import SwiftUI

struct TagSelectionView_test: View {
    @Binding var taglist: [PhotoTag]
    @Binding var selectedtags: [Bool]
    var body: some View {
        List {
            ForEach(1..<taglist.count) { idx in
                Toggle(isOn: $selectedtags[idx]) {
                    Text(taglist[idx].Name)
                }
            }
        }
    }
}

struct PhotoGridView: View {
    @State private var TagList: [PhotoTag] = [
        PhotoTag(id: 0, Name: "Home"),
        PhotoTag(id: 1, Name: "Work"),
        PhotoTag(id: 2, Name: "Pets"),
        PhotoTag(id: 3, Name: "Fun")
    ]
    
    @State private var selected: Int = 0
    @State private var name: String = ""
    @State private var tags: [Bool] = [false, false, false, false]
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    VStack {
                        //
                    }
                    .frame(width: 200.0, height: 200.0)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    Text("Selected tags:")
                    
                    List {
                        ForEach(1..<TagList.count) { idx in
                            Text("\(TagList[idx].Name): \(tags[idx] ? "yes" : "no")")
                        }
                    }
                    
                    // NavigationStack {
                    NavigationLink {
                        TagSelectionView_test(
                           taglist: $TagList,
                           selectedtags: $tags
                        )
                    } label: {
                        Text("Select tags")
                    }
                    
                    Button {
                        //
                    } label: {
                        Text("Click!")
                    }
                    .buttonStyle(.borderless)
                    .padding()

                    /*
                     NavigationLink {
                     TagSelectionView()
                     } label: {
                     Text("Select tags")
                     }
                     .navigationTitle("Tags?")
                     */
                    // }
                    
                    /*
                     Picker(selection: $selected) {
                     ForEach(TagList) {ptag in
                     Text("\(ptag.Name)")
                     .tag(ptag as PhotoTag)
                     }
                     } label: {
                     Text("Choose a tag")
                     }
                     */
                    //}
                }
            }
        }
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView()
    }
}
