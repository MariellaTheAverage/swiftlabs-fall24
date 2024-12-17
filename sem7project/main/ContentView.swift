//
//  ContentView.swift
//  sem7project
//


import SwiftUI

struct ContentView: View {
    // @Binding var task4data: [Photo]
    // var loader: PhotoLoader
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Task1View()
                } label: {
                    Text("Task 1")
                }
                NavigationLink {
                    Task2View()
                } label: {
                    Text("Task 2")
                }
                NavigationLink {
                    Task3View()
                } label: {
                    Text("Task 3")
                }
                NavigationLink {
                    Task4View()
                } label: {
                    Text("Task 4")
                }
            }
            .navigationTitle("Tasks")
            Spacer()
            Button {
                hard_reset_4()
            } label: {
                Text("Reset the gallery (task 4)")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func hard_reset_4(){
        var path: URL
        guard let path = try? FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
                .appendingPathComponent("photogallery.data") else {
            print("Error in path...")
            return
        }
        
        // remove metadata
        let emptyPhotos: [MetaPhoto] = []
        guard let data = try? JSONEncoder().encode(emptyPhotos) else {
            print("Something went wrong with the encoder and i don't care what")
            return
        }

        do {
            try data.write(to: path)
            print("Metadata wiped successfully")
        } catch {
            print("Error clearing data: \(error)")
        }
        
        // remove images/
        guard let path = try? FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
                .appendingPathComponent("images") else {
            print("Error in path...")
            return
        }
        do {
            // Check if the folder exists
            if FileManager.default.fileExists(atPath: path.path) {
                // Remove the folder and all its contents
                try FileManager.default.removeItem(at: path)
                print("images/ folder deleted successfully.")
            } else {
                print("images/ folder does not exist.")
            }
        } catch {
            print("Failed to delete images/ folder: \(error)")
        }
        
        // recreate images/
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*
        let loader = PhotoLoader()
        ContentView(task4data: $loader.Collection, loader: loader)
            .task {
                do {
                    try await loader.LoadPhotoInfo()
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
         */
        Task1View()
    }
}
