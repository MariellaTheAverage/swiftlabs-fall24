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
    @Published var FilteredCollection: [Int] = []
    private var lastID: Int
    private var isFiltering: Bool = false
    
    // hardcoded tags, will implement dynamic later
    // maybe
    public let TagList: [PhotoTag] = [
        PhotoTag(id: 0, Name: "Home"),
        PhotoTag(id: 1, Name: "Work"),
        PhotoTag(id: 2, Name: "Pets"),
        PhotoTag(id: 3, Name: "Fun")
    ]
    
    func resetFiltering() {
        self.FilteredCollection = []
        self.Collection.forEach { photo in
            self.FilteredCollection.append(photo.Meta.id)
        }
        isFiltering = false
    }
    
    func checkForTag(tid: Int, meta: MetaPhoto) -> Bool {
        for i in 0..<meta.Tags.count {
            if tid == meta.Tags[i].id { return true }
        }
        return false
    }
    
    func filterByName(name: String, filterable: [Int]) -> [Int] {
        var res: [Int] = []
        filterable.forEach { id in
            if self.Collection[id].Meta.Name == name {
                res.append(id)
            }
        }
        return res
    }
    
    func filterByDescription(desc: String, filterable: [Int]) -> [Int] {
        var res: [Int] = []
        filterable.forEach { id in
            if self.Collection[id].Meta.Description == desc {
                res.append(id)
            }
        }
        return res
    }
    
    func filterByTag(tid: Int, filterable: [Int]) -> [Int] {
        var res: [Int] = []
        filterable.forEach { id in
            if checkForTag(tid: tid, meta: self.Collection[id].Meta) {
                res.append(id)
            }
        }
        return res
    }
    
    func filterCollection(srchName: String, srchDesc: String, srchTag: Int?) {
        self.resetFiltering()
        
        if srchName != "" {
            self.FilteredCollection = filterByName(name: srchName, filterable: self.FilteredCollection)
            self.isFiltering = true
        }
        
        if srchDesc != "" {
            self.FilteredCollection = filterByDescription(desc: srchDesc, filterable: self.FilteredCollection)
            self.isFiltering = true
        }
        
        if srchTag != nil {
            self.FilteredCollection = filterByTag(tid: srchTag!, filterable: self.FilteredCollection)
            self.isFiltering = true
        }
    }
    
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
        self.isFiltering = false
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
        print(newMeta)
        let newPhoto = Photo(Meta: newMeta, Image: img)
        self.Collection.append(newPhoto)
        self.lastID += 1
        if !self.isFiltering {
            self.FilteredCollection.append(newMeta.id)
            print(self.FilteredCollection)
        }
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
        do { try await SavePhotos() }
        catch {
            print("Error in saving metadata: \(error)")
        }
    }
    
    func LoadPhotoInfo() async throws {
        let task = Task<[Photo], Error> {
            let fileURL = try Self.fileURL()
            print(fileURL)
            do {
                let directoryURL = try FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: false)
                    .appendingPathComponent("images")
                if !FileManager.default.fileExists(atPath: directoryURL.path) {
                    do {
                        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Failed to create directory: \(error.localizedDescription)")
                    }
                }
            }
            catch {
                print("Something went wrong in init loader: \(error)")
            }
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
                    let newPhoto = Photo(Meta: meta, Image: nil)
                    PhotoList.append(newPhoto)
                }
            }
            return PhotoList
        }
        let res = try await task.value
        self.Collection = res
        self.resetFiltering()
        print("What was loaded so far...")
        print(self.Collection)
        print(self.FilteredCollection)
    }
    
    func getIdxByPhotoID(id: Int) -> Int {
        for i in 0..<self.Collection.count {
            if self.Collection[i].Meta.id == id {
                return i
            }
        }
        return -1
    }
    
    func SavePhotos() async throws {
        let task = Task<Void, Error> {
            let fileURL = try Self.fileURL()
            var MetaList: [MetaPhoto] = []
            Collection.forEach { photo in
                MetaList.append(photo.Meta)
            }
            guard let data = try? JSONEncoder().encode(MetaList) else {
                throw NSError(domain: "Encoding error", code: 42)
            }

            do {
                try data.write(to: fileURL)
                print("Metadata saved to \(fileURL.path)")
            } catch {
                print("Error saving metadata: \(error)")
            }
        }
        try await task.value
    }
}
