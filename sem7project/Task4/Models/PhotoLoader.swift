//
//  PhotoLoader.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import Foundation
import AVFoundation
import SwiftUI

@MainActor
class PhotoLoader: UIImagePickerController, ObservableObject {
    @Published var Collection: [Photo]
    private var lastID: Int
    
    // let cam = Camera()
    /*
    init(Collection: [Photo]?, lastID: Int?) {
        super.init()
        self.Collection = Collection ?? []
        self.lastID = lastID ?? 0
    }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("photogallery.data")
    }
    
    func LoadPhotoInfo() async throws {
        let task = Task<[Photo], Error> {
            let fileURL = try Self.fileURL()
            print(fileURL)
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let PhotoList = try JSONDecoder().decode([Photo].self, from: data)
            print(PhotoList)
            return PhotoList
        }
        let res = try await task.value
        self.Collection = res
    }
    
    func SavePhoto(object: tempPhoto) async throws -> Photo {
        let task = Task<Photo, Error> {
            let fileURL = try Self.fileURL()
            let newPhoto = Photo(tmplt: object, pid: self.lastID)
            self.lastID += 1
            self.Collection.append(newPhoto)
            guard let data = try? JSONEncoder().encode(self.Collection) else {
                throw NSError(domain: "Encoding error", code: 42)
            }
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                defer {
                    try! fileHandle.close()
                }
                fileHandle.write(data)
            }
            return newPhoto
        }
        let res = try await task.value
        return res
    }
}
