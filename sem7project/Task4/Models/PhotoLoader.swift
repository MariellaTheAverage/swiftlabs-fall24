//
//  PhotoLoader.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import Foundation
import AVFoundation
import SwiftUI

class PhotoLoader: ObservableObject {
    @Published var Collection: [Photo] = []
    private var lastID: Int
    
    init() {
        self.lastID = 0
        Task {
            do { try await LoadPhotoInfo() }
            catch { print("\(error)") }
        }
        if self.Collection.count > 0 {
            self.lastID = self.Collection[self.Collection.count-1].Meta.id + 1
        }
        else {
            self.lastID = 0
        }
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("photogallery.data")
    }
    
    func AppendPhoto(img: UIImage, meta: MetaPhoto) {
        var newMeta = meta
        newMeta.id = self.lastID
        let newPhoto = Photo(Meta: meta, Image: img)
        self.Collection.append(newPhoto)
        self.lastID += 1
        Task.detached { [self] in
            await saveNewPhoto(img: img, meta: newMeta)
        }
    }
    
    func saveNewPhoto(img: UIImage, meta: MetaPhoto) async {
        if let data = img.pngData() {
            do {
                try data.write(to: meta.FileURL)
                print("Image saved to \(meta.FileURL.path)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    func LoadPhotoInfo() async throws {
        let task = Task<[Photo], Error> {
            let fileURL = try Self.fileURL()
            print(fileURL)
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let MetaList = try JSONDecoder().decode([MetaPhoto].self, from: data)
            print(MetaList)
            var PhotoList: [Photo] = []
            MetaList.forEach { meta in
                // load respective photos
                if let curData = try? Data(contentsOf: meta.FileURL) {
                    let curImg = UIImage(data: curData)
                    let newPhoto = Photo(Meta: meta, Image: curImg ?? UIImage())
                    PhotoList.append(newPhoto)
                }
                else {
                    print("Failed to load \(meta.FileURL)")
                }
            }
            return PhotoList
        }
        let res = try await task.value
        self.Collection = res
    }
    
    func SavePhotos() async throws -> Bool {
        let task = Task<Bool, Error> {
            let fileURL = try Self.fileURL()
            var MetaList: [MetaPhoto] = []
            Collection.forEach { photo in
                MetaList.append(photo.Meta)
            }
            guard let data = try? JSONEncoder().encode(MetaList) else {
                throw NSError(domain: "Encoding error", code: 42)
            }
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                defer {
                    try! fileHandle.close()
                }
                fileHandle.write(data)
            }
            return true
        }
        let res = try await task.value
        return res
    }
}
